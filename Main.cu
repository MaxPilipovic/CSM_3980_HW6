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
    //268435456
    int SIZE = 536870912;
    int *x = (int*)malloc(SIZE * sizeof(int));
    int *y = (int*)malloc(SIZE * sizeof(int));
    int *z = (int*)malloc(SIZE * sizeof(int));

    random(x, SIZE);
    random(y, SIZE);

    //Number between 1 and 100
    time_t start = time(NULL);

    start_t = clock();
    for (int i = 0; i < SIZE; i++) {
        z[i] = x[i] * c + y[i];
    }
    time_t end = time(NULL);
    printf("%d\n", difftime(end, start));

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

