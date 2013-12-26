//
//  WorkoutTreeRoot+CRUD.m
//  TimeYa2
//
//  Created by PartyMan on 12/20/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "WorkoutTreeRoot+CRUD.h"
#import "TimeYaConstants.h"
#import "Workout+CRUD.h"
#import "Exercise+CRUD.h"
#import "Group+CRUD.h"
#import "Activity+CRUD.h"
#import "WorkoutTreeNode+CRUD.h"

@interface WorkoutTreeRoot ()

@property (nonatomic) NSInteger position;
@property (nonatomic) NSInteger depth;
@property (strong, nonatomic) NSMutableArray *parentStack;

@end

@implementation WorkoutTreeRoot (CRUD)

+ (WorkoutTreeRoot *) workoutTreeRootWithWorkout:(Workout *) workout{
    
    WorkoutTreeRoot *treeRoot = nil;
    treeRoot = [NSEntityDescription insertNewObjectForEntityForName:WORKOUT_TREE_ROOT_ENTITY_NAME inManagedObjectContext:workout.managedObjectContext];

    treeRoot.workout = workout;
    
    return treeRoot;
}

+ (NSArray *) workoutTreeRootNodesInManagedObjectContext:(NSManagedObjectContext *)context error:(NSError *__autoreleasing *)error{
        
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WORKOUT_TREE_ROOT_ENTITY_NAME];
    request.predicate = nil;
    request.sortDescriptors = nil;
    
    return [context executeFetchRequest:request error:error];
    
}

@end
