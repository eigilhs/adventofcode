const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var sea = Sea{};
    const input = try stdin.readAllAlloc(&arena.allocator, 1 << 32);
    var splt = std.mem.tokenize(u8, input, ",");
    while (splt.next()) |n| {
        sea.fish[n[0] - '0'] += 1;
    }

    const part1 = sea.advance_days(80);
    const part2 = sea.advance_days(256 - 80);

    try stdout.print("Part 1: {}\nPart 2: {}\n", .{ part1, part2 });
}

const Sea = struct {
    fish: std.meta.Vector(9, usize) = [_]usize{0} ** 9,
    zero: usize = 0,

    fn advance_days(self: *@This(), days: usize) usize {
        var day: usize = 0;
        while (day < days) : (day += 1) {
            self.fish[(self.zero + 7) % 9] += self.fish[self.zero % 9];
            self.zero += 1;
        }

        return @reduce(.Add, self.fish);
    }
};
