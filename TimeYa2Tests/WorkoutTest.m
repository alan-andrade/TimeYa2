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
#import "Activity+CRUD.h"

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
    [Exercise activityWithName:@"Ex1" inWorkout:self.workout];
    [Exercise activityWithName:@"Ex2" inWorkout:self.workout];
    Group *group1 = (Group *)[Group activityWithName:@"Grp1" inWorkout:self.workout];
    
    //Exercise
    NSArray *invalidGroups = [Workout validateWorkout:self.workout];
    
    //Validate
    XCTAssertTrue([invalidGroups count] == 1, @"There is only one invalid group");
    XCTAssertEqual(invalidGroups[0], group1, @"Group1 is an invalid group");
    
}

- (void) testInvalidaWorkoutTwoLevels{
    
    //Setup
    Group *group1 = (Group *)[Group activityWithName:@"G1L1" inWorkout:self.workout];
    Group *group2 = (Group *)[Group activityWithName:@"G2L1" inWorkout:self.workout];
    Group *group3 = (Group *)[Group activityWithName:@"G3L2" inGroup:group1];
    [Exercise activityWithName:@"Ex1" inGroup:group3];
    [Exercise activityWithName:@"Ex2" inGroup:group3];
    
    Group *group4 = (Group *) [Group activityWithName:@"G4L2" inGroup:group2];
    
    //Exercise
    NSArray *invalidGroups = [Workout validateWorkout:self.workout];
    
    //Validate
    XCTAssertTrue([invalidGroups count] == 1, @"There is only one invalid group");
    XCTAssertEqual(invalidGroups[0], group4, @"Group4 is an invalid group");
}

- (void) testNextActiivtySingleExercise{
    
    //Setup
    Exercise *ex = (Exercise *)[Exercise activityWithName:@"Ex" inWorkout:self.workout];
    
    //Exercise
    Activity *next = [Workout activity:self.workout nextActivity:ex];
    
    //Validate
    XCTAssertNil(next, @"There is no next activity");
}

- (void) testNextActivitySingleGroup{
    //Setup
    Group *group = (Group *)[Group activityWithName:@"Gr" inWorkout:self.workout];
    
    //Exercise
    Activity *next = [Workout activity:self.workout nextActivity:group];
    
    //Validate
    XCTAssertNil(next, @"There is no next activity");
}

- (void) testNextActivityMultipleActivities{
    
    //Setup
    Group *grp1 = (Group *)[Group activityWithName:@"Group1" inWorkout:self.workout];
    Exercise *ex2 = (Exercise *)[Exercise activityWithName:@"Ex2" inWorkout:self.workout];
    Exercise *ex3 = (Exercise *)[Exercise activityWithName:@"Ex3" inWorkout:self.workout];
    
    //Exercise
    Activity *next = [Workout activity:self.workout nextActivity:grp1];
    XCTAssertEqual(next, ex2, @"Ex2 in next to grp1");
    
    next = [Workout activity:self.workout nextActivity:ex2];
    XCTAssertEqual(next, ex3, @"Ex3 is next to ex2");
    
    next = [Workout activity:self.workout nextActivity:ex3];
    XCTAssertNil(next, @"There is no exercise after ex3");
}

@end
