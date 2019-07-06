//
//  PremultiplyOld.h
//
//  Util methods to premultiply and unpremultiply CoreGraphics
//  premultiplied alpha pixel values.

#ifndef _PREMULTIPLY_HEADER_H
#define _PREMULTIPLY_HEADER_H

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <math.h>
#include <assert.h>
#include <limits.h>
#include <unistd.h>

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus

// Premultiply

static
inline
uint32_t premultiply_c_inline(uint32_t c, uint32_t alpha)
{
  // PRE = STRAIGHT * ALPHA
  c = (c * alpha + 127) / 255;
  return c;
}
  
static
inline
uint32_t premultiply_bgra4_inline(uint32_t red, uint32_t green, uint32_t blue, uint32_t alpha)
{
  uint32_t result = (alpha << 24) | (premultiply_c_inline(red, alpha) << 16) | (premultiply_c_inline(green, alpha) << 8) | premultiply_c_inline(blue, alpha);
  return result;
}

static
inline
uint32_t premultiply_bgra4_check_inline(uint32_t red, uint32_t green, uint32_t blue, uint32_t alpha)
{
  uint32_t premultPixel;
  if (alpha == 0xFF) {
    premultPixel = (alpha << 24) | (red << 16) | (green << 8) | blue;
  } else if (alpha == 0x0) {
    premultPixel = 0x0;
  } else {
    premultPixel = premultiply_bgra4_inline(red, green, blue, alpha);
  }
  return premultPixel;
}

// Invoke premultiply_bgra4_inline() after shifting components out of pixel

static
inline
uint32_t premultiply_bgra(uint32_t unpremultPixel)
{
  uint32_t alpha = (unpremultPixel >> 24) & 0xFF;
  uint32_t red = (unpremultPixel >> 16) & 0xFF;
  uint32_t green = (unpremultPixel >> 8) & 0xFF;
  uint32_t blue = (unpremultPixel >> 0) & 0xFF;
  
  uint32_t premultPixel;
  
  if (alpha == 0xFF) {
    premultPixel = unpremultPixel;
  } else if (alpha == 0x0) {
    premultPixel = 0x0;
  } else {
    premultPixel = premultiply_bgra4_inline(red, green, blue, alpha);
  }
  
  return premultPixel;
}

#ifdef __cplusplus
}
#endif // __cplusplus

#endif // _PREMULTIPLY_HEADER_H
