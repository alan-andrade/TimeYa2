//
//  WorkoutExecutionControllerMock.h
//  TimeYa2
//
//  Created by PartyMan on 1/5/14.
//  Copyright (c) 2014 PartyMan. All rights reserved.
//

#import "WorkoutExecutionController.h"
#import "WorkoutExecution+CRUD.h"

@interface WorkoutExecutionControllerMock : WorkoutExecutionController

@property (strong, nonatomic) NSArray *workoutActiveBranch;

- (void) processWorkoutBeat:(NSNotification *) notification;


@end
