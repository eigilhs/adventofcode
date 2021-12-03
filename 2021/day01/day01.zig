const std = @import("std");

fn Sonar(comptime window_size: usize) type {
    return struct {
        window: [window_size]usize = undefined,
        count: usize = 0,
        i: usize = 0,

        fn advance(self: *@This(), depth: usize) void {
            const prev_start = self.i % window_size;

            if (self.i >= window_size and depth > self.window[prev_start])
                self.count += 1;

            self.window[prev_start] = depth;
            self.i += 1;
        }
    };
}

pub fn main() !void {
    var buffer: [12]u8 = undefined;
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var part1 = Sonar(1){};
    var part2 = Sonar(3){};

    while (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        const depth = try std.fmt.parseInt(u32, line, 10);
        part1.advance(depth);
        part2.advance(depth);
    }

    try stdout.print(
        "Part 1: {}\nPart 2: {}\n",
        .{ part1.count, part2.count },
    );
}
