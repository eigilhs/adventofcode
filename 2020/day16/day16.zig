const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;
    const input = try stdin.readAllAlloc(allocator, 1 << 32);

    var lines = std.mem.split(input, "\n");
    var rules = std.ArrayList(Rule).init(allocator);

    while (lines.next()) |line| {
        if (line.len == 0) break;
        try rules.append(try Rule.parse(allocator, line));
    }

    var rs = RuleSet{ .rules = rules.items };
    _ = lines.next();
    const myTicket = try Ticket.parse(allocator, lines.next().?);
    _ = lines.next();
    _ = lines.next();

    var errorRate: u64 = 0;
    while (lines.next()) |line| {
        if (line.len == 0) break;
        errorRate += rs.apply(try Ticket.parse(allocator, line));
    }

    std.sort.sort(Rule, rs.rules, {}, Rule.popCountAsc);

    var used: u64 = 0;
    for (rs.rules) |*rule| {
        const x = rule.positions & ~used;
        rule.positions = x & ~x + 1;
        used |= rule.positions;
    }

    std.sort.sort(Rule, rs.rules, {}, Rule.asc);

    var part2: u64 = 1;
    for (myTicket.numbers) |n, i| {
        if (rs.rules[i].departure)
            part2 *= n;
    }

    try stdout.print("Part 1: {}\nPart 2: {}\n", .{ errorRate, part2 });
}

const Ticket = struct {
    numbers: []u64,

    fn parse(allocator: *std.mem.Allocator, input: []const u8) !@This() {
        var al = std.ArrayList(u64).init(allocator);
        var nums = std.mem.split(input, ",");
        while (nums.next()) |num|
            try al.append(try std.fmt.parseUnsigned(u64, num, 10));
        return @This(){ .numbers = al.items };
    }
};

const RuleSet = struct {
    rules: []Rule,

    fn apply(self: @This(), ticket: Ticket) u64 {
        for (ticket.numbers) |n| {
            for (self.rules) |rule| {
                if (rule.valid(n)) break;
            } else return n;
        }
        for (ticket.numbers) |n, i| {
            for (self.rules) |*rule| {
                if (!rule.valid(n))
                    rule.positions &= ~(@as(u64, 1) << @intCast(u6, i));
            }
        }
        return 0;
    }
};

const Rule = struct {
    ranges: []Range,
    positions: u64 = ~@as(u64, 0),
    departure: bool,

    fn parse(allocator: *std.mem.Allocator, input: []const u8) !@This() {
        var pts = std.mem.split(input, ": ");
        const name = pts.next().?;
        var ranges = std.mem.split(pts.next().?, " or ");
        var al = std.ArrayList(Range).init(allocator);
        while (ranges.next()) |range| {
            var lims = std.mem.split(range, "-");
            const lo = try std.fmt.parseUnsigned(u64, lims.next().?, 10);
            const hi = try std.fmt.parseUnsigned(u64, lims.next().?, 10);
            try al.append(.{ .low = lo, .high = hi });
        }
        return @This(){
            .departure = std.mem.startsWith(u8, name, "departure"),
            .ranges = al.items,
        };
    }

    fn valid(self: @This(), n: u64) bool {
        for (self.ranges) |range|
            if (range.valid(n)) return true;
        return false;
    }

    fn asc(_: void, a: @This(), b: @This()) bool {
        return a.positions < b.positions;
    }

    fn popCountAsc(_: void, a: @This(), b: @This()) bool {
        return @popCount(u64, a.positions) < @popCount(u64, b.positions);
    }
};

const Range = struct {
    low: u64,
    high: u64,

    fn valid(self: @This(), n: u64) bool {
        return self.low <= n and n <= self.high;
    }
};
