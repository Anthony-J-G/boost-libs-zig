const std = @import("std");

const constants = @import("constants.zig");
const utils = @import("utils.zig");
const checkSystemLibrary = utils.checkSystemLibrary;

const boost_libs = constants.boost_libs;
const boost_version = constants.boost_version;
const cxxFlags = constants.cxxFlags;

pub fn buildCobalt(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const cobaltPath = b.dependency("cobalt", .{}).path("src");
    obj.defineCMacro("BOOST_COBALT_SOURCE", null);
    obj.addCSourceFiles(.{
        .root = cobaltPath,
        .files = &.{
            "channel.cpp",
            "detail/exception.cpp",
            "detail/util.cpp",
            "error.cpp",
            "main.cpp",
            "this_thread.cpp",
            "thread.cpp",
        },
        .flags = cxxFlags ++ &[_][]const u8{"-std=c++20"},
    });
}

pub fn buildContainer(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const containerPath = b.dependency("container", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = containerPath,
        .files = &.{
            "pool_resource.cpp",
            "monotonic_buffer_resource.cpp",
            "synchronized_pool_resource.cpp",
            "unsynchronized_pool_resource.cpp",
            "global_resource.cpp",
        },
        .flags = cxxFlags,
    });
}

pub fn buildCoroutine(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const coroutinePath = b.dependency("coroutine", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = coroutinePath,
        .flags = cxxFlags,
        .files = &.{

        },
    });
}

pub fn buildCoroutine2(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const coroutine2Path = b.dependency("coroutine2", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = coroutine2Path,
        .flags = cxxFlags ++ &[_][]const u8{"-std=c++11"},
        .files = &.{

        },
    });
}

pub fn buildFiber(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const fiberPath = b.dependency("fiber", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = fiberPath,
        .files = &.{
            "algo/algorithm.cpp",
            "algo/round_robin.cpp",
            "algo/shared_work.cpp",
            "algo/work_stealing.cpp",
            "barrier.cpp",
            "condition_variable.cpp",
            "context.cpp",
            "fiber.cpp",
            "future.cpp",
            "mutex.cpp",
            "numa/algo/work_stealing.cpp",
            "properties.cpp",
            "recursive_mutex.cpp",
            "recursive_timed_mutex.cpp",
            "scheduler.cpp",
            "timed_mutex.cpp",
            "waker.cpp",
        },
        .flags = cxxFlags,
    });
}

pub fn buildJson(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const jsonPath = b.dependency("json", .{}).path("src");

    obj.addCSourceFiles(.{
        .root = jsonPath,
        .files = &.{
            "src.cpp",
        },
        .flags = cxxFlags,
    });
}

pub fn buildProcess(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const processPath = b.dependency("process", .{}).path("src");

    obj.addCSourceFiles(.{
        .root = processPath,
        .files = &.{
            "detail/environment_posix.cpp",
            "detail/environment_win.cpp",
            "detail/last_error.cpp",
            "detail/process_handle_windows.cpp",
            "detail/throw_error.cpp",
            "detail/utf8.cpp",
            "environment.cpp",
            "error.cpp",
            "ext/cmd.cpp",
            "ext/cwd.cpp",
            "ext/env.cpp",
            "ext/exe.cpp",
            "ext/proc_info.cpp",
            "pid.cpp",
            "shell.cpp",
            switch (obj.rootModuleTarget().os.tag) {
                .windows => "windows/default_launcher.cpp",
                else => "posix/close_handles.cpp",
            },
        },
        .flags = cxxFlags,
    });
}

pub fn buildSystem(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const systemPath = b.dependency("system", .{}).path("src");

    obj.addCSourceFiles(.{
        .root = systemPath,
        .files = &.{
            "error_code.cpp",
        },
        .flags = cxxFlags,
    });
}

pub fn buildAtomic(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const atomicPath = b.dependency("atomic", .{}).path("src");

    obj.addIncludePath(atomicPath);
    obj.addCSourceFiles(.{
        .root = atomicPath,
        .files = &.{
            "lock_pool.cpp",
        },
        .flags = cxxFlags,
    });
    if (obj.rootModuleTarget().os.tag == .windows)
        obj.addCSourceFiles(.{
            .root = atomicPath,
            .files = &.{
                "wait_on_address.cpp",
            },
            .flags = cxxFlags,
        });
    if (std.Target.x86.featureSetHas(obj.rootModuleTarget().cpu.features, .sse2)) {
        obj.addCSourceFiles(.{
            .root = atomicPath,
            .files = &.{
                "find_address_sse2.cpp",
            },
            .flags = cxxFlags,
        });
    }
    if (std.Target.x86.featureSetHas(obj.rootModuleTarget().cpu.features, .sse4_1)) {
        obj.addCSourceFiles(.{
            .root = atomicPath,
            .files = &.{
                "find_address_sse41.cpp",
            },
            .flags = cxxFlags,
        });
    }
}

pub fn buildRegex(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const regPath = b.dependency("regex", .{}).path("src");

    obj.addCSourceFiles(.{
        .root = regPath,
        .files = &.{
            "posix_api.cpp",
            "wide_posix_api.cpp",
        },
        .flags = cxxFlags,
    });
}

pub fn buildFileSystem(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const fsPath = b.dependency("filesystem", .{}).path("src");

    if (obj.rootModuleTarget().os.tag == .windows) {
        obj.addCSourceFiles(.{
            .root = fsPath,
            .files = &.{"windows_file_codecvt.cpp"},
            .flags = cxxFlags,
        });
        obj.defineCMacro("BOOST_USE_WINDOWS_H", null);
        obj.defineCMacro("NOMINMAX", null);
    }
    obj.defineCMacro("BOOST_FILESYSTEM_NO_CXX20_ATOMIC_REF", null);
    obj.addIncludePath(fsPath);
    obj.addCSourceFiles(.{
        .root = fsPath,
        .files = &.{
            "codecvt_error_category.cpp",
            "directory.cpp",
            "exception.cpp",
            "path.cpp",
            "path_traits.cpp",
            "portability.cpp",
            "operations.cpp",
            "unique_path.cpp",
            "utf8_codecvt_facet.cpp",
        },
        .flags = cxxFlags,
    });
    if (obj.rootModuleTarget().abi == .msvc) {
        obj.defineCMacro("_SCL_SECURE_NO_WARNINGS", null);
        obj.defineCMacro("_SCL_SECURE_NO_DEPRECATE", null);
        obj.defineCMacro("_CRT_SECURE_NO_WARNINGS", null);
        obj.defineCMacro("_CRT_SECURE_NO_DEPRECATE", null);
    }
}

pub fn buildSerialization(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const serialPath = b.dependency("serialization", .{}).path("src");

    obj.addCSourceFiles(.{
        .root = serialPath,
        .files = &.{
            "archive_exception.cpp",
            "basic_archive.cpp",
            "basic_iarchive.cpp",
            "basic_iserializer.cpp",
            "basic_oarchive.cpp",
            "basic_oserializer.cpp",
            "basic_pointer_iserializer.cpp",
            "basic_pointer_oserializer.cpp",
            "basic_serializer_map.cpp",
            "basic_text_iprimitive.cpp",
            "basic_text_oprimitive.cpp",
            "basic_text_wiprimitive.cpp",
            "basic_text_woprimitive.cpp",
            "basic_xml_archive.cpp",
            "binary_iarchive.cpp",
            "binary_oarchive.cpp",
            "binary_wiarchive.cpp",
            "binary_woarchive.cpp",
            "codecvt_null.cpp",
            "extended_type_info.cpp",
            "extended_type_info_no_rtti.cpp",
            "extended_type_info_typeid.cpp",
            "polymorphic_binary_iarchive.cpp",
            "polymorphic_binary_oarchive.cpp",
            "polymorphic_iarchive.cpp",
            "polymorphic_oarchive.cpp",
            "polymorphic_text_iarchive.cpp",
            "polymorphic_text_oarchive.cpp",
            "polymorphic_text_wiarchive.cpp",
            "polymorphic_text_woarchive.cpp",
            "polymorphic_xml_iarchive.cpp",
            "polymorphic_xml_oarchive.cpp",
            "polymorphic_xml_wiarchive.cpp",
            "polymorphic_xml_woarchive.cpp",
            "stl_port.cpp",
            "text_iarchive.cpp",
            "text_oarchive.cpp",
            "text_wiarchive.cpp",
            "text_woarchive.cpp",
            "utf8_codecvt_facet.cpp",
            "void_cast.cpp",
            "xml_archive_exception.cpp",
            "xml_grammar.cpp",
            "xml_iarchive.cpp",
            "xml_oarchive.cpp",
            "xml_wgrammar.cpp",
            "xml_wiarchive.cpp",
            "xml_woarchive.cpp",
        },
        .flags = cxxFlags,
    });
}

pub fn buildCharConv(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const cconvPath = b.dependency("charconv", .{}).path("src");

    obj.addCSourceFiles(.{
        .root = cconvPath,
        .files = &.{
            "from_chars.cpp",
            "to_chars.cpp",
        },
        .flags = cxxFlags,
    });
}

pub fn buildRandom(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const rndPath = b.dependency("random", .{}).path("src");

    obj.addCSourceFiles(.{
        .root = rndPath,
        .files = &.{
            "random_device.cpp",
        },
        .flags = cxxFlags,
    });
}

pub fn buildException(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const exceptPath = b.dependency("exception", .{}).path("src");

    obj.addCSourceFiles(.{
        .root = exceptPath,
        .files = &.{
            "clone_current_exception_non_intrusive.cpp",
        },
        .flags = cxxFlags,
    });
}

pub fn buildStacktrace(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const stackPath = b.dependency("stacktrace", .{}).path("src");

    obj.addIncludePath(stackPath);
    obj.addCSourceFiles(.{
        .root = stackPath,
        .files = &.{
            "addr2line.cpp",
            "basic.cpp",
            "from_exception.cpp",
            "noop.cpp",
        },
        .flags = cxxFlags,
    });
    // TODO: fix https://github.com/ziglang/zig/issues/21308
    if (checkSystemLibrary(obj, "backtrace")) {
        obj.addCSourceFiles(.{
            .root = stackPath,
            .files = &.{
                "backtrace.cpp",
            },
            .flags = cxxFlags,
        });
        obj.linkSystemLibrary("backtrace");
    }

    if (obj.rootModuleTarget().abi == .msvc) {
        obj.addCSourceFiles(.{
            .root = stackPath,
            .files = &.{
                "windbg.cpp",
                "windbg_cached.cpp",
            },
            .flags = cxxFlags,
        });

        obj.linkSystemLibrary("dbgeng");
        obj.linkSystemLibrary("ole32");
    }
}

pub fn buildProgramOptions(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const poPath = b.dependency("program_options", .{}).path("src");

    obj.addCSourceFiles(.{
        .root = poPath,
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
            "winmain.cpp",
        },
        .flags = cxxFlags,
    });
}

pub fn buildURL(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const urlPath = b.dependency("url", .{}).path("src");

    obj.addCSourceFiles(.{
        .root = urlPath,
        .files = &.{
            "authority_view.cpp",
            "decode_view.cpp",
            "detail/any_params_iter.cpp",
            "detail/any_segments_iter.cpp",
            "detail/decode.cpp",
            "detail/except.cpp",
            "detail/format_args.cpp",
            "detail/normalize.cpp",
            "detail/params_iter_impl.cpp",
            "detail/pattern.cpp",
            "detail/pct_format.cpp",
            "detail/replacement_field_rule.cpp",
            "detail/segments_iter_impl.cpp",
            "detail/url_impl.cpp",
            "detail/vformat.cpp",
            "encoding_opts.cpp",
            "error.cpp",
            "grammar/ci_string.cpp",
            "grammar/dec_octet_rule.cpp",
            "grammar/delim_rule.cpp",
            "grammar/detail/recycled.cpp",
            "grammar/error.cpp",
            "grammar/literal_rule.cpp",
            "grammar/string_view_base.cpp",
            "ipv4_address.cpp",
            "ipv6_address.cpp",
            "params_base.cpp",
            "params_encoded_base.cpp",
            "params_encoded_ref.cpp",
            "params_encoded_view.cpp",
            "params_ref.cpp",
            "params_view.cpp",
            "parse.cpp",
            "parse_path.cpp",
            "parse_query.cpp",
            "pct_string_view.cpp",
            "rfc/absolute_uri_rule.cpp",
            "rfc/authority_rule.cpp",
            "rfc/detail/h16_rule.cpp",
            "rfc/detail/hier_part_rule.cpp",
            "rfc/detail/host_rule.cpp",
            "rfc/detail/ip_literal_rule.cpp",
            "rfc/detail/ipv6_addrz_rule.cpp",
            "rfc/detail/ipvfuture_rule.cpp",
            "rfc/detail/port_rule.cpp",
            "rfc/detail/relative_part_rule.cpp",
            "rfc/detail/scheme_rule.cpp",
            "rfc/detail/userinfo_rule.cpp",
            "rfc/ipv4_address_rule.cpp",
            "rfc/ipv6_address_rule.cpp",
            "rfc/origin_form_rule.cpp",
            "rfc/query_rule.cpp",
            "rfc/relative_ref_rule.cpp",
            "rfc/uri_reference_rule.cpp",
            "rfc/uri_rule.cpp",
            "scheme.cpp",
            "segments_base.cpp",
            "segments_encoded_base.cpp",
            "segments_encoded_ref.cpp",
            "segments_encoded_view.cpp",
            "segments_ref.cpp",
            "segments_view.cpp",
            "static_url.cpp",
            "url.cpp",
            "url_base.cpp",
            "url_view.cpp",
            "url_view_base.cpp",
        },
        .flags = cxxFlags,
    });
}

pub fn buildIOStreams(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const iostreamPath = b.dependency("iostreams", .{}).path("src");

    obj.addCSourceFiles(.{
        .root = iostreamPath,
        .files = &.{
            "bzip2.cpp",
            "file_descriptor.cpp",
            "gzip.cpp",
            "mapped_file.cpp",
            "zlib.cpp",
            "zstd.cpp",
            "lzma.cpp",
        },
        .flags = cxxFlags,
    });
}

pub fn buildLog(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const logPath = b.dependency("log", .{}).path("src");
    obj.defineCMacro("BOOST_LOG_NO_THREADS", null);
    obj.addIncludePath(logPath);
    obj.addCSourceFiles(.{
        .root = logPath,
        .files = &.{
            "attribute_name.cpp",
            "attribute_set.cpp",
            "attribute_value_set.cpp",
            "code_conversion.cpp",
            "core.cpp",
            "date_time_format_parser.cpp",
            "default_attribute_names.cpp",
            "default_sink.cpp",
            "dump.cpp",
            "dump_avx2.cpp",
            "dump_ssse3.cpp",
            "event.cpp",
            "exceptions.cpp",
            "format_parser.cpp",
            "global_logger_storage.cpp",
            "named_scope.cpp",
            "named_scope_format_parser.cpp",
            "once_block.cpp",
            "permissions.cpp",
            "process_id.cpp",
            "process_name.cpp",
            "record_ostream.cpp",
            "setup/default_filter_factory.cpp",
            "setup/default_formatter_factory.cpp",
            "setup/filter_parser.cpp",
            "setup/formatter_parser.cpp",
            "setup/init_from_settings.cpp",
            "setup/init_from_stream.cpp",
            "setup/matches_relation_factory.cpp",
            "setup/parser_utils.cpp",
            "setup/settings_parser.cpp",
            "severity_level.cpp",
            "spirit_encoding.cpp",
            "syslog_backend.cpp",
            "text_file_backend.cpp",
            "text_multifile_backend.cpp",
            "text_ostream_backend.cpp",
            "thread_id.cpp",
            "thread_specific.cpp",
            "threadsafe_queue.cpp",
            "timer.cpp",
            "timestamp.cpp",
            "trivial.cpp",
        },
        .flags = cxxFlags,
    });
    obj.addCSourceFiles(.{
        .root = logPath,
        .files = switch (obj.rootModuleTarget().os.tag) {
            .windows => &.{
                "windows/debug_output_backend.cpp",
                "windows/event_log_backend.cpp",
                "windows/ipc_reliable_message_queue.cpp",
                "windows/ipc_sync_wrappers.cpp",
                "windows/is_debugger_present.cpp",
                "windows/light_rw_mutex.cpp",
                "windows/mapped_shared_memory.cpp",
                "windows/object_name.cpp",
            },
            else => &.{
                "posix/ipc_reliable_message_queue.cpp",
                "posix/object_name.cpp",
            },
        },
        .flags = cxxFlags,
    });
}

pub fn buildNoWide(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const nwPath = b.dependency("nowide", .{}).path("src");

    obj.addIncludePath(nwPath);
    obj.addCSourceFiles(.{
        .root = nwPath,
        .files = &.{
            "console_buffer.cpp",
            "cstdio.cpp",
            "cstdlib.cpp",
            "filebuf.cpp",
            "iostream.cpp",
            "stat.cpp",
        },
        .flags = cxxFlags,
    });
}

pub fn buildPython(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const pyPath = b.dependency("python", .{}).path("src");

    obj.linkSystemLibrary("python3");
    obj.addCSourceFiles(.{
        .root = pyPath,
        .files = &.{
            "converter/arg_to_python_base.cpp",
            "converter/builtin_converters.cpp",
            "converter/from_python.cpp",
            "converter/registry.cpp",
            "converter/type_id.cpp",
            "dict.cpp",
            "errors.cpp",
            "exec.cpp",
            "import.cpp",
            "list.cpp",
            "long.cpp",
            "module.cpp",
            "object/class.cpp",
            "object/enum.cpp",
            "object/function.cpp",
            "object/function_doc_signature.cpp",
            "object/inheritance.cpp",
            "object/iterator.cpp",
            "object/life_support.cpp",
            "object/pickle_support.cpp",
            "object/stl_iterator.cpp",
            "object_operators.cpp",
            "object_protocol.cpp",
            "slice.cpp",
            "str.cpp",
            "tuple.cpp",
            "wrapper.cpp",
        },
        .flags = cxxFlags,
    });

    if (checkSystemLibrary(obj, "npymath")) {
        obj.linkSystemLibrary("npymath");
        obj.addCSourceFiles(.{
            .root = pyPath,
            .files = &.{
                "numpy/dtype.cpp",
                "numpy/matrix.cpp",
                "numpy/ndarray.cpp",
                "numpy/numpy.cpp",
                "numpy/scalars.cpp",
                "numpy/ufunc.cpp",
            },
            .flags = cxxFlags,
        });
    }
}

pub fn buildWave(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const wavePath = b.dependency("wave", .{}).path("src");

    obj.addCSourceFiles(.{
        .root = wavePath,
        .files = &.{
            "cpplexer/re2clex/aq.cpp",
            "cpplexer/re2clex/cpp_re.cpp",
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
        },
        .flags = cxxFlags,
    });
}

pub fn buildContext(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const contextPath = b.dependency("context", .{}).path("src");
    const ctxPath = contextPath.getPath(b);
    obj.addIncludePath(.{
        .cwd_relative = b.pathJoin(&.{ ctxPath, "asm" }),
    }); // common.h
    obj.addCSourceFiles(.{
        .root = contextPath,
        .files = &.{
            "continuation.cpp",
            "fiber.cpp",
        },
        .flags = cxxFlags,
    });

    obj.addCSourceFile(.{
        .file = switch (obj.rootModuleTarget().os.tag) {
            .windows => .{
                .cwd_relative = b.pathJoin(&.{ ctxPath, "windows/stack_traits.cpp" }),
            },
            else => .{
                .cwd_relative = b.pathJoin(&.{ ctxPath, "posix/stack_traits.cpp" }),
            },
        },
        .flags = cxxFlags,
    });
    if (obj.rootModuleTarget().os.tag == .windows) {
        obj.defineCMacro("BOOST_USE_WINFIB", null);
        obj.want_lto = false;
    } else {
        obj.defineCMacro("BOOST_USE_UCONTEXT", null);
    }
    switch (obj.rootModuleTarget().cpu.arch) {
        .arm => switch (obj.rootModuleTarget().os.tag) {
            .windows => {
                if (obj.rootModuleTarget().abi == .msvc) {
                    obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/jump_arm_aapcs_pe_armasm.asm" }) });
                    obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/make_arm_aapcs_pe_armasm.asm" }) });
                    obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/ontop_arm_aapcs_pe_armasm.asm" }) });
                }
            },
            .macos => {
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/jump_arm_aapcs_macho_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/make_arm_aapcs_macho_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/ontop_arm_aapcs_macho_gas.S" }) });
            },
            else => {
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/jump_arm_aapcs_elf_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/make_arm_aapcs_elf_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/ontop_arm_aapcs_elf_gas.S" }) });
            },
        },
        .aarch64 => switch (obj.rootModuleTarget().os.tag) {
            .windows => {
                if (obj.rootModuleTarget().abi == .msvc) {
                    obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/jump_arm64_aapcs_pe_armasm.asm" }) });
                    obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/make_arm64_aapcs_pe_armasm.asm" }) });
                    obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/ontop_arm64_aapcs_pe_armasm.asm" }) });
                }
            },
            .macos => {
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/jump_arm64_aapcs_macho_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/make_arm64_aapcs_macho_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/ontop_arm64_aapcs_macho_gas.S" }) });
            },
            else => {
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/jump_arm64_aapcs_elf_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/make_arm64_aapcs_elf_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/ontop_arm64_aapcs_elf_gas.S" }) });
            },
        },
        .riscv64 => {
            obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/jump_riscv64_sysv_elf_gas.S" }) });
            obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/make_riscv64_sysv_elf_gas.S" }) });
            obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/ontop_riscv64_sysv_elf_gas.S" }) });
        },
        .x86 => switch (obj.rootModuleTarget().os.tag) {
            .windows => {
                // @panic("undefined symbol:{j/m/o}-fcontext");
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/jump_i386_ms_pe_clang_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/make_i386_ms_pe_clang_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/ontop_i386_ms_pe_clang_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/jump_i386_ms_pe_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/make_i386_ms_pe_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/ontop_i386_ms_pe_gas.S" }) });
            },
            .macos => {
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/jump_i386_x86_64_sysv_macho_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/jump_i386_sysv_macho_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/make_i386_x86_64_sysv_macho_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/make_i386_sysv_macho_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/ontop_i386_sysv_macho_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/ontop_i386_x86_64_sysv_macho_gas.S" }) });
            },
            else => {
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/jump_i386_sysv_elf_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/make_i386_sysv_elf_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/ontop_i386_sysv_elf_gas.S" }) });
            },
        },
        .x86_64 => switch (obj.rootModuleTarget().os.tag) {
            .windows => {
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/jump_x86_64_ms_pe_clang_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/make_x86_64_ms_pe_clang_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/ontop_x86_64_ms_pe_clang_gas.S" }) });
            },
            .macos => {
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/jump_i386_x86_64_sysv_macho_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/jump_x86_64_sysv_macho_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/make_i386_x86_64_sysv_macho_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/make_x86_64_sysv_macho_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/ontop_x86_64_sysv_macho_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/ontop_i386_x86_64_sysv_macho_gas.S" }) });
            },
            else => {
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/jump_x86_64_sysv_elf_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/make_x86_64_sysv_elf_gas.S" }) });
                obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/ontop_x86_64_sysv_elf_gas.S" }) });
            },
        },
        .s390x => {
            obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/jump_s390x_sysv_elf_gas.S" }) });
            obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/make_s390x_sysv_elf_gas.S" }) });
            obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/ontop_s390x_sysv_elf_gas.S" }) });
        },
        .mips, .mipsel => {
            obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/jump_mips32_o32_elf_gas.S" }) });
            obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/make_mips32_o32_elf_gas.S" }) });
            obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/ontop_mips32_o32_elf_gas.S" }) });
        },
        .mips64, .mips64el => {
            obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/jump_mips64_n64_elf_gas.S" }) });
            obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/make_mips64_n64_elf_gas.S" }) });
            obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/ontop_mips64_n64_elf_gas.S" }) });
        },
        .loongarch64 => {
            obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/jump_loongarch64_sysv_elf_gas.S" }) });
            obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/make_loongarch64_sysv_elf_gas.S" }) });
            obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/ontop_loongarch64_sysv_elf_gas.S" }) });
        },
        .powerpc => {
            obj.addCSourceFile(.{
                .file = .{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/tail_ontop_ppc32_sysv.cpp" }) },
                .flags = cxxFlags,
            });
            obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/jump_ppc32_sysv_elf_gas.S" }) });
            obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/make_ppc32_sysv_elf_gas.S" }) });
            obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/ontop_ppc32_sysv_elf_gas.S" }) });
        },
        .powerpc64 => {
            obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/jump_ppc64_sysv_elf_gas.S" }) });
            obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/make_ppc64_sysv_elf_gas.S" }) });
            obj.addAssemblyFile(.{ .cwd_relative = b.pathJoin(&.{ ctxPath, "asm/ontop_ppc64_sysv_elf_gas.S" }) });
        },
        else => @panic("Invalid arch"),
    }
}

