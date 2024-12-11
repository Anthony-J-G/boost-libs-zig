const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const exceptionPath = b.dependency("exception", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = exceptionPath,
        .files = &.{
			"clone_current_exception_non_intrusive.cpp"
        },
        .flags = cxxFlags,
    });
}
