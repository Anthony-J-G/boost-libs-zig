const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const testPath = b.dependency("test", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = testPath,
        .files = &.{
			"compiler_log_formatter.cpp",
			"cpp_main.cpp",
			"debug.cpp",
			"decorator.cpp",
			"execution_monitor.cpp",
			"framework.cpp",
			"junit_log_formatter.cpp",
			"plain_report_formatter.cpp",
			"progress_monitor.cpp",
			"results_collector.cpp",
			"results_reporter.cpp",
			"test_framework_init_observer.cpp",
			"test_main.cpp",
			"test_tools.cpp",
			"test_tree.cpp",
			"unit_test_log.cpp",
			"unit_test_main.cpp",
			"unit_test_monitor.cpp",
			"unit_test_parameters.cpp",
			"xml_log_formatter.cpp",
			"xml_report_formatter.cpp"
        },
        .flags = cxxFlags,
    });
}
