const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var buffer: [128 * 8 * 11]u8 = undefined;
    var seats: [128 * 8]bool = undefined;

    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    _ = try stdin.readAllAlloc(&fba.allocator, buffer.len);

    var max: u10 = 0;
    for (@ptrCast(*[128 * 8][10:'\n']u8, &buffer).*) |line| {
        var x = seat(line);
        if (x > max)
            max = x;
        seats[x] = true;
    }

    const mySeat = for (seats) |occupied, id| {
        if (occupied and !seats[id + 1] and seats[id + 2])
            break id + 1;
    } else unreachable;

    try stdout.print("Part 1: {}\nPart 2: {}\n", .{ max, mySeat });
}

fn seat(pass: [10:'\n']u8) u10 {
    var id: u10 = 0;
    for (pass) |c| {
        id <<= 1;
        if (c == 'B' or c == 'R')
            id |= 1;
    }
    return id;
}
