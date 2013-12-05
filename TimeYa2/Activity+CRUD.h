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

/** Searches activities 
 */

/** Deletes an anctivity from the specified context
 @param activity Activity to delete
 */
+ (void) deleteActivity:(Activity *) activity;

@end
