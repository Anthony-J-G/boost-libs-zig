const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const randomPath = b.dependency("random", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = randomPath,
        .files = &.{
			"random_device.cpp"
        },
        .flags = cxxFlags,
    });
}
