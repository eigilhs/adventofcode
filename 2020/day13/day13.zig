const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const input = try stdin.readAllAlloc(&arena.allocator, 1 << 32);
    const nl = std.mem.indexOfScalar(u8, input, '\n').?;
    const arrival = try std.fmt.parseInt(i64, input[0..nl], 10);

    var al = std.ArrayList(Bus).init(&arena.allocator);
    var tkn = std.mem.tokenize(input[nl + 1 ..], ",\n");
    var i: usize = 0;
    while (tkn.next()) |b| : (i += 1) {
        if (b[0] == 'x') continue;
        const busId = try std.fmt.parseInt(i64, b, 10);
        try al.append(.{ .id = busId, .offset = @intCast(i64, i) });
    }
    const buses = al.items;

    const firstBus = std.sort.min(Bus, buses, arrival, Bus.ascByWait).?;
    try stdout.print("Part 1: {}\nPart 2: {}\n", .{
        firstBus.wait(arrival) * firstBus.id,
        chineseRemainder(buses),
    });
}

const Bus = struct {
    id: i64,
    offset: i64,

    fn ascByWait(time: i64, a: @This(), b: @This()) bool {
        return a.wait(time) < b.wait(time);
    }

    fn wait(self: @This(), time: i64) i64 {
        return @mod(-time, self.id);
    }
};

fn eGcd(a: i64, b: i64) struct { g: i64, x: i64, y: i64 } {
    if (a == 0) return .{ .g = b, .x = 0, .y = 1 };
    const e = eGcd(@mod(b, a), a);
    return .{ .g = e.g, .x = e.y - @divFloor(b, a) * e.x, .y = e.x };
}

fn modInv(x: i64, n: i64) i64 {
    const e = eGcd(x, n);
    return @mod((@mod(e.x, n) + n), n);
}

fn chineseRemainder(buses: []Bus) i64 {
    var prod: i64 = 1;
    for (buses) |b|
        prod *= b.id;

    var sum: i64 = 0;
    for (buses) |b| {
        const p = @divFloor(prod, b.id);
        sum += b.offset * modInv(p, b.id) * p;
    }

    return @mod(-sum, prod);
}
