const std = @import("std");
const itoa = std.fmt.parseInt;
const intToEnum = std.meta.intToEnum;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    const input = try stdin.readAllAlloc(&arena.allocator, 1 << 32);

    try stdout.print("Part 1: {}\nPart 2: {}\n", .{
        run(input, part1),
        run(input, part2),
    });
}

fn run(input: []const u8, verify: fn (Field, []const u8) bool) usize {
    var ti = std.mem.tokenize(input, " \n");
    var cnt: usize = 0;
    var validCount: usize = 0;

    while (ti.next()) |token| {
        if (ti.index - token.len > 2 and ti.buffer[ti.index - token.len - 2] == '\n') {
            if (validCount >= 7)
                cnt += 1;
            validCount = 0;
        }
        const field = @intToEnum(Field, @ptrCast(*align(1) const u24, token).*);
        if (verify(field, token[4..]))
            validCount += 1;
    }

    if (validCount >= 7)
        cnt += 1;

    return cnt;
}

fn part1(field: Field, value: []const u8) bool {
    return field != .cid;
}

fn part2(field: Field, value: []const u8) bool {
    return switch (field) {
        .cid => false,
        .byr, .iyr, .eyr => blk: {
            const year = itoa(u16, value, 10) catch break :blk false;
            break :blk switch (field) {
                .byr => year >= 1920 and year <= 2002,
                .iyr => year >= 2010 and year <= 2020,
                .eyr => year >= 2020 and year <= 2030,
                else => unreachable,
            };
        },
        .hgt => blk: {
            const height = itoa(u16, value[0 .. value.len - 2], 10) catch break :blk false;
            const val = @ptrCast(*align(1) const u16, value[value.len - 2 ..]).*;
            const unit = intToEnum(Unit, val) catch break :blk false;
            break :blk switch (unit) {
                .cm => height >= 150 and height <= 193,
                .in => height >= 59 and height <= 76,
            };
        },
        .hcl => blk: {
            var v = value[0] == '#' and value.len == 7;
            for (value[1..]) |c| {
                v = v and ((c >= '0' and c <= '9') or (c >= 'a' and c <= 'f'));
            }
            break :blk v;
        },
        .ecl => blk: {
            const color = @ptrCast(*align(1) const u24, value).*;
            _ = intToEnum(EyeColor, color) catch break :blk false;
            break :blk true;
        },
        .pid => blk: {
            var v = value.len == 9;
            for (value) |c| {
                v = v and c >= '0' and c <= '9';
            }
            break :blk v;
        },
    };
}

const Field = enum(u24) {
    byr = trio("byr"),
    iyr = trio("iyr"),
    eyr = trio("eyr"),
    hgt = trio("hgt"),
    hcl = trio("hcl"),
    ecl = trio("ecl"),
    pid = trio("pid"),
    cid = trio("cid"),
};

const EyeColor = enum(u24) {
    amb = trio("amb"),
    blu = trio("blu"),
    brn = trio("brn"),
    gry = trio("gry"),
    grn = trio("grn"),
    hzl = trio("hzl"),
    oth = trio("oth"),
};

const Unit = enum(u16) {
    cm = duo("cm"),
    in = duo("in"),
};

fn trio(comptime v: *const [3]u8) u24 {
    return @ptrCast(*const u24, v).*;
}

fn duo(comptime v: *const [2]u8) u16 {
    return @ptrCast(*const u16, v).*;
}
