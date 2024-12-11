const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const timerPath = b.dependency("timer", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = timerPath,
        .files = &.{
			"auto_timers_construction.cpp",
			"cpu_timer.cpp"
        },
        .flags = cxxFlags,
    });
}
