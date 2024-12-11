const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const atomicPath = b.dependency("atomic", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = atomicPath,
        .files = &.{
			"find_address_sse2.cpp",
			"find_address_sse41.cpp",
			"lock_pool.cpp",
			"wait_on_address.cpp"
        },
        .flags = cxxFlags,
    });
}
