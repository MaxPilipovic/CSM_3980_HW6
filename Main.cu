#include <cstdio>
#include "Main.cuh"

__global__ void mykernel(void) {}

int main(void) {
    mykernel<<<1,1>>>();
    printf("Hello World!TEST\n");
    return 0;
}

