const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const contractPath = b.dependency("contract", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = contractPath,
        .files = &.{
			"contract.cpp"
        },
        .flags = cxxFlags,
    });
}
