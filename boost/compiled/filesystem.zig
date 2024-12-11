const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const filesystemPath = b.dependency("filesystem", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = filesystemPath,
        .files = &.{
			"codecvt_error_category.cpp",
			"directory.cpp",
			"exception.cpp",
			"operations.cpp",
			"path.cpp",
			"path_traits.cpp",
			"portability.cpp",
			"unique_path.cpp",
			"utf8_codecvt_facet.cpp",
			"windows_file_codecvt.cpp"
        },
        .flags = cxxFlags,
    });
}
