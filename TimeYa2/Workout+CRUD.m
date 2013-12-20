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
#import "Group.h"
#import "Activity.h"
#import "Exercise+CRUD.h"

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

+ (NSArray *) validateWorkout:(Workout *)workout{
    
    NSMutableArray *invalidNodes = [[NSMutableArray alloc] init];
    
    for (Activity *activity in workout.activities) {
        [invalidNodes addObjectsFromArray:[self searchEmptyGroups:activity]];
    }
    
    return invalidNodes;
}

+ (NSArray *) searchEmptyGroups:(Activity *) activity{
    
    NSMutableArray *emptyGroups = [[NSMutableArray alloc] init];
    NSEntityDescription *groupEntity = [NSEntityDescription entityForName:GROUP_ENTITY_NAME inManagedObjectContext:activity.managedObjectContext];
    
    if ([[activity entity] isKindOfEntity:groupEntity]) {
        Group *group = (Group *) activity;
        
        if ([group.activities count] == 0) {
            [emptyGroups addObject:group];
        }else{
            for (Activity *activity in group.activities) {
                [emptyGroups addObjectsFromArray:[self searchEmptyGroups:activity]];
            }
        }
    }
    
    return emptyGroups;
    
}


#pragma mark - Core Data one-to-many accessor method

- (void)addActivitiesObject:(Activity *)value{
    
    NSMutableOrderedSet *tmpOrderedSet = [self mutableOrderedSetValueForKey:WORKOUT_ACTIVITIES_KEY];
    [tmpOrderedSet addObject:value];
    
}

int position;
int depth;
NSMutableArray *parentStack;

+ (void) preorderWorkout:(Workout *) workout{
    
    NSLog(@"Workout: %@", workout.name);
    
    position = 0;
    depth = 0;
    parentStack = [[NSMutableArray alloc] init];
    
    for (Activity* activity in workout.activities) {
        [self preorder:activity];
    }
    
    parentStack = nil;
    
}

+ (void) preorder:(Activity *) activity{
    
    if ([self isKindOfExerciseEntity:activity]) {
        NSLog(@"%i)%*s %@ (%@) \t Parent: %@", position, depth, "", activity.name, @0, [[parentStack lastObject] name]);
    }else{
        NSLog(@"%i)%*s %@ (%i) \t Parent: %@", position, depth, "", activity.name, [((Group *)activity).activities count], [[parentStack lastObject] name]);
    }
    
    position++;
    
    if([self isKindOfGroupEntity:activity]){
        
        Group *group = (Group *)activity;

        depth++;
        [parentStack addObject:group];
        
        for (Activity *childActivity in group.activities) {
            [self preorder:childActivity];
        }
        
        depth --;
        [parentStack removeLastObject];
        
    }else if([self isKindOfExerciseEntity:activity]){
        return;
    }
}

+ (BOOL) isKindOfGroupEntity:(Activity *) activity{
    
    NSEntityDescription *groupEntity = [NSEntityDescription entityForName:GROUP_ENTITY_NAME inManagedObjectContext:activity.managedObjectContext];
    return [[activity entity] isKindOfEntity:groupEntity];
}

+ (BOOL) isKindOfExerciseEntity:(Activity *) activity{
    
    NSEntityDescription *exerciseEntity = [NSEntityDescription entityForName:EXERCISE_ENTITY_NAME inManagedObjectContext:activity.managedObjectContext];
    return [[activity entity] isKindOfEntity:exerciseEntity];
}



@end
