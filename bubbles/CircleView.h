//
//  CircleView.h
//  bubbles
//
//  Created by MEGHA GULATI on 9/12/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView

@property(nonatomic,strong) UIGravityBehavior *g;
@property (nonatomic,strong)UICollisionBehavior *c;
@property (nonatomic,strong)UIDynamicAnimator *animator;
@property (nonatomic,strong)UIDynamicItemBehavior * i;

@property (nonatomic, assign) NSInteger originalIndex;


-(void) pickUp;
-(void) drop;

@end
