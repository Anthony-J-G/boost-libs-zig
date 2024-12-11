const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const systemPath = b.dependency("system", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = systemPath,
        .files = &.{
			"error_code.cpp"
        },
        .flags = cxxFlags,
    });
}
