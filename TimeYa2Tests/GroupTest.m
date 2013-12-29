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
    Group *group = (Group *) [Group activityWithName:@"Add" inParent:self.workout];
    
    //Validate
    XCTAssertNotNil(group, @"Should not be nil");
    XCTAssertEqual(group.workout, self.workout, @"Should be equal");
    XCTAssertTrue([self.workout.activities count] ==1, @"Workout should have one activity");
    XCTAssertEqual([self.workout.activities objectAtIndex:0], group,@"Should be equal");
    
}

- (void) testAddGroupToGroup{
    
    //Setup
    Group *group1 = (Group *) [Group activityWithName:@"Add1" inParent:self.workout];
    
    //Exercise
    Group *group2 = (Group *) [Group activityWithName:@"Add2" inParent:group1];
    
    //Validate
    XCTAssertNotNil(group2, @"Should not be nil");
    XCTAssertEqual(group2.group, group1, @"Should be equal");
    XCTAssertEqual([group1.activities objectAtIndex:0], group2, @"Should be equal");
    XCTAssertTrue([group1.activities count] == 1, @"Group should have one activity");
    
}

- (void) testDeleteGroupFromWorkout{
    
    //Setup
    Group *group1 = (Group *) [Group activityWithName:@"Del" inParent:self.workout];
    
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
    Group *group1 = (Group *) [Group activityWithName:@"Del1" inParent:self.workout];
    Group *group2 = (Group *) [Group activityWithName:@"Del2" inParent:group1];
    
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
    Group *group1 = (Group *) [Group activityWithName:@"Group1" inParent:self.workout];
    [Exercise activityWithName:@"Ex1" inParent:group1];
    [Exercise activityWithName:@"Ex2" inParent:group1];
    
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
    Group *group1 = (Group *) [Group activityWithName:@"Group1" inParent:self.workout];
    Group *group2 = (Group *) [Group activityWithName:@"Group2" inParent:group1];
    
    //Exercise
    Exercise *exercise1 = (Exercise *) [Exercise activityWithName:@"Ex1" inParent:group2];
    Exercise *exercise2 = (Exercise *) [Exercise activityWithName:@"Ex2" inParent:group2];
    
    //Validate
    XCTAssertTrue([group2.activities count] == 2, @"Group 2 should have two exercises");
    XCTAssertEqual([group2.activities objectAtIndex:0], exercise1, @"First activity should be exercise1");
    XCTAssertEqual([group2.activities objectAtIndex:1], exercise2, @"Second activity should be exercise2");
    XCTAssertEqual(exercise1.group, group2, @"Exercise1 is a children of group2");
    XCTAssertEqual(exercise2.group, group2, @"Exercise2 is a children of group2");
    
    
}

- (void) testDeleteWorkoutDeletesGroupsAndExercises{
    
    //Setup
    Group *group1 = (Group *) [Group activityWithName:@"Group1" inParent:self.workout];
    Group *group2 = (Group *) [Group activityWithName:@"Group2" inParent:group1];
    [Exercise activityWithName:@"Ex1" inParent:group2];
    [Exercise activityWithName:@"Ex2" inParent:group2];
    [Exercise activityWithName:@"Ex3" inParent:self.workout];
    
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
    Group *group1 = (Group *) [Group activityWithName:@"G1" inParent:self.workout];
    
    //Exercise
    NSError *error;
    NSArray *groups = [Group groupsInManagedObjectContext:self.workout.managedObjectContext error:&error];
    
    //Validate
    XCTAssertTrue([groups count] == 1, @"Should only one group");
    XCTAssertEqual(groups[0], group1, @"Should be the same");
    
}

- (void) testGroupParent{
    
    //Setup
    Group *group = (Group *) [Group activityWithName:@"child" inParent:self.workout];
    
    //Exercise
    NSManagedObject *parent = [Activity parent:group];
    
    //Validate
    XCTAssertEqual(parent, self.workout, @"Should be the same");
}

-(void) testGroupInGroupParent{
    
    //Setup
    Group *group1 = (Group *) [Group activityWithName:@"child" inParent:self.workout];
    Group *group2 = (Group *) [Group activityWithName:@"grandChild" inParent:group1];
    Exercise *exercise = (Exercise *) [Exercise activityWithName:@"ex1" inParent:group2];
    
    //Exercise
    NSManagedObject *parent1 = [Activity parent:group2];
    NSManagedObject *parent2 = [Activity parent:exercise];
    
    //Validate
    XCTAssertEqual(parent1, group1, @"Should be the same");
    XCTAssertEqual(parent2, group2, @"Should be the same");
    
}

- (void) testNextActivityGroupWithMultipleActivities{
        
    //Setup
    Group *group = (Group *) [Group activityWithName:@"Group" inParent:self.workout];
    Group *grp1 = (Group *)[Group activityWithName:@"Group1" inParent:group];
    Exercise *ex2 = (Exercise *)[Exercise activityWithName:@"Ex2" inParent:group];
    Exercise *ex3 = (Exercise *)[Exercise activityWithName:@"Ex3" inParent:group];
    
    //Exercise
    Activity *next = [Group activity:group nextActivity:grp1];
    XCTAssertEqual(next, ex2, @"Ex2 in next to grp1");
    
    next = [Group activity:group nextActivity:ex2];
    XCTAssertEqual(next, ex3, @"Ex3 is next to ex2");
    
    next = [Group activity:group nextActivity:ex3];
    XCTAssertNil(next, @"There is no exercise after ex3");
}


@end
