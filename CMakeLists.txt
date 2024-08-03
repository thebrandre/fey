cmake_minimum_required(VERSION 3.25)
project("Fey")

if(WIN32)
  add_compile_definitions("_WIN32_WINNT=0x0A00" "_UNICODE" "UNICODE")
endif()

if(MSVC)
  add_compile_options("/utf-8" "/permissive-" "/Zc:__cplusplus"
                      "/Zc:preprocessor")
endif()

find_package(stdexec CONFIG REQUIRED)

add_subdirectory("test")
