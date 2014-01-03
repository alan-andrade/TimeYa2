//
//  Workout+CRUD.h
//  TimeYa2
//
//  Created by PartyMan on 11/29/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "Workout.h"
#import "WorkoutActions.h"
#import "WorkoutParentElementActions.h"

/**Workout category that takes care of create, read, update and delete operations
 
 */

@interface Workout (CRUD) <WorkoutActions, WorkoutParentElementActions>

/** Search for all workouts in the specified context
 @paran context Context where to search
 @param error Pointer to a NSError object
 @return Array of existing workouts in the specified context. If there are no workouts, the array is empty. Nil if there is an error.
 */
+ (NSArray *) workoutsInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error;

/** Delete a workout from the specified context
 @param workout Workout to delete
 @param error A pointer to a NSError object
 @return YES if the workout is deleted, otherwise NO
 */
+ (BOOL) deleteWorkout:(Workout *) workout error:(NSError**) error;

+ (BOOL) isKindOfWorkoutEntity:(id <WorkoutParentElementActions>) parent;

@end
