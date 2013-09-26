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
#import "BluetoothManager.h"

@implementation CircleView
{
    NSMutableArray * mySubViews;
    BOOL isMoving;
    UITouch *movingTouch;
    CGSize touchOffset;
    CGPoint originalPosition;
}


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
    
    mySubViews = [[NSMutableArray alloc] init];
    
    //Making view into circle and setting random circle
    self.alpha = 1.0;
    self.layer.cornerRadius = 62;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor pickRandomColor];

    //Smaller circle sub views
//    for( NSInteger i = 0; i < 3; i++ ) {
//        [self addSmallerCircles:i];
//    }
//    
//    for( UIView *myCircleSubView in self.subviews ) {
//        if( [myCircleSubView isKindOfClass:[CircleView class]] ) {
//            [mySubViews addObject:myCircleSubView];
//        }
//        
//    }
    
    //Add Gravity and Collision behavior for samller circles
//    [self addAnimation];

    
    //Assigning Tap gesture to main circle view
    [self assignTapGesture];
    
    
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    
    
    if (recognizer.numberOfTapsRequired == 2) {
        //Remove circle on double tap
        [self removeFromSuperview];
        
        NSDictionary *dict = @{@"command": @(BluetoothCommandPop),
                               @"viewNumber": @(_originalIndex)};
        [[BluetoothManager instance] sendDictionaryToPeers:dict];
        
    }
    
}

-(void)addSmallerCircles:(NSInteger )i{
    CGRect frame;
    frame.origin.x = 10.*i;
    frame.origin.y = 10.*i;
    frame.size.width = 30.;
    frame.size.height = 30.;
    CircleView *v = [[CircleView alloc] initWithFrame:frame];
    v.layer.cornerRadius = 15;
    v.backgroundColor = [UIColor pickRandomColor];
    [mySubViews addObject:v];
    [self addSubview:v];

}

-(void)assignTapGesture{

    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleTap:)];
    singleFingerTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleFingerTap];
    
    UITapGestureRecognizer *doubleTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleTap:)];
    singleFingerTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];


}

-(void)addAnimation{
    self.c = [[UICollisionBehavior alloc] initWithItems:mySubViews];
    self.i = [[UIDynamicItemBehavior alloc] initWithItems:mySubViews];
    self.g = [[UIGravityBehavior alloc] initWithItems:mySubViews];
    _animator =[[UIDynamicAnimator alloc] initWithReferenceView:self];
    self.g.angle= 3.14/2;
    self.g.magnitude = 2.5;
    self.i.friction = 0.5;
    self.i.resistance = 0.5;
    self.i.elasticity = 1.0;
    
    
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    
    [self.c setTranslatesReferenceBoundsIntoBoundaryWithInsets:titleInsets] ;
    
    [_animator addBehavior:self.g];
    [_animator addBehavior:self.c];
    [_animator addBehavior:self.i];

}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 */
//- (void)drawRect:(CGRect)rect
//{
//}


-(void) pickUp
{
    isMoving = TRUE;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.85;
        CGAffineTransform t = CGAffineTransformMakeScale( 1.11, 1.11 );
        t = CGAffineTransformRotate( t, M_PI );
        self.transform = t;
    }];
}


-(void) drop
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.99;
        self.transform = CGAffineTransformIdentity;
    }];
    
    isMoving = FALSE;
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if( isMoving ) return;
    
    movingTouch = [touches anyObject];
    
    CGPoint touchPoint = [movingTouch locationInView:self.superview];
    touchOffset = CGSizeMake( self.center.x - touchPoint.x, self.center.y - touchPoint.y );
    originalPosition = self.center;
    [self pickUp];
    
    NSDictionary *dict = @{@"command": @(BluetoothCommandPickUp),
                           @"viewNumber": @(_originalIndex)};
    [[BluetoothManager instance] sendDictionaryToPeers:dict];
}


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if( [touches containsObject:movingTouch] ) {
        [self drop];
        movingTouch = nil;
        
        NSDictionary *dict = @{@"command": @(BluetoothCommandDrop),
                               @"viewNumber": @(_originalIndex)};
        [[BluetoothManager instance] sendDictionaryToPeers:dict];
    }
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if( [touches containsObject:movingTouch] ) {
        [UIView animateWithDuration:0.3 animations:^{
            self.center = originalPosition;
        }];
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSLog(@"calculate touch point") ;
    if( [touches containsObject:movingTouch] ) {
        CGPoint touchPoint = [movingTouch locationInView:self.superview];
        self.center = CGPointMake( touchPoint.x + touchOffset.width, touchPoint.y + touchOffset.height );
        
        NSDictionary *dict = @{@"command": @(BluetoothCommandMove),
                               @"viewNumber": @(_originalIndex),
                               @"newCenter": [NSValue valueWithCGPoint:self.center]};
        [[BluetoothManager instance] sendDictionaryToPeers:dict];
    }
}


@end
