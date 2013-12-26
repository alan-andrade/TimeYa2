//
//  WorkoutTreeNode+CRUD.h
//  TimeYa2
//
//  Created by PartyMan on 12/24/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "WorkoutTreeNode.h"

@interface WorkoutTreeNode (CRUD)

/**Create a WorkoutTreeNode node entity with an activity in the specified context
 @param activity Activity that will be used to create the tree node
 @return WorkoutTreeNode entity created
 */

+ (WorkoutTreeNode *) workoutTreeNodeWithActivity:(Activity *) activity;

/** Search for all WorkoutTreeNode nodes in the specified context
 @paran context Context where to search
 @param error Pointer to a NSError object
 @return Array of existing WorkoutTreeNode nodes in the specified context. If there are no nodes, the array is empty. Nil if there is an error.
 */

+ (NSArray *) workoutTreeRootNodesInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error;

@end
