const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const regexPath = b.dependency("regex", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = regexPath,
        .files = &.{
			"posix_api.cpp",
			"regex.cpp",
			"regex_debug.cpp",
			"static_mutex.cpp",
			"wide_posix_api.cpp"
        },
        .flags = cxxFlags,
    });
}
