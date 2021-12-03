const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var buffer: [32]u8 = undefined;

    var part1 = Submarine1{};
    var part2 = Submarine2{};

    while (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var splt = std.mem.tokenize(u8, line, " ");
        const direction = splt.next().?[0];
        const units = try std.fmt.parseInt(u8, splt.next().?, 10);

        part1.advance(direction, units);
        part2.advance(direction, units);
    }

    try stdout.print("Part 1: {}\nPart 2: {}\n", .{
        part1.x * part1.depth,
        part2.x * part2.depth,
    });
}

const Submarine1 = struct {
    depth: usize = 0,
    x: usize = 0,

    fn advance(self: *@This(), direction: u8, units: u8) void {
        switch (direction) {
            'f' => self.x += units,
            'd' => self.depth += units,
            'u' => self.depth -= units,
            else => unreachable,
        }
    }
};

const Submarine2 = struct {
    depth: usize = 0,
    x: usize = 0,
    aim: usize = 0,

    fn advance(self: *@This(), direction: u8, units: u8) void {
        switch (direction) {
            'd' => self.aim += units,
            'u' => self.aim -= units,
            'f' => {
                self.x += units;
                self.depth += self.aim * units;
            },
            else => unreachable,
        }
    }
};
