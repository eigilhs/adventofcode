const std = @import("std");

pub fn main() !void {
    const ir = std.io.getStdIn().reader();
    const stdin = std.io.bufferedReader(ir).reader();
    const stdout = std.io.getStdOut().writer();

    var total1: usize = 0;
    var total2: usize = 0;

    while (stdin.readByte() catch null) |a| {
        var c = a;
        var any: u26 = 0;
        var all: u26 = ~@as(u26, 0);

        while (c != '\n') : (c = stdin.readByte() catch '\n') {
            var person: u26 = 0;

            while (c != '\n') : (c = try stdin.readByte())
                person |= @as(u26, 1) << @intCast(u5, c - 'a');

            any |= person;
            all &= person;
        }

        total1 += @popCount(u26, any);
        total2 += @popCount(u26, all);
    }

    try stdout.print("Part 1: {}\nPart 2: {}\n", .{ total1, total2 });
}
