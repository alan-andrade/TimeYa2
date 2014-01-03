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
#import "Activity+CRUD.h"
#import "Exercise+CRUD.h"
#import "WorkoutParentElementActions.h"

static int ddLogLevel = APP_LOG_LEVEL;

@implementation Workout (CRUD)

+ (NSArray *) workoutsInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WORKOUT_ENTITY_NAME];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:WORKOUT_LAST_RUN_KEY ascending:YES]];
    
    return [context executeFetchRequest:request error:error];
    
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

+ (BOOL) isKindOfWorkoutEntity:(id <WorkoutParentElementActions>) parent{
    
    return [parent conformsToProtocol:@protocol(WorkoutActions)];
    
}

#pragma mark WorkoutActions protocol methods

+ (Activity *) activity:(id <WorkoutParentElementActions>) parent nextActivity:(Activity *) child{
    
    NSUInteger position = [parent.activities indexOfObject:child];
    
    if (position == ([parent.activities count] -1)) {
        return nil;
    }else{
        return [parent.activities objectAtIndex:position+1];
    }
}

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

+ (NSArray *) validateWorkout:(Workout *)workout{
    
    NSMutableArray *invalidNodes = [[NSMutableArray alloc] init];
    
    for (Activity *activity in workout.activities) {
        [invalidNodes addObjectsFromArray:[self searchEmptyGroups:activity]];
    }
    
    return invalidNodes;
}

+ (Workout *) initWithWorkout:(Workout *)workout{
    
    Workout *newWorkout = [Workout workoutWithName:workout.name inMangedObjectContext:workout.managedObjectContext];
    
    NSDate *now = [NSDate date];
    workout.creationDate = now;
    workout.lastRun = now;
    
    //Copy its activities
    for(Activity *activity in workout.activities){
        [[activity class] initWithActivity:activity inParent:newWorkout];
    }
    
    return newWorkout;
    
}

# pragma mark WorkoutParentActions protocol methods

- (Activity *) nextLeafAfterActivity:(Activity *)child{
    
    //Check that the parent passed as paramenter is the real parent of the child activity
    id <WorkoutParentElementActions> parent = [Activity parent:child];
    
    
    if(child && ![parent isEqual:self]){
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Parent passed is not the parent of the child activity" userInfo:nil] raise];
    }
    
    if (!child) {
        
        Activity *firstActivity = [[self activities] firstObject];
        if([Activity isKindOfLeafEntity:firstActivity]){
            return firstActivity;
        }else{
            return [(id <WorkoutParentElementActions>)firstActivity nextLeafAfterActivity:nil];
        }
    
    }else{
        
        NSUInteger childIndex = [[parent activities] indexOfObject:child];
        
        if (childIndex != NSNotFound) {
            if(childIndex < ([[parent activities] count] -1)){
                
                Activity *nextLeaf = [parent activities][childIndex+1];
                
                if([Activity isKindOfLeafEntity:nextLeaf]){
                    return nextLeaf;
                }else{
                    return [(id <WorkoutParentElementActions>)nextLeaf nextLeafAfterActivity:nil];
                }
                
            }else{
                return nil;
            }
        }else{
            
            [[NSException exceptionWithName:NSGenericException reason:@"Invalid execution path" userInfo:nil] raise];
            
            return nil;
        }
        
    }

}


#pragma mark - Core Data one-to-many accessor method

- (void)addActivitiesObject:(Activity *)value{
    
    NSMutableOrderedSet *tmpOrderedSet = [self mutableOrderedSetValueForKey:WORKOUT_ACTIVITIES_KEY];
    [tmpOrderedSet addObject:value];
    
}

@end
