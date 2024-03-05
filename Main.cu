#include <stdio.h>
#include <stdlib.h>
//Single-Threaded Program

void random(int *array, int SIZE) {
    for (int i = 0; i < SIZE; i++) {
        array[i] = rand();
    }
}

int main() {
    int SIZE = 536870912;
    int *x = (int*)malloc(SIZE * sizeof(int));
    int *y = (int*)malloc(SIZE * sizeof(int));
    int *z = (int*)malloc(SIZE * sizeof(int));

    random(x, SIZE);
    random(y, SIZE);

    int c = rand() % 100;
    printf("%d\n", c);
    printf("%d\n", x[3]);
    printf("Hello World!TEST\n");

    for (int i = 0; i < SIZE; i++) {
        z[i] = x[i] * c + y[i];
    }

    //Free Memory
    free(x);
    free(y);
    free(z);

    return 0;
}

