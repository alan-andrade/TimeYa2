//
//  Workout+CRUD.m
//  TimeYa2
//
//  Created by PartyMan on 11/29/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "DDLog.h"
#import "Workout+CRUD.h"
#import "TimeYaConstants.h"

static int ddLogLevel = APP_LOG_LEVEL;

@implementation Workout (CRUD)

+ (Workout *) workoutWithName:(NSString *) name inMangedObjectContext:(NSManagedObjectContext *) context{
    
    if([name length] == 0){
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Workout name can't be empty" userInfo:nil] raise];
    }
    
    Workout *workout = nil;
    workout = [NSEntityDescription insertNewObjectForEntityForName:WORKOUT_ENTITY_NAME inManagedObjectContext:context];
    
    NSDate *now = [NSDate date];
    workout.creationDate = now;
    workout.lastRun = now;
    workout.name = name;
    
    return workout;

}

+ (BOOL) deleteWorkout:(Workout *) workout error:(NSError**) error{
    
    
    NSManagedObjectContext *context = workout.managedObjectContext;
    
    [context deleteObject:workout];
    
    BOOL deleted = [context save:error];
    
    if (!deleted) {
        DDLogError(@"[%@ %@] [ERROR] Workout entity could not be deleted. Workout ID: %@ Name: %@ Error: %@ User Info: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), workout.objectID, workout.name, *error, ((NSError *)*error).userInfo);
    }
    
    return deleted;
}

+ (Workout *) updateWorkout: (Workout *) workout
                 properties:(NSDictionary *) properties{
    
    NSDictionary *workoutAttrDict = [[NSEntityDescription entityForName:WORKOUT_ENTITY_NAME inManagedObjectContext:workout.managedObjectContext] attributesByName];
    NSArray *workoutAttrKeys = [workoutAttrDict allKeys];
    
    NSArray *propertyKeys = [properties allKeys];
    for(NSString* propertyKey in propertyKeys){
        
        if([workoutAttrKeys containsObject:propertyKey]){
            [workout setValue:properties[propertyKey] forKey:propertyKey];
        }
    }
    
    return workout;
}

+ (NSArray *) workoutsInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WORKOUT_ENTITY_NAME];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:WORKOUT_LAST_RUN_KEY ascending:YES]];
    
    return [context executeFetchRequest:request error:error];
    
}

@end
