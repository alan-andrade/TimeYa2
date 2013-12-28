//
//  Activity+CRUD.h
//  TimeYa2
//
//  Created by PartyMan on 12/4/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "Activity.h"
#import "ActivityOperations.h"

/**Workout category that takes care of create, read, update and delete operations
 
 */

@interface Activity (CRUD) <ActivityOperations>

/** Search activities within the specified context
 @param context Context to search
 @return Array of existing activities in the specified context. If there are no activities, the array is empty. Nil if there is an error.
 */

+ (NSArray *) activitiesInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error;


/** Delete an activity from the specified context
 @param activity Activity to delete
 @param error Pointer to a NSError object
 @return YES if the activity is deleted, otherwise NO
 */
+ (BOOL) deleteActivity:(Activity *) activity error:(NSError **)error;


/** Returns the parent node of the specified activity
 @param activity Activity which we want to know its parent
 @return NSManagedObject that is parent of activity
 */
+ (NSManagedObject *) parent:(Activity *)activity;


@end
