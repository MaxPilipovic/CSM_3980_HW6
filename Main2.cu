#include <stdio.h>
#include <stdlib.h>
#include <time.h>
//Adjacent Multi-Threaded CUDA
void random(int *array, int SIZE) {
    for (int i = 0; i < SIZE; i++) {
        array[i] = rand();
    }
}

__global__ void vecadd_kernel(int* x, int* y, int* z, int c, int n) {
    int i = blockDim.x*blockIdx.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;

    //Works on different array elements seperated by stride
    for (int j = i; j < n; j += stride) {
        z[j] = c * x[j] + y[j];
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
    int numThreadsPerBlock = 512;
    int numBlocks = (SIZE + numThreadsPerBlock - 1) / numThreadsPerBlock;
    vecadd_kernel<<<numBlocks, numThreadsPerBlock>>>(x_d, y_d, z_d, c, SIZE);

    //Synchronize
    cudaDeviceSynchronize();

    // Copy data from GPU memory
    cudaMemcpy(z, z_d, SIZE *sizeof(int), cudaMemcpyDeviceToHost);

    // Deallocate GPU memory
    cudaFree(x_d);
    cudaFree(y_d);
    cudaFree(z_d);
}

int main() {
    srand(time(NULL));
    //268435456
    int SIZE = 134217728;
    int *x = (int*)malloc(SIZE * sizeof(int));
    int *y = (int*)malloc(SIZE * sizeof(int));
    int *z = (int*)malloc(SIZE * sizeof(int));

    random(x, SIZE);
    random(y, SIZE);

    //Number between 1 and 100
    int c = rand() % 100 + 1;

    clock_t start_t, end_t;
    double total_t;
    start_t = clock();

    //Send it
    vecadd(x, y, z, c, SIZE);

    end_t = clock();
    total_t = (double)(end_t - start_t) / CLOCKS_PER_SEC;
    printf("%f\n", total_t);


    free(x);
    free(y);
    free(z);

    return 0;
}