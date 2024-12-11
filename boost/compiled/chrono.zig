const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const chronoPath = b.dependency("chrono", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = chronoPath,
        .files = &.{
			"chrono.cpp",
			"process_cpu_clocks.cpp",
			"thread_clock.cpp"
        },
        .flags = cxxFlags,
    });
}
