#include <stdio.h>
#include <stdlib.h>
#include <time.h>
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

    //Number between 1 and 100
    int c = rand() % 100;

    for (int j = 0; i < 0xFFFFFFF; i++) {
        int ticks = clock();

        for (int i = 0; i < SIZE; i++) {
            z[i] = x[i] * c + y[i];
        }
        printf("%d\n", c);
        printf("%d\n", x[3]);
        printf("Hello World!TEST\n");
        printf("");
        printf("%f\n", (float)ticks / CLOCKS_PER_SEC);
    }


    //Free Memory
    free(x);
    free(y);
    free(z);

    return 0;
}

