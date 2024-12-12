bolierplate = (
"""const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;
"""
)



lib_build_function = (
"""
fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const **BOOST_LIBRARY_NAME**Path = b.dependency("**BOOST_LIBRARY_NAME**", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = **BOOST_LIBRARY_NAME**Path,
        .files = &.{
**SOURCE_FILES_HERE**
        },
        .flags = cxxFlags,
    });
}
""")