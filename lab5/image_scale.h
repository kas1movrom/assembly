#ifndef IMAGE_SCALE_H
#define IMAGE_SCALE_H

void image_scale(unsigned char *output, unsigned char *input, int width,
                 int height, int new_width, int new_height, int channels);

void image_scale_asm(unsigned char *output, unsigned char *input, int width,
                     int height, int new_width, int new_height, int channels);

#endif
