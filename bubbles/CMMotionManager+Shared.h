//
//  CMMotionManager+Shared.h
//  bubbles
//
//  Created by MEGHA GULATI on 9/13/13.
//  Copyright (c) 2013 MEGHA GULATI. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>

@interface CMMotionManager (Shared)
+ (CMMotionManager *)sharedMotionManager;

@end
