//
//  BubbledBehavior.m
//  bubbles
//
//  Created by MEGHA GULATI on 9/12/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import "BubbledBehavior.h"

@implementation BubbledBehavior

- (instancetype)initWithItems:(NSArray*)items animator:(UIDynamicAnimator *)animator{
    if( self =[super init] ){
        
        self.c = [[UICollisionBehavior alloc] initWithItems:items];
        self.i = [[UIDynamicItemBehavior alloc] initWithItems:items];
        self.g = [[UIGravityBehavior alloc] initWithItems:items];
        self.animator =[[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        self.g.angle= 3.14/2;
        self.g.magnitude = 2.5;
        self.i.friction = 0.5;
        self.i.resistance = 0.5;
        self.i.elasticity = 1.0;
        UIEdgeInsets titleInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        
        [self.c setTranslatesReferenceBoundsIntoBoundaryWithInsets:titleInsets] ;

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        self.g = [[UIGravityBehavior alloc] initWithItems:items];
        UICollisionBehavior * c = [[UICollisionBehavior alloc] initWithItems:items];
        UIDynamicItemBehavior * i = [[UIDynamicItemBehavior alloc] initWithItems:items];
        self.g.angle= 3.14/2;
        self.g.magnitude = 2.5;
        i.friction = 0.5;
        i.resistance = 0.5;
        i.elasticity = 1.0;
        UIEdgeInsets titleInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);

        [c setTranslatesReferenceBoundsIntoBoundaryWithInsets:titleInsets] ;

        [self addChildBehavior:self.g];
        [self addChildBehavior:c];
        [self addChildBehavior:i];


    }
    return self;
}

@end
