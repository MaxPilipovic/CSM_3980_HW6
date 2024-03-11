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
    //here
    srand(time(NULL));
    int SIZE = 536870912; //2GB
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
    for (int i = 0; i < SIZE; i++) {
        z[i] = x[i] * c + y[i];
    }
    end_t = clock();
    total_t = (double)(end_t - start_t) / CLOCKS_PER_SEC;
    printf("%f\n", total_t);

    printf("%d\n", c);
    printf("%d\n", x[3]);
    printf("Hello World!TEST\n");
    printf("\n");

    //Free Memory
    free(x);
    free(y);
    free(z);

    return 0;
}

