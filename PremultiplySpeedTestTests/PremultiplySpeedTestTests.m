//
//  PremultiplySpeedTestTests.m
//  PremultiplySpeedTestTests
//
//  Created by Mo DeJong on 7/5/19.
//  Copyright © 2019 HelpURock. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Premultiply.h"

@interface PremultiplySpeedTestTests : XCTestCase

@end

uint8_t randByte()
{
  float f = (float)rand() / (float)RAND_MAX;
  return (uint8_t) round(f * 255);
}

void pre_new(int width, int height, uint32_t *inPixelsPtr, uint32_t *outPixelsPtr);
void pre_old(int width, int height, uint32_t *inPixelsPtr, uint32_t *outPixelsPtr);

@implementation PremultiplySpeedTestTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testNewPremultPerf {
  // Allocate 2D array of pixels, fill with random values
  
  int width = 2048;
  int height = 2048;

  NSMutableData *mInData = [NSMutableData data];
  [mInData setLength:(width * height * sizeof(uint32_t))];

  NSMutableData *mOutData = [NSMutableData data];
  [mOutData setLength:(width * height * sizeof(uint32_t))];
  
  uint32_t *inPixelsPtr = (uint32_t *) mInData.bytes;
  uint32_t *outPixelsPtr = (uint32_t *) mOutData.bytes;
  
  srand((unsigned int)time(0));
  
  int offset = 0;
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      uint32_t R = randByte();
      uint32_t G = randByte();
      uint32_t B = randByte();
      uint32_t A = randByte();
      
      uint32_t pixel = (A << 24) | (B << 16) | (G << 8) | R;
      inPixelsPtr[offset++] = pixel;
    }
  }
  
  [self measureBlock:^{
    pre_new(width, height, inPixelsPtr, outPixelsPtr);
  }];
}

- (void)testOldPremultPerf {
  // Allocate 2D array of pixels, fill with random values
  
  int width = 2048;
  int height = 2048;
  
  NSMutableData *mInData = [NSMutableData data];
  [mInData setLength:(width * height * sizeof(uint32_t))];
  
  NSMutableData *mOutData = [NSMutableData data];
  [mOutData setLength:(width * height * sizeof(uint32_t))];
  
  uint32_t *inPixelsPtr = (uint32_t *) mInData.bytes;
  uint32_t *outPixelsPtr = (uint32_t *) mOutData.bytes;
  
  srand((unsigned int)time(0));
  
  int offset = 0;
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      uint32_t R = randByte();
      uint32_t G = randByte();
      uint32_t B = randByte();
      uint32_t A = randByte();
      
      uint32_t pixel = (A << 24) | (B << 16) | (G << 8) | R;
      inPixelsPtr[offset++] = pixel;
    }
  }
  
  [self measureBlock:^{
    pre_old(width, height, inPixelsPtr, outPixelsPtr);
  }];
}

@end
