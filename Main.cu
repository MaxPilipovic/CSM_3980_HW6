#include <cstdio>
#include <cstdlib>
//Single-Threaded Program

void random(int *array, int SIZE) {
    for (int i = 0; i < SIZE; i++) {
        array[i] = rand();
    }
}

int main() {
    int SIZE = 536870912;
    int* x = new int [SIZE];
    int* y = new int [SIZE];
    int* z = new int [SIZE];

    random(x, SIZE);
    random(y, SIZE);

    int c = rand();
    printf("%d\n", c);
    printf("%d\n", x[3]);
    printf("Hello World!TEST\n");

    delete[] x;
    delete[] y;
    delete[] z;

    return 0;
}

