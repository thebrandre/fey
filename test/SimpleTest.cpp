#include <gtest/gtest.h>
#include <string_view>

#include <exec/static_thread_pool.hpp>
#include <stdexec/execution.hpp>

TEST(static_thread_pool, sample)
{
    exec::static_thread_pool ThreadPool(3);

    auto Scheduler = ThreadPool.get_scheduler();

    auto MyFunction = [](int i) { return i * i; };
    auto MyAsyncWork = stdexec::when_all(stdexec::on(Scheduler, stdexec::just(0) | stdexec::then(MyFunction)),
                                         stdexec::on(Scheduler, stdexec::just(1) | stdexec::then(MyFunction)),
                                         stdexec::on(Scheduler, stdexec::just(2) | stdexec::then(MyFunction)));

    // Launch the work and wait for the result
    auto Result = stdexec::sync_wait(std::move(MyAsyncWork));
    ASSERT_TRUE(Result.has_value());
    auto [i, j, k] = Result.value();

    EXPECT_EQ(i, 0);
    EXPECT_EQ(j, 1);
    EXPECT_EQ(k, 4);

    
    EXPECT_EQ(std::string_view("🤖"), std::string_view("\U0001f917"));
}