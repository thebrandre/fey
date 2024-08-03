find_package(GTest CONFIG REQUIRED)

set(MY_TEST_NAME "${CMAKE_PROJECT_NAME}_test")
add_executable(${MY_TEST_NAME})
target_sources(${MY_TEST_NAME} PRIVATE "SimpleTest.cpp" "GTestCustomMain.cpp")
target_compile_features(${MY_TEST_NAME} PUBLIC cxx_std_23)
target_link_libraries(${MY_TEST_NAME} PRIVATE GTest::gtest GTest::gmock)

include(GoogleTest)
gtest_discover_tests(${MY_TEST_NAME})
