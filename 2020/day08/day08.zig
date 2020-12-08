const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var codeList = std.ArrayList(Statement).init(allocator);
    const input = try stdin.readAllAlloc(allocator, 1 << 32);
    var lines = std.mem.tokenize(input, "\n");
    while (lines.next()) |line| {
        try codeList.append(Statement{
            .ins = @intToEnum(
                Instruction,
                @ptrCast(*align(1) const u24, line[0..3]).*,
            ),
            .imm = try std.fmt.parseInt(i16, line[4..], 10),
        });
    }

    var machine = &Machine{ .code = codeList.items };
    _ = machine.run();
    try stdout.print("Part 1: {}\n", .{machine.accumulator});
    machine.clear();

    var cur: usize = 0;
    while (true) : (cur += 1) {
        while (!machine.swap(cur)) : (cur += 1) {}

        if (machine.run()) break;

        _ = machine.swap(cur);
        machine.clear();
    }

    try stdout.print("Part 2: {}\n", .{machine.accumulator});
}

const Instruction = enum(u24) {
    nop = @ptrCast(*const u24, "nop").*,
    acc = @ptrCast(*const u24, "acc").*,
    jmp = @ptrCast(*const u24, "jmp").*,
};

const Statement = struct {
    cnt: usize = 0,
    ins: Instruction,
    imm: i16,
};

const Machine = struct {
    code: []Statement,
    accumulator: i32 = 0,

    fn clear(self: *@This()) void {
        for (self.code) |*c|
            c.cnt = 0;
        self.accumulator = 0;
    }

    fn run(self: *@This()) bool {
        self.accumulator = 0;
        var code = self.code;
        var ip: usize = 0;
        while (ip < code.len) : (ip += 1) {
            const cur = &code[ip];
            if (cur.cnt == 1) {
                cur.cnt = 0;
                return false;
            }
            switch (cur.ins) {
                .nop => {},
                .acc => {
                    self.accumulator += cur.imm;
                },
                .jmp => {
                    ip = @intCast(usize, @intCast(i64, ip) + cur.imm - 1);
                },
            }
            cur.cnt += 1;
        }
        return true;
    }

    fn swap(self: *@This(), idx: usize) bool {
        var s = &self.code[idx].ins;
        switch (s.*) {
            .jmp => {
                s.* = .nop;
                return true;
            },
            .nop => {
                s.* = .jmp;
                return true;
            },
            else => return false,
        }
    }
};
