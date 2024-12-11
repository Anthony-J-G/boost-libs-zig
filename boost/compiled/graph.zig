const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const graphPath = b.dependency("graph", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = graphPath,
        .files = &.{
			"graphml.cpp",
			"read_graphviz_new.cpp"
        },
        .flags = cxxFlags,
    });
}
