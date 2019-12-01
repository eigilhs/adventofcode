const std = @import("std");

const bis = std.io.BufferedInStream(std.fs.File.InStream.Error);

pub fn main() !void {
    var buffer: [10]u8 = undefined;
    const stdin = &bis.init(&std.io.getStdIn().inStream().stream).stream;

    var sum: u32 = 0;
    while (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |value| {
        sum += (try std.fmt.parseInt(u32, value, 10)) / 3 - 2;
    }

    std.debug.warn("{}\n", sum);
}
