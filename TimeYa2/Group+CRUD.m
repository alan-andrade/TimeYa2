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

     
#pragma mark - Core Data one-to-many accessor method
     
- (void) addActivitiesObject:(Activity *)value{
    
    NSMutableOrderedSet *tmpOrderedSet = [self mutableOrderedSetValueForKey:GROUP_ACTIVITIES_KEY];
    [tmpOrderedSet addObject:value];
    
}
@end
