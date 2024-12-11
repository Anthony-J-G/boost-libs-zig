const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const serializationPath = b.dependency("serialization", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = serializationPath,
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
			"xml_woarchive.cpp"
        },
        .flags = cxxFlags,
    });
}
