//
//  WorkoutListController.m
//  TimeYa2
//
//  Created by PartyMan on 12/25/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "WorkoutListController.h"
#import "WorkoutList+CRUD.h"
#import "WorkoutListActivity+CRUD.h"
#import "Activity+CRUD.h"
#import "Group+CRUD.h"
#import "TimeYaConstants.h"
#import "WorkoutParentElementActions.h"
#import "WorkoutChildElementActions.h"

@interface WorkoutListController ()

@property (nonatomic) NSUInteger position;
@property (readonly, nonatomic) NSUInteger depth;
@property (strong, nonatomic) NSMutableArray *parentStack;
@property (strong, nonatomic) WorkoutList *list;

@end

@implementation WorkoutListController

- (WorkoutListController *) initWithWorkout:(Workout *)workout{
    
    self = [super init];
    
    if (self) {
        
        self.parentStack = [[NSMutableArray alloc] init];
        self.list = [WorkoutList workoutListWithWorkout:workout];
        [self populateWorkoutList];
        
    }
    
    return self;
}

- (void) populateWorkoutList{
    
    for (Activity* activity in self.list.workout.activities) {
        [self preOrder:activity];
    }
    
    [self resetInstanceVariables];
    
}


- (void) preOrder:(Activity *) activity{
        
    if([self isKindOfGroupEntity:activity]){
        
        [self createWorkoutListItem:activity];
        
        Group *group = (Group *)activity;
        
        [self.parentStack addObject:group];
        
        for (Activity *childActivity in group.activities) {
            [self preOrder:childActivity];
        }
        
        [self.parentStack removeLastObject];
        
    }else if([self isKindOfExerciseEntity:activity]){
        
        [self createWorkoutListItem:activity];
        
        return;
        
    }else{
        [[NSException exceptionWithName:NSGenericException reason:@"Invalid execution path" userInfo:nil] raise];
    }
}

- (void) createWorkoutListItem:(Activity *) activity{
    
    WorkoutListActivity *listItem = [WorkoutListActivity workoutListActivityWithActivity:activity];
    
    [self isKindOfGroupEntity:activity] ? (listItem.allowChildren = @YES) : (listItem.allowChildren = @NO);
    
    listItem.depth = [NSNumber numberWithInteger:self.depth];
    listItem.position = [NSNumber numberWithInteger:self.position];
    listItem.activity = activity;
    listItem.list = self.list;
    
    self.position++;
    
}

- (BOOL) isKindOfGroupEntity:(Activity *) activity{
    NSEntityDescription *groupEntity = [NSEntityDescription entityForName:GROUP_ENTITY_NAME inManagedObjectContext:activity.managedObjectContext];
    return [[activity entity] isKindOfEntity:groupEntity];
}

- (BOOL) isKindOfExerciseEntity:(Activity *) activity{
    NSEntityDescription *exerciseEntity = [NSEntityDescription entityForName:EXERCISE_ENTITY_NAME inManagedObjectContext:activity.managedObjectContext];
    return [[activity entity] isKindOfEntity:exerciseEntity];
}

- (BOOL) iskindOfWorkoutEntity:(NSManagedObject *) entity{
    NSEntityDescription *workoutEntity = [NSEntityDescription entityForName:WORKOUT_ENTITY_NAME inManagedObjectContext:entity.managedObjectContext];
    return [[entity entity] isKindOfEntity:workoutEntity];
}

//- (BOOL) deleteWorkoutTree{
//    
//    NSManagedObjectContext *context = self.root.managedObjectContext;
//    
//    [context deleteObject:self.root];
//    
//    NSError* error;
//    BOOL deleted = [context save:&error];
//    
//    if (!deleted) {
//        DDLogError(@"[%@ %@] [ERROR] Workout tree root could not be deleted. Workout tree ID: %@ Name: %@ Error: %@ User Info: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.root.objectID, self.root.workout.name, error, error.userInfo);
//    }
//    
//    return deleted;
//}

- (WorkoutListActivity *) activityAtPosition:(NSUInteger)position error:(NSError**)error{
    
    if(position >= [self activityCount]){
        
        *error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSNotFound userInfo:nil];
        
        return nil;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:WORKOUT_LIST_ACTIVITY_ENTITY_NAME];
    request.predicate = [NSPredicate predicateWithFormat:@"list == %@ AND position == %U", self.list, position];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:WORKOUT_LIST_ACTIVITY_POSITION ascending:YES]];
    
    NSManagedObjectContext *context = self.list.workout.managedObjectContext;
    
    WorkoutListActivity *listItem = [[context executeFetchRequest:request error:error] lastObject];
    
    return listItem;
}

- (BOOL) deleteActivityAtPosition:(NSUInteger) position error: (NSError**) error{
    
    NSInteger preActivityCount = [self activityCount];
    WorkoutListActivity *listItem = [self activityAtPosition:position error:error];
    
    if(listItem){
        Activity *nextActivity= [self findNextActivity:listItem.activity];
        BOOL deleted =  [Activity deleteActivity:listItem.activity error:error];
        if(deleted){
            
            NSInteger postActivityCount = [self activityCount];
            NSUInteger activityCountDelta = postActivityCount - preActivityCount;
            
            if(nextActivity) {
                [self recalibrateWorkoutListActivityPositions:nextActivity withDelta:activityCountDelta error:error];
            }
            
            return YES;
            
        }else{
            return NO;;
        }
        
    }else{
        return NO;
    }
    
}

- (Activity *) findNextActivity:(Activity *) child{
    
    Activity *nextActivity = nil;
    
    NSManagedObject *parent = [Activity parent:child];
    
    //Only workout and group entities could be parents
    if ([self iskindOfWorkoutEntity:parent]) {
        nextActivity = [Workout activity:(Workout *)parent nextActivity:child];
        
        if (nextActivity) {
            return nextActivity;
        }else{
            //Last activity in the workout
            return nil;
        }
    }else{
        nextActivity = [Group activity:(Group *)parent nextActivity:child];
        
        if(nextActivity){
            return nextActivity;
        }else{
            //Last activity in the group. Search again in the parent of the parent
            return [self findNextActivity:(Group *)parent];
        }
    }
}

- (BOOL) recalibrateWorkoutListActivityPositions:(Activity *) activity withDelta:(NSInteger) delta error:(NSError **) error{
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:WORKOUT_LIST_ACTIVITY_ENTITY_NAME];
    request.predicate = [NSPredicate predicateWithFormat:@"list == %@ AND position >= %@", activity.activityNode.list, activity.activityNode.position];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:WORKOUT_LIST_ACTIVITY_POSITION ascending:YES]];
    
    NSManagedObjectContext *context = activity.managedObjectContext;
    
    NSArray *listItems = [context executeFetchRequest:request error:error];
    
    if (listItems) {
        
        self.position = [activity.activityNode.position integerValue] + delta;
        
        for (WorkoutListActivity *listItem in listItems) {
            listItem.position = [NSNumber numberWithUnsignedInteger:self.position];
            self.position++;
        }
        
        [self resetInstanceVariables];
        
        return YES;
        
    }else{
        return NO;;
    }
}

- (WorkoutListActivity *) insertActivityAtPosition:(NSInteger) position ofType:(Class) type withName:(NSString *) name error:(NSError **) error {
    
    if (![type conformsToProtocol:@protocol(ActivityActions)]) {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Type parameter must conform to Activity Actions Protocol" userInfo:nil] raise];
    }
    
    Class <ActivityActions> activityClass = type;
    Activity *activity;
    id <WorkoutParentElementActions> parent;
    BOOL listActivityAllowChildren;
    NSUInteger listActivityPosition, listActivityDepth;
    
    
    //The parent is the workout
    if (position < 0) {
        
        parent = self.list.workout;
        listActivityDepth = 0;
        listActivityPosition = [self activityCount];
        
    }else{ //The parent is the activity at the specified position
        
        WorkoutListActivity *parentListItem =[self activityAtPosition:position error:error];
        
        if (parentListItem) {
            
            if (![parentListItem.activity conformsToProtocol:@protocol(WorkoutParentElementActions)]) {
                [[NSException exceptionWithName:NSGenericException reason:@"Activity at indicated position can't hold child activities" userInfo:nil] raise];
            }
            
            parent = (id <WorkoutParentElementActions>) parentListItem.activity;
            listActivityDepth = [parentListItem.depth integerValue] + 1;
            listActivityPosition = [[[[[parent activities] lastObject] activityNode] position] integerValue] + 1;
            
        }else{
            return nil;
        }
        
    }
    
    activity = [activityClass activityWithName:name inParent:parent];
    
    Activity *nextActivity= [self findNextActivity:activity];
    
    if(nextActivity){
        
        BOOL recalibrated = [self recalibrateWorkoutListActivityPositions:nextActivity withDelta:1 error:error];
        
        if(!recalibrated){
            return nil;
        }
        
    }
    
    
    listActivityAllowChildren = [activity conformsToProtocol:@protocol(WorkoutChildElementActions)] ? NO : YES;
    
    WorkoutListActivity* listActivity = [WorkoutListActivity workoutListActivityWithActivity:activity];
    listActivity.allowChildren = [NSNumber numberWithBool:listActivityAllowChildren];
    listActivity.position = [NSNumber numberWithUnsignedInteger:listActivityPosition];
    listActivity.depth = [NSNumber numberWithUnsignedInteger:listActivityDepth];
    listActivity.list = self.list;
    
    return listActivity;
    
}

- (NSInteger) activityCount{
    return [self.list.items count];
}

- (void) resetInstanceVariables{
    [self.parentStack removeAllObjects];
    self.position = 0;
}

#pragma mark Property accessors 

- (NSUInteger) depth{
    return [self.parentStack count];
}


@end
