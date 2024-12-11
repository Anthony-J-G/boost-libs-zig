const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const containerPath = b.dependency("container", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = containerPath,
        .files = &.{
			"dlmalloc.cpp",
			"global_resource.cpp",
			"monotonic_buffer_resource.cpp",
			"pool_resource.cpp",
			"synchronized_pool_resource.cpp",
			"unsynchronized_pool_resource.cpp"
        },
        .flags = cxxFlags,
    });
}
