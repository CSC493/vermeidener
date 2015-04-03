//
//  Map.h
//  Image Test
//
//  Created by Christopher Primerano on 2015-03-20.
//  Copyright (c) 2015 Christopher Primerano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Map : NSObject

+(UIImage *)disparityMap:(UIImage *) left andRight:(UIImage *) right;

@end
