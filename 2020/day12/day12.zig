const std = @import("std");

pub fn main() !void {
    const ir = std.io.getStdIn().reader();
    const stdin = std.io.bufferedReader(ir).reader();
    const stdout = std.io.getStdOut().writer();

    var p1 = Vec{ .x = 0, .y = 0 };
    var bearing: isize = 90;
    var p2 = Vec{ .x = 0, .y = 0 };
    var wp = Vec{ .x = 10, .y = 1 };

    while (stdin.readByte() catch null) |c| {
        var buffer: [20]u8 = undefined;
        const ip = try stdin.readUntilDelimiterOrEof(&buffer, '\n');
        var arg = try std.fmt.parseUnsigned(isize, ip.?, 10);

        switch (c) {
            'N' => {
                p1.y += arg;
                wp.y += arg;
            },
            'S' => {
                p1.y -= arg;
                wp.y -= arg;
            },
            'E' => {
                p1.x += arg;
                wp.x += arg;
            },
            'W' => {
                p1.x -= arg;
                wp.x -= arg;
            },
            'L', 'R' => {
                if (c == 'R') arg = 360 - @mod(arg, 360);
                bearing = @mod(bearing - arg, 360);
                switch (arg) {
                    90 => wp.set(-wp.y, wp.x),
                    180 => wp.set(-wp.x, -wp.y),
                    270 => wp.set(wp.y, -wp.x),
                    else => unreachable,
                }
            },
            'F' => {
                switch (bearing) {
                    0 => p1.y += arg,
                    90 => p1.x += arg,
                    180 => p1.y -= arg,
                    270 => p1.x -= arg,
                    else => unreachable,
                }
                p2.y += wp.y * arg;
                p2.x += wp.x * arg;
            },
            else => unreachable,
        }
    }

    try stdout.print("Part 1: {}\nPart 2: {}\n", .{ p1.dist(), p2.dist() });
}

const Vec = struct {
    x: isize,
    y: isize,

    fn dist(self: @This()) usize {
        return std.math.absCast(self.x) + std.math.absCast(self.y);
    }

    fn set(self: *@This(), x: isize, y: isize) void {
        self.x = x;
        self.y = y;
    }
};
