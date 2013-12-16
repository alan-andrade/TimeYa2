//
//  Activity+CRUD.h
//  TimeYa2
//
//  Created by PartyMan on 12/4/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "Activity.h"

/**Workout category that takes care of create, read, update and delete operations
 
 */

@interface Activity (CRUD)

/** Search activities within the specified context
 @param context Context to search
 @return Array of existing activities in the specified context. If there are no activities, the array is empty. Nil if there is an error.
 */

+ (NSArray *) activitiesInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error;

/** Delete an anctivity from the specified context
 @param activity Activity to delete
 @param error Pointer to a NSError object
 @return YES if the activity is deleted, otherwise NO
 */
+ (BOOL) deleteActivity:(Activity *) activity error:(NSError **)error;

/** Update an activity attributes that passed in the values dictionary
 @param activity Acitity to update
 @param values Dictionary that contains key/values to update
 @return Updated activity. Nil if the activity class is unkown
 
 This is an abstract method that delegates the update operation to the activity's class method
 
 */

+ (Activity *) updateActivity:(Activity *) activity withValues:(NSDictionary *) values;

/** Validate attributes on the specified activity
 @param activity Activity to validate
 @return Empty if there are no errors. Otherwise it returns error messages found
 
 This is an abstract method that delegates the validation process to the activity's class method
 */
+ (NSArray*) validateActivity:(Activity *) activity;

@end
