//
//  WorkoutListActivity+CRUD.h
//  TimeYa2
//
//  Created by PartyMan on 12/24/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "WorkoutListActivity.h"

@interface WorkoutListActivity (CRUD)

/**Create a WorkoutListActivity entity with an activity in the specified context
 @param activity Activity that will be used to create the workout list activity entry
 @return WorkoutListActivity entity created
 */

+ (WorkoutListActivity *) workoutListActivityWithActivity:(Activity *) activity;

/** Search for all WorkoutListActivities in the specified context
 @paran context Context where to search
 @param error Pointer to a NSError object
 @return Array of existing WorkoutListActivities in the specified context. If there are no entries, the array is empty. Nil if there is an error.
 */

+ (NSArray *) workoutListActivitiesInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error;

@end
