const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const jsonPath = b.dependency("json", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = jsonPath,
        .files = &.{
			"src.cpp"
        },
        .flags = cxxFlags,
    });
}
