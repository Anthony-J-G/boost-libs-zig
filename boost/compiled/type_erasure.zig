const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const type_erasurePath = b.dependency("type_erasure", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = type_erasurePath,
        .files = &.{
			"dynamic_binding.cpp"
        },
        .flags = cxxFlags,
    });
}
