const std = @import("std");

pub fn main() !void {
    var buffer: [64]u8 = undefined;
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var sum1: usize = 0;
    var sum2: usize = 0;
    var group = ~@as(u128, 0);
    var i: usize = 1;

    while (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |line| : (i += 1) {
        var seen_a: u128 = 0;
        var seen_b: u128 = 0;

        for (line[0 .. line.len / 2]) |item|
            seen_a |= @shlExact(@as(u128, 1), @intCast(u7, item));
        for (line[line.len / 2 ..]) |item|
            seen_b |= @shlExact(@as(u128, 1), @intCast(u7, item));

        sum1 += prio(@ctz(seen_a & seen_b));
        group &= seen_a | seen_b;
        if (i % 3 == 0) {
            sum2 += prio(@ctz(group));
            group = ~@as(u128, 0);
        }
    }

    try stdout.print(
        "Part 1: {}\nPart 2: {}\n",
        .{ sum1, sum2 },
    );
}

fn prio(item: u8) usize {
    if (item < 'a')
        return item - 'A' + 27
    else
        return item - 'a' + 1;
}
