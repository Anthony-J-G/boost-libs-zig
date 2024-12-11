const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const iostreamsPath = b.dependency("iostreams", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = iostreamsPath,
        .files = &.{
			"bzip2.cpp",
			"file_descriptor.cpp",
			"gzip.cpp",
			"lzma.cpp",
			"mapped_file.cpp",
			"zlib.cpp",
			"zstd.cpp"
        },
        .flags = cxxFlags,
    });
}
