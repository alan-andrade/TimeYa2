//
//  WorkoutList+CRUD.m
//  TimeYa2
//
//  Created by PartyMan on 12/20/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "WorkoutList+CRUD.h"
#import "TimeYaConstants.h"
#import "Workout+CRUD.h"
#import "Exercise+CRUD.h"
#import "Group+CRUD.h"
#import "Activity+CRUD.h"
#import "WorkoutListActivity+CRUD.h"

@interface WorkoutList ()

@property (nonatomic) NSInteger position;
@property (nonatomic) NSInteger depth;
@property (strong, nonatomic) NSMutableArray *parentStack;

@end

@implementation WorkoutList (CRUD)

+ (WorkoutList *) workoutListWithWorkout:(Workout *) workout{
    
    WorkoutList *list = nil;
    list = [NSEntityDescription insertNewObjectForEntityForName:WORKOUT_LIST_ENTITY_NAME inManagedObjectContext:workout.managedObjectContext];

    list.workout = workout;
    
    return list;
}

+ (NSArray *) workoutListsInManagedObjectContext:(NSManagedObjectContext *)context error:(NSError *__autoreleasing *)error{
        
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WORKOUT_LIST_ENTITY_NAME];
    request.predicate = nil;
    request.sortDescriptors = nil;
    
    return [context executeFetchRequest:request error:error];
    
}

@end
