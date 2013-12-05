//
//  Workout+CRUD.h
//  TimeYa2
//
//  Created by PartyMan on 11/29/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "Workout.h"

/**Workout category that takes care of create, read, update and delete operations
 
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
 @param error A pointer to a NSError object
 @return YES if the workout is deleted, otherwise NO
 */
+ (BOOL) deleteWorkout:(Workout *) workout error:(NSError**) error;

/** Updates a workout properties
 @param wokout Workout to update
 @properties Workout properties to update
 @return Updated workout
 */
+ (Workout *) updateWorkout: (Workout *) workout
                 properties:(NSDictionary *) properties;


/** Searches for all workouts in the specified context
 @paran context Context where to search
 @param error Pointer to a NSError object
 @return Array of existing workouts in the specified context. If there are no workouts, the array is empty. Nil if there is an error.
 */
+ (NSArray *) workoutsInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error;

@end
