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

There are a LOT of Boost libraries, for the full list of supported switches, `boost/options.zig` has more details.

### or use in new zig project

Make directory and init

```bash
$ zig init
## add in 'build.zig.zon' boost-libraries-zig package
$ zig fetch --save=boost git+https://github.com/Anthony-J-G/boost-libs-zig
```
Add in **build.zig**
```zig
const std = @import("std");
pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const boost = b.dependency("boost", .{
        .target = target,
        .optimize = optimize,
        // Add extra definitions here, -Dboost_all is assumed unless otherwise specified
    });
    const boostLib = boost.artifact("boost");

    // Assume there to be some Step.Compile defined named `exe`
    // ...

    // Link
    exe.linkLibrary(boost_artifact);
}
```

The build system will automatically install and detect headers that the selected Boost Libraries require.

## License

see: [LICENSE](LICENSE)