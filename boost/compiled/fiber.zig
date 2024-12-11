const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const fiberPath = b.dependency("fiber", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = fiberPath,
        .files = &.{
			"barrier.cpp",
			"condition_variable.cpp",
			"context.cpp",
			"fiber.cpp",
			"future.cpp",
			"mutex.cpp",
			"properties.cpp",
			"recursive_mutex.cpp",
			"recursive_timed_mutex.cpp",
			"scheduler.cpp",
			"timed_mutex.cpp",
			"waker.cpp",
			"algorithm.cpp",
			"round_robin.cpp",
			"shared_work.cpp",
			"work_stealing.cpp",
			"pin_thread.cpp",
			"topology.cpp",
			"pin_thread.cpp",
			"topology.cpp",
			"work_stealing.cpp",
			"pin_thread.cpp",
			"topology.cpp",
			"pin_thread.cpp",
			"topology.cpp",
			"pin_thread.cpp",
			"topology.cpp",
			"pin_thread.cpp",
			"topology.cpp",
			"pin_thread.cpp",
			"topology.cpp"
        },
        .flags = cxxFlags,
    });
}
