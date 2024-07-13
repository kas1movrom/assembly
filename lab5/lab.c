#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define STB_IMAGE_IMPLEMENTATION
#include "stb/stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb/stb_image_write.h"
#include "image_scale.h"

int main(int argc, char **argv)
{
    if (argc != 5)
    {
        printf("Usage: %s <input> <output> <new_width> <new_height>\n", argv[0]);
        return 1;
    }

    int width, height, channels;
    unsigned char *input = stbi_load(argv[1], &width, &height, &channels, 0);
    if (input == NULL)
    {
        printf("Failed to load the image\n");
        return 1;
    }
    
    printf("Width: %d\nHeight: %d\nChannels: %d\n", width, height, channels);
    
    int new_width = strtoul(argv[3], NULL, 10);
    int new_height = strtoul(argv[4], NULL, 10);
    unsigned char *output = malloc(new_width * new_height * channels);
    if (output == NULL)
    {
        printf("Failed to allocate memory for the output image\n");
        stbi_image_free(input);
        return 1;
    }

    clock_t start = clock();
    // image_scale_asm(output, input, width, height, new_width, new_height, channels);
    image_scale(output, input, width, height, new_width, new_height, channels);
    printf("Time: %ld\n", clock() - start);

    if (!stbi_write_png(argv[2], new_width, new_height, channels, output, new_width * channels))
    {
        printf("Failed to write the image\n");
        stbi_image_free(input);
        free(output);
        return 1;
    }

    stbi_image_free(input);
    free(output);

    return 0;
}