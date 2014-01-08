//
//  ActivityExecution+CRUD.m
//  TimeYa2
//
//  Created by PartyMan on 1/4/14.
//  Copyright (c) 2014 PartyMan. All rights reserved.
//

#import "ActivityExecution+CRUD.h"
#import "TimeYaConstants.h"
#import "Activity+CRUD.h"
#import "ActivityExecutionActions.h"

@implementation ActivityExecution (CRUD)

+ (ActivityExecution *) activityExecutionWithActivity:(Activity *) activity{
    
    ActivityExecution *activityExecution = nil;
    
    activityExecution = [NSEntityDescription insertNewObjectForEntityForName:ACTIVITY_EXECUTION_ENTITY_NAME inManagedObjectContext:activity.managedObjectContext];
    
    activityExecution.activity = activity;
    
    return activityExecution;
    
}

+ (NSArray *) workoutListActivityRunsInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:ACTIVITY_EXECUTION_ENTITY_NAME];
    request.predicate = nil;
    request.sortDescriptors = nil;
    
    return [context executeFetchRequest:request error:error];
    
}

#pragma mark - Property Accessors

- (NSNumber *) active{
    
    if(![self.running boolValue]){
        return @NO;
    }else{
        
        if ([self.activity conformsToProtocol:@protocol(ActivityExecutionActions)]) {
            
            id<ActivityExecutionActions> activity = (id<ActivityExecutionActions>)self.activity;
            
            //Check if the activity has time constraints
            if ([activity.time doubleValue] > 0) {
                
                int stillActive = [activity.time doubleValue] - [self.elapsedTime doubleValue];
                
                if (stillActive > 0) {
                    [self setPrimitiveValue:@YES forKey:ACTIVITY_EXECUTION_ACTIVE];
                    return @YES;
                }else{
                    [self setPrimitiveValue:@NO forKey:ACTIVITY_EXECUTION_ACTIVE];
                    return @NO;
                }
            }else{ 
                [self setPrimitiveValue:@YES forKey:ACTIVITY_EXECUTION_ACTIVE];
                return @YES;
            }
            
        }else{
            //Still don't know what to do here
            return nil;
        }
        
    }
    
}

- (void) incrementElapsedTime{
    
    double elapsedTime = [self.elapsedTime doubleValue];
    self.elapsedTime = [NSNumber numberWithDouble:(elapsedTime + WORKOUT_PACER_INTERVAL)];
    
}

- (void) resetElapsedTime{
    self.elapsedTime = @0;
}

@end
