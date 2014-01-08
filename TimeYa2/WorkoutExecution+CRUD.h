//
//  WorkoutExecution+CRUD.h
//  TimeYa2
//
//  Created by PartyMan on 1/4/14.
//  Copyright (c) 2014 PartyMan. All rights reserved.
//

#import "WorkoutExecution.h"
#import "WorkoutExecutionElementActions.h"

@interface WorkoutExecution (CRUD) <WorkoutExecutionElementActions>

/**Creates a WorkoutExecution entity with a given workout
 @param workout Workout used to create the WorkoutExecution entity
 @return WorkoutExeuction entity created
 */

+ (WorkoutExecution *) workoutExecutionWithWorkout:(Workout *) workout;

/** Search for all WorkoutExecution entities in the specified context
 @paran context Context where to search
 @return Array of existing WorkoutExeuction entitis in the specified context. If there are no nodes, the array is empty. Nil if there is an error.
 */
+ (NSArray *) workoutExecutionsInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error;

@end
