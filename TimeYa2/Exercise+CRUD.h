//
//  Exercise+CRUD.h
//  TimeYa2
//
//  Created by PartyMan on 12/10/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "Exercise.h"

@interface Exercise (CRUD)

/**Create an exercise entity with a name in the specified workout
 @param name Name of the exercise
 @param workout Workout where the exercise will be added
 @return Exercise entity created
 */

+ (Exercise *) exerciseWithName:(NSString *) name inWorkout:(Workout *) workout;

/**Create an exercise entity with a name in the specified group
 @param name Name of the exercise
 @param workout Group where the exercise will be added
 @return Exercise entity created
 */

+ (Exercise *) exerciseWithName:(NSString *) name inGroup:(Group *) group;

/** Search for all exercises in the specified context
 @paran context Context where to search
 @param error Pointer to a NSError object
 @return Array of existing exercises in the specified context. If there are no exercises, the array is empty. Nil if there is an error.
 */
+ (NSArray *) exercisesInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error;



@end
