const std = @import("std");

const Content = struct {
    count: usize,
    color: []const u8,
};

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var children = std.StringHashMap([]Content).init(allocator);
    var parents = std.StringHashMap(std.ArrayList([]const u8)).init(allocator);

    const input = try stdin.readAllAlloc(allocator, 1 << 32);
    var lines = std.mem.tokenize(input, ".\n");

    outer: while (lines.next()) |line| {
        var colors = std.mem.tokenize(line, ",");
        var parts = std.mem.split(colors.next().?, " bags contain ");
        const container = parts.next().?;
        var color = parts.next();

        var clrs = std.ArrayList(Content).init(allocator);

        while (color != null) : (color = colors.next()) {
            var words = std.mem.tokenize(color.?, " ");
            const count = std.fmt.parseInt(u32, words.next().?, 10) catch
                continue :outer;

            const rest = words.rest();
            const colorLen = words.next().?.len + words.next().?.len + 1;
            const colorName = rest[0..colorLen];

            try clrs.append(.{ .count = count, .color = colorName });

            const gopr = try parents.getOrPut(colorName);
            if (!gopr.found_existing)
                gopr.entry.value = std.ArrayList([]const u8).init(allocator);
            try gopr.entry.value.append(container);
        }

        try children.put(container, clrs.items);
    }

    var set = std.BufSet.init(allocator);
    try uniqueParentsOf(parents, &set, "shiny gold");

    try stdout.print("Part 1: {}\nPart 2: {}\n", .{
        set.count(),
        countChildren(children, "shiny gold"),
    });
}

fn uniqueParentsOf(
    mp: std.StringHashMap(std.ArrayList([]const u8)),
    set: *std.BufSet,
    key: []const u8,
) error{OutOfMemory}!void {
    var pts = mp.get(key) orelse return;
    for (pts.items) |p| {
        try set.put(p);
        try uniqueParentsOf(mp, set, p);
    }
}

fn countChildren(mp: std.StringHashMap([]Content), key: []const u8) usize {
    var pts = mp.get(key) orelse return 0;
    var sum: usize = 0;
    for (pts) |p|
        sum += p.count * (countChildren(mp, p.color) + 1);
    return sum;
}
