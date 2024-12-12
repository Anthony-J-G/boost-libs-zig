import json
from pathlib import Path
import requests
from bs4 import BeautifulSoup
import os

from templates import bolierplate, lib_build_function


LIBS_DOCS_URL = "https://www.boost.org/doc/libs/1_86_0/"
LIBS_CAT_DOCS_URL = "https://www.boost.org/doc/libs/1_86_0/?view=categorized"
LIBS_CON_DOCS_URL = "https://www.boost.org/doc/libs/1_86_0/?view=condensed"



class BoostLibrary:
    name: str
    path: Path | None
    categories: list[str]
    cpp_std_min: str
    src_path: Path
    tests_path: Path
    header_only: True
    source_files: list[str] = []

    def __init__(self, name: str, path: str):
        self.name = name
        self.path = Path(path)
        self.src_path = self.path.joinpath("src")
        self.tests_path = self.path.joinpath("test")

    def _check_header_only(self):
        """
            check_header_only
            
            Check the library at it's path to see if there is also a source directory contained within the
            submodule. If there is, assume the library needs to be compiled and is NOT header only
        """
        self.header_only = self.src_path.exists()
            
    def _find_source_files(self) -> bool:
        if not self.src_path.exists():
            return False
        
        sources = []
        for root, _, files in os.walk(self.src_path):
            for file in files:
                if '.cpp' in file:
                    sources.append(file)
        return sources
    
    def generate_zig_function(self):
        self._find_source_files()

        if len(self.source_files) != 0:
            pass


    def generate_zig_tests(self):
        pass



def find_libs_in_clone(boost_path: Path | str) -> dict[str, BoostLibrary]:
    """
        find_libs
        - boost_path: Path | str, absolute path to a clone of https://github.com/boostorg/boost. Assumes all Git submodules to be initialized

        Using a local clone of the boost project, extract libraries from it to ensure full representation inside of the Zig build system.

        returns a list of all the found libraries
    """
    boost_path = Path(boost_path)
    lib_dir= boost_path.joinpath('libs/')
    libs = {}
    for file in os.listdir(lib_dir):
        if not lib_dir.joinpath(file).is_dir():
            continue
        libs[file]= BoostLibrary(name=file, path=lib_dir.joinpath(file))
    return libs


def get_lib_info(libs: dict[str, BoostLibrary]) -> dict[str, BoostLibrary]:
    """
        find_libs_in_docs

        Search the official Boost documentation (https://www.boost.org/doc/libs/1_86_0/) for more information on
        each library to inform the zig function generation
    """
    res = requests.get(LIBS_DOCS_URL)
    soup = BeautifulSoup(res.content, 'html.parser')
    dts = soup.find_next('dt', {"id": "lib-accumulators"})
    print(dts)

    return libs


def generate_zig_functions(libs):
    code = bolierplate

    for lib in libs:
        pass

    return code


def write_options(libs: list[BoostLibrary], output_path: str):
    output_path = Path(output_path)

    option_definitions = ""
    option_declaration = ""
    for lib in libs:
        option_name = f"boost_{lib.name}"
        declaration = f"\t\t{option_name}: bool = true,\n"
        defintion   = f'\t\t\t\t.{option_name} = b.option(bool, "{option_name}", "Compile with {lib.name} support") orelse defaults.{option_name},\n'

        option_definitions = option_definitions + defintion
        option_declaration = option_declaration + declaration    

    boost_compilation_options_template = (
    """const std = @import("std");
    
    pub const Options = struct {
        // General Build Options
        shared: bool = false,
        config: []const u8 = &.{},
        
		// Boost Add Library by Category (https://www.boost.org/doc/libs/1_86_0/?view=categorized)
		boost_category_str_text: bool = true,
		boost_category_containers: bool = true,
		boost_category_iterators: bool = true,
		boost_category_categories: bool = true,
		boost_category_funcs_higher_order: bool = true,

        // Libraries to Add (Overrides category definitions)
**BOOST_OPTION_DECLARATIONS**

        const defaults = Options{};

        pub fn getOptions(b: *std.Build) Options {
            return .{
                .shared = b.option(bool, "shared", "Compile as shared library") orelse defaults.shared,        
                .config = b.option([]const u8, "config", "Compile with custom define macros overriding config.h") orelse &.{},

**BOOST_OPTION_DEFINITIONS**                
            };
        }
    };
    """)

    code = boost_compilation_options_template.replace("**BOOST_OPTION_DECLARATIONS**", option_declaration)
    code = code.replace("**BOOST_OPTION_DEFINITIONS**", option_definitions)

    with open(output_path, 'w') as f:
        f.write(code)


# Compare submodules to docs labelled libraries
with open("scripts/libraries_by_category.json") as f:
    categories = json.load(f)

libs = []
for c in categories:
    for lib in c:
        libs.append(c)



