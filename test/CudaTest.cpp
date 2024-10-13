#include <gtest/gtest.h>

void addWithCuda(int *c, const int *a, const int *b, unsigned int size);
void myCudaDeviceReset();

TEST(cuda_test, sample)
{
    static constexpr int arraySize = 5;
    const int a[arraySize] = {1, 2, 3, 4, 5};
    const int b[arraySize] = {10, 20, 30, 40, 50};
    int c[arraySize]{};

    // Add vectors in parallel.
    addWithCuda(c, a, b, arraySize);
    for (int i = 0; i < arraySize; ++i)
    {
        EXPECT_EQ(c[i], a[i] + b[i]);
    }
    myCudaDeviceReset();
}