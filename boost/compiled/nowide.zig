const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const nowidePath = b.dependency("nowide", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = nowidePath,
        .files = &.{
			"console_buffer.cpp",
			"cstdio.cpp",
			"cstdlib.cpp",
			"filebuf.cpp",
			"iostream.cpp",
			"stat.cpp"
        },
        .flags = cxxFlags,
    });
}
