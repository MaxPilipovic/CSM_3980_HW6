#include <stdio.h>
#include <stdlib.h>
#include <time.h>
//Adjacent Multi-Threaded CUDA
void random(float *array, float SIZE) {
    for (float i = 0; i < SIZE; i++) {
        array[i] = rand();
    }
}

__global__ void vecadd_kernel(float* x, float* y, float* z, float c, float n) {
    int i = blockDim.x * blockIdx.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;

    //Works on different array elements seperated by stride
    for (int j = i; j < n; j += stride) {
        z[j] = c * x[j] + y[j];
    }
}

void vecadd(float* x, float* y, float* z, float c, float SIZE) {
    //Allocate GPU memory
    float *x_d, *y_d, *z_d;

    cudaMalloc((void**) &x_d, SIZE*sizeof(float));
    cudaMalloc((void**) &y_d, SIZE*sizeof(float));
    cudaMalloc((void**) &z_d, SIZE*sizeof(float));

    //Copy data to GPU memory
    cudaMemcpy(x_d, x, SIZE*sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(y_d, y, SIZE*sizeof(float), cudaMemcpyHostToDevice);

    //Start time
    //clock_t start_t, end_t;
    //double total_t;
    //start_t = clock();

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start, 0);
    float time;

    //Perform computation on GPU
    int numThreadsPerBlock = 512;
    int numBlocks = (SIZE + numThreadsPerBlock - 1) / numThreadsPerBlock;
    vecadd_kernel<<<numBlocks, numThreadsPerBlock>>>(x_d, y_d, z_d, c, SIZE);

    //end_t = clock();
    //total_t = (double)(end_t - start_t) / CLOCKS_PER_SEC;
    //printf("%f\n", total_t);

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
    cudaMemcpy(z, z_d, SIZE *sizeof(float), cudaMemcpyDeviceToHost);

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
    float SIZE = 1610612736;
    float *x = (float*)malloc(SIZE * sizeof(float));
    float *y = (float*)malloc(SIZE * sizeof(float));
    float *z = (float*)malloc(SIZE * sizeof(float));

    random(x, SIZE);
    random(y, SIZE);

    //Number between 1 and 100
    float c = rand() % 100 + 1;

    //Send it
    vecadd(x, y, z, c, SIZE);

    free(x);
    free(y);
    free(z);

    return 0;
}