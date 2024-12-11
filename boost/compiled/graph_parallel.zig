const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const graph_parallelPath = b.dependency("graph_parallel", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = graph_parallelPath,
        .files = &.{
			"mpi_process_group.cpp",
			"tag_allocator.cpp"
        },
        .flags = cxxFlags,
    });
}
