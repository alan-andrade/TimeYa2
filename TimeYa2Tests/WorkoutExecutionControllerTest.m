//
//  WorkoutExecutionControllerTest.m
//  TimeYa2
//
//  Created by PartyMan on 1/3/14.
//  Copyright (c) 2014 PartyMan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CoreDataTest.h"
#import "WorkoutExecutionController.h"
#import "WorkoutExecutionControllerMock.h"
#import "Group+CRUD.h"
#import "Exercise+CRUD.h"
#import "Activity+CRUD.h"
#import "WorkoutExecution+CRUD.h"
#import "ActivityExecution+CRUD.h"
#import "OCMock.h"
#import "TimeYaConstants.h"

@interface WorkoutExecutionControllerTest : CoreDataTest

@property (strong, nonatomic) Workout *workout;
@property (strong, nonatomic) WorkoutExecutionControllerMock *executionController;

@end

@implementation WorkoutExecutionControllerTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void) simpleWorkout{
    
    self.workout = [Workout workoutWithName:@"SimpleWorkout" inMangedObjectContext:self.delegate.managedObjectContext];
    Exercise *ex1 = (Exercise *)[Exercise activityWithName:@"Ex1" inParent:self.workout];
    ex1.time = @2;
    Exercise *ex2 = (Exercise *)[Exercise activityWithName:@"Ex2" inParent:self.workout];
    ex2.time = @2;
    Exercise *ex3 = (Exercise *)[Exercise activityWithName:@"Ex3" inParent:self.workout];
    ex3.time = @2;
    
}

- (void) advancedWorkout{
    
    self.workout = [Workout workoutWithName:@"AdvancedWorkout" inMangedObjectContext:self.delegate.managedObjectContext];
    
    Group *warmUp = (Group *) [Group activityWithName:@"WarmUp" inParent:self.workout];
    
    Group *lowerWarmUp = (Group *) [Group activityWithName:@"LowerWarmUp" inParent:warmUp];
    [Exercise activityWithName:@"Quads Stretch" inParent:lowerWarmUp];
    [Exercise activityWithName:@"Hams Stretch" inParent:lowerWarmUp];
    [Exercise activityWithName:@"Calves Stretch" inParent:lowerWarmUp];
    
    Group *upperWarmUp = (Group *) [Group activityWithName:@"UpperWarmUp" inParent:warmUp];
    [Exercise activityWithName:@"Chest Stretch" inParent:upperWarmUp];
    [Exercise activityWithName:@"Shoulder Stretch" inParent:upperWarmUp];
    [Exercise activityWithName:@"Arms Stretch" inParent:upperWarmUp];
    
    [Exercise activityWithName:@"Rest" inParent:self.workout];
    
    Group *main = (Group *) [Group activityWithName:@"Main" inParent:self.workout];
    
    Group *lowerBody = (Group *) [Group activityWithName:@"LowerBody" inParent:main];
    [Exercise activityWithName:@"Deep Squat" inParent:lowerBody];
    [Exercise activityWithName:@"Lunges" inParent:lowerBody];
    [Exercise activityWithName:@"One Leg Squat" inParent:lowerBody];
    
    Group *upperBody = (Group *) [Group activityWithName:@"UpperBody" inParent:main];
    [Exercise activityWithName:@"Bench Press" inParent:upperBody];
    [Exercise activityWithName:@"Shoulder Press" inParent:upperBody];
    [Exercise activityWithName:@"Row" inParent:upperBody];
    
    [Exercise activityWithName:@"Rest" inParent:self.workout];
    
    Group *coolDown = (Group *)[Group activityWithName:@"CoolDown" inParent:self.workout];
    
    [Exercise activityWithName:@"Leg Stretch" inParent:coolDown];
    [Exercise activityWithName:@"Back Stretch" inParent:coolDown];
    [Exercise activityWithName:@"Arm Strech" inParent:coolDown];
    
    
    
}

- (void) testWorkoutExecutionControllerWithAdvanceWorkout{
    
    //Validate
    NSError *error;
    NSArray *workoutLists = [WorkoutExecution workoutExecutionsInManagedObjectContext:self.workout.managedObjectContext error:&error];
    NSArray *workouts = [Workout workoutsInManagedObjectContext:self.workout.managedObjectContext error:&error];
    NSArray *activities = [Activity activitiesInManagedObjectContext:self.workout.managedObjectContext error:&error];
    
    XCTAssertNil(error, @"Verify there is no error");
    XCTAssertTrue([workoutLists count] == 0, @"No workout lists created yet");
    XCTAssertTrue([workouts count] == 0, @"No workouts created yet");
    XCTAssertTrue([activities count] == 0, @"No activities created yet");
    
    //Setup
    [self advancedWorkout];
    
    //Exercise
    self.executionController = [[WorkoutExecutionControllerMock alloc] initWithWorkout:self.workout];
    
    //Validate
    workoutLists = [WorkoutExecution workoutExecutionsInManagedObjectContext:self.workout.managedObjectContext error:&error];
    workouts = [Workout workoutsInManagedObjectContext:self.workout.managedObjectContext error:&error];
    activities = [Activity activitiesInManagedObjectContext:self.workout.managedObjectContext error:&error];
    
    XCTAssertTrue([workoutLists count] == 1, @"One list should've been created");
    XCTAssertTrue([workouts count] == 2, @"There should be two workouts created. One is the orginal workout and the other is the copy created when the WorkoutListRun was instantiated");
    XCTAssertTrue([activities count] == 48, @"There should 24 be activities created. 24 are from the original workout and the other 20 are a copy of the workout created when the WorkoutListRun was instantiated");
    
}

- (void) testDesignateInitializerWithEmptyWorkout{
    
    //Setup
    self.workout = [Workout workoutWithName:@"Empty" inMangedObjectContext:self.delegate.managedObjectContext];
    id mock = [OCMockObject partialMockForObject:self.executionController];
    
    //Exercise
    self.executionController = [[WorkoutExecutionControllerMock alloc] initWithWorkout:self.workout];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WORKOUT_PACER_NOTIFICATION object:self];
    
    //Validate
    XCTAssertNil([self.executionController valueForKey:@"workoutActiveBranch"],  @"There should not be an active branch because the workout is empty");
    [mock verify];
    
}

- (void) testDesignatedInitializerWithSimpleWorkout{
    
    //Setup
    [self simpleWorkout];
    
    //Exercise
    self.executionController = [[WorkoutExecutionControllerMock alloc] initWithWorkout:self.workout];
    
    //Validate
    XCTAssertNotNil(self.executionController.workoutActiveBranch, @"Should have values since the workout is not empty");
    XCTAssertTrue([self.executionController.workoutActiveBranch count] == 2, @"The workout active branch should contain the workout and ex1 nodes");
}

- (void) testDesignatedInitializerRegisterForNotifications{
    
    //Setup
    [self simpleWorkout];
    
    //Exercise
    self.executionController = [[WorkoutExecutionControllerMock alloc] initWithWorkout:self.workout];
    id mock = [OCMockObject partialMockForObject:self.executionController];
    [[mock expect] processWorkoutBeat:[OCMArg any]];
    [[NSNotificationCenter defaultCenter] postNotificationName:WORKOUT_PACER_NOTIFICATION object:self];
    
    //Validate
    [mock verify];
}

- (void) testNotificationsAreProcessed{
    
    [self simpleWorkout];
    self.executionController = [[WorkoutExecutionControllerMock alloc] initWithWorkout:self.workout];
    
    //Exercise
    [[NSNotificationCenter defaultCenter] postNotificationName:WORKOUT_PACER_NOTIFICATION object:self];
    //Validate
    XCTAssertEqualObjects([[self.executionController.workoutActiveBranch lastObject] name], @"Ex1", @"Ex1 should be active");
    ActivityExecution *activityExecution1 = (ActivityExecution *)[[self.executionController.workoutActiveBranch lastObject] listNode];
    XCTAssertEqualObjects(activityExecution1.elapsedTime, @1, @"One second elapsed");
    XCTAssertTrue([activityExecution1.active boolValue], @"Should be active");
    
    //Exercise
    [[NSNotificationCenter defaultCenter] postNotificationName:WORKOUT_PACER_NOTIFICATION object:self];
    //Validate
    XCTAssertEqualObjects([[self.executionController.workoutActiveBranch lastObject] name], @"Ex2", @"Ex2 should be active after 2 seconds elapsed");
    ActivityExecution *activityExecution2 = (ActivityExecution *)[[self.executionController.workoutActiveBranch lastObject] listNode];
    XCTAssertEqualObjects(activityExecution2.elapsedTime, @0, @"Ex2 has been executed for Zero seconds at this point");
    XCTAssertTrue([activityExecution2.active boolValue], @"Should be active");
    
    XCTAssertFalse([activityExecution1.active boolValue], @"Ex1 should not be active any more");
    XCTAssertEqualObjects(activityExecution1.elapsedTime, @0, @"Ex1 elapsed time should've been reset back to zero");
    
    
}

- (void) testIncrementActivityElapsedTimeWhenProcessingPaceBeat{
    
    [self simpleWorkout];
    self.executionController = [[WorkoutExecutionControllerMock alloc] initWithWorkout:self.workout];
    
    //Validate
    XCTAssertEqualObjects([[self.executionController.workoutActiveBranch lastObject] name], @"Ex1", @"Ex1 should be active");
    ActivityExecution *activityExecution1 = (ActivityExecution *)[[self.executionController.workoutActiveBranch lastObject] listNode];
    XCTAssertTrue([activityExecution1.active boolValue], @"Should be active");
    XCTAssertEqualObjects(activityExecution1.elapsedTime, @0, @"Zero seconds elapsed");
    
    //Exercise
    [[NSNotificationCenter defaultCenter] postNotificationName:WORKOUT_PACER_NOTIFICATION object:self];
    
    //Validate
    XCTAssertEqualObjects(activityExecution1.elapsedTime, @1, @"One second elapsed");
    XCTAssertTrue([activityExecution1.active boolValue], @"Should be active");
    
}

@end
