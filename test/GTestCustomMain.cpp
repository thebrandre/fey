#include <gtest/gtest.h>
#include <gmock/gmock.h>
#include <locale>

#ifdef _WIN32
#include <Windows.h>
#endif

int main(int Argc, char *Argv[])
{
#ifdef _WIN32
    const auto PreviousLocale = std::locale::global(std::locale("en_US.UTF-8"));
    // Stack Overflow: "Properly print utf8 characters in windows console"
    // https://stackoverflow.com/q/10882277
    const UINT PreviousConsoleCodepage = GetConsoleOutputCP();
    SetConsoleOutputCP(CP_UTF8);
#endif
    ::testing::InitGoogleTest(&Argc, Argv);
    ::testing::InitGoogleMock(&Argc, Argv);
    const int Result = RUN_ALL_TESTS();
#ifdef _WIN32
    SetConsoleOutputCP(PreviousConsoleCodepage);
    std::locale::global(PreviousLocale);
#endif
    return Result;
}