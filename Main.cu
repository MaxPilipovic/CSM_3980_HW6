#include <cstdio>
#include "Main.cuh"
//Single-Threaded Program

void random(int *array, int size) {
    for (int i = 0; i < SIZE; i++) {
        arr[i] = rand();
    }
}

int main() {
    int SIZE = 536870912;
    int* x = new int [SIZE];
    int* y = new int [SIZE];
    int* z = new int [SIZE];

    random(int x, SIZE);
    random(int y, SIZE);

    int c = rand();
    printf(c);
    printf(x[3]);
    printf("Hello World!TEST\n");
}

