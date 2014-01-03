//
//  Activity+CRUD.m
//  TimeYa2
//
//  Created by PartyMan on 12/4/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "Activity+CRUD.h"
#import "TimeYaConstants.h"
#import "DDLog.h"

static int ddLogLevel = APP_LOG_LEVEL;

@implementation Activity (CRUD)

+ (NSArray *) activitiesInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:ACTIVITY_ENTITY_NAME];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:ACTIVITY_WORKOUT ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:ACTIVITY_NAME_KEY ascending:YES]];
    
    return [context executeFetchRequest:request error:error];
}


+ (BOOL) deleteActivity:(Activity *) activity error:(NSError **)error{
   
    NSManagedObjectContext *context = activity.managedObjectContext;
    
    [context deleteObject:activity];
    
    BOOL deleted = [context save:error];
    
    if (!deleted) {
        DDLogError(@"[%@ %@] [ERROR] Activity could not be deleted. Activity ID: %@ Name: %@ Error: %@ User Info: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), activity.objectID, activity.name, *error, ((NSError *)*error).userInfo);
    }
    
    return deleted;
}

+ (id<WorkoutParentElementActions>) parent:(Activity *)activity{
    
    id<WorkoutParentElementActions> parent = nil;
    
    if (activity.workout != nil) {
        parent = (id<WorkoutParentElementActions>)  activity.workout;
    }else{
        parent = (id<WorkoutParentElementActions>) activity.group;
    }
    
    return parent;
}

+ (BOOL) isKindOfParentEntity:(Activity *) activity{
 
    return [activity conformsToProtocol:@protocol(WorkoutParentElementActions)];
}

+ (BOOL) isKindOfLeafEntity:(Activity *) activity{

    return [activity conformsToProtocol:@protocol(WorkoutLeafElementActions)];
}

#pragma mark ActivityActions protocol methods

+ (Activity *) activity:(id <WorkoutParentElementActions>) parent nextActivity:(Activity *) child{
    
    [[NSException exceptionWithName:NSGenericException reason:@"This is an abstract method that should not be called" userInfo:nil] raise];
    
    return nil;
}

+ (Activity *) activityWithName:(NSString *)name inParent:(id<WorkoutParentElementActions>)parent{
    
    [[NSException exceptionWithName:NSGenericException reason:@"This is an abstract method that should not be called" userInfo:nil] raise];
    
    return nil;
}

+ (Activity *) initWithActivity:(Activity *)activity inParent:(id <WorkoutParentElementActions>) parent{
    
    [[NSException exceptionWithName:NSGenericException reason:@"This is an abstract method that should not be called" userInfo:nil] raise];
    
    return nil;
}

+ (Activity *) updateActivity:(Activity *) activity withValues:(NSDictionary *) values{
    
    return [[activity class] updateActivity:activity withValues:values];
}

+ (NSArray *) validateActivity:(Activity *) activity{
    
    return [[activity class] validateActivity:activity];
}




@end
