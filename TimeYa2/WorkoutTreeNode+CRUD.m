//
//  WorkoutTreeNode+CRUD.m
//  TimeYa2
//
//  Created by PartyMan on 12/24/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "WorkoutTreeNode+CRUD.h"
#import "TimeYaConstants.h"
#import "Activity+CRUD.h"

@implementation WorkoutTreeNode (CRUD)

+ (WorkoutTreeNode *) workoutTreeNodeWithActivity:(Activity *) activity{
    
    WorkoutTreeNode *treeNode = nil;
    treeNode = [NSEntityDescription insertNewObjectForEntityForName:WORKOUT_TREE_NODE_ENTITY_NAME inManagedObjectContext:activity.managedObjectContext];
    treeNode.activity = activity;
    
    return treeNode;
    
}

+ (NSArray *) workoutTreeRootNodesInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:WORKOUT_TREE_NODE_ENTITY_NAME];
    request.predicate = nil;
    request.sortDescriptors = nil;
    
   return [context executeFetchRequest:request error:error];

}

@end
