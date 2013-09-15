//
//  ViewController.m
//  bubbles
//
//  Created by MEGHA GULATI on 9/12/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import "ViewController.h"
#import "CircleView.h"
#import "UIColor+PickRandomColor.h"
#import "CMMotionManager+Shared.h"

@interface ViewController () 
{
    NSMutableArray *circleViews;
}
@property (nonatomic,strong)UIGravityBehavior *g;
@property (nonatomic,strong)UICollisionBehavior *c;
@property (nonatomic,strong)UIDynamicAnimator *animator;
@property (nonatomic,strong)UIDynamicItemBehavior * i;

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
    circleViews = cv;
    
    [self addAnimation];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    
    //Motion Animation
    CMMotionManager *motionManager = [CMMotionManager sharedMotionManager];
    if ([motionManager isAccelerometerAvailable]) {
        [motionManager setAccelerometerUpdateInterval:1/10];
        [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *data, NSError *error) {
            self.g.gravityDirection = CGVectorMake(data.acceleration.x, data.acceleration.y*(-1));

            for( CircleView *v in circleViews ) {
                v.g.gravityDirection = CGVectorMake(data.acceleration.x, data.acceleration.y);
                
            }
        }];
    }
    
    

}

-(void)addAnimation{
    self.c = [[UICollisionBehavior alloc] initWithItems:circleViews];
    self.i = [[UIDynamicItemBehavior alloc] initWithItems:circleViews];
    self.g = [[UIGravityBehavior alloc] initWithItems:circleViews];
    self.animator =[[UIDynamicAnimator alloc] initWithReferenceView:self.view];
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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
