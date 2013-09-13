//
//  CircleView.m
//  bubbles
//
//  Created by MEGHA GULATI on 9/12/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import "CircleView.h"
#import "UIColor+PickRandomColor.h"
#import <QuartzCore/QuartzCore.h>

@implementation CircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void) awakeFromNib
{
    [super awakeFromNib];
    self.alpha = 0.5;
    self.layer.cornerRadius = 50;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor pickRandomColor];
    
    for( NSInteger i = 0; i < 4; i++ ) {
        
        CGRect frame;
        frame.origin.x = 10.*i;
        frame.origin.y = 10.*i;
        frame.size.width = 30.;
        frame.size.height = 30.;
        UIView *v = [[UIView alloc] initWithFrame:frame];
//        v.alpha = 0.5;
        v.layer.cornerRadius = 15;
        v.backgroundColor = [UIColor pickRandomColor];
        [self addSubview:v];
        NSLog(@"herer");

    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
//- (void)drawRect:(CGRect)rect
//{
//    
//    
//    NSLog(@" Then here herer");
//}


@end
