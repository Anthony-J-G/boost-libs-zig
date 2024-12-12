# Boost Libraries using Zig build-system

[Boost Libraries](https://boost.io) using `build.zig`.

Replacing the [CMake](https://cmake.org/) and [B2](https://www.bfgroup.xyz/b2/) build system. Inspired by [allyourcodebase/boost-libraries-zig](https://github.com/allyourcodebase/boost-libraries-zig).

To include all of the numerous boost libraries using Zig's build system in a highly customizable and portable format, the zig module was generated and bootstrapped using Python. See [scripts](scripts/) for more details.

Generally, Boost Libraries are header only and don't require actual compilation. However, there are a few libraries that do require a compile step and the Zig module attempts to handle them gracefully. Additonally, Boost libraries are modular and designed in a way so that you only need to pay for what you need.


> [!IMPORTANT]
> For C++ projects, `zig c++` uses llvm-libunwind + llvm-libc++ (static-linking) by default.
> Except, for MSVC target (`-nostdlib++`).


### Requirements

- [zig](https://ziglang.org/download) v0.13.0 or master

## How to use

Build all libraries
```bash
# Build all libraries
$ zig build -Doptimize=<Debug|ReleaseSafe|ReleaseFast|ReleaseSmall> \
    -Dtarget=<triple-target> \
    --summary <all|new> \
    -Dboost_all
```

Build libraries by type

```bash
# Build libraries by compilation type
$ zig build -Doptimize=<Debug|ReleaseSafe|ReleaseFast|ReleaseSmall> \
    -Dtarget=<triple-target> \
    --summary <all|new> \
    -Dheader_only
    -Dcompiled
```

Build libraries by category

```bash
# Build libraries by category
$ zig build -Doptimize=<Debug|ReleaseSafe|ReleaseFast|ReleaseSmall> \
    -Dtarget=<triple-target> \
    --summary <all|new> \
    -Dboost_category_string \
    -Dboost_category_containers \
    -Dboost_category_iterators \
    -Dboost_category_algorithms \
    -Dboost_category_function_objects \
    -Dboost_category_generic \
    -Dboost_category_metaprogramming \
    -Dboost_category_preprocessor \
    -Dboost_category_concurrent \
    -Dboost_category_math \
    -Dboost_category_correctness \
    -Dboost_category_error_handling \
    -Dboost_category_data \
    -Dboost_category_domain \
    -Dboost_category_image_processing \
    -Dboost_category_io \
    -Dboost_category_inter_language \
    -Dboost_category_emulation \
    -Dboost_category_memory \
    -Dboost_category_parsing \
    -Dboost_category_patterns \
    -Dboost_category_programming \
    -Dboost_category_state \
    -Dboost_category_system \
    -Dboost_category_miscellaneous \
    -Dboost_category_workarounds \

```

#### Helper

```bash
Project-Specific Options:
  -Dtarget=[string]            The CPU architecture, OS, and ABI to build for
  -Dcpu=[string]               Target CPU features to add or subtract
  -Ddynamic-linker=[string]    Path to interpreter on the target system
  -Doptimize=[enum]            Prioritize performance, safety, or binary size
                                 Supported Values:
                                   Debug
                                   ReleaseSafe
                                   ReleaseFast
                                   ReleaseSmall
  -Datomic=[bool]              Build boost.atomic library (default: false)
  -Dcharconv=[bool]            Build boost.charconv library (default: false)
  -Dcobalt=[bool]              Build boost.cobalt library (default: false)
  -Dcontainer=[bool]           Build boost.container library (default: false)
  -Dcontext=[bool]             Build boost.context library (default: false)
  -Dexception=[bool]           Build boost.exception library (default: false)
  -Dfiber=[bool]               Build boost.fiber library (default: false)
  -Dfilesystem=[bool]          Build boost.filesystem library (default: false)
  -Diostreams=[bool]           Build boost.iostreams library (default: false)
  -Djson=[bool]                Build boost.json library (default: false)
  -Dlog=[bool]                 Build boost.log library (default: false)
  -Dnowide=[bool]              Build boost.nowide library (default: false)
  -Dprocess=[bool]             Build boost.process library (default: false)
  -Dpython=[bool]              Build boost.python library (default: false)
  -Drandom=[bool]              Build boost.random library (default: false)
  -Dregex=[bool]               Build boost.regex library (default: false)
  -Dserialization=[bool]       Build boost.serialization library (default: false)
  -Dstacktrace=[bool]          Build boost.stacktrace library (default: false)
  -Dsystem=[bool]              Build boost.system library (default: false)
  -Durl=[bool]                 Build boost.url library (default: false)
  -Dwave=[bool]                Build boost.wave library (default: false)
  -Dshared=[bool]              Build as shared library (default: false)
```


### or use in new zig project

Make directory and init

```bash
$ zig init
## add in 'build.zig.zon' boost-libraries-zig package
$ zig fetch --save=boost git+https://github.com/allyourcodebase/boost-libraries-zig
```
Add in **build.zig**
```zig
const std = @import("std");
pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const boost_dep = b.dependency("boost", .{
        .target = target,
        .optimize = optimize,
    });
    const boost_artifact = boost_dep.artifact("boost");

    for(boost_artifact.root_module.include_dirs.items) |include_dir| {
        try exe.root_module.include_dirs.append(b.allocator, include_dir);
    }
    // if not header-only, link library
    exe.linkLibrary(boost_artifact);
}
```

## License

see: [LICENSE](LICENSE)