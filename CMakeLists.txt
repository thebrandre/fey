cmake_minimum_required(VERSION 3.28)

if(POLICY CMP0141)
  # Enables the use of the MSVC_DEBUG_INFORMATION_FORMAT target property
  # https://cmake.org/cmake/help/latest/policy/CMP0141.html
  cmake_policy(SET CMP0141 NEW)
  set(CMAKE_POLICY_DEFAULT_CMP0141 NEW)
endif()

project("Fey")

if(WIN32)
  add_compile_definitions("_WIN32_WINNT=0x0A00" "_UNICODE" "UNICODE")
endif()

# add_compile_options($<$<COMPILE_LANG_AND_ID:CXX,MSVC>:/utf-8 /permissive-
# /Zc:__cplusplus /Zc:preprocessor>)

if(MSVC)
  add_compile_options("-utf-8" "-permissive-" "-Zc:__cplusplus"
                      "-Zc:preprocessor")
endif()

find_package(stdexec CONFIG REQUIRED)

if(NOT DEFINED CMAKE_CUDA_STANDARD)
  set(CMAKE_CUDA_STANDARD 20)
  set(CMAKE_CUDA_STANDARD_REQUIRED ON)
endif()

enable_language(CUDA)
find_package(CUDAToolkit REQUIRED)

set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -arch=sm_60")

add_subdirectory("test")
