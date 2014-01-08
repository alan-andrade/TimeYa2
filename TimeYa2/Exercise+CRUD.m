//
//  Exercise+CRUD.m
//  TimeYa2
//
//  Created by PartyMan on 12/10/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "Exercise+CRUD.h"
#import "TimeYaConstants.h"
#import "Workout+CRUD.h"
#import "Group+CRUD.h"
#import "Activity+CRUD.h"

@implementation Exercise (CRUD)


+ (NSArray *) exercisesInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:EXERCISE_ENTITY_NAME];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:ACTIVITY_NAME_KEY ascending:YES]];
    
    return [context executeFetchRequest:request error:error];
}

#pragma mark ActivityActions protocol methods

+ (Activity *) activity:(id <WorkoutParentElementActions>) parent nextActivity:(Activity *) child{
    
    return nil;
}

+ (Activity *) activityWithName:(NSString *)name inParent:(id<WorkoutParentElementActions>)parent{
    
    Exercise *exercise = [Exercise exerciseWithName:name inContext:parent.managedObjectContext];
    [parent addActivitiesObject:exercise];
    return exercise;
    
}

+ (Activity *) updateActivity:(Activity *) activity withValues:(NSDictionary *) values{
    
    Exercise* exercise;
    
    if([activity isKindOfClass:[Exercise class]]){
        exercise = (Exercise *)activity;
        
        values = [Exercise cleanUpUpdateValues:values];
        
        NSDictionary *exerciseAttr = [[NSEntityDescription entityForName:EXERCISE_ENTITY_NAME inManagedObjectContext:activity.managedObjectContext] attributesByName];
        NSArray *exerciseAttrKeys = [exerciseAttr allKeys];
        
        NSArray *keys = [values allKeys];
        for(NSString* key in keys){
            
            if([exerciseAttrKeys containsObject:key]){
                [exercise setValue:values[key] forKey:key];
            }
        }
    }
    
    return exercise;
    
}

+ (NSArray *) validateActivity:(Activity *) activity{
    
    NSMutableArray *errors;
    
    if([activity isKindOfClass:[Exercise class]]){
        
        Exercise *exercise = (Exercise*) activity;
        
        errors = [[NSMutableArray alloc] init];
        
        //Validate all units have a type
        if(exercise.distance.intValue != 0 && exercise.distanceUnit.intValue == 0){
            [errors addObject:NSLocalizedString(EXERCISE_DISTANCE_MISSING_UNIT_ERROR, nil)];
        }
        
        if(exercise.time.intValue != 0 && exercise.timeUnit.intValue == 0) {
            [errors addObject:NSLocalizedString(EXERCISE_TIME_MISSING_UNIT_ERROR, nil)];
        }
        
        if(exercise.weight.intValue != 0 && exercise.weightUnit.intValue == 0){
            [errors addObject:NSLocalizedString(EXERCISE_WEIGHT_MISSING_UNIT_ERROR, nil)];
        }
        
        if(exercise.setRestTime.intValue != 0 && exercise.setRestTimeUnit == 0){
            [errors addObject:NSLocalizedString(EXERCISE_SET_REST_TIME_MISSING_UNIT_ERROR, nil)];
        }
        
        //Validate Weight is not the only attribute defined
        if (exercise.weight.intValue != 0 && (exercise.reps.intValue == 0 && exercise.time.intValue == 0 && exercise.distance.intValue == 0)) {
            [errors addObject:NSLocalizedString(EXERCISE_WEIGHT_UNIQUE_ATTR_ERROR, nil)];
        }
        
        //Validate Reps if Sets is defined
        if(exercise.sets.intValue != 0 && exercise.reps.intValue == 0){
            [errors addObject:NSLocalizedString(EXERCISE_SETS_REPS_ATTR_ERROR, nil)];
        }
        
    }
    
    return errors;
}

+ (Activity *) initWithActivity:(Activity *)activity inParent:(id <WorkoutParentElementActions>) parent{
    
    if([activity isKindOfClass:[Exercise class]]){
        Exercise *newExercise = nil;
        Exercise *exercise = (Exercise *)activity;
        
        newExercise = (Exercise *) [Exercise activityWithName:activity.name inParent:parent];
        
        
        NSDictionary *attr= [[exercise entity] attributesByName];
        NSArray *attrKeys = [attr allKeys];
        
        for (NSString *attrKey in attrKeys) {
            [newExercise setValue:[exercise valueForKey:attrKey]  forKey:attrKey];
        }
        
        return newExercise;
        
    }else{
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Activity should be of type Exercise" userInfo:nil] raise];
        return nil;
    }
    
}

#pragma mark WorkoutChildElementActions methods

- (NSArray *) leafWourkoutTreeBranch{
    
    NSMutableArray *branchElements = [[NSMutableArray alloc] init];
    
    [branchElements insertObject:self atIndex:0];
    
    id<WorkoutParentElementActions> parent = [Activity parent:self];
    
    [self populuateLeafWorkoutBranch:parent elements:branchElements];
    
    return branchElements;
}

- (void) populuateLeafWorkoutBranch:(id<WorkoutParentElementActions>) parent elements:(NSMutableArray*) elements{
    
    [elements insertObject:parent atIndex:0];
    
    if([Workout isKindOfWorkoutEntity:parent]){
        return;
    }else{
        [self populuateLeafWorkoutBranch:[Activity parent:(Activity *)parent] elements:elements];
    }
    
}



#pragma mark Helper methods

+ (Exercise *) exerciseWithName:(NSString *)name inContext:(NSManagedObjectContext *)context{
    
    if(name.length == 0){
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Exercise name can't be empty" userInfo:nil] raise];
    }
    
    Exercise *exercise = [NSEntityDescription insertNewObjectForEntityForName:EXERCISE_ENTITY_NAME inManagedObjectContext:context];
    exercise.name = name;
    return exercise;
    
}

+ (NSDictionary *) cleanUpUpdateValues:(NSDictionary *) values{
    
    NSMutableDictionary *mutableValues = [values mutableCopy];
    
    //Sets == 0
    if ([mutableValues[EXERCISE_SETS_KEY] intValue] == 0) {
        [mutableValues removeObjectForKey:EXERCISE_SET_REST_TIME_KEY];
        [mutableValues removeObjectForKey:EXERCISE_SET_REST_TIME_UNIT_KEY];
    }
    
    //Set Rest Time == 0
    if([mutableValues[EXERCISE_SET_REST_TIME_KEY] intValue] == 0){
        [mutableValues removeObjectForKey:EXERCISE_SET_REST_TIME_UNIT_KEY];
    }
    
    //Time == 0
    if([mutableValues[EXERCISE_TIME_KEY] intValue] == 0){
        [mutableValues removeObjectForKey:EXERCISE_TIME_UNIT_KEY];
    }
    
    //Weight == 0
    if([mutableValues[EXERCISE_WEIGHT_KEY] intValue] == 0){
        [mutableValues removeObjectForKey:EXERCISE_WEIGHT_UNIT_KEY];
    }
    
    //Distance == 0
    if([mutableValues[EXERCISE_DISTANCE_KEY] intValue] == 0){
        [mutableValues removeObjectForKey:EXERCISE_DISTANCE_UNIT_KEY];
    }
    
    return mutableValues;
    
}


@end
