const std = @import("std");

pub fn main() !void {
    var buffer: [4]u8 = undefined;
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var score1: i32 = 0;
    var score2: i32 = 0;

    while (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        const elf = @intCast(i8, line[0] - 'A');
        const outcome = @intCast(i8, line[2] - 'X');

        const me = switch (outcome) {
            0 => @mod(elf - 1, 3),
            2 => @mod(elf + 1, 3),
            else => elf,
        };

        score1 += score(elf, outcome);
        score2 += score(elf, me);
    }

    try stdout.print(
        "Part 1: {}\nPart 2: {}\n",
        .{ score1, score2 },
    );
}

fn score(elf: i8, me: i8) i8 {
    return if (@mod(me - 1, 3) == elf)
        6 + me + 1
    else if (me == elf)
        3 + me + 1
    else
        me + 1;
}
