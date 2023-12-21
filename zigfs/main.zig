const std = @import("std");
const print = std.debug.print;

pub fn fine_print(user: []const u8, message: []const u8) void {
    print("{s}: {s}", .{ user, message });
}

// pub fn fileCopy() anyerror!void {
//     try std.fs.cwd().copyFile()
// }

pub fn main() anyerror!void {
    fine_print("Satyam", "Golly gee! I wonder where all of my brain cells went!\n");

    // const file = std.fs.cwd().openFile("sample2.txt", .{
    //     .mode = .read_only,
    //     .lock = .none,
    // });

    try std.fs.cwd().copyFile("sample2.txt", std.fs.cwd(), "copied.txt", .{
        .override_mode = null,
    });

    const home_dir = std.os.getenv("HOME");

    const gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const full_path = std.fs.path.join(allocator, .{ home_dir, "playground/zig" });
    defer full_path;

    print("fs: {any}", .{full_path});
    print("fs: this is the home directory = {any}\n", .{@TypeOf(home_dir)});

    const copy_file = std.fs.cwd().openFile("copied.txt", .{
        .mode = .read_only,
        .lock = .none,
    });

    print("This is what the value of 'file' is: {any}", .{copy_file});
}
