const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const threadPath = b.dependency("thread", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = threadPath,
        .files = &.{
			"future.cpp",
			"tss_null.cpp",
			"once.cpp",
			"once_atomic.cpp",
			"thread.cpp",
			"thread.cpp",
			"thread_primitives.cpp",
			"tss_dll.cpp",
			"tss_pe.cpp"
        },
        .flags = cxxFlags,
    });
}
