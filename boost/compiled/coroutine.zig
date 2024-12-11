const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const coroutinePath = b.dependency("coroutine", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = coroutinePath,
        .files = &.{
			"exceptions.cpp",
			"coroutine_context.cpp",
			"stack_traits.cpp",
			"stack_traits.cpp"
        },
        .flags = cxxFlags,
    });
}
