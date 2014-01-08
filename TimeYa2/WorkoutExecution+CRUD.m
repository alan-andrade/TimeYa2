//
//  WorkoutExecution+CRUD.m
//  TimeYa2
//
//  Created by PartyMan on 1/4/14.
//  Copyright (c) 2014 PartyMan. All rights reserved.
//

#import "WorkoutExecution+CRUD.h"
#import "TimeYaConstants.h"
#import "Workout+CRUD.h"

@implementation WorkoutExecution (CRUD)

+ (WorkoutExecution *) workoutExecutionWithWorkout:(Workout *) workout{
    
    WorkoutExecution *workoutExecution = nil;
    
    workoutExecution = [NSEntityDescription insertNewObjectForEntityForName:WORKOUT_EXECUTION_ENTITY_NAME inManagedObjectContext:workout.managedObjectContext];
    
    workoutExecution.workout = workout;
    
    return workoutExecution;
}

+ (NSArray *) workoutExecutionsInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:WORKOUT_EXECUTION_ENTITY_NAME];
    request.predicate = nil;
    request.sortDescriptors = nil;
    
    return [context executeFetchRequest:request error:error];
    
}

- (NSNumber *) active{
    
    if(![self.running boolValue]){
        [self setPrimitiveValue:@YES forKey:WORKOUT_EXECUTION_ACTIVE];
        return @NO;
    }else{
        [self setPrimitiveValue:@YES forKey:WORKOUT_EXECUTION_ACTIVE];
        return @YES;
    }
}

- (void) incrementElapsedTime{
    
    double activeTime = [self.activeTime doubleValue];
    self.activeTime = [NSNumber numberWithDouble:(activeTime + WORKOUT_PACER_INTERVAL)];
    
}

- (void) resetElapsedTime{
    
    self.activeTime = @0;
}

@end
