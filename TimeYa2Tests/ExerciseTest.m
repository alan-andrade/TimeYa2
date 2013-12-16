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
    Exercise *exercise = [Exercise exerciseWithName:@"Pull ups" inWorkout:self.workout];
    
    //Validate
    XCTAssertNotNil(exercise, @"Should not be nil");
    XCTAssertEqual(exercise.workout, self.workout, @"Pointers should be the same");
    XCTAssertTrue([self.workout.activities count] == 1, @"Workout should have one exercise");
    
}

- (void) testAddMultipleExercisesToWorkout{
    //Exercise
    
    Exercise *exercise1 = [Exercise exerciseWithName:@"Ex1" inWorkout:self.workout];
    Exercise *exercise2 = [Exercise exerciseWithName:@"Ex2" inWorkout:self.workout];
    Exercise *exercise3 = [Exercise exerciseWithName:@"Ex3" inWorkout:self.workout];
    
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
    [Exercise exerciseWithName:@"Del1" inWorkout:self.workout];
    [Exercise exerciseWithName:@"Del2" inWorkout:self.workout];
    
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
    Exercise *exercise1 = [Exercise exerciseWithName:@"Del1" inWorkout:self.workout];
    Exercise *exercise2 = [Exercise exerciseWithName:@"Keep2" inWorkout:self.workout];
    
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
    Exercise *exercise = [Exercise exerciseWithName:@"Update1" inWorkout:self.workout];
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
    Exercise *exercise = [Exercise exerciseWithName:@"Valid1" inWorkout:self.workout];
    
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
    Exercise *exercise = [Exercise exerciseWithName:@"Validate1" inWorkout:self.workout];
    
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
    Exercise *exercise = [Exercise exerciseWithName:@"Validate1" inWorkout:self.workout];
    
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
    Exercise *exercise = [Exercise exerciseWithName:@"Validate1" inWorkout:self.workout];
    
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

@end
