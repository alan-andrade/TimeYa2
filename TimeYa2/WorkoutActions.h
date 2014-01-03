//
//  WorkoutActions.h
//  TimeYa2
//
//  Created by PartyMan on 12/28/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkoutElementActions.h"

@protocol WorkoutActions <WorkoutElementActions>

/**Create a workout entity with a name in the specified context
 @param name Name of the workout
 @param context Context where to create the workout
 @return Workout entity created
 */
+ (Workout *) workoutWithName:(NSString *) name inMangedObjectContext:(NSManagedObjectContext *) context;

/** Creates a new workout by copying another given workout including all its children activities
 @param workout A workout from which to copy all values
 @return A workout of the type of the receiver
 */

+ (Workout *) initWithWorkout:(Workout *) workout;

/** Update a workout properties
 @param wokout Workout to update
 @properties Workout properties to update
 @return Updated workout
 */
+ (Workout *) updateWorkout: (Workout *) workout
                 properties:(NSDictionary *) properties;

/** Validate a workout does not have groups without activities
 @param workout Workout to validate
 @return Empty array if the workout is valid. Otherwise it will return all invalid group nodes
 */
+ (NSArray *) validateWorkout:(Workout *)workout;


@end
