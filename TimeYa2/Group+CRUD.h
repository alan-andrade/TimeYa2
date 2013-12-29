//
//  Group+CRUD.h
//  TimeYa2
//
//  Created by PartyMan on 12/10/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "Group.h"
#import "ActivityActions.h"
#import "WorkoutParentElementActions.h"

@interface Group (CRUD) <ActivityActions, WorkoutParentElementActions>

/** Search for all groups in the specified context
 @paran context Context where to search
 @param error Pointer to a NSError object
 @return Array of existing groups in the specified context. If there are no groups, the array is empty. Nil if there is an error.
 */
+ (NSArray *) groupsInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error;

@end
