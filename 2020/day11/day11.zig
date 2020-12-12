const std = @import("std");

pub fn main() !void {
    const ir = std.io.getStdIn().reader();
    const stdin = std.io.bufferedReader(ir).reader();
    const stdout = std.io.getStdOut().writer();
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var n: usize = 0;
    var al = std.ArrayList(Place).init(&arena.allocator);
    while (stdin.readByte() catch null) |c| switch (c) {
        '.' => try al.append(.{ .is_seat = false }),
        'L' => try al.append(.{ .is_seat = true }),
        '\n' => {
            if (n == 0) n = al.items.len;
        },
        else => unreachable,
    };
    const s = State{ .seats = al.items, .n = n };

    try stdout.print("Part 1: {}\nPart 2: {}\n", .{ s.part1(), s.part2() });
}

const Place = struct {
    neighbors: u4 = 0,
    is_seat: bool,
    occupied: bool = false,
};

const State = struct {
    seats: []Place,
    n: usize,

    fn part1(self: @This()) usize {
        while (true) {
            for (self.seats) |seat, i|
                if (seat.occupied)
                    self.inc1(i / self.n, i % self.n);
            if (!self.applyRules(4))
                return self.countAndClear();
        }
    }

    fn part2(self: @This()) usize {
        while (true) {
            for (self.seats) |seat, i|
                if (seat.occupied)
                    self.inc2(i / self.n, i % self.n);
            if (!self.applyRules(5))
                return self.countAndClear();
        }
    }

    fn applyRules(self: @This(), required: usize) bool {
        var changed = false;
        for (self.seats) |*seat| {
            if (seat.is_seat and !seat.occupied and seat.neighbors == 0) {
                seat.occupied = true;
                changed = true;
            } else if (seat.occupied and seat.neighbors >= required) {
                seat.occupied = false;
                changed = true;
            }
            seat.neighbors = 0;
        }
        return changed;
    }

    fn countAndClear(self: @This()) usize {
        var cnt: usize = 0;
        for (self.seats) |*seat, i| {
            if (seat.occupied)
                cnt += 1;
            seat.occupied = false;
        }
        return cnt;
    }

    fn inc1(self: @This(), i: usize, j: usize) void {
        for ([_]i2{ -1, 0, 1 }) |di| {
            var xi = @intCast(isize, i) + di;
            if (xi < 0 or xi >= self.seats.len / self.n)
                continue;

            for ([_]i2{ -1, 0, 1 }) |dj| {
                if (di == 0 and dj == 0) continue;
                var xj = @intCast(isize, j) + dj;
                if (xj < 0 or xj >= self.n)
                    continue;

                const idx = @intCast(usize, xi) * self.n + @intCast(usize, xj);
                self.seats[idx].neighbors += 1;
            }
        }
    }

    fn inc2(self: @This(), i: usize, j: usize) void {
        for ([_]i2{ -1, 0, 1 }) |di| {
            for ([_]i2{ -1, 0, 1 }) |dj| {
                if (di == 0 and dj == 0) continue;
                const a = self.see(i, j, di, dj) orelse continue;
                self.seats[a].neighbors += 1;
            }
        }
    }

    fn see(self: @This(), pi: usize, pj: usize, di: i3, dj: i3) ?usize {
        if ((pi == 0 and di < 0) or (pj == 0 and dj < 0))
            return null;
        const i = @intCast(usize, @intCast(isize, pi) + di);
        const j = @intCast(usize, @intCast(isize, pj) + dj);
        if (i * self.n + j >= self.seats.len or j >= self.n)
            return null;
        if (self.seats[i * self.n + j].is_seat)
            return i * self.n + j;
        return self.see(i, j, di, dj);
    }
};
