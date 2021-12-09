const std = @import("std");

const uint = u12;
const word_size = @bitSizeOf(uint);
const short = std.meta.Int(.unsigned, @ceil(@log2(@as(f32, word_size))));

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var buffer: [word_size]u8 = undefined;

    var nums = std.ArrayList(uint).init(&arena.allocator);
    while (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |line|
        try nums.append(try std.fmt.parseUnsigned(uint, line, 2));
    std.sort.sort(uint, nums.items, {}, comptime std.sort.asc(uint));

    var counts: [word_size]usize = .{0} ** word_size;
    var j: usize = nums.items.len;

    for (nums.items) |n| {
        var i: short = 0;
        while (i < word_size) : (i += 1) {
            if (n & (@as(uint, 1) << (@as(short, word_size) - 1 - i)) != 0)
                counts[i] += 1;
        }
    }

    var gamma: uint = 0;
    for (counts) |c| {
        gamma <<= 1;
        if (c > j / 2)
            gamma |= 1;
    }

    const o2 = rating(Gas.oxygen, nums.items, word_size);
    const co2 = rating(Gas.carbondioxide, nums.items, word_size);

    try stdout.print("Part 1: {}\nPart 2: {}\n", .{
        @as(u32, gamma) * ~gamma,
        @as(u32, o2) * co2,
    });
}

fn rating(comptime gas: Gas, nums: []uint, col: short) uint {
    const len = nums.len;
    if (len == 1)
        return nums[0];

    const pivot = for (nums) |n, i| {
        if (n & (@as(uint, 1) << (col - 1)) != 0)
            break i;
    } else len;

    const criterion = switch (gas) {
        Gas.oxygen => pivot * 2 > len,
        Gas.carbondioxide => pivot * 2 <= len,
    };

    if (criterion)
        return rating(gas, nums[pivot..len], col - 1);
    return rating(gas, nums[0..pivot], col - 1);
}

const Gas = enum {
    oxygen,
    carbondioxide,
};
