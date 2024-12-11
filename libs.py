import json
from pathlib import Path
import os

PATH_TO_BOOST_REPO = r"C:\Dev\External\boost"

def find_libs(boost_path: Path | str):
    boost_path = Path(boost_path)
    lib_dir= boost_path.joinpath('libs/')
    libs = []
    for file in os.listdir(lib_dir):
        if lib_dir.joinpath(file).is_dir:
            libs.append({"name": file, "path": str(lib_dir.joinpath(file))})
    
    return libs

def check_if_comp_needed(lib_path: Path | str):
    return Path(lib_path).joinpath("src").exists()

def find_source_files(src_path: Path | str):
    sources = []
    for root, _, files in os.walk(Path(src_path)):
        for file in files:
            if '.cpp' in file:
                sources.append(file)
    return sources
        
def format_source_list_for_zig(sources: list[str]):
    formatted = ''
    for i, src in enumerate(sources):
        if i == len(sources) - 1:
            formatted = formatted + f'\t\t\t"{src}"'
        else:
            formatted = formatted + f'\t\t\t"{src}",\n'

    return formatted


libs = find_libs(PATH_TO_BOOST_REPO)
print(f"found {len(libs)} boost libraries in repository")
comp_req_libs = []
for lib in libs:
    if check_if_comp_needed(lib["path"]):
        comp_req_libs.append(lib)

print(len(comp_req_libs))

lib_build_template = (
"""const std = @import("std");
const constants = @import("../constants.zig");
const cxxFlags = constants.cxxFlags;


fn addLibraryToConfig(b: *std.Build, obj: *std.Build.Step.Compile) void {
    const **BOOST_LIBRARY_NAME**Path = b.dependency("**BOOST_LIBRARY_NAME**", .{}).path("src");
    obj.addCSourceFiles(.{
        .root = **BOOST_LIBRARY_NAME**Path,
        .files = &.{
**SOURCE_FILES_HERE**
        },
        .flags = cxxFlags,
    });
}
""")

for lib in comp_req_libs:
    src = find_source_files(lib["path"] + "/src")
    src = format_source_list_for_zig(src)

    code = lib_build_template.replace("**BOOST_LIBRARY_NAME**", lib["name"])
    code = code.replace("**SOURCE_FILES_HERE**", src)

    with open(f"boost/compiled/{lib['name']}.zig", 'w') as f:
        f.write(code)