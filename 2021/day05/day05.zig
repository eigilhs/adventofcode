const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var buffer: [32]u8 = undefined;

    var part1 = Map.init(&arena.allocator, .no_diagonals);
    var part2 = Map.init(&arena.allocator, .all);

    while (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var splt = std.mem.tokenize(u8, line, ", ->");
        var ln: [4]i32 = undefined;
        for (ln) |*l|
            l.* = try std.fmt.parseInt(i32, splt.next().?, 10);

        const a: Point = ln[0..2].*;
        const b: Point = ln[2..].*;

        try part1.add_line(a, b);
        try part2.add_line(a, b);
    }

    try stdout.print("Part 1: {}\nPart 2: {}\n", .{
        part1.count(),
        part2.count(),
    });
}

const Map = struct {
    points: std.AutoHashMap(Point, usize),
    lines: Lines,
    const Lines = enum {
        all,
        no_diagonals,
    };

    fn init(allocator: *std.mem.Allocator, lines: Lines) @This() {
        return @This(){
            .points = std.AutoHashMap(Point, usize).init(allocator),
            .lines = lines,
        };
    }

    fn add_line(self: *@This(), a: Point, b: Point) !void {
        const diff = b - a;

        if (@reduce(.And, diff != zero) and self.lines == .no_diagonals)
            return;

        var cur = a;
        const delta1 = @select(i32, diff < zero, minus_one, diff);
        const delta = @select(i32, delta1 > zero, one, delta1);

        while (@reduce(.Or, cur != b + delta)) : (cur += delta) {
            var entry = try self.points.getOrPut(cur);
            if (!entry.found_existing)
                entry.value_ptr.* = 0;
            entry.value_ptr.* += 1;
        }
    }

    fn count(self: *@This()) usize {
        var c: usize = 0;
        var it = self.points.valueIterator();
        while (it.next()) |v| {
            if (v.* > 1)
                c += 1;
        }
        return c;
    }
};

const Point = std.meta.Vector(2, i32);
const zero: Point = [_]i32{ 0, 0 };
const one: Point = [_]i32{ 1, 1 };
const minus_one: Point = [_]i32{ -1, -1 };
