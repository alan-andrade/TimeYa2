//
//  WorkoutTreeRoot+CRUD.h
//  TimeYa2
//
//  Created by PartyMan on 12/20/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "WorkoutTreeRoot.h"

@interface WorkoutTreeRoot (CRUD)

/**Create a WorkoutTreeRoot node entity with a workout in its own context
 @param workout Workout that will be used to create the tree root
 @return WorkoutTreeRoot entity created
 */

+ (WorkoutTreeRoot *) workoutTreeRootWithWorkout:(Workout *) workout;


/** Search for all WorkoutTreeRoot nodes in the specified context
  @paran context Context where to search
  @return Array of existing WorkoutTreeRoot nodes in the specified context. If there are no nodes, the array is empty. Nil if there is an error.
  */

+ (NSArray *) workoutTreeRootNodesInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error;

@end
