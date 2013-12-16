//
//  Group+CRUD.h
//  TimeYa2
//
//  Created by PartyMan on 12/10/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "Group.h"

@interface Group (CRUD)

/**Create a group entity with a name in the specified workout
 @param name Name of the group
 @param workout Workout where the exercise will be added
 @return Group entity created
 */

+ (Group *) groupWithName:(NSString *) name inWorkout:(Workout *) workout;

/**Create a group entity with a name in the specified group
 @param name Name of the group
 @param workout Group where the group will be added
 @return Group entity created
 */

+ (Group *) groupWithName:(NSString *) name inGroup:(Group *) group;

/** Search for all groups in the specified context
 @paran context Context where to search
 @param error Pointer to a NSError object
 @return Array of existing groups in the specified context. If there are no groups, the array is empty. Nil if there is an error.
 */
+ (NSArray *) groupsInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error;

@end
