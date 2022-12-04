const std = @import("std");
const max = std.math.max;
const min = std.math.min;

pub fn main() !void {
    var buffer: [12]u8 = undefined;
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var count1: usize = 0;
    var count2: usize = 0;

    while (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var tok = std.mem.tokenize(u8, line, "-,");
        const a: Interval = .{ .start = try read(&tok), .end = try read(&tok) };
        const b: Interval = .{ .start = try read(&tok), .end = try read(&tok) };

        if (a.contains(b) or b.contains(a))
            count1 += 1;
        if (a.overlaps(b))
            count2 += 1;
    }

    try stdout.print(
        "Part 1: {}\nPart 2: {}\n",
        .{ count1, count2 },
    );
}

fn read(tok: *std.mem.TokenIterator(u8)) !u8 {
    return try std.fmt.parseUnsigned(u8, tok.next().?, 10);
}

const Interval = struct {
    start: u8,
    end: u8,

    fn contains(self: Interval, other: Interval) bool {
        return self.start <= other.start and self.end >= other.end;
    }

    fn overlaps(self: Interval, other: Interval) bool {
        return min(self.end, other.end) >= max(self.start, other.start) or
            max(self.end, other.end) <= min(self.start, other.start);
    }
};
