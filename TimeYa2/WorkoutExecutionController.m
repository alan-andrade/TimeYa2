//
//  WorkoutExecutionController.m
//  TimeYa2
//
//  Created by PartyMan on 1/4/14.
//  Copyright (c) 2014 PartyMan. All rights reserved.
//

#import "WorkoutExecutionController.h"
#import "WorkoutExecution+CRUD.h"
#import "ActivityExecution+CRUD.h"
#import "Exercise+CRUD.h"
#import "Group+CRUD.h"
#import "Activity+CRUD.h"
#import "TimeYaConstants.h"

@interface WorkoutExecutionController ()

@property (strong, nonatomic) WorkoutExecution *list;
@property (strong, nonatomic) NSArray *workoutActiveBranch;

@end

@implementation WorkoutExecutionController


- (WorkoutExecutionController *) initWithWorkout:(Workout *) workout{
    
    //Copy the workout
    Workout *workoutCopy = [Workout initWithWorkout:workout];
    
    self = [super initWithWorkout:workoutCopy];
    
    if (self) {
        id<WorkoutLeafElementActions> firstExercise = (id<WorkoutLeafElementActions> )[self.workout nextLeafAfterActivity:nil];
        
        if (firstExercise) { //Workout is not empty
            
            self.workoutActiveBranch =[firstExercise leafWourkoutTreeBranch];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processWorkoutBeat:) name:WORKOUT_PACER_NOTIFICATION object:nil];
        }
    }
    
    return self;
    
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) processWorkoutBeat:(NSNotification *) notification{
    
    
    //Increment elapsed time of all activities in the workoutActiveBranch
    for(id<WorkoutElementActions> element in self.workoutActiveBranch){
        id<WorkoutExecutionElementActions> executionElement = [element listNode];
        [executionElement incrementElapsedTime];
    }
    
    
    id<WorkoutElementActions> inactiveElement = nil;
    //Check if all the activitis in the workoutActiveBranch are still active
    for (id<WorkoutElementActions> element in self.workoutActiveBranch) {
        id<WorkoutExecutionElementActions> executionElement = [element listNode];
        
        if(![[executionElement active] boolValue]){
            inactiveElement = element;
            break;
        }
    }
    
    
    if(inactiveElement){
        
        //Reset elapsed time of the inactive element and its children in the leafWorkoutTreeBranch
        int inactiveElemntIndex = [self.workoutActiveBranch indexOfObject:inactiveElement];
        
        for (int i = inactiveElemntIndex; i < [self.workoutActiveBranch count]; i++) {
            id <WorkoutElementActions> element = [self.workoutActiveBranch objectAtIndex:i];
            id<WorkoutExecutionElementActions> executionElement = [element listNode];
            [executionElement resetElapsedTime];
        }

        
        
        //Ask the parent to given the next activity and its leafWorkoutTreeBranch
        if([inactiveElement conformsToProtocol:@protocol(ActivityActions)]){
            
            Activity *inactiveActivity = (Activity *)inactiveElement;
            id<WorkoutParentElementActions> parent = [Activity parent:inactiveActivity];
            id<WorkoutLeafElementActions> nextActivity = (id<WorkoutLeafElementActions>)[parent nextLeafAfterActivity:inactiveActivity];
            self.workoutActiveBranch = [nextActivity leafWourkoutTreeBranch];
            
        }else{
            [[NSException exceptionWithName:NSGenericException reason:@"Invalid Execution Path" userInfo:nil] raise];
        }
    }
    
    
}

- (void) setWorkoutActiveBranch:(NSArray *)workoutActiveBranch{

    if(_workoutActiveBranch){
        
        for(id<WorkoutElementActions> element in _workoutActiveBranch){
            id <WorkoutExecutionElementActions> listElement = [element listNode];
            [listElement setRunning:@NO];
        }
    }
    
    if (workoutActiveBranch) {
        
        _workoutActiveBranch = workoutActiveBranch;
        for(id<WorkoutElementActions> element in workoutActiveBranch){
            id <WorkoutExecutionElementActions> listElement = [element listNode];
            [listElement setRunning:@YES];
        }
    }else{
        //Workout finished
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (WorkoutExecution *) list{
    
    if(!_list){
        _list = [WorkoutExecution workoutExecutionWithWorkout:self.workout];
    }
    return _list;
    
}

- (ActivityExecution *) workoutListItem:(Activity*) activity{
    return [ActivityExecution activityExecutionWithActivity:activity];
}

@end
