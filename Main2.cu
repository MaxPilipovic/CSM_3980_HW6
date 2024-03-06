#include <stdio.h>
#include <stdlib.h>
#include <time.h>
//Adjacent Multi-Threaded CUDA
int main() {
    int SIZE = 536870912;
    int *x = (int*)malloc(SIZE * sizeof(int));
    int *y = (int*)malloc(SIZE * sizeof(int));
    int *z = (int*)malloc(SIZE * sizeof(int));

    random(x, SIZE);
    random(y, SIZE);

    //Number between 1 and 100
    int c = rand() % 100 + 1;

    //Send it
    for (int j = 0; j < 0xFFFFFFF; j++) {
        int ticks = clock();
        vecadd(x, y, z, c, SIZE);
        printf("%f\n", (float)ticks / CLOCKS_PER_SEC);
        break;
    }

    free(x);
    free(y);
    free(z);

    return 0;
}

void random(int *array, int SIZE) {
    for (int i = 0; i < SIZE; i++) {
        array[i] = rand();
    }
}

void vecadd(int* x, int* y, int* z, int c, int SIZE) {
    // Allocate GPU memory
    int *x_d, *y_d, *z_d;

    cudaMalloc((void**) &x_d, SIZE*sizeof(int));
    cudaMalloc((void**) &y_d, SIZE*sizeof(int));
    cudaMalloc((void**) &z_d, SIZE*sizeof(int));
    // Copy data to GPU memory
    cudaMemcpy(x_d, x, SIZE*sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(y_d, y, SIZE*sizeof(int), cudaMemcpyHostToDevice);

    // Perform computation on GPU
    int threadsBlock = 256;
    int threadsGrid = (SIZE + threadsBlock - 1) / threadsBlock;
    vecadd_kernel<<<threadsGrid, threadsBlock>>>(x_d, y_d, z_d, c, SIZE);

    //Synchronize
    cudaDeviceSynchronize();

    // Copy data from GPU memory
    cudaMemcpy(z, z_d, SIZE *sizeof(int), cudaMemcpyDeviceToHost);

    // Deallocate GPU memory
    cudaFree(x_d);
    cudaFree(y_d);
    cudaFree(z_d);
}

__global__ void vecadd_kernel(int* x, int* y, int* z, int c, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;

    for (int j = i; j < n; j += stride) {
        z[j] = c * x[j] + y[j];
    }
}