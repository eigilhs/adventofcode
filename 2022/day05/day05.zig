const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    const input = try stdin.readAllAlloc(allocator, 1 << 32);
    var parts = std.mem.split(u8, input, "\n\n");

    const manifest = parts.next().?;
    const procedure = try CrateMoverProc.init(allocator, parts.next().?);
    const ship1 = try Ship.init(allocator, manifest);
    const ship2 = try ship1.clone();

    try crate_mover_9000(procedure, ship1);
    try crate_mover_9001(procedure, ship2);

    try stdout.print(
        "Part 1: {s}\nPart 2: {s}\n",
        .{ try ship1.result(), try ship2.result() },
    );
}

fn crate_mover_9000(proc: CrateMoverProc, ship: Ship) !void {
    const stacks = ship.stacks;
    for (proc.operations) |op| {
        var i: usize = 0;
        while (i < op.count) : (i += 1)
            try stacks[op.to].append(stacks[op.from].pop());
    }
}

fn crate_mover_9001(proc: CrateMoverProc, ship: Ship) !void {
    const stacks = ship.stacks;
    for (proc.operations) |op| {
        const from = &stacks[op.from];
        try stacks[op.to].appendSlice(from.items[from.items.len - op.count ..]);
        from.shrinkRetainingCapacity(from.items.len - op.count);
    }
}
const Ship = struct {
    stacks: []std.ArrayList(u8),
    allocator: std.mem.Allocator,

    fn init(allocator: std.mem.Allocator, manifest: []const u8) !Ship {
        const num_stacks = (std.mem.indexOf(u8, manifest, "\n").? + 1) / 4;
        var stacks = blk: {
            var stacks = std.ArrayList(std.ArrayList(u8)).init(allocator);
            var i: usize = 0;
            while (i < num_stacks) : (i += 1)
                try stacks.append(std.ArrayList(u8).init(allocator));
            break :blk stacks.items;
        };

        var floors = std.mem.tokenize(u8, manifest, "\n");
        while (floors.next()) |floor| {
            var i: usize = 1;
            while (i < floor.len - 1) : (i += 4) {
                const stack_no = (i - 1) / 4;
                switch (floor[i]) {
                    'A'...'Z' => |crate| try stacks[stack_no].append(crate),
                    else => continue,
                }
            }
        }
        for (stacks) |stack|
            std.mem.reverse(u8, stack.items);

        return .{ .stacks = stacks, .allocator = allocator };
    }

    fn clone(self: Ship) !Ship {
        const new_mem = try self.allocator.alloc(std.ArrayList(u8), self.stacks.len);
        for (self.stacks) |*stack, i|
            new_mem[i] = try stack.clone();
        return .{ .allocator = self.allocator, .stacks = new_mem };
    }

    fn result(self: Ship) ![]const u8 {
        var res = std.ArrayList(u8).init(self.allocator);
        for (self.stacks) |stack|
            try res.append(stack.items[stack.items.len - 1]);
        return res.items;
    }
};

const CrateMoverProc = struct {
    const Operation = struct {
        count: u8,
        from: u8,
        to: u8,
    };

    operations: []Operation,

    fn init(allocator: std.mem.Allocator, procedure: []const u8) !CrateMoverProc {
        var proc = std.ArrayList(Operation).init(allocator);
        var operations = std.mem.tokenize(u8, procedure, "\n");
        while (operations.next()) |operation| {
            var tok = std.mem.tokenize(u8, operation[5..], " fromt");
            const count = try std.fmt.parseUnsigned(u8, tok.next().?, 10);
            const from_idx = try std.fmt.parseUnsigned(u8, tok.next().?, 10) - 1;
            const to_idx = try std.fmt.parseUnsigned(u8, tok.next().?, 10) - 1;
            try proc.append(.{ .count = count, .from = from_idx, .to = to_idx });
        }
        return .{ .operations = proc.items };
    }
};
