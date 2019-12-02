const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

const bis = std.io.BufferedInStream(std.fs.File.InStream.Error);

pub fn main() !void {
    var buffer: [10]u8 = undefined;
    var original: [4096]u32 = undefined;
    var prog: [4096]u32 = undefined;
    const stdin = &bis.init(&std.io.getStdIn().inStream().stream).stream;

    var i: u32 = 0;
    while (try stdin.readUntilDelimiterOrEof(&buffer, ',')) |val| : (i += 1)
        original[i] = try fmt.parseInt(u32, mem.trimRight(u8, val, "\n"), 10);

    var noun: u8 = 0;
    var verb: u8 = 0;
    outer: while (noun < 100) : ({ noun += 1; verb = 0; }) {
        while (verb < 100) : (verb += 1) {
            mem.copy(u32, prog[0..i], original);
            prog[1] = noun;
            prog[2] = verb;
            if (run(prog[0..i]) == 19690720)
                break :outer;
        }
    } else unreachable;

    std.debug.warn("{}\n", @intCast(u32, noun) * 100 + verb);
}

inline fn run(prog: []u32) u32 {
    var ip: u32 = 0;
    while (ip < prog.len) : (ip += 4) {
        switch (prog[ip]) {
            1 => prog[prog[ip+3]] = prog[prog[ip+1]] + prog[prog[ip+2]],
            2 => prog[prog[ip+3]] = prog[prog[ip+1]] * prog[prog[ip+2]],
            99 => break,
            else => unreachable,
        }
    }
    return prog[0];
}
