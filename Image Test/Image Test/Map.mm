//
//  Map.m
//  Image Test
//
//  Created by Christopher Primerano on 2015-03-20.
//  Copyright (c) 2015 Christopher Primerano. All rights reserved.
//

#import "Map.h"

#import <opencv2/videoio/cap_ios.h>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgproc.hpp>
#import <opencv2/objdetect.hpp>
#import <opencv2/calib3d.hpp>

using namespace cv;

@interface Map ()

@end

@implementation Map

+(cv::Mat)cvMatFromUIImage:(UIImage *)image {
	CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
	CGFloat cols = image.size.width;
	CGFloat rows = image.size.height;
	
	cv::Mat cvMat(rows, cols, CV_8UC4);
	
	CGContextRef contextRef = CGBitmapContextCreate(cvMat.data, cols, rows, 8, cvMat.step[0], colorSpace, kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
	
	CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
	CGContextRelease(contextRef);
	
	return cvMat;
}

+(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
	NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
	CGColorSpaceRef colorSpace;
	
	if (cvMat.elemSize() == 1) {
		colorSpace = CGColorSpaceCreateDeviceGray();
	} else {
		colorSpace = CGColorSpaceCreateDeviceRGB();
	}
	
	CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
	
	// Creating CGImage from cv::Mat
	CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
										cvMat.rows,                                 //height
										8,                                          //bits per component
										8 * cvMat.elemSize(),                       //bits per pixel
										cvMat.step[0],                            //bytesPerRow
										colorSpace,                                 //colorspace
										kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
										provider,                                   //CGDataProviderRef
										NULL,                                       //decode
										false,                                      //should interpolate
										kCGRenderingIntentDefault                   //intent
										);
	
	
	// Getting UIImage from CGImage
	UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CGDataProviderRelease(provider);
	CGColorSpaceRelease(colorSpace);
	
	return finalImage;
}

+(UIImage *)disparityMap:(UIImage *) left andRight:(UIImage *) right {
	
	
	Mat l, r;
	l = [Map cvMatFromUIImage:left];
	r = [Map cvMatFromUIImage:right];
	Mat grayscaleLeft, grayscaleRight;
	cvtColor(l, grayscaleLeft, CV_BGR2GRAY);
	cvtColor(r, grayscaleRight, CV_BGR2GRAY);
	
//	Ptr<StereoSGBM> sbm = StereoSGBM::create(0, 96, 11, 8 * (11 ^ 2), 32 * (11 ^ 2), 1, 63, 10, 125, 1, 0);
	Ptr<StereoSGBM> sbm = StereoSGBM::create(0, 96, 11);
	sbm->setP1(8 * (9^2));
	sbm->setP2(32 * (9 ^2));
	sbm->setDisp12MaxDiff(1);
	sbm->setPreFilterCap(63);
	sbm->setUniquenessRatio(10);
	sbm->setSpeckleWindowSize(125);
	sbm->setSpeckleRange(1);
	sbm->setMode(StereoSGBM::MODE_SGBM);
	
//	sbm->fullDP = false;

	Mat disparity;
	sbm->compute(grayscaleLeft, grayscaleRight, disparity);
	Mat output;
	normalize(disparity, output, 0, 255, NORM_MINMAX, CV_8UC1);
	
	NSArray *obs = [Map getObstacles:output];
	
	NSLog(@"%hhd, %hhd, %hhd", [obs[0] boolValue], [obs[1] boolValue], [obs[2] boolValue]);

	[Map playTones:[obs[0] boolValue] Front:[obs[1] boolValue] Right:[obs[2] boolValue]];

	return [Map UIImageFromCVMat:output];

}

+(void)playTones:(BOOL)left Front:(BOOL)front Right:(BOOL)right {
	SystemSoundID leftSound;
	SystemSoundID frontSound;
	SystemSoundID rightSound;
	
	if (left) {
		NSString *left = [[NSBundle mainBundle] pathForResource:@"440-500" ofType:@"caf"];
		NSURL *leftURL = [NSURL fileURLWithPath:left];
		AudioServicesCreateSystemSoundID((__bridge CFURLRef)leftURL, &leftSound);
		AudioServicesPlaySystemSound(leftSound);
//		sleep(1);
		timespec *time = (timespec *)malloc(sizeof(timespec));
		time->tv_sec = 0;
		time->tv_nsec = 500000000;
		nanosleep(time, nil);
	}
	if (front) {
		NSString *front = [[NSBundle mainBundle] pathForResource:@"580-500" ofType:@"caf"];
		NSURL *frontURL = [NSURL fileURLWithPath:front];
		AudioServicesCreateSystemSoundID((__bridge CFURLRef)frontURL, &frontSound);
		AudioServicesPlaySystemSound(frontSound);
		timespec *time = (timespec *)malloc(sizeof(timespec));
		time->tv_sec = 0;
		time->tv_nsec = 500000000;
		nanosleep(time, nil);
	}
	if (right) {
		NSString *right = [[NSBundle mainBundle] pathForResource:@"750-500" ofType:@"caf"];
		NSURL *rightURL = [NSURL fileURLWithPath:right];
		AudioServicesCreateSystemSoundID((__bridge CFURLRef)rightURL, &rightSound);
		AudioServicesPlaySystemSound(rightSound);
		timespec *time = (timespec *)malloc(sizeof(timespec));
		time->tv_sec = 0;
		time->tv_nsec = 500000000;
		nanosleep(time, nil);
	}
}

+(NSArray *)getObstacles:(Mat) dmap {
	int basicVal = 0;
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
	for(int i = 0; i < dmap.rows; i++) {
		for(int j = 0; j < dmap.cols; j++) {
			id obj = [dic objectForKey:[NSNumber numberWithInt:dmap.at<unsigned char>(i, j)]];
			if (obj != nil) {
				int value = [((NSNumber *)obj) intValue];
				value += 1;
				[dic setObject:[NSNumber numberWithInt:value] forKey:[NSNumber numberWithInt:dmap.at<unsigned char>(i, j)]];
			} else {
				int value = 1;
				[dic setObject:[NSNumber numberWithInt:value] forKey:[NSNumber numberWithInt:dmap.at<unsigned char>(i, j)]];
			}
		}
	}
	int maximum = 0;
	for (NSNumber *num in [dic keyEnumerator]) {
		int value = [[dic objectForKey:num] intValue];
		if (value >= maximum) {
			maximum = value;
			basicVal = [num intValue];
		}
	}

	
	int lenSide = dmap.cols / 4;
	int lenFront = dmap.cols / 2;
	
	int deviation = basicVal + basicVal / 2;
	
	int threshold = lenSide / 4;
	
	BOOL left = false, right = false, front = false;
	
	BOOL obsLeft = false, obsFront = false, obsRight = false;
	
	for (int y = 0; y < dmap.rows; y++) {
		int start = 0;
		int end = 0;
		BOOL n = true;
		
		for (int x = 0; x < dmap.cols; x++) {
			if (dmap.at<unsigned char>(y, x) >= deviation && n) {
				start = x;
				n = false;
				
			} else if (dmap.at<unsigned char>(y, x) < deviation && !n) {
				end = x;
				n = true;
				
				if (end - start >= threshold) {
					if (start <= lenSide && end > lenSide) {
						front = true;
					} else if (start <= lenSide + 1 && end > lenSide + 1 + lenFront) {
						front = true;
					} else if (end <= lenSide) {
						left = true;
					} else if (start >= lenSide + 1 && end <= lenSide + 1 + lenFront) {
						front = true;
					} else if (start >= lenSide + 2 + lenFront) {
						right = true;
					}
				}
			}
		}
		obsLeft = left ? true : obsLeft;
		obsFront = front ? true : obsFront;
		obsRight = right ? true : obsRight;
		
	}
	
	return @[[NSNumber numberWithBool:obsLeft],	[NSNumber numberWithBool:obsFront], [NSNumber numberWithBool:obsRight]];
	
}

@end
