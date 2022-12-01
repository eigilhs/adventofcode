const std = @import("std");

pub fn main() !void {
    var buffer: [12]u8 = undefined;
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var calories: u32 = 0;
    var max = [_]u32{0} ** 3;

    while (true) {
        const line = try stdin.readUntilDelimiterOrEof(&buffer, '\n');
        const end_of_elf = if (line) |l| l.len == 0 else true;
        if (end_of_elf) {
            if (calories > max[0])
                max[0] = calories;
            std.sort.sort(u32, &max, {}, std.sort.asc(u32));
            if (line) |_| {} else break;
            calories = 0;
        } else {
            calories += try std.fmt.parseInt(u32, line.?, 10);
        }
    }

    try stdout.print(
        "Part 1: {}\nPart 2: {}\n",
        .{ max[2], max[0] + max[1] + max[2] },
    );
}
