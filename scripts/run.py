import json
from libs import BoostLibrary, find_libs_in_clone, generate_zig_functions

PATH_TO_BOOST_REPO = r"C:\Dev\External\boost"

def main():
    libs = find_libs_in_clone(PATH_TO_BOOST_REPO)
    print(f"found {len(libs)} boost libraries in repository")

    generate_zig_functions(libs)


if __name__ == "__main__":
    main()