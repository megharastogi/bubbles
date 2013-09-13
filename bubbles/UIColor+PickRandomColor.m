//
//  UIColor+PickRandomColor.m
//  bubbles
//
//  Created by MEGHA GULATI on 9/12/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import "UIColor+PickRandomColor.h"

@implementation UIColor (PickRandomColor)
+(UIColor*) pickRandomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

-(UIColor*) returnLighterColor
{
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    NSLog(@"Current Color hue: %0.2f, saturation: %0.2f, brightness: %0.2f, alpha: %0.2f", hue, saturation, brightness, alpha);
    saturation = MIN((saturation - 0.20), 1);
    
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
    return color;
}


@end
