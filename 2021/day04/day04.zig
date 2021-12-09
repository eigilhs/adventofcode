const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var buffer: [std.mem.page_size]u8 = undefined;

    var nums = std.ArrayList(u8).init(&arena.allocator);
    var first_line = try stdin.readUntilDelimiterOrEof(&buffer, '\n');
    var splt = std.mem.tokenize(u8, first_line.?, ",");
    while (splt.next()) |n|
        try nums.append(try std.fmt.parseUnsigned(u8, n, 10));
    _ = try stdin.readUntilDelimiterOrEof(&buffer, '\n');

    var data: [5][5]u8 = undefined;
    var row: usize = 0;
    var boards = std.ArrayList(Board).init(&arena.allocator);
    while (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |line| : (row = (row + 1) % 6) {
        var splt2 = std.mem.tokenize(u8, line, " ");
        var i: usize = 0;
        while (splt2.next()) |n| : (i += 1)
            data[row][i] = try std.fmt.parseUnsigned(u8, n, 10);
        if (row == 4)
            try boards.append(Board{ .data = data });
    }

    var done: usize = 0;
    for (nums.items) |n| {
        for (boards.items) |*board| {
            if (!board.mark(n))
                continue;
            done += 1;
            if (done == 1) {
                try stdout.print("Part 1: {}\n", .{board.sum_unmarked() * n});
            } else if (boards.items.len == done) {
                try stdout.print("Part 2: {}\n", .{board.sum_unmarked() * n});
                return;
            }
        }
    }
}

const Board = struct {
    data: [5][5]u8 = undefined,
    done: bool = false,

    fn mark(self: *@This(), n: u8) bool {
        if (self.done)
            return false;

        return outer: for (self.data) |*row, i| {
            for (row) |*col, j| {
                if (col.* == n) {
                    col.* = 'x';
                    self.done = self.bingo(i, j);
                    break :outer self.done;
                }
            }
        } else false;
    }

    fn bingo(self: *@This(), row: usize, col: usize) bool {
        if (std.mem.allEqual(u8, self.data[row][0..], 'x'))
            return true;

        return for (self.data) |r| {
            if (r[col] != 'x')
                break false;
        } else true;
    }

    fn sum_unmarked(self: *@This()) u32 {
        var sum: u32 = 0;
        for (self.data) |row| {
            for (row) |n| {
                if (n != 'x')
                    sum += n;
            }
        }
        return sum;
    }
};
