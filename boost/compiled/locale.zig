const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const localePath = b.dependency("locale", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = localePath,
        .files = &.{
			"codepage.cpp",
			"boundary.cpp",
			"codecvt.cpp",
			"collator.cpp",
			"conversion.cpp",
			"date_time.cpp",
			"formatter.cpp",
			"formatters_cache.cpp",
			"icu_backend.cpp",
			"numeric.cpp",
			"time_zone.cpp",
			"codecvt.cpp",
			"collate.cpp",
			"converter.cpp",
			"numeric.cpp",
			"posix_backend.cpp",
			"date_time.cpp",
			"format.cpp",
			"formatting.cpp",
			"generator.cpp",
			"iconv_codecvt.cpp",
			"ids.cpp",
			"localization_backend.cpp",
			"message.cpp",
			"mo_lambda.cpp",
			"codecvt.cpp",
			"collate.cpp",
			"converter.cpp",
			"numeric.cpp",
			"std_backend.cpp",
			"codecvt_converter.cpp",
			"default_locale.cpp",
			"encoding.cpp",
			"gregorian.cpp",
			"info.cpp",
			"locale_data.cpp",
			"collate.cpp",
			"converter.cpp",
			"lcid.cpp",
			"numeric.cpp",
			"win_backend.cpp"
        },
        .flags = cxxFlags,
    });
}
