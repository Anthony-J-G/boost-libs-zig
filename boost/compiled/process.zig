const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const processPath = b.dependency("process", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = processPath,
        .files = &.{
			"environment.cpp",
			"error.cpp",
			"pid.cpp",
			"shell.cpp",
			"environment_posix.cpp",
			"environment_win.cpp",
			"last_error.cpp",
			"process_handle_windows.cpp",
			"throw_error.cpp",
			"utf8.cpp",
			"cmd.cpp",
			"cwd.cpp",
			"env.cpp",
			"exe.cpp",
			"proc_info.cpp",
			"close_handles.cpp",
			"default_launcher.cpp"
        },
        .flags = cxxFlags,
    });
}
