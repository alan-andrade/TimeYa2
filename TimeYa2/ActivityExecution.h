//
//  ActivityExecution.h
//  TimeYa2
//
//  Created by PartyMan on 1/7/14.
//  Copyright (c) 2014 PartyMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WorkoutListActivity.h"


@interface ActivityExecution : WorkoutListActivity

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSNumber * elapsedReps;
@property (nonatomic, retain) NSNumber * elapsedTime;
@property (nonatomic, retain) NSNumber * running;

@end
