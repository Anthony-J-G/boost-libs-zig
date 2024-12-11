const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const contextPath = b.dependency("context", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = contextPath,
        .files = &.{
			"continuation.cpp",
			"dummy.cpp",
			"fcontext.cpp",
			"fiber.cpp",
			"untested.cpp",
			"tail_ontop_ppc32_sysv.cpp",
			"stack_traits.cpp",
			"stack_traits.cpp"
        },
        .flags = cxxFlags,
    });
}
