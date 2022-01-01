#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

void main()
{
    FILE *fp = fopen("hello.txt", "w");

    if (fp) {
        fprintf(fp, "hello linux filesystem\n");
        fclose(fp);
        sync();
    }
}

