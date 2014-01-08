//
//  ActivityExecution+CRUD.h
//  TimeYa2
//
//  Created by PartyMan on 1/4/14.
//  Copyright (c) 2014 PartyMan. All rights reserved.
//

#import "ActivityExecution.h"
#import "WorkoutExecutionElementActions.h"

@interface ActivityExecution (CRUD) <WorkoutExecutionElementActions>

/**Creates an ActivityExecution entity with a given activity
 @param activity Activity that will be used to create the ActivityExecution entity
 @return ActivityExecution entity created
 */

+ (ActivityExecution *) activityExecutionWithActivity:(Activity *) activity;

/** Search for all ActivityExeuction entities in the specified context
 @paran context Context where to search
 @param error Pointer to a NSError object
 @return Array of existing ActivityExecutino entities in the specified context. If there are no entries, the array is empty. Nil if there is an error.
 */

+ (NSArray *) workoutListActivityRunsInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error;

@end
