const std = @import("std");
const print = @import("std").debug.print;
const c = @cImport({
    @cDefine("_NO_CRT_STDIO_INLINE", "1");
    @cInclude("stdio.h");
});

const sql = @cImport({
    @cInclude("mysql.h");
});

pub fn ptrToString(ptr: []const u8) anyerror!void {
    for (ptr) |num| {
        print("{any}", .{num});
    }
}

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    print("All your {s} are belong to us.\n", .{"lives"});
    _ = c.printf("I love god and all of his little minions.\n");

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});
    const testing: c_ulong = 45;
    var mysql_ptr: sql.MYSQL = undefined;
    const conn_ptr = sql.mysql_init(&mysql_ptr);
    print("mysql: {any}\nconn: {any}\n", .{ @TypeOf(mysql_ptr), @TypeOf(conn_ptr) });

    // Code snippet to run the mysql commands
    print("MySQL Client Information: {any}\n\nValue of c_ulong: {any}\n\nMySQL Server Information: {any}\n\n", .{ std.mem.span(sql.mysql_get_client_info()), testing, sql.mysql_get_server_info(&mysql_ptr) });
    try ptrToString(std.mem.span(sql.mysql_get_client_info()));
    try bw.flush(); // don't forget to flush!
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
