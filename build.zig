const std = @import("std");

const constants = @import("boost/constants.zig");
const compiled = @import("boost/compiled.zig");

const boost_version = constants.boost_version;
const boost_libs = constants.boost_libs;
const cxxFlags = constants.cxxFlags;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const boost = boostLibraries(b, .{
        .target = target,
        .optimize = optimize,
        .module = .{
            .atomic = b.option(bool, "atomic", "Build boost.atomic library (default: false)") orelse false,
            .charconv = b.option(bool, "charconv", "Build boost.charconv library (default: false)") orelse false,
            .cobalt = b.option(bool, "cobalt", "Build boost.cobalt library (default: false)") orelse false,
            .container = b.option(bool, "container", "Build boost.container library (default: false)") orelse false,
            .context = b.option(bool, "context", "Build boost.context library (default: false)") orelse false,
            .coroutine = b.option(bool, "coroutine", "Build boost.coroutine (Warning: Deprecated) library (default: false)") orelse false,
            .coroutine2 = b.option(bool, "coroutine2", "Build boost.coroutine2 library (default: false)") orelse false,
            .exception = b.option(bool, "exception", "Build boost.exception library (default: false)") orelse false,
            .fiber = b.option(bool, "fiber", "Build boost.fiber library (default: false)") orelse false,
            .filesystem = b.option(bool, "filesystem", "Build boost.filesystem library (default: false)") orelse false,
            .iostreams = b.option(bool, "iostreams", "Build boost.iostreams library (default: false)") orelse false,
            .json = b.option(bool, "json", "Build boost.json library (default: false)") orelse false,
            .log = b.option(bool, "log", "Build boost.log library (default: false)") orelse false,
            .nowide = b.option(bool, "nowide", "Build boost.nowide library (default: false)") orelse false,
            .process = b.option(bool, "process", "Build boost.process library (default: false)") orelse false,
            .python = b.option(bool, "python", "Build boost.python library (default: false)") orelse false,
            .random = b.option(bool, "random", "Build boost.random library (default: false)") orelse false,
            .program_options = b.option(bool, "program_options", "Build Boost.ProgramOptions library (default: false)") orelse false,
            .regex = b.option(bool, "regex", "Build boost.regex library (default: false)") orelse false,
            .serialization = b.option(bool, "serialization", "Build boost.serialization library (default: false)") orelse false,
            .stacktrace = b.option(bool, "stacktrace", "Build boost.stacktrace library (default: false)") orelse false,
            .system = b.option(bool, "system", "Build boost.system library (default: false)") orelse false,
            .url = b.option(bool, "url", "Build boost.url library (default: false)") orelse false,
            .wave = b.option(bool, "wave", "Build boost.wave library (default: false)") orelse false,
        },
    });
    b.installArtifact(boost);

    // Creates a step for unit testing. This only builds the test executable
    // but does not run it.
    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);
}

pub fn boostLibraries(b: *std.Build, config: Config) *std.Build.Step.Compile {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    
    const shared = b.option(bool, "shared", "Build as shared library (default: false)") orelse false;

    const lib = if (shared) b.addSharedLibrary(.{
        .name = "boost",
        .target = config.target,
        .optimize = config.optimize,
        .version = boost_version,
    }) else b.addStaticLibrary(.{
        .name = "boost",
        .target = config.target,
        .optimize = config.optimize,
        .version = boost_version,
    });

    inline for (boost_libs) |name| {
        const boostLib = b.dependency(name, .{});
        lib.installHeadersDirectory( // Ensures all Boost headers are output to installation prefix
            boostLib.path("include"), "", .{ .include_extensions = &.{ ".h", ".hpp", ".ipp" } });
        lib.addIncludePath(boostLib.path("include"));
    }
    // TODO: Currently ALL headers are added and any granularity is ignored, needs to be implemented.

    // zig-pkg bypass (artifact need generate object file)
    const empty = b.addWriteFile("empty.cc",
        \\ #include <boost/config.hpp>
    );
    lib.step.dependOn(&empty.step);
    lib.addCSourceFiles(.{
        .root = empty.getDirectory(),
        .files = &.{"empty.cc"},
        .flags = cxxFlags,
    });
    if (config.module) |module| {
        if (module.atomic) {
            compiled.buildAtomic(b, lib);
        }
        if (module.cobalt) {
            compiled.buildCobalt(b, lib);
        }
        if (module.container) {
            compiled.buildContainer(b, lib);
        }
        if (module.exception) {
            compiled.buildException(b, lib);
        }
        if (module.random) {
            compiled.buildRandom(b, lib);
        }
        if (module.context) {
            compiled.buildContext(b, lib);
        }
        if (module.charconv) {
            compiled.buildCharConv(b, lib);
        }
        if (module.coroutine) {
            if (boost_version.isGreater(std.SemanticVersion{.major=1, .minor=86, .patch=0})) {
                stdout.print(
                    "WARNING: Library Boost.Coroutine is deprecated in version {d}.{d}, compiling anyway.", 
                    .{boost_version.major, boost_version.minor}
                ) catch @panic("OOM");
                bw.flush() catch @panic("OOM"); // don't forget to flush!
            }            
            compiled.buildCoroutine(b, lib);
        }
        if (module.coroutine2) {
            compiled.buildCoroutine2(b, lib);
        }
        if (module.process) {
            compiled.buildProcess(b, lib);
        }
        if (module.iostreams) {
            compiled.buildIOStreams(b, lib);
        }
        if (module.json) {
            compiled.buildJson(b, lib);
        }
        if (module.log) {
            compiled.buildLog(b, lib);
        }
        if (module.fiber) {
            compiled.buildFiber(b, lib);
        }
        if (module.filesystem) {
            compiled.buildFileSystem(b, lib);
        }
        if (module.serialization) {
            compiled.buildSerialization(b, lib);
        }
        if (module.nowide) {
            compiled.buildNoWide(b, lib);
        }
        if (module.system) {
            compiled.buildSystem(b, lib);
        }
        if (module.python) {
            compiled.buildPython(b, lib);
        }
        if (module.stacktrace) {
            compiled.buildStacktrace(b, lib);
        }
        if (module.program_options) {
            compiled.buildProgramOptions(b, lib);
        }
        if (module.regex) {
            compiled.buildRegex(b, lib);
        }
        if (module.url) {
            compiled.buildURL(b, lib);
        }
        if (module.wave) {
            compiled.buildWave(b, lib);
        }
    }
    if (lib.rootModuleTarget().abi == .msvc)
        lib.linkLibC()
    else {
        lib.defineCMacro("_GNU_SOURCE", null);
        lib.linkLibCpp();
    }
    return lib;
}

pub const Config = struct {
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    module: ?boostLibrariesModules = null,
};

// No header-only libraries
const boostLibrariesModules = struct {
    atomic: bool = false,
    charconv: bool = false,
    cobalt: bool = false,
    container: bool = false,
    context: bool = false,
    coroutine: bool = false,
    coroutine2: bool = false,
    exception: bool = false,
    fiber: bool = false,
    filesystem: bool = false,
    iostreams: bool = false,
    json: bool = false,
    log: bool = false,
    nowide: bool = false,
    process: bool = false,
    python: bool = false,
    random: bool = false,
    program_options: bool = false,
    regex: bool = false,
    stacktrace: bool = false,
    serialization: bool = false,
    system: bool = false,
    url: bool = false,
    wave: bool = false,
};
