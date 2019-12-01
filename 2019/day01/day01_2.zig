const std = @import("std");

const bis = std.io.BufferedInStream(std.fs.File.InStream.Error);

pub fn main() !void {
    var buffer: [10]u8 = undefined;
    const stdin = &bis.init(&std.io.getStdIn().inStream().stream).stream;

    var sum: u32 = 0;
    while (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |value| {
        sum += fuel(try std.fmt.parseInt(u32, value, 10));
    }

    std.debug.warn("{}\n", sum);
}

inline fn fuel(mass: u32) u32 {
    var x = mass;
    var sum: u32 = 0;

    while (!@subWithOverflow(u32, x / 3, 2, &x)) {
        sum += x;
    }

    return sum;
}

test "examples" {
    std.testing.expectEqual(@intCast(u32, 50346), fuel(100756));
    std.testing.expectEqual(@intCast(u32, 966), fuel(1969));
    std.testing.expectEqual(@intCast(u32, 2), fuel(14));
}
