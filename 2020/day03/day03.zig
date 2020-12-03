const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    const map = try stdin.readAllAlloc(&arena.allocator, 1 << 32);
    const width = std.mem.indexOfScalar(u8, map, '\n').? + 1;

    const slope1 = run(map, width, 3, 1);
    const slopes = [_][2]u8{
        .{ 1, 1 },
        .{ 5, 1 },
        .{ 7, 1 },
        .{ 1, 2 },
    };

    var total = slope1;
    for (slopes) |s| {
        total *= run(map, width, s[0], s[1]);
    }

    try stdout.print("Part 1: {}\nPart 2: {}\n", .{ slope1, total });
}

fn run(map: []u8, width: usize, dx: u8, dy: u8) u32 {
    var x: usize = 0;
    var y: usize = 0;
    var trees: u32 = 0;

    while (y < map.len / width) {
        if (map[y * width + x] == '#')
            trees += 1;

        x = (x + dx) % (width - 1);
        y += dy;
    }

    return trees;
}
