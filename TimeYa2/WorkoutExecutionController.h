//
//  WorkoutExecutionController.h
//  TimeYa2
//
//  Created by PartyMan on 1/4/14.
//  Copyright (c) 2014 PartyMan. All rights reserved.
//

#import "WorkoutListController.h"

@interface WorkoutExecutionController : WorkoutListController

/** Designated initializer to instantiate a WorkoutExecutionController
 @param workout Workout used to instantiat the WorkoutExecutionController
 @return A WorkoutExecutionController instance
 */
- (WorkoutExecutionController *) initWithWorkout:(Workout *) workout;

@end
