//
//  WorkoutList+CRUD.h
//  TimeYa2
//
//  Created by PartyMan on 12/20/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "WorkoutList.h"

@interface WorkoutList (CRUD)

/**Create a WorkoutList node entity with a workout in its own context
 @param workout Workout that will be used to create the tree root
 @return WorkoutList entity created
 */

+ (WorkoutList *) workoutListWithWorkout:(Workout *) workout;


/** Search for all WorkoutList nodes in the specified context
  @paran context Context where to search
  @return Array of existing WorkoutList nodes in the specified context. If there are no nodes, the array is empty. Nil if there is an error.
  */

+ (NSArray *) workoutListsInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error;

@end
