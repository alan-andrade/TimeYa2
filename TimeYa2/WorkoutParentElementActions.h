//
//  WorkoutParentElementActions.h
//  TimeYa2
//
//  Created by PartyMan on 12/28/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WorkoutParentElementActions <NSObject>

/** Parent activities setter
 */

- (void) setActivities:(NSOrderedSet *)activities;

/** Parent activities getter
 */
- (NSOrderedSet *) activities;

/** Parent's managed object context getter
 */

- (NSManagedObjectContext *)managedObjectContext;

/** Helper method to add an activity to the activities collection
 */
- (void) addActivitiesObject:(Activity *)value;

/** Retruns the next leaf node in the workout tree
 @param child Activity node that will be used as reference to return the next leaf node in the workout tree
 @return Next activity leaf node after the child activity in the workout tree doing a pre-order depth-first search
 */

- (Activity *) nextLeafAfterActivity:(Activity *) child;

@end
