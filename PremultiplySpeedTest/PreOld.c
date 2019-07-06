#import "PremultiplyOld.h"

void pre_old(int width, int height, uint32_t *inPixelsPtr, uint32_t *outPixelsPtr) {
  int offset = 0;
  
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      uint32_t pixel = inPixelsPtr[offset];
      
      uint32_t prePixel = premultiply_bgra(pixel);
      
      if ((0)) {
        fprintf(stdout, "(un) 0x%08X -> (pre) 0x%08X\n", pixel, prePixel);
      }
      
      outPixelsPtr[offset] = prePixel;
      
      offset++;
    }
  }

}
