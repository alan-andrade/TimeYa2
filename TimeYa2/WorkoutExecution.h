//
//  WorkoutExecution.h
//  TimeYa2
//
//  Created by PartyMan on 1/7/14.
//  Copyright (c) 2014 PartyMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WorkoutList.h"


@interface WorkoutExecution : WorkoutList

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSNumber * activeTime;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSDate * finishTime;
@property (nonatomic, retain) NSNumber * running;
@property (nonatomic, retain) NSDate * startTime;

@end
