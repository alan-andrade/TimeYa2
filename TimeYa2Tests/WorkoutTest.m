//
//  WorkoutTest.m
//  TimeYa2
//
//  Created by PartyMan on 11/30/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "Workout+CRUD.h"
#import "CoreDataTest.h"
#import "TimeYaConstants.h"
#import "Exercise+CRUD.h"
#import "Group+CRUD.h"

@interface WorkoutTest : CoreDataTest

@property (strong, nonatomic) Workout *workout;

@end

@implementation WorkoutTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    self.workout = [Workout workoutWithName:@"Sally" inMangedObjectContext:self.delegate.managedObjectContext];

}

- (void)tearDown
{
    
    self.workout = nil;

    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void) testWorkoutIsCreated{
    
    //Verfify
    XCTAssertNotNil(self.workout, @"Workout shold've been created");
    XCTAssertEqualObjects(self.workout.name, @"Sally", @"Name should match");
    XCTAssertTrue([self.workout.creationDate timeIntervalSinceNow] < 0, @"Creation date shold be at an earlier time");
    XCTAssertEqualObjects(self.workout.creationDate, self.workout.lastRun, @"Creation and Last Run date should match after creation");
    
}

- (void) testWorkoutIsDeleted{
    
    NSError* error;
    
    //Exercise
    [Workout deleteWorkout:self.workout error:&error];
    
    //Verify
    NSArray *workouts = [Workout workoutsInManagedObjectContext:self.delegate.managedObjectContext error:&error];
    
    XCTAssertTrue([workouts count] == 0, @"There should be no workouts created");
    
}

- (void) testWorkoutIsUpdated{

    //Setup
    NSDate* lastRun = [NSDate date];
    NSDictionary *workoutProperties = @{
                                   WORKOUT_NAME_KEY:@"Betty",
                                   WORKOUT_LAST_RUN_KEY:lastRun
                                   };
    //Exercise
    [Workout updateWorkout:self.workout properties:workoutProperties];
    
    
    //Validate
    XCTAssertEqualObjects(self.workout.name, @"Betty", @"New workout name should be Betty");
    XCTAssertEqualObjects(self.workout.lastRun, lastRun, @"Date should've been udpated");
    
}

- (void) testInvalidaWorkoutOneLevel{
    
    //Setup
    [Exercise exerciseWithName:@"Ex1" inWorkout:self.workout];
    [Exercise exerciseWithName:@"Ex2" inWorkout:self.workout];
    Group *group1 = [Group groupWithName:@"Grp1" inWorkout:self.workout];
    
    //Exercise
    NSArray *invalidGroups = [Workout validateWorkout:self.workout];
    
    //Validate
    XCTAssertTrue([invalidGroups count] == 1, @"There is only one invalid group");
    XCTAssertEqual(invalidGroups[0], group1, @"Group1 is an invalid group");
    
}

- (void) testInvalidaWorkoutTwoLevels{
    
    //Setup
    Group *group1 = [Group groupWithName:@"G1L1" inWorkout:self.workout];
    Group *group2 = [Group groupWithName:@"G2L1" inWorkout:self.workout];
    Group *group3 = [Group groupWithName:@"G3L2" inGroup:group1];
    [Exercise exerciseWithName:@"Ex1" inGroup:group3];
    [Exercise exerciseWithName:@"Ex2" inGroup:group3];
    
    Group *group4 = [Group groupWithName:@"G4L2" inGroup:group2];
    
    //Exercise
    NSArray *invalidGroups = [Workout validateWorkout:self.workout];
    
    //Validate
    XCTAssertTrue([invalidGroups count] == 1, @"There is only one invalid group");
    XCTAssertEqual(invalidGroups[0], group4, @"Group4 is an invalid group");
}



@end
