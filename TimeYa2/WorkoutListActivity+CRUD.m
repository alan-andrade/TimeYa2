//
//  WorkoutListActivity+CRUD.m
//  TimeYa2
//
//  Created by PartyMan on 12/24/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "WorkoutListActivity+CRUD.h"
#import "TimeYaConstants.h"
#import "Activity+CRUD.h"

@implementation WorkoutListActivity (CRUD)

+ (WorkoutListActivity *) workoutListActivityWithActivity:(Activity *) activity{
    
    WorkoutListActivity *activityItem = nil;
    activityItem = [NSEntityDescription insertNewObjectForEntityForName:WORKOUT_LIST_ACTIVITY_ENTITY_NAME inManagedObjectContext:activity.managedObjectContext];
    activityItem.activity = activity;
    
    return activityItem;
    
}

+ (NSArray *) workoutListActivitiesInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:WORKOUT_LIST_ACTIVITY_ENTITY_NAME];
    request.predicate = nil;
    request.sortDescriptors = nil;
    
   return [context executeFetchRequest:request error:error];

}

@end
