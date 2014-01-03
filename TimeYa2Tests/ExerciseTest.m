//
//  ExerciseTest.m
//  TimeYa2
//
//  Created by PartyMan on 12/11/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CoreDataTest.h"
#import "Workout+CRUD.h"
#import "Exercise+CRUD.h"
#import "Activity+CRUD.h"
#import "Group+CRUD.h"
#import "TimeYaConstants.h"

@interface ExerciseTest : CoreDataTest

@property (strong, nonatomic) Workout* workout;

@end

@implementation ExerciseTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    
    self.workout = [Workout workoutWithName:@"Dummy" inMangedObjectContext:self.delegate.managedObjectContext];
    
    
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    
    NSError *error;
    [Workout deleteWorkout:self.workout error:&error];
    self.workout = nil;
    
    [super tearDown];
}

- (void) testAddExerciseToWorkout{
    
    //Exercise
    Exercise *exercise = (Exercise *) [Exercise activityWithName:@"Pull ups" inParent:self.workout];
    
    //Validate
    XCTAssertNotNil(exercise, @"Should not be nil");
    XCTAssertEqual(exercise.workout, self.workout, @"Pointers should be the same");
    XCTAssertTrue([self.workout.activities count] == 1, @"Workout should have one exercise");
    
}

- (void) testAddMultipleExercisesToWorkout{
    //Exercise
    
    Exercise *exercise1 = (Exercise *) [Exercise activityWithName:@"Ex1" inParent:self.workout];
    Exercise *exercise2 = (Exercise *) [Exercise activityWithName:@"Ex2" inParent:self.workout];
    Exercise *exercise3 = (Exercise *) [Exercise activityWithName:@"Ex3" inParent:self.workout];
    
    //Validate
    XCTAssertTrue([self.workout.activities count] == 3, @"Workout should have three exercises");
    
    
    XCTAssertNotNil(exercise1, @"Should not be nil");
    XCTAssertEqual(exercise1.workout, self.workout, @"Pointers should be the same");
    
    XCTAssertNotNil(exercise2, @"Should not be nil");
    XCTAssertEqual(exercise2.workout, self.workout, @"Pointers should be the same");
    
    XCTAssertNotNil(exercise3, @"Should not be nil");
    XCTAssertEqual(exercise3.workout, self.workout, @"Pointers should be the same");
    
    XCTAssertEqual([self.workout.activities objectAtIndex:0], exercise1, @"Should be the same");
    XCTAssertEqual([self.workout.activities objectAtIndex:1], exercise2, @"Should be the same");
    XCTAssertEqual([self.workout.activities objectAtIndex:2], exercise3, @"Should be the same");
}

- (void) testDeleteWorkoutDeletesExercises{
    
    //Setup
    [Exercise activityWithName:@"Del1" inParent:self.workout];
    [Exercise activityWithName:@"Del2" inParent:self.workout];
    
    //Exercise
    NSError *error;
    BOOL deleted = [Workout deleteWorkout:self.workout error:&error];

    //Validate
    XCTAssertTrue(deleted, @"Confirm workout was deleted");
    
    NSArray* exercises = [Exercise exercisesInManagedObjectContext:self.delegate.managedObjectContext error:&error];
    
    XCTAssertNotNil(exercises, @"Exercises should be an empty array of exercises");
    XCTAssertTrue([exercises count] == 0, @"No exercises should exist");
    
}

- (void) testDeleteExerciseFromWorkout{
    
    //Setup
    Exercise *exercise1 = (Exercise *) [Exercise activityWithName:@"Del1" inParent:self.workout];
    Exercise *exercise2 = (Exercise *) [Exercise activityWithName:@"Keep2" inParent:self.workout];
    
    //Exercise
    
    NSError *error;
    BOOL deleted = [Activity deleteActivity:exercise1 error:&error];
    
    //Validate
    XCTAssertTrue(deleted, @"Confirm exercise was deleted");
    XCTAssertTrue([[self.workout activities] count] == 1, @"Confirm it only has one activity");
    XCTAssertEqual([self.workout.activities objectAtIndex:0], exercise2, @"Exercise2 should still exist");

}

- (void) testUdpateExercise{
    
    //Setup
    Exercise *exercise = (Exercise *) [Exercise activityWithName:@"Update1" inParent:self.workout];
    Exercise *exerciseTmp = exercise;
    
    NSDictionary *values = @{
                              ACTIVITY_NAME_KEY: @"Burpess",
                              EXERCISE_REPS_KEY:@10
                            };
    
    //Exercise
    exercise = (Exercise *)[Activity updateActivity:exercise withValues:values];
    
    //Validate
    XCTAssertEqual(exercise, exerciseTmp, @"The object should be the same");
    XCTAssertEqualObjects(exercise.name, @"Burpess", @"Exercise should have the new name");
    XCTAssertNotNil(exercise.reps, @"It should have a value now");
    XCTAssertEqualObjects(exercise.reps, (NSNumber *)@10, @"Repst should be 10");
    
    
}

- (void) testValidExercise{
    
    //Setup
    Exercise *exercise = (Exercise *) [Exercise activityWithName:@"Valid1" inParent:self.workout];
    
    NSDictionary *values = @{
                             ACTIVITY_NAME_KEY: @"Burpess",
                             EXERCISE_REPS_KEY:@10
                             };

    [Activity updateActivity:exercise withValues:values];
    
    //Exercise
    NSArray *errors = [Activity validateActivity:exercise];
    
    //Validate
    XCTAssertTrue([errors count] == 0, @"There are no errors on this exercise");
    
}

- (void) testInvalidExerciseIncompleteDefinition{
    
    //Setup
    Exercise *exercise = (Exercise *) [Exercise activityWithName:@"Validate1" inParent:self.workout];
    
    NSDictionary *values = @{
                             ACTIVITY_NAME_KEY: @"Bench Press",
                             EXERCISE_WEIGHT_KEY:@200
                             };
    
    exercise = (Exercise *)[Activity updateActivity:exercise withValues:values];
    
    //Exercise
    NSArray *errors = [Activity validateActivity:exercise];
    
    //Validate
    XCTAssertTrue([errors count] != 0, @"It should contain at least one error message");
    
}

- (void) testInvalidExerciseUndefinedReps{
    
    //Setup
    Exercise *exercise = (Exercise *) [Exercise activityWithName:@"Validate1" inParent:self.workout];
    
    NSDictionary *values = @{
                             ACTIVITY_NAME_KEY: @"Bench Press",
                             EXERCISE_SETS_KEY:@3
                             };
    
    exercise = (Exercise *)[Activity updateActivity:exercise withValues:values];
    
    //Exercise
    NSArray *errors = [Activity validateActivity:exercise];
    
    //Validate
    XCTAssertTrue([errors count] != 0, @"It should contain at least one error message");

}

- (void) testInvalidExerciseMissingUnitType{
    
    //Setup
    Exercise *exercise = (Exercise *) [Exercise activityWithName:@"Validate1" inParent:self.workout];
    
    NSDictionary *values = @{
                             ACTIVITY_NAME_KEY: @"Clean",
                             EXERCISE_WEIGHT_KEY:@200
                             };
    
    exercise = (Exercise *)[Activity updateActivity:exercise withValues:values];
    
    //Exercise
    NSArray *errors = [Activity validateActivity:exercise];
    
    //Validate
    XCTAssertTrue([errors count] !=0, @"It should contain at least one error message");
    
}

- (void) testExerciseParent{
    
    //Setup
    Exercise *exercise = (Exercise *) [Exercise activityWithName:@"Child" inParent:self.workout];
    
    //Exercise
    NSManagedObject* parent = [Activity parent:exercise];
    
    //Validate
    XCTAssertEqual(parent, self.workout, @"Should be the same");
    
}

- (void) testLeafWorkoutTreeBranchOneLevelBranch{
    
    //Setup
    Exercise *exercise = (Exercise*) [Exercise activityWithName:@"L1" inParent:self.workout];
    
    //Exercise
    NSOrderedSet *branch = [exercise leafWourkoutTreeBranch];
    
    //Validate
    XCTAssertTrue([branch count] == 2, @"Should have 2 levels. One for the exercise and antoher for the workout");
    XCTAssertEqual(branch[0], self.workout, @"L0 = Workout");
    XCTAssertEqual(branch[1], exercise, @"L1 = Exercise");
    
}

- (void) testLeafWorkoutTreeBranchTwoLevelBranch{
    
    //Setup
    Group *grp1 = (Group *) [Group activityWithName:@"L1" inParent:self.workout];
    Exercise *ex1 = (Exercise *) [Exercise activityWithName:@"L2" inParent:grp1];
    
    //Exercise
    NSOrderedSet *branch = [ex1 leafWourkoutTreeBranch];
    
    //Validate
    XCTAssertTrue([branch count] == 3, @"Should have 3 levels. One for the exercise, one for the group and antoher for the workout");
    XCTAssertEqual(branch[0], self.workout, @"L0 = Workout");
    XCTAssertEqual(branch[1], grp1, @"L1 = grp1");
    XCTAssertEqual(branch[2], ex1, @"L2 = ex1");
    
    
}

- (void) testLeafWorkoutTreeBranchThreeLevelBranch{
    
    //Setup
    Group *grp1 = (Group *) [Group activityWithName:@"L1" inParent:self.workout];
    Group *grp2 = (Group *) [Group activityWithName:@"L2" inParent:grp1];
    Exercise *ex1 = (Exercise *) [Exercise activityWithName:@"L2" inParent:grp2];
    
    //Exercise
    NSOrderedSet *branch = [ex1 leafWourkoutTreeBranch];
    
    //Validate
    XCTAssertTrue([branch count] == 4, @"Should have 4 levels. One for the exercise, two for the groups and antoher for the workout");
    XCTAssertEqual(branch[0], self.workout, @"L0 = Workout");
    XCTAssertEqual(branch[1], grp1, @"L1 = grp1");
    XCTAssertEqual(branch[2], grp2, @"L2 = grp2");
    XCTAssertEqual(branch[3], ex1, @"L3 = ex1");
    
    
}

@end
