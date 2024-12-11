const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const stacktracePath = b.dependency("stacktrace", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = stacktracePath,
        .files = &.{
			"addr2line.cpp",
			"backtrace.cpp",
			"basic.cpp",
			"from_exception.cpp",
			"noop.cpp",
			"windbg.cpp",
			"windbg_cached.cpp"
        },
        .flags = cxxFlags,
    });
}
