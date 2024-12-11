const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const charconvPath = b.dependency("charconv", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = charconvPath,
        .files = &.{
			"from_chars.cpp",
			"to_chars.cpp"
        },
        .flags = cxxFlags,
    });
}
