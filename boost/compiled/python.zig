const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const pythonPath = b.dependency("python", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = pythonPath,
        .files = &.{
			"dict.cpp",
			"errors.cpp",
			"exec.cpp",
			"import.cpp",
			"list.cpp",
			"long.cpp",
			"module.cpp",
			"object_operators.cpp",
			"object_protocol.cpp",
			"slice.cpp",
			"str.cpp",
			"tuple.cpp",
			"wrapper.cpp",
			"arg_to_python_base.cpp",
			"builtin_converters.cpp",
			"from_python.cpp",
			"registry.cpp",
			"type_id.cpp",
			"dtype.cpp",
			"matrix.cpp",
			"ndarray.cpp",
			"numpy.cpp",
			"scalars.cpp",
			"ufunc.cpp",
			"class.cpp",
			"enum.cpp",
			"function.cpp",
			"function_doc_signature.cpp",
			"inheritance.cpp",
			"iterator.cpp",
			"life_support.cpp",
			"pickle_support.cpp",
			"stl_iterator.cpp"
        },
        .flags = cxxFlags,
    });
}
