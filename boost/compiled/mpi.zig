const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const mpiPath = b.dependency("mpi", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = mpiPath,
        .files = &.{
			"broadcast.cpp",
			"cartesian_communicator.cpp",
			"communicator.cpp",
			"computation_tree.cpp",
			"content_oarchive.cpp",
			"environment.cpp",
			"error_string.cpp",
			"exception.cpp",
			"graph_communicator.cpp",
			"group.cpp",
			"intercommunicator.cpp",
			"mpi_datatype_cache.cpp",
			"mpi_datatype_oarchive.cpp",
			"offsets.cpp",
			"packed_iarchive.cpp",
			"packed_oarchive.cpp",
			"packed_skeleton_iarchive.cpp",
			"packed_skeleton_oarchive.cpp",
			"point_to_point.cpp",
			"request.cpp",
			"status.cpp",
			"text_skeleton_oarchive.cpp",
			"timer.cpp",
			"collectives.cpp",
			"datatypes.cpp",
			"documentation.cpp",
			"module.cpp",
			"py_communicator.cpp",
			"py_environment.cpp",
			"py_exception.cpp",
			"py_nonblocking.cpp",
			"py_request.cpp",
			"py_timer.cpp",
			"serialize.cpp",
			"skeleton_and_content.cpp",
			"status.cpp"
        },
        .flags = cxxFlags,
    });
}
