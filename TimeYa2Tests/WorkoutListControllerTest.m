//
//  WorkoutListControllerTest.m
//  TimeYa2
//
//  Created by PartyMan on 12/25/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WorkoutListController.h"
#import "CoreDataTest.h"
#import "Workout+CRUD.h"
#import "Exercise+CRUD.h"
#import "Group+CRUD.h"
#import "WorkoutList+CRUD.h"
#import "WorkoutListActivity+CRUD.h"



@interface WorkoutListControllerTest : CoreDataTest

@property (strong, nonatomic) Workout *workout;
@property (strong, nonatomic) WorkoutListController *listController;

@end

@implementation WorkoutListControllerTest

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
    [Exercise activityWithName:@"Ex1" inWorkout:self.workout];
    [Exercise activityWithName:@"Ex2" inWorkout:self.workout];
    [Exercise activityWithName:@"Ex3" inWorkout:self.workout];
    
}

- (void) normalWorkout{
    
    self.workout = [Workout workoutWithName:@"NormalWorkout" inMangedObjectContext:self.delegate.managedObjectContext];
    
    Group *warmUp = (Group *)[Group activityWithName:@"WarmUp" inWorkout:self.workout];
    
    [Exercise activityWithName:@"Leg Stretch" inGroup:warmUp];
    [Exercise activityWithName:@"Back Stretch" inGroup:warmUp];
    [Exercise activityWithName:@"Arm Strech" inGroup:warmUp];
    
    [Exercise activityWithName:@"Jog" inWorkout:self.workout];
    
    Group *upperBody = (Group *)[Group activityWithName:@"UpperBody" inWorkout:self.workout];
    [Exercise activityWithName:@"Push Ups" inGroup:upperBody];
    [Exercise activityWithName:@"Pull Ups" inGroup:upperBody];
    [Exercise activityWithName:@"Dips" inGroup:upperBody];
    
    [Exercise activityWithName:@"Jog" inWorkout:self.workout];
    
    Group *lowerBody = (Group *)[Group activityWithName:@"LowerBody" inWorkout:self.workout];
    [Exercise activityWithName:@"Lunges" inGroup:lowerBody];
    [Exercise activityWithName:@"Squats" inGroup:lowerBody];
    [Exercise activityWithName:@"Box Jumps" inGroup:lowerBody];
    
    [Exercise activityWithName:@"Jog" inWorkout:self.workout];
    
    Group *coolDown = (Group *)[Group activityWithName:@"CoolDown" inWorkout:self.workout];
    
    [Exercise activityWithName:@"Leg Stretch" inGroup:coolDown];
    [Exercise activityWithName:@"Back Stretch" inGroup:coolDown];
    [Exercise activityWithName:@"Arm Strech" inGroup:coolDown];
    
}

- (void) advancedWorkout{
    
    self.workout = [Workout workoutWithName:@"AdvancedWorkout" inMangedObjectContext:self.delegate.managedObjectContext];
    
    Group *warmUp = (Group *) [Group activityWithName:@"WarmUp" inWorkout:self.workout];
    
    Group *lowerWarmUp = (Group *) [Group activityWithName:@"LowerWarmUp" inGroup:warmUp];
    [Exercise activityWithName:@"Quads Stretch" inGroup:lowerWarmUp];
    [Exercise activityWithName:@"Hams Stretch" inGroup:lowerWarmUp];
    [Exercise activityWithName:@"Calves Stretch" inGroup:lowerWarmUp];
    
    Group *upperWarmUp = (Group *) [Group activityWithName:@"UpperWarmUp" inGroup:warmUp];
    [Exercise activityWithName:@"Chest Stretch" inGroup:upperWarmUp];
    [Exercise activityWithName:@"Shoulder Stretch" inGroup:upperWarmUp];
    [Exercise activityWithName:@"Arms Stretch" inGroup:upperWarmUp];
    
    [Exercise activityWithName:@"Rest" inWorkout:self.workout];
    
    Group *main = (Group *) [Group activityWithName:@"Main" inWorkout:self.workout];
    
    Group *lowerBody = (Group *) [Group activityWithName:@"LowerBody" inGroup:main];
    [Exercise activityWithName:@"Deep Squat" inGroup:lowerBody];
    [Exercise activityWithName:@"Lunges" inGroup:lowerBody];
    [Exercise activityWithName:@"One Leg Squat" inGroup:lowerBody];
    
    Group *upperBody = (Group *) [Group activityWithName:@"UpperBody" inGroup:main];
    [Exercise activityWithName:@"Bench Press" inGroup:upperBody];
    [Exercise activityWithName:@"Shoulder Press" inGroup:upperBody];
    [Exercise activityWithName:@"Row" inGroup:upperBody];
    
    [Exercise activityWithName:@"Rest" inWorkout:self.workout];
    
    Group *coolDown = (Group *)[Group activityWithName:@"CoolDown" inWorkout:self.workout];
    
    [Exercise activityWithName:@"Leg Stretch" inGroup:coolDown];
    [Exercise activityWithName:@"Back Stretch" inGroup:coolDown];
    [Exercise activityWithName:@"Arm Strech" inGroup:coolDown];
    
    
    
}

- (void) testWorkoutListControllerWithEmptyWorkout{
    
    //Validate
    NSError *error;
    NSArray *workoutLists = [WorkoutList workoutListsInManagedObjectContext:self.workout.managedObjectContext error:&error];
    
    XCTAssertNil(error, @"Verify there is no error");
    
    //Setup
    self.workout = [Workout workoutWithName:@"SimpleWorkout" inMangedObjectContext:self.delegate.managedObjectContext];

    //Exercise
    self.listController = [[WorkoutListController alloc] initWithWorkout:self.workout];
    
    //Validate
    workoutLists = [WorkoutList workoutListsInManagedObjectContext:self.workout.managedObjectContext error:&error];
    
    XCTAssertNil(error, @"Verify there is no error");
    XCTAssertTrue([workoutLists count] == 1, @"One list should've been created");
    
}

- (void) testWorkoutTreeSimpleWorkout{
    
    //Setup
    [self simpleWorkout];
    
    //Exercise
    self.listController = [[WorkoutListController alloc] initWithWorkout:self.workout];
    
    //Validate
    NSError *error;
    NSArray *lists = [WorkoutList workoutListsInManagedObjectContext:self.workout.managedObjectContext error:&error];
    
    XCTAssertNil(error, @"Verify there is no error");
    XCTAssertTrue([lists count] == 1, @"One list should've been created");
    
    NSArray *listActivities = [WorkoutListActivity workoutListActivitiesInManagedObjectContext:self.workout.managedObjectContext error:&error];
    XCTAssertNil(error, @"Vefiry there is no error");
    XCTAssertTrue([listActivities count] == 3, @"Three exercise items should've been created");

}

- (void) testWorkoutTreeSimpleWorkoutChildrenOrder{

    //Setup
    [self simpleWorkout];
    
    //Exercise
    self.listController = [[WorkoutListController alloc] initWithWorkout:self.workout];
    
    //Validate
    NSError *error;
    WorkoutListActivity *item0 = [self.listController activityAtPosition:0 error:&error];
    XCTAssertTrue([item0.position integerValue] == 0, @"This is the first exercise");
    XCTAssertEqual(item0.activity, [[self.workout activities] objectAtIndex:0], @"Should point to the same object");
    
    WorkoutListActivity *item1 = [self.listController activityAtPosition:1 error:&error];
    XCTAssertTrue([item1.position integerValue] == 1, @"This is the second exercise");
    XCTAssertEqual(item1.activity, [[self.workout activities] objectAtIndex:1], @"Should point to the same object");
    
    WorkoutListActivity *item2 = [self.listController activityAtPosition:2 error:&error];
    XCTAssertTrue([item2.position integerValue] == 2, @"This is the third exercise");
    XCTAssertEqual(item2.activity, [[self.workout activities] objectAtIndex:2], @"Should point to the same object");
    
}

- (void) testWorkoutTreeNormalWorkout{
    
    //Setup
    [self normalWorkout];
    
    //Exercise
    self.listController = [[WorkoutListController alloc] initWithWorkout:self.workout];
    
    //Validate
    NSError *error;
    NSArray *lists = [WorkoutList workoutListsInManagedObjectContext:self.workout.managedObjectContext error:&error];
    
    XCTAssertNil(error, @"Verify there is no error");
    XCTAssertTrue([lists count] == 1, @"One workout list should've been created");
    
    NSArray *listItems = [WorkoutListActivity workoutListActivitiesInManagedObjectContext:self.workout.managedObjectContext error:&error];
    XCTAssertNil(error, @"Vefiry there is no error");
    XCTAssertTrue([listItems count] == 19, @"19 items should've been created");
    XCTAssertEqual([self.listController activityCount] , 19, @"There is a total of 19 items");
}

- (void) testWorkoutTreeNormalWorkoutChildrenOrder{
    //Setup
    [self normalWorkout];
    
    //Exercise
    self.listController = [[WorkoutListController alloc] initWithWorkout:self.workout];
    
    //Validate
    NSError *error;
    WorkoutListActivity *item0 = [self.listController activityAtPosition:0 error:&error];
    XCTAssertTrue([item0.position integerValue] == 0, @"This is the first exercise");
    XCTAssertEqual(item0.activity, [[self.workout activities] objectAtIndex:0], @"Should point to the same object");
    
    WorkoutListActivity *item18 = [self.listController activityAtPosition:18 error:&error];
    XCTAssertTrue([item18.position integerValue] == 18, @"This is the last exercise in the workout");
    
    Group *group = [[self.workout activities] lastObject];
    Exercise *ex = [[group activities] lastObject];
    XCTAssertEqual(item18.activity, ex, @"Should point to the same object");
    
    WorkoutListActivity *item11 = [self.listController activityAtPosition:11 error:&error];
    
    group = [[self.workout activities] objectAtIndex:4];
    ex = [[group activities] objectAtIndex:0];
    XCTAssertEqual(item11.activity, ex, @"Should point to the same object");
}

- (void) testWorkoutTreeNormalWorkoutChildrenDepth{
    //Setup
    [self normalWorkout];
    
    //Exercise
    self.listController = [[WorkoutListController alloc] initWithWorkout:self.workout];
    
    //Validate
    NSError *error;
    WorkoutListActivity *item0 = [self.listController activityAtPosition:0 error:&error];
    XCTAssertTrue([item0.depth integerValue] == 0, @"Activity in the first level");
    
    WorkoutListActivity *item1 = [self.listController activityAtPosition:1 error:&error];
    XCTAssertTrue([item1.depth integerValue] == 1, @"Activity in the second level");
    
    WorkoutListActivity *item18 = [self.listController activityAtPosition:18 error:&error];
    XCTAssertTrue([item18.depth integerValue] == 1, @"Activity in the second level");
    
    WorkoutListActivity *item11 = [self.listController activityAtPosition:11 error:&error];
    XCTAssertTrue([item11.depth integerValue] == 1, @"Activity in the second level");
}

- (void) testWorkoutTreeNormalWorkoutAllowChildre{
    //Setup
    [self normalWorkout];
    
    //Exercise
    self.listController = [[WorkoutListController alloc] initWithWorkout:self.workout];
    
    //Validate
    NSError *error;
    WorkoutListActivity *item0 = [self.listController activityAtPosition:0 error:&error];
    XCTAssertTrue([item0.allowChildren boolValue] == YES, @"Group should allow children");
    
    WorkoutListActivity *item18 = [self.listController activityAtPosition:18 error:&error];
    XCTAssertTrue([item18.allowChildren boolValue] == NO, @"Exercise should not allow children");
    
}

- (void) testWorkoutTreeAdvancedWorkout{
    
    //Setup
    [self advancedWorkout];
    
    //Exercise
    self.listController = [[WorkoutListController alloc] initWithWorkout:self.workout];
    
    //Validate
    NSError *error;
    NSArray *lists = [WorkoutList workoutListsInManagedObjectContext:self.workout.managedObjectContext error:&error];
    
    XCTAssertNil(error, @"Verify there is no error");
    XCTAssertTrue([lists count] == 1, @"One root item should've been created");
    
    NSArray *listItems = [WorkoutListActivity workoutListActivitiesInManagedObjectContext:self.workout.managedObjectContext error:&error];
    XCTAssertNil(error, @"Vefiry there is no error");
    XCTAssertTrue([listItems count] == 24, @"24 list items should've been created");
    XCTAssertEqual([self.listController activityCount] , 24, @"There is a total of 24 list items");
    
}

- (void) testWorkoutTreeAdvancedWorkoutChildrenOrder{
    //Setup
    [self advancedWorkout];
    
    //Exercise
    self.listController = [[WorkoutListController alloc] initWithWorkout:self.workout];
    
    //Validate
    NSError *error;
    WorkoutListActivity *item9 = [self.listController activityAtPosition:9 error:&error];
    XCTAssertTrue([item9.position integerValue] == 9, @"This is the ninth exercise");
    XCTAssertEqual(item9.activity, [[self.workout activities] objectAtIndex:1], @"Should point to the same object");
    
    WorkoutListActivity *item23 = [self.listController activityAtPosition:23 error:&error];
    XCTAssertTrue([item23.position integerValue] == 23, @"This is the last exercise in the workout");
    
    Group *group = [[self.workout activities] lastObject];
    Exercise *ex = [[group activities] lastObject];
    XCTAssertEqual(item23.activity, ex, @"Should point to the same object");
    
    WorkoutListActivity *item17 = [self.listController activityAtPosition:17 error:&error];
    
    group = [[self.workout activities] objectAtIndex:2];
    Group *group2 = [[group activities] lastObject];
    ex = [[group2 activities] objectAtIndex:1];
    XCTAssertEqual(item17.activity, ex, @"Should point to the same object");
}

- (void) testDeleteOperationSingleActivityWorkout{
    
    //Setup
    self.workout = [Workout workoutWithName:@"SingleActivityWorkout" inMangedObjectContext:self.delegate.managedObjectContext];
    [Exercise activityWithName:@"Ex1" inWorkout:self.workout];
    self.listController = [[WorkoutListController alloc] initWithWorkout:self.workout];
    
    //Exercise
    NSError *error;
    BOOL deleted = [self.listController deleteActivityAtPosition:0 error:&error];

    //Validate
    XCTAssertTrue(deleted, @"Validate item was deleted");
    XCTAssertTrue([self.listController activityCount] == 0, @"Workout should be empty");
    
}

- (void) testDeleteOperationSimpleWorkout{
    
    //Setup
    [self simpleWorkout];
    self.listController = [[WorkoutListController alloc] initWithWorkout:self.workout];
    NSError *error;
    WorkoutListActivity *ex1 = [self.listController activityAtPosition:1 error:&error];
    
    //Exercise
    BOOL deleted = [self.listController deleteActivityAtPosition:0 error:&error];
    WorkoutListActivity *item0 = [self.listController activityAtPosition:0 error:&error];

    //Validate
    XCTAssertTrue(deleted, @"Validate item was deleted");
    XCTAssertTrue([self.listController activityCount] == 2, @"Workout list now has 2 items");
    XCTAssertNil(error, @"No error retreiving item at position 0");
    XCTAssertNotNil(item0, @"Tree should rebalance automatically and cover the position that was deleted");
    XCTAssertEqual(item0, ex1, @"The first exercise should now be what use to be the second exercise");
}

- (void) testDeleteOperationSimpleWorkout2{
    
    //Setup
    [self simpleWorkout];
    self.listController = [[WorkoutListController alloc] initWithWorkout:self.workout];
    NSError *error;
    
    //Exercise
    BOOL deleted = [self.listController deleteActivityAtPosition:2 error:&error];
    WorkoutListActivity *item2 = [self.listController activityAtPosition:2 error:&error];
    
    //Validate
    XCTAssertTrue(deleted, @"Validate item was deleted");
    XCTAssertTrue([self.listController activityCount] == 2, @"Workout list now has 2 items");
    XCTAssertNil(error, @"No error retreiving item at position 0");
    XCTAssertNil(item2, @"Last activity was deleted. item2 should be nil");

}

- (void) testDeleteOperationNormalWorkout{
    
    //Setup
    [self normalWorkout];
    self.listController = [[WorkoutListController alloc] initWithWorkout:self.workout];
    
    //Exercise
    NSError *error;
    WorkoutListActivity *item11 = [self.listController activityAtPosition:14 error:&error];
    BOOL deleted = [self.listController deleteActivityAtPosition:10 error:&error];
    WorkoutListActivity *item = [self.listController activityAtPosition:10 error:&error];

    //Validation
    XCTAssertTrue(deleted, @"Validate item was deleted");
    XCTAssertTrue([self.listController activityCount] == 15, @"Workout list now has 18 items");
    XCTAssertEqualObjects(item.activity.name, item11.activity.name, @"Should be the same item after deleting item 10");
    
}

- (void) testDeleteOperationAdvancedWorkout{
    
    //Setup
    [self advancedWorkout];
    self.listController = [[WorkoutListController alloc] initWithWorkout:self.workout];
    
    //Exercise
    NSError *error;
    WorkoutListActivity *item19 = [self.listController activityAtPosition:19 error:&error];
    NSString *item19Name = [item19.activity.name copy];
    BOOL deleted = [self.listController deleteActivityAtPosition:15 error:&error];
    WorkoutListActivity *item = [self.listController activityAtPosition:15 error:&error];
    NSString *itemName = [item.activity.name copy];
    
    //Validation
    XCTAssertTrue(deleted, @"Validate item was deleted");
    XCTAssertTrue([self.listController activityCount] == 20, @"Workout list now has 20 items");
    XCTAssertEqual(item19, item, @"Should point to the same object");
    XCTAssertEqualObjects(itemName, item19Name, @"Should be the same name");
    
}

@end
