find_package(GTest CONFIG REQUIRED)

set(MY_TEST_NAME "${CMAKE_PROJECT_NAME}_test")
add_executable(${MY_TEST_NAME})
target_sources(${MY_TEST_NAME} PRIVATE "StdexecTest.cpp" "GTestCustomMain.cpp" "AddKernel.cu" "CudaTest.cpp")
target_compile_features(${MY_TEST_NAME} PUBLIC cxx_std_23)
target_link_libraries(${MY_TEST_NAME} PRIVATE GTest::gtest GTest::gmock CUDA::cuda_driver)

set_target_properties(${MY_TEST_NAME} PROPERTIES
                            CUDA_SEPARABLE_COMPILATION ON)


# Error: "CUDA_PTX_COMPILATION property can only be applied to OBJECT"
# set_target_properties(${MY_TEST_NAME} PROPERTIES CUDA_PTX_COMPILATION ON)


include(GoogleTest)
gtest_discover_tests(${MY_TEST_NAME})
