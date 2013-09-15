//
//  BubbledBehavior.h
//  bubbles
//
//  Created by MEGHA GULATI on 9/12/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BubbledBehavior : UIDynamicBehavior
- (instancetype)initWithItems:(NSArray*)items animator:(UIDynamicAnimator *)animator;
@property(nonatomic,strong) UIGravityBehavior * g;
@property(nonatomic,strong) UICollisionBehavior * c;
@property(nonatomic,strong) UIDynamicItemBehavior * i;

@end
