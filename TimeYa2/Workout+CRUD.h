//
//  Workout+CRUD.h
//  TimeYa2
//
//  Created by PartyMan on 11/29/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "Workout.h"

/**Workout entity category that takes care of create, read, update and delelet operations
 
 */

@interface Workout (CRUD)

/**Creates a workout entity with a name in the specified context
 @param name Name of the workout
 @param context Context where to create the workout
 @return Workout entity created
 */
+ (Workout *) workoutWithName:(NSString *) name inMangedObjectContext:(NSManagedObjectContext *) context;

/** Deletes a workout from the specified context
 @param workout Workout to delete
 @param context Context where to delete
 */
+ (void) deleteWorkout:(Workout *) workout inManagedObjectContext: (NSManagedObjectContext *) context;

/** Searches for all workouts in the specified context
 @paran context Context where to search
 @param return Array of existing workouts
 */
+ (NSArray *) workoutsInManagedObjectContext:(NSManagedObjectContext *) context;

@end
