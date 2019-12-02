const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

const bis = std.io.BufferedInStream(std.fs.File.InStream.Error);

pub fn main() !void {
    var buffer: [10]u8 = undefined;
    var prog: [4096]u32 = undefined;
    const stdin = &bis.init(&std.io.getStdIn().inStream().stream).stream;

    var i: u32 = 0;
    while (try stdin.readUntilDelimiterOrEof(&buffer, ',')) |val| : (i += 1) {
        prog[i] = try fmt.parseInt(u32, mem.trimRight(u8, val, "\n"), 10);
    }

    prog[1] = 12;
    prog[2] = 2;

    var ip: u32 = 0;
    while (ip < i) : (ip += 4) {
        switch (prog[ip]) {
            1 => prog[prog[ip+3]] = prog[prog[ip+1]] + prog[prog[ip+2]],
            2 => prog[prog[ip+3]] = prog[prog[ip+1]] * prog[prog[ip+2]],
            99 => break,
            else => unreachable,
        }
    }

    std.debug.warn("{}\n", prog[0]);
}
