//
//  GroupTest.m
//  TimeYa2
//
//  Created by PartyMan on 12/14/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CoreDataTest.h"
#import "Group+CRUD.h"
#import "Workout+CRUD.h"
#import "Activity+CRUD.h"
#import "Exercise+CRUD.h"


@interface GroupTest : CoreDataTest

@property (strong, nonatomic) Workout* workout;

@end

@implementation GroupTest

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

- (void) testAddGroupToWorkout{
    
    //Exercise
    Group *group = [Group groupWithName:@"Add" inWorkout:self.workout];
    
    //Validate
    XCTAssertNotNil(group, @"Should not be nil");
    XCTAssertEqual(group.workout, self.workout, @"Should be equal");
    XCTAssertTrue([self.workout.activities count] ==1, @"Workout should have one activity");
    XCTAssertEqual([self.workout.activities objectAtIndex:0], group,@"Should be equal");
    
}

- (void) testAddGroupToGroup{
    
    //Setup
    Group *group1 = [Group groupWithName:@"Add1" inWorkout:self.workout];
    
    //Exercise
    Group *group2 = [Group groupWithName:@"Add2" inGroup:group1];
    
    //Validate
    XCTAssertNotNil(group2, @"Should not be nil");
    XCTAssertEqual(group2.group, group1, @"Should be equal");
    XCTAssertEqual([group1.activities objectAtIndex:0], group2, @"Should be equal");
    XCTAssertTrue([group1.activities count] == 1, @"Group should have one activity");
    
}

- (void) testDeleteGroupFromWorkout{
    
    //Setup
    Group *group1 = [Group groupWithName:@"Del" inWorkout:self.workout];
    
    //Exercise
    NSError *error, *error2 = nil;
    BOOL deleted = [Activity deleteActivity:group1 error:&error];
    NSArray *groups = [Group groupsInManagedObjectContext:self.workout.managedObjectContext error:&error2];
    
    //Validate
    XCTAssertTrue(deleted, @"Confirm group was deleted");
    XCTAssertTrue([self.workout.activities count] == 0, @"Should have no activities");
    XCTAssertTrue([groups count] == 0, @"There should be no groups");
}

- (void) testDeleteGroupfromGroup{
    
    //Setup
    Group *group1 = [Group groupWithName:@"Del1" inWorkout:self.workout];
    Group *group2 = [Group groupWithName:@"Del2" inGroup:group1];
    
    //Exercise
    NSError *error, *error2 = nil;
    BOOL deleted = [Activity deleteActivity:group2 error:&error];
    NSArray *groups = [Group groupsInManagedObjectContext:self.workout.managedObjectContext error:&error2];
    
    
    //Validate
    XCTAssertTrue(deleted, @"Confirm group was deleted");
    XCTAssertTrue([group1.activities count] == 0, @"Should have no activities");
    XCTAssertEqual(group1.workout, self.workout, @"Group1 should still be part of the workout");
    XCTAssertTrue([groups count] == 1, @"There should be only one group");
    XCTAssertEqual(groups[0], group1, @"Group1 should be the only existing group");
    
}

- (void) testDeleteGroupDeletesExercises{
    
    //Setup
    Group *group1 = [Group groupWithName:@"Group1" inWorkout:self.workout];
    [Exercise exerciseWithName:@"Ex1" inGroup:group1];
    [Exercise exerciseWithName:@"Ex2" inGroup:group1];
    
    //Exercise
    NSError *error1, *error2 = nil;
    BOOL deleted = [Activity deleteActivity:group1 error:&error1];
    NSArray *exercises = [Exercise exercisesInManagedObjectContext:self.workout.managedObjectContext error:&error2];
    
    //Validate
    XCTAssertTrue(deleted, @"Confirm group was deleted");
    XCTAssertTrue([exercises count] == 0, @"There should be no exercises after deleting the group they belong");
    XCTAssertTrue([self.workout.activities count] == 0, @"Should have no activities");
    
}

- (void) testAddExerciseToGroup{
    
    //Setup
    Group *group1 = [Group groupWithName:@"Group1" inWorkout:self.workout];
    Group *group2 = [Group groupWithName:@"Group2" inGroup:group1];
    
    //Exercise
    Exercise *exercise1 = [Exercise exerciseWithName:@"Ex1" inGroup:group2];
    Exercise *exercise2 = [Exercise exerciseWithName:@"Ex2" inGroup:group2];
    
    //Validate
    XCTAssertTrue([group2.activities count] == 2, @"Group 2 should have two exercises");
    XCTAssertEqual([group2.activities objectAtIndex:0], exercise1, @"First activity should be exercise1");
    XCTAssertEqual([group2.activities objectAtIndex:1], exercise2, @"Second activity should be exercise2");
    XCTAssertEqual(exercise1.group, group2, @"Exercise1 is a children of group2");
    XCTAssertEqual(exercise2.group, group2, @"Exercise2 is a children of group2");
    
    
}

- (void) testDeleteWorkoutDeletesGroupsAndExercises{
    
    //Setup
    Group *group1 = [Group groupWithName:@"Group1" inWorkout:self.workout];
    Group *group2 = [Group groupWithName:@"Group2" inGroup:group1];
    [Exercise exerciseWithName:@"Ex1" inGroup:group2];
    [Exercise exerciseWithName:@"Ex2" inGroup:group2];
    [Exercise exerciseWithName:@"Ex3" inWorkout:self.workout];
    
    //Exercise
    NSError *error1, *error2, *error3 = nil;
    BOOL deleted = [Workout deleteWorkout:self.workout error:&error1];
    NSArray *exercises = [Exercise exercisesInManagedObjectContext:self.delegate.managedObjectContext error:&error2];
    NSArray *groups = [Group groupsInManagedObjectContext:self.delegate.managedObjectContext error:&error3];
    
    //Validate
    XCTAssertTrue(deleted, @"Confirm workout was deleted");
    XCTAssertTrue([exercises count] == 0, @"There should be no exercises");
    XCTAssertTrue([groups count] == 0, @"There should be no groups");
    
}

- (void) testCountGroups{
    
    //Setup
    Group *group1 = [Group groupWithName:@"G1" inWorkout:self.workout];
    
    //Exercise
    NSError *error;
    NSArray *groups = [Group groupsInManagedObjectContext:self.workout.managedObjectContext error:&error];
    
    //Validate
    XCTAssertTrue([groups count] == 1, @"Should only one group");
    XCTAssertEqual(groups[0], group1, @"Should be the same");
    
}


@end
