const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const date_timePath = b.dependency("date_time", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = date_timePath,
        .files = &.{
			"date_generators.cpp",
			"gregorian_types.cpp",
			"greg_month.cpp",
			"greg_weekday.cpp",
			"posix_time_types.cpp"
        },
        .flags = cxxFlags,
    });
}
