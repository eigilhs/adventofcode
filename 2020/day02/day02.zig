const std = @import("std");

inline fn validPart1(pwd: []const u8, min: u8, max: u8, char: u8) bool {
    var cnt: u32 = 0;
    for (pwd) |c| {
        if (c == char)
            cnt += 1;
    }
    return cnt <= max and cnt >= min;
}

inline fn validPart2(pwd: []const u8, a: u8, b: u8, char: u8) bool {
    return @boolToInt(pwd[a - 1] == char) ^ @boolToInt(pwd[b - 1] == char) == 1;
}

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var buffer: [64]u8 = undefined;
    var total1: u16 = 0;
    var total2: u16 = 0;

    while (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var splt = std.mem.tokenize(line, "-: ");
        var a = try std.fmt.parseInt(u8, splt.next().?, 10);
        var b = try std.fmt.parseInt(u8, splt.next().?, 10);
        var char = splt.next().?;
        var pwd = splt.next().?;

        if (validPart1(pwd, a, b, char[0]))
            total1 += 1;
        if (validPart2(pwd, a, b, char[0]))
            total2 += 1;
    }

    try stdout.print("Part 1: {}\nPart 2: {}\n", .{ total1, total2 });
}
