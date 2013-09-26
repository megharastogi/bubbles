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
#import "BluetoothManager.h"

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
    NSInteger i = 0;
    for( CircleView *view in self.view.subviews ) {
        view.originalIndex = i;
            [cv addObject:view];
        i = i + 1;
    }
    circleViews = cv;
    
    [BluetoothManager instance];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bluetoothDataReceived:)
                                                 name:@"bluetoothDataReceived"
                                               object:nil];

    //Adding Gravity and Collision behavior
//    [self addAnimation];
    
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


-(void) bluetoothDataReceived:(NSNotification*)note

{
    
    NSLog(@"reciving data");
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSDictionary *dict = [note object];
        NSInteger command = [dict[@"command"] intValue];
        switch( command ) {
            case BluetoothCommandPickUp:
            {
                
                NSLog(@"pick data");

                NSInteger viewNumber = [dict[@"viewNumber"] intValue];
                CircleView *bubble = self.view.subviews[viewNumber];
                if( [bubble isKindOfClass:[CircleView class]] )
                    [bubble pickUp];
                break;
            }
            case BluetoothCommandDrop:
            {
                NSLog(@"drop data");

                NSInteger viewNumber = [dict[@"viewNumber"] intValue];
                CircleView *bubble = self.view.subviews[viewNumber];
                if( [bubble isKindOfClass:[CircleView class]] )
                    [bubble drop];
                break;
            }
            case BluetoothCommandMove:
            {
                NSInteger viewNumber = [dict[@"viewNumber"] intValue];
                CircleView *bubble = self.view.subviews[viewNumber];
                if( [bubble isKindOfClass:[CircleView class]] )
                    bubble.center = [dict[@"newCenter"] CGPointValue];
            }
            case BluetoothCommandPop:
            {
                NSLog(@"Pop");
                
                NSInteger viewNumber = [dict[@"viewNumber"] intValue];
                CircleView *bubble = self.view.subviews[viewNumber];
                if( [bubble isKindOfClass:[CircleView class]] )
                    [bubble removeFromSuperview];
                
                break;
            }
                
            case BluetoothCommandCreateNew:
            {
                NSLog(@"Create");
                NSInteger i;
                
                i = [self.view.subviews count] + 1;
                
                CGRect frame;
                frame.origin.x = 10;
                frame.origin.y = 10;
                frame.size.width = 124.;
                frame.size.height = 124.;
                CircleView *v = [[CircleView alloc] initWithFrame:frame];
                v.layer.cornerRadius = 62;
                v.backgroundColor = [UIColor pickRandomColor];
                [self.view addSubview:v];
                            

                break;
            }


        }
    }];
}

- (IBAction)createNewBubble
{

        NSInteger i;

        i = [self.view.subviews count] + 1;
        
        CGRect frame;
        frame.origin.x = 10;
        frame.origin.y = 10;
        frame.size.width = 124.;
        frame.size.height = 124.;
        CircleView *v = [[CircleView alloc] initWithFrame:frame];
        v.layer.cornerRadius = 62;
        v.backgroundColor = [UIColor pickRandomColor];
        [self.view addSubview:v];
        
    NSDictionary *dict = @{@"command": @(BluetoothCommandCreateNew)};
    
        [[BluetoothManager instance] sendDictionaryToPeers:dict];

}

@end
