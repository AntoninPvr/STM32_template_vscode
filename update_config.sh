#!/bin/bash

path_main_c="./lib/cubemx/src/main.c"
path_main_h="./lib/cubemx/inc/main.h"
path_driver_c="./lib/cubemx/src/driver.c"
path_driver_h="./lib/cubemx/src/driver.h"
Inc="./lib/cubemx/Inc/"
src="./lib/cubemx/src/"
main="main.h"
driver="driver.h"
lib_file="./lib/cubemx/"

search_string="\${project_dir_absolute_path}"
replace_string="./lib/cubemx/"

if [ ! -f "stm32pio.ini" ]; then
    echo "stm32pio.ini not found"
    echo "init stm32pio"
    stm32pio init
    echo "replace lib file path in stm32pio.ini"
    sed "s|${search_string}|${replace_string}|g" stm32pio.ini > stm32pio.ini.new
    mv stm32pio.ini.new stm32pio.ini
fi

# clean src directory
echo "clean lib/src directory"
rm -rf "$src"

# generate code with CubeMX
stm32pio generate

# move Src to src
if [ -d "./lib/cubemx/Src" ]; then
    echo "move Src to src"
    mv ./lib/cubemx/Src ./lib/cubemx/src
fi

# move Inc file to src
if [ -d "$Inc" ]; then
    echo "move Inc to src"
    cp "${Inc}"* "$src"
    echo "remove Inc"
    rm -rf "$Inc"
fi

# replace main.c with driver.c
if [ -e "$path_main_c" ]; then
    echo "remove main.c"
    sed "s/main/driver/" $path_main_c > $path_driver_c
    rm $path_main_c
fi

# replace all occurence of "main.h" in srcs
if [ -e "$src$main_h" ]; then
    echo "replace all occurence of main.h in srcs"
    for file in "$src"/*; do
        if [ -f "$file" ]; then
            sed "s/$main/$driver/g" "$file" > "${file}.new"
            mv "${file}.new" "$file"
        fi
    done
    # rename main.h to driver.h
    mv "$src/$main" "$src/$driver"
fi

# add driver declaration
if [ -f "$path_driver_h" ]; then
    echo "add void driver(void) declaration"
    if ! grep -q "int driver(void);" "$path_driver_h"; then
        sed '/\/\* USER CODE BEGIN EFP \*\//a int driver(void);' "$path_driver_h" > "${path_driver_h}.new"
        mv "${path_driver_h}.new" "$path_driver_h"
    fi
fi