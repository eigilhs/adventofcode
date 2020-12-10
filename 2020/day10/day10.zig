const std = @import("std");

const Node = struct {
    count: usize = 0,
    value: u64,
    fn asc(_: void, a: @This(), b: @This()) bool {
        return a.value < b.value;
    }
};

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var buffer: [20]u8 = undefined;
    var al = std.ArrayList(Node).init(&arena.allocator);
    try al.append(.{ .value = 0 });
    while (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |line|
        try al.append(.{ .value = try std.fmt.parseUnsigned(u64, line, 10) });
    std.sort.sort(Node, al.items, {}, Node.asc);
    try al.append(.{ .value = al.items[al.items.len - 1].value + 3 });
    const nums = al.items;

    var ones: usize = 0;
    var threes = ones;
    const part1 = for (nums[1..]) |n, i| {
        if (n.value - nums[i].value == 1) ones += 1;
        if (n.value - nums[i].value == 3) threes += 1;
    } else ones * threes;

    try stdout.print("Part 1: {}\nPart 2: {}\n", .{ part1, count(nums, 0) });
}

fn count(nums: []Node, i: usize) usize {
    const cur = &nums[i];
    if (cur.count != 0) return cur.count;
    if (i == nums.len - 1) return 1;

    cur.count = count(nums, i + 1);
    if (i < nums.len - 2 and nums[i + 2].value <= cur.value + 3)
        cur.count += count(nums, i + 2);
    if (i < nums.len - 3 and nums[i + 3].value <= cur.value + 3)
        cur.count += count(nums, i + 3);

    return cur.count;
}
