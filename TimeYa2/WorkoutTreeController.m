//
//  WorkoutTreeController.m
//  TimeYa2
//
//  Created by PartyMan on 12/25/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "WorkoutTreeController.h"
#import "WorkoutTreeRoot+CRUD.h"
#import "WorkoutTreeNode+CRUD.h"
#import "Activity+CRUD.h"
#import "Group+CRUD.h"
#import "TimeYaConstants.h"
#import "DDLog.h"

static int ddLogLevel = APP_LOG_LEVEL;

@interface WorkoutTreeController ()

@property (nonatomic) NSUInteger position;
@property (readonly, nonatomic) NSInteger depth;
@property (strong, nonatomic) NSMutableArray *parentStack;
@property (strong, nonatomic) WorkoutTreeRoot *root;

@end

@implementation WorkoutTreeController

- (WorkoutTreeController *) initWithWorkout:(Workout *)workout{
    
    self = [super init];
    
    if (self) {
        
        self.parentStack = [[NSMutableArray alloc] init];
        self.root = [WorkoutTreeRoot workoutTreeRootWithWorkout:workout];
        [self populateTree];
        
    }
    
    return self;
}

- (void) populateTree{
    
    for (Activity* activity in self.root.workout.activities) {
        [self preOrder:activity];
    }
    
    [self resetInstanceVariables];
    
}


- (void) preOrder:(Activity *) activity{
        
    if([self isKindOfGroupEntity:activity]){
        
        [self createActivityTreeNode:activity];
        
        Group *group = (Group *)activity;
        
        [self.parentStack addObject:group];
        
        for (Activity *childActivity in group.activities) {
            [self preOrder:childActivity];
        }
        
        [self.parentStack removeLastObject];
        
    }else if([self isKindOfExerciseEntity:activity]){
        
        [self createActivityTreeNode:activity];
        
        return;
        
    }else{
        [[NSException exceptionWithName:NSGenericException reason:@"Invalid execution path" userInfo:nil] raise];
    }
}

- (void) createActivityTreeNode:(Activity *) activity{
    
    WorkoutTreeNode *treeNode = [WorkoutTreeNode workoutTreeNodeWithActivity:activity];
    
    [self isKindOfGroupEntity:activity] ? (treeNode.allowChildren = @YES) : (treeNode.allowChildren = @NO);
    
    treeNode.depth = [NSNumber numberWithInteger:self.depth];
    treeNode.position = [NSNumber numberWithInteger:self.position];
    treeNode.activity = activity;
    treeNode.root = self.root;
    
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

- (BOOL) deleteWorkoutTree{
    
    NSManagedObjectContext *context = self.root.managedObjectContext;
    
    [context deleteObject:self.root];
    
    NSError* error;
    BOOL deleted = [context save:&error];
    
    if (!deleted) {
        DDLogError(@"[%@ %@] [ERROR] Workout tree root could not be deleted. Workout tree ID: %@ Name: %@ Error: %@ User Info: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.root.objectID, self.root.workout.name, error, error.userInfo);
    }
    
    return deleted;
}

- (WorkoutTreeNode *) activityAtPosition:(NSUInteger)position error:(NSError**)error{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:WORKOUT_TREE_NODE_ENTITY_NAME];
    request.predicate = [NSPredicate predicateWithFormat:@"root == %@ AND position == %U", self.root, position];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:WORKOUT_TREE_NODE_POSITION ascending:YES]];
    //request.sortDescriptors = nil;
    
    NSManagedObjectContext *context = self.root.workout.managedObjectContext;
    
    WorkoutTreeNode *node = [[context executeFetchRequest:request error:error] lastObject];
    
    return node;
}

- (BOOL) deleteActivityAtPosition:(NSUInteger) position error: (NSError**) error{
    
    NSInteger preActivityCount = [self activityCount];
    WorkoutTreeNode *node = [self activityAtPosition:position error:error];
    
    if(node){
        Activity *nextNode = [self findNextActivity:node.activity];
        BOOL deleted =  [Activity deleteActivity:node.activity error:error];
        if(deleted){
            
            NSInteger postActivityCount = [self activityCount];
            NSUInteger activityCountDelta = preActivityCount - postActivityCount;
            
            if(nextNode) {
                [self recalibrateTreeNodePosition:nextNode withDelta:activityCountDelta];
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

- (void) recalibrateTreeNodePosition:(Activity *) activity withDelta:(NSUInteger) delta{
    
    
    if ([self isKindOfExerciseEntity:activity]) {
        NSUInteger position = [activity.activityNode.position unsignedIntegerValue];
        activity.activityNode.position = [NSNumber numberWithUnsignedInteger:(position - delta)];
        
    }else if([self isKindOfGroupEntity:activity]){
        self.position = [activity.activityNode.position unsignedIntegerValue] - delta;
        
        Group *group = (Group *)activity;
        
        for(Activity *activity in group.activities){
            [self preOrderPositionRecalibration:activity];
        }
    }else{
        [[NSException exceptionWithName:NSGenericException reason:@"Invalid execution path" userInfo:nil] raise];
    }
    
    [self resetInstanceVariables];
    
    
}

- (void) preOrderPositionRecalibration:(Activity *) activity{
    
    if([self isKindOfGroupEntity:activity]){
        
        activity.activityNode.position = [NSNumber numberWithUnsignedInteger:self.position];
        self.position++;
        
        Group *group = (Group *)activity;
        
        [self.parentStack addObject:group];
        
        for (Activity *childActivity in group.activities) {
            [self preOrder:childActivity];
        }
        
        [self.parentStack removeLastObject];
        
    }else if([self isKindOfExerciseEntity:activity]){
        
        activity.activityNode.position = [NSNumber numberWithUnsignedInteger:self.position];
        self.position++;
        
        return;
        
    }else{
        [[NSException exceptionWithName:NSGenericException reason:@"Invalid execution path" userInfo:nil] raise];
    }
}

- (NSInteger) activityCount{
    return [self.root.nodes count];
}

- (void) resetInstanceVariables{
    [self.parentStack removeAllObjects];
    self.position = 0;
}

#pragma mark Property accessors 

- (NSInteger) depth{
    return [self.parentStack count];
}


@end
