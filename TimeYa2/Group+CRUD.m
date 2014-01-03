//
//  Group+CRUD.m
//  TimeYa2
//
//  Created by PartyMan on 12/10/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "Group+CRUD.h"
#import "TimeYaConstants.h"
#import "Workout+CRUD.h"
#import "Activity+CRUD.h"

@implementation Group (CRUD)


+ (NSArray *) groupsInManagedObjectContext:(NSManagedObjectContext *) context error:(NSError **) error{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:GROUP_ENTITY_NAME];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:ACTIVITY_NAME_KEY ascending:YES]];
    
    return [context executeFetchRequest:request error:error];
    
}

+ (Group *) groupWithName:(NSString *)name inContext:(NSManagedObjectContext*) context{
    
    if(name.length == 0){
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Exercise name can't be empty" userInfo:nil] raise];
    }
    
    Group *group = [NSEntityDescription insertNewObjectForEntityForName:GROUP_ENTITY_NAME inManagedObjectContext:context];
    group.name = name;
    return group;
}


#pragma mark ActivityActions protocol methods

+ (Activity *) activity:(id <WorkoutParentElementActions>) parent nextActivity:(Activity *) child{
    
    NSUInteger position = [parent.activities indexOfObject:child];
    
    if (position == ([parent.activities count] -1)) {
        return nil;
    }else{
        return [parent.activities objectAtIndex:position+1];
    }
    
}

+ (Activity *) activityWithName:(NSString *)name inParent:(id <WorkoutParentElementActions>) parent{
    
    Group *group = [Group groupWithName:name inContext:parent.managedObjectContext];
    [parent addActivitiesObject:group];
    return group;
    
}

+ (Activity *) initWithActivity:(Activity *)activity inParent:(id<WorkoutParentElementActions>)parent{
    
    if([activity isKindOfClass:[Group class]]){
        
        Group *newGroup = nil;
        Group *group = (Group *)activity;
        
        newGroup = (Group*) [Group activityWithName:group.name inParent:parent];
        
        NSDictionary *attr = [[group entity] attributesByName];
        NSArray *attrKeys = [attr allKeys];
        
        for (NSString *attrKey in attrKeys) {
            [newGroup setValue:[group valueForKey:attrKey] forKey:attrKey];
        }
        
        for(Activity *activity in group.activities){
            [[activity class] initWithActivity:activity inParent:newGroup];
        }
        
        return newGroup;
        
    }else{
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Activity should be of type Group" userInfo:nil] raise];
        return nil;
    }
    
}

#pragma mark WorkoutParentElementActions methods

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
        Activity *nextActivty = nil;
        
        if (childIndex != NSNotFound) {
            if(childIndex < ([[parent activities] count] -1)){
                nextActivty = [parent activities][childIndex + 1];
            }else{
                nextActivty = [[parent activities] firstObject];
            }
            
            if([Activity isKindOfLeafEntity:nextActivty]){
                return nextActivty;
            }else{
                return [(id<WorkoutParentElementActions>)nextActivty nextLeafAfterActivity:nil];
            }
            
        }else{
            
            [[NSException exceptionWithName:NSGenericException reason:@"Invalid execution path" userInfo:nil] raise];
            
            return nil;
        }
        
    };
}

     
#pragma mark - Core Data one-to-many accessor method
     
- (void) addActivitiesObject:(Activity *)value{
    
    NSMutableOrderedSet *tmpOrderedSet = [self mutableOrderedSetValueForKey:GROUP_ACTIVITIES_KEY];
    [tmpOrderedSet addObject:value];
    
}
@end
