const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const program_optionsPath = b.dependency("program_options", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = program_optionsPath,
        .files = &.{
			"cmdline.cpp",
			"config_file.cpp",
			"convert.cpp",
			"options_description.cpp",
			"parsers.cpp",
			"positional_options.cpp",
			"split.cpp",
			"utf8_codecvt_facet.cpp",
			"value_semantic.cpp",
			"variables_map.cpp",
			"winmain.cpp"
        },
        .flags = cxxFlags,
    });
}
