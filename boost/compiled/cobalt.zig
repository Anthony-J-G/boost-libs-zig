const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const cobaltPath = b.dependency("cobalt", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = cobaltPath,
        .files = &.{
			"channel.cpp",
			"error.cpp",
			"main.cpp",
			"this_thread.cpp",
			"thread.cpp",
			"exception.cpp",
			"util.cpp"
        },
        .flags = cxxFlags,
    });
}
