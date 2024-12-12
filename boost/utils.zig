const std = @import("std");

// temporary workaround for https://github.com/ziglang/zig/issues/21308
pub fn checkSystemLibrary(compile: *std.Build.Step.Compile, name: []const u8) bool {
    var is_linking_libc = false;
    var is_linking_libcpp = false;

    var dep_it = compile.root_module.iterateDependencies(compile, true);
    while (dep_it.next()) |dep| {
        for (dep.module.link_objects.items) |link_object| {
            switch (link_object) {
                .system_lib => |lib| if (std.mem.eql(u8, lib.name, name)) return true,
                else => continue,
            }
        }
        if (dep.module.link_libc) |link_libc|
            is_linking_libc = is_linking_libc or link_libc;
        if (dep.module.link_libcpp) |link_libcpp|
            is_linking_libcpp = is_linking_libcpp or (link_libcpp == true);
    }

    if (compile.rootModuleTarget().is_libc_lib_name(name)) {
        return is_linking_libc;
    }

    if (compile.rootModuleTarget().is_libcpp_lib_name(name)) {
        return is_linking_libcpp;
    }

    return false;
}