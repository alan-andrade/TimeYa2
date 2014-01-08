//
//  Exercise+CRUD.h
//  TimeYa2
//
//  Created by PartyMan on 12/10/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "Exercise.h"
#import "ActivityActions.h"
#import "ActivityExecutionActions.h"
#import "WorkoutChildElementActions.h"

@interface Exercise (CRUD) <ActivityActions, WorkoutLeafElementActions, ActivityExecutionActions>

/** Search for all exercises in the specified context
 @paran context Context where to search
 @param error Pointer to a NSError object
 @return Array of existing exercises in the specified context. If there are no exercises, the array is empty. Nil if there is an error.
 */
+ (NSArray *) exercisesInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error;



@end
