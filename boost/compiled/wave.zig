const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const wavePath = b.dependency("wave", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = wavePath,
        .files = &.{
			"instantiate_cpp_exprgrammar.cpp",
			"instantiate_cpp_grammar.cpp",
			"instantiate_cpp_literalgrs.cpp",
			"instantiate_defined_grammar.cpp",
			"instantiate_has_include_grammar.cpp",
			"instantiate_predef_macros.cpp",
			"instantiate_re2c_lexer.cpp",
			"instantiate_re2c_lexer_str.cpp",
			"token_ids.cpp",
			"wave_config_constant.cpp",
			"aq.cpp",
			"cpp_re.cpp"
        },
        .flags = cxxFlags,
    });
}
