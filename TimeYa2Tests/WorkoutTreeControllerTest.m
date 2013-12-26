//
//  WorkoutTreeControllerTest.m
//  TimeYa2
//
//  Created by PartyMan on 12/25/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WorkoutTreeController.h"
#import "CoreDataTest.h"
#import "Workout+CRUD.h"
#import "Exercise+CRUD.h"
#import "Group+CRUD.h"
#import "WorkoutTreeRoot+CRUD.h"
#import "WorkoutTreeNode+CRUD.h"



@interface WorkoutTreeControllerTest : CoreDataTest

@property (strong, nonatomic) Workout *workout;
@property (strong, nonatomic) WorkoutTreeController *treeController;

@end

@implementation WorkoutTreeControllerTest

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

- (void) testWorkoutTreeControllerWithEmptyWorkout{
    
    //Validate
    NSError *error;
    NSArray *rootNodes = [WorkoutTreeRoot workoutTreeRootNodesInManagedObjectContext:self.workout.managedObjectContext error:&error];
    
    XCTAssertNil(error, @"Verify there is no error");
    
    //Setup
    self.workout = [Workout workoutWithName:@"SimpleWorkout" inMangedObjectContext:self.delegate.managedObjectContext];

    //Exercise
    self.treeController = [[WorkoutTreeController alloc] initWithWorkout:self.workout];
    
    //Validate
    rootNodes = [WorkoutTreeRoot workoutTreeRootNodesInManagedObjectContext:self.workout.managedObjectContext error:&error];
    
    XCTAssertNil(error, @"Verify there is no error");
    XCTAssertTrue([rootNodes count] == 1, @"One root node should've been created");
    
}

- (void) testWorkoutTreeSimpleWorkout{
    
    //Setup
    [self simpleWorkout];
    
    //Exercise
    self.treeController = [[WorkoutTreeController alloc] initWithWorkout:self.workout];
    
    //Validate
    NSError *error;
    NSArray *rootNodes = [WorkoutTreeRoot workoutTreeRootNodesInManagedObjectContext:self.workout.managedObjectContext error:&error];
    
    XCTAssertNil(error, @"Verify there is no error");
    XCTAssertTrue([rootNodes count] == 1, @"One root node should've been created");
    
    NSArray *childNodes = [WorkoutTreeNode workoutTreeRootNodesInManagedObjectContext:self.workout.managedObjectContext error:&error];
    XCTAssertNil(error, @"Vefiry there is no error");
    XCTAssertTrue([childNodes count] == 3, @"Three exercise nodes should've been created");

}

- (void) testWorkoutTreeSimpleWorkoutChildrenOrder{

    //Setup
    [self simpleWorkout];
    
    //Exercise
    self.treeController = [[WorkoutTreeController alloc] initWithWorkout:self.workout];
    
    //Validate
    NSError *error;
    WorkoutTreeNode *node0 = [self.treeController activityAtPosition:0 error:&error];
    XCTAssertTrue([node0.position integerValue] == 0, @"This is the first exercise");
    XCTAssertEqual(node0.activity, [[self.workout activities] objectAtIndex:0], @"Should point to the same object");
    
    WorkoutTreeNode *node1 = [self.treeController activityAtPosition:1 error:&error];
    XCTAssertTrue([node1.position integerValue] == 1, @"This is the second exercise");
    XCTAssertEqual(node1.activity, [[self.workout activities] objectAtIndex:1], @"Should point to the same object");
    
    WorkoutTreeNode *node2 = [self.treeController activityAtPosition:2 error:&error];
    XCTAssertTrue([node2.position integerValue] == 2, @"This is the third exercise");
    XCTAssertEqual(node2.activity, [[self.workout activities] objectAtIndex:2], @"Should point to the same object");
    
}

- (void) testWorkoutTreeNormalWorkout{
    
    //Setup
    [self normalWorkout];
    
    //Exercise
    self.treeController = [[WorkoutTreeController alloc] initWithWorkout:self.workout];
    
    //Validate
    NSError *error;
    NSArray *rootNodes = [WorkoutTreeRoot workoutTreeRootNodesInManagedObjectContext:self.workout.managedObjectContext error:&error];
    
    XCTAssertNil(error, @"Verify there is no error");
    XCTAssertTrue([rootNodes count] == 1, @"One root node should've been created");
    
    NSArray *childNodes = [WorkoutTreeNode workoutTreeRootNodesInManagedObjectContext:self.workout.managedObjectContext error:&error];
    XCTAssertNil(error, @"Vefiry there is no error");
    XCTAssertTrue([childNodes count] == 19, @"19 activity nodes should've been created");
    XCTAssertEqual([self.treeController activityCount] , 19, @"There is a total of 19 activities");
}

- (void) testWorkoutTreeNormalWorkoutChildrenOrder{
    //Setup
    [self normalWorkout];
    
    //Exercise
    self.treeController = [[WorkoutTreeController alloc] initWithWorkout:self.workout];
    
    //Validate
    NSError *error;
    WorkoutTreeNode *node0 = [self.treeController activityAtPosition:0 error:&error];
    XCTAssertTrue([node0.position integerValue] == 0, @"This is the first exercise");
    XCTAssertEqual(node0.activity, [[self.workout activities] objectAtIndex:0], @"Should point to the same object");
    
    WorkoutTreeNode *node18 = [self.treeController activityAtPosition:18 error:&error];
    XCTAssertTrue([node18.position integerValue] == 18, @"This is the last exercise in the workout");
    
    Group *group = [[self.workout activities] lastObject];
    Exercise *ex = [[group activities] lastObject];
    XCTAssertEqual(node18.activity, ex, @"Should point to the same object");
    
    WorkoutTreeNode *node11 = [self.treeController activityAtPosition:11 error:&error];
    
    group = [[self.workout activities] objectAtIndex:4];
    ex = [[group activities] objectAtIndex:0];
    XCTAssertEqual(node11.activity, ex, @"Should point to the same object");
}

- (void) testWorkoutTreeNormalWorkoutChildrenDepth{
    //Setup
    [self normalWorkout];
    
    //Exercise
    self.treeController = [[WorkoutTreeController alloc] initWithWorkout:self.workout];
    
    //Validate
    NSError *error;
    WorkoutTreeNode *node0 = [self.treeController activityAtPosition:0 error:&error];
    XCTAssertTrue([node0.depth integerValue] == 0, @"Activity in the first level");
    
    WorkoutTreeNode *node1 = [self.treeController activityAtPosition:1 error:&error];
    XCTAssertTrue([node1.depth integerValue] == 1, @"Activity in the second level");
    
    WorkoutTreeNode *node18 = [self.treeController activityAtPosition:18 error:&error];
    XCTAssertTrue([node18.depth integerValue] == 1, @"Activity in the second level");
    
    WorkoutTreeNode *node11 = [self.treeController activityAtPosition:11 error:&error];
    XCTAssertTrue([node11.depth integerValue] == 1, @"Activity in the second level");
}

- (void) testWorkoutTreeNormalWorkoutAllowChildre{
    //Setup
    [self normalWorkout];
    
    //Exercise
    self.treeController = [[WorkoutTreeController alloc] initWithWorkout:self.workout];
    
    //Validate
    NSError *error;
    WorkoutTreeNode *node0 = [self.treeController activityAtPosition:0 error:&error];
    XCTAssertTrue([node0.allowChildren boolValue] == YES, @"Group should allow children");
    
    WorkoutTreeNode *node18 = [self.treeController activityAtPosition:18 error:&error];
    XCTAssertTrue([node18.allowChildren boolValue] == NO, @"Exercise should not allow children");
    
}

- (void) testWorkoutTreeAdvancedWorkout{
    
    //Setup
    [self advancedWorkout];
    
    //Exercise
    self.treeController = [[WorkoutTreeController alloc] initWithWorkout:self.workout];
    
    //Validate
    NSError *error;
    NSArray *rootNodes = [WorkoutTreeRoot workoutTreeRootNodesInManagedObjectContext:self.workout.managedObjectContext error:&error];
    
    XCTAssertNil(error, @"Verify there is no error");
    XCTAssertTrue([rootNodes count] == 1, @"One root node should've been created");
    
    NSArray *childNodes = [WorkoutTreeNode workoutTreeRootNodesInManagedObjectContext:self.workout.managedObjectContext error:&error];
    XCTAssertNil(error, @"Vefiry there is no error");
    XCTAssertTrue([childNodes count] == 24, @"24 activity nodes should've been created");
    XCTAssertEqual([self.treeController activityCount] , 24, @"There is a total of 24 activities");
    
}

- (void) testWorkoutTreeAdvancedWorkoutChildrenOrder{
    //Setup
    [self advancedWorkout];
    
    //Exercise
    self.treeController = [[WorkoutTreeController alloc] initWithWorkout:self.workout];
    
    //Validate
    NSError *error;
    WorkoutTreeNode *node9 = [self.treeController activityAtPosition:9 error:&error];
    XCTAssertTrue([node9.position integerValue] == 9, @"This is the first exercise");
    XCTAssertEqual(node9.activity, [[self.workout activities] objectAtIndex:1], @"Should point to the same object");
    
    WorkoutTreeNode *node23 = [self.treeController activityAtPosition:23 error:&error];
    XCTAssertTrue([node23.position integerValue] == 23, @"This is the last exercise in the workout");
    
    Group *group = [[self.workout activities] lastObject];
    Exercise *ex = [[group activities] lastObject];
    XCTAssertEqual(node23.activity, ex, @"Should point to the same object");
    
    WorkoutTreeNode *node17 = [self.treeController activityAtPosition:17 error:&error];
    
    group = [[self.workout activities] objectAtIndex:2];
    Group *group2 = [[group activities] lastObject];
    ex = [[group2 activities] objectAtIndex:1];
    XCTAssertEqual(node17.activity, ex, @"Should point to the same object");
}

@end
