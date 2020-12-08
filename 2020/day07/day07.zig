const std = @import("std");

const Child = struct {
    count: usize,
    color: *Color,
};

const Color = struct {
    children: []Child = &[_]Child{},
    parents: std.ArrayListUnmanaged(*Color) = .{},
    visited: bool = false,

    fn init(allocator: *std.mem.Allocator) !*@This() {
        const color = try allocator.create(@This());
        color.* = .{};
        return color;
    }

    fn uniqueParentsOf(self: *@This()) usize {
        var sum: usize = 0;
        for (self.parents.items) |p| {
            if (p.visited)
                continue;
            p.visited = true;
            sum += uniqueParentsOf(p) + 1;
        }
        return sum;
    }

    fn countChildren(self: *@This()) usize {
        var sum: usize = 0;
        for (self.children) |c|
            sum += c.count * (countChildren(c.color) + 1);
        return sum;
    }
};

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var colors = std.StringHashMap(*Color).init(allocator);

    const input = try stdin.readAllAlloc(allocator, 1 << 32);
    var lines = std.mem.tokenize(input, ".\n");

    outer: while (lines.next()) |line| {
        var childColors = std.mem.tokenize(line, ",");
        var parts = std.mem.split(childColors.next().?, " bags contain ");

        const res = try colors.getOrPut(parts.next().?);
        if (!res.found_existing)
            res.entry.value = try Color.init(allocator);
        const container = res.entry.value;

        var children = std.ArrayList(Child).init(allocator);
        var color = parts.next();

        while (color != null) : (color = childColors.next()) {
            var words = std.mem.tokenize(color.?, " ");
            const count = std.fmt.parseInt(u32, words.next().?, 10) catch
                continue :outer;

            const rest = words.rest();
            const colorLen = words.next().?.len + words.next().?.len + 1;
            const colorName = rest[0..colorLen];

            const res2 = try colors.getOrPut(colorName);
            if (!res2.found_existing)
                res2.entry.value = try Color.init(allocator);

            try res2.entry.value.parents.append(allocator, container);
            try children.append(.{ .count = count, .color = res2.entry.value });
        }

        container.children = children.items;
    }

    var shinyGold = colors.get("shiny gold").?;
    try stdout.print("Part 1: {}\nPart 2: {}\n", .{
        shinyGold.uniqueParentsOf(),
        shinyGold.countChildren(),
    });
}
