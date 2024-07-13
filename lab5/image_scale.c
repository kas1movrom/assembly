#include "image_scale.h"

void image_scale(unsigned char *output, unsigned char *input, int old_width,
                 int old_height, int new_width, int new_height, int channels)
{
    for (int y = 0; y < new_height; y++)
    {
        int src_y = y * old_height / new_height;

        for (int x = 0; x < new_width; x++) 
        {
            int src_x = x * old_width / new_width;

            int src_ind = (src_y * old_width + src_x) * channels;
            int dest_ind = (y * new_width + x) * channels;

            for (int c = 0; c < channels; c++)
                output[dest_ind + c] = input[src_ind + c];
        }
    }
}