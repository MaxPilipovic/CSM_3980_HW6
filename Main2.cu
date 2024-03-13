#include <stdio.h>
#include <stdlib.h>
#include <time.h>
//Adjacent Multi-Threaded CUDA
void random(int *array, int size_t) {
    for (int i = 0; i < size_t; i++) {
        array[i] = rand();
    }
}

__global__ void vecadd_kernel(int* x, int* y, int* z, int c, size_t) {
    int i = blockDim.x * blockIdx.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;

    //Works on different array elements seperated by stride
    for (int j = i; j < size_t; j += stride) {
        z[j] = c * x[j] + y[j];
    }
}

void vecadd(int* x, int* y, int* z, int c, size_t) {
    //Allocate GPU memory
    int *x_d, *y_d, *z_d;

    cudaMalloc((void**) &x_d, size_t*sizeof(int));
    cudaMalloc((void**) &y_d, size_t*sizeof(int));
    cudaMalloc((void**) &z_d, size_t*sizeof(int));

    //Copy data to GPU memory
    cudaMemcpy(x_d, x, size_t*sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(y_d, y, size_t*sizeof(int), cudaMemcpyHostToDevice);

    //Perform computation on GPU
    int numThreadsPerBlock = 512;
    int numBlocks = (SIZE + numThreadsPerBlock - 1) / numThreadsPerBlock;

    //Start time
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start, 0);
    float time;

    vecadd_kernel<<<numBlocks, numThreadsPerBlock>>>(x_d, y_d, z_d, c, size_t);

    //End time
    cudaEventRecord(stop, 0);
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&time, start, stop);
    printf("%f\n", time);
    cudaEventDestroy(start);
    cudaEventDestroy(stop);

    //Synchronize
    cudaDeviceSynchronize();

    //Copy data from GPU memory
    cudaMemcpy(z, z_d, SIZE *sizeof(int), cudaMemcpyDeviceToHost);

    //Deallocate GPU memory
    cudaFree(x_d);
    cudaFree(y_d);
    cudaFree(z_d);
}

int main() {
    srand(time(NULL));
    //268435456
    //805306368
    //1073741824
    size_t = 1610612736;
    int *x = (int*)malloc(size_t * sizeof(int));
    int *y = (int*)malloc(SIZE * sizeof(int));
    int *z = (int*)malloc(SIZE * sizeof(int));

    random(x, size_t);
    random(y, size_t);

    //Number between 1 and 100
    int c = rand() % 100 + 1;

    //Send it
    vecadd(x, y, z, c, size_t);

    free(x);
    free(y);
    free(z);

    return 0;
}