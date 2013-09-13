//
//  ViewController.m
//  bubbles
//
//  Created by MEGHA GULATI on 9/12/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import "ViewController.h"
#import "CircleView.h"
@interface ViewController ()
{
    NSArray *circleViews;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *cv = [NSMutableArray new];
    for( UIView *view in self.view.subviews ) {
        if( [view isKindOfClass:[CircleView class]] ) {
            [cv addObject:view];
        }
    }
    circleViews = [NSArray arrayWithArray:cv];
    
    for( CircleView *v in circleViews ) {
        CGRect newrect = CGRectMake(v.frame.origin.x, v.frame.origin.y, 100, 100);
        [ v drawRect:(CGRect)newrect];

        NSLog( @"%@", NSStringFromCGRect( v.frame ) );
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
