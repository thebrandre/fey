#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <memory>
#include <stdexcept>
// #include <thrust/host_vector.h>
// #include <thrust/device_vector.h>

__global__ void addKernel(int *c, const int *a, const int *b)
{
    int i = threadIdx.x;
    c[i] = a[i] + b[i];
}

template <typename T> static auto createDeviceBuffer(std::size_t Size)
{
    struct DeleterType
    {
        void operator()(void *Buffer) const noexcept
        {
            cudaFree(Buffer);
        }
    };

    T *Result = nullptr;
    cudaError_t cudaStatus = cudaMalloc(reinterpret_cast<void **>(&Result), Size * sizeof(T));
    if (cudaStatus != cudaSuccess)
        throw std::runtime_error("cudaMalloc failed!");

    return std::unique_ptr<T, DeleterType>(Result);
}

// Helper function for using CUDA to add vectors in parallel.
void addWithCuda(int *c, const int *a, const int *b, unsigned int size)
{
    cudaError_t cudaStatus;

    // Choose which GPU to run on, change this on a multi-GPU system.
    cudaStatus = cudaSetDevice(0);
    if (cudaStatus != cudaSuccess)
        throw std::runtime_error("cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");

    // Allocate GPU buffers for three vectors (two input, one output)    .
    auto DeviceBufferA = ::createDeviceBuffer<int>(size);
    auto DeviceBufferB = ::createDeviceBuffer<int>(size);
    auto DeviceBufferC = ::createDeviceBuffer<int>(size);

    // Copy input vectors from host memory to GPU buffers.
    cudaStatus = cudaMemcpy(DeviceBufferA.get(), a, size * sizeof(int), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess)
        throw std::runtime_error("cudaMemcpy failed!");

    cudaStatus = cudaMemcpy(DeviceBufferB.get(), b, size * sizeof(int), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess)
        throw std::runtime_error("cudaMemcpy failed!");

    // Launch a kernel on the GPU with one thread for each element.
    addKernel<<<1, size>>>(DeviceBufferC.get(), DeviceBufferA.get(), DeviceBufferB.get());

    // Check for any errors launching the kernel
    cudaStatus = cudaGetLastError();
    if (cudaStatus != cudaSuccess)
        throw std::runtime_error(std::string("addKernel launch failed: ") + cudaGetErrorString(cudaStatus));

    // cudaDeviceSynchronize waits for the kernel to finish, and returns
    // any errors encountered during the launch.
    cudaStatus = cudaDeviceSynchronize();
    if (cudaStatus != cudaSuccess)
        throw std::runtime_error(std::string("cudaDeviceSynchronize failed after launching addKernel: ") +
                                 cudaGetErrorString(cudaStatus));

    // Copy output vector from GPU buffer to host memory.
    cudaStatus = cudaMemcpy(c, DeviceBufferC.get(), size * sizeof(int), cudaMemcpyDeviceToHost);
    if (cudaStatus != cudaSuccess)
        throw std::runtime_error("cudaMemcpy failed!");
}

void myCudaDeviceReset()
{
    // cudaDeviceReset must be called before exiting in order for profiling and
    // tracing tools such as Nsight and Visual Profiler to show complete traces.
    auto cudaStatus = cudaDeviceReset();
    if (cudaStatus != cudaSuccess)
        throw std::runtime_error("cudaDeviceReset failed!");
}
