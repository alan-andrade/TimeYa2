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
    [Exercise activityWithName:@"Ex1" inParent:self.workout];
    [Exercise activityWithName:@"Ex2" inParent:self.workout];
    Group *group1 = (Group *)[Group activityWithName:@"Grp1" inParent:self.workout];
    
    //Exercise
    NSArray *invalidGroups = [Workout validateWorkout:self.workout];
    
    //Validate
    XCTAssertTrue([invalidGroups count] == 1, @"There is only one invalid group");
    XCTAssertEqual(invalidGroups[0], group1, @"Group1 is an invalid group");
    
}

- (void) testInvalidaWorkoutTwoLevels{
    
    //Setup
    Group *group1 = (Group *)[Group activityWithName:@"G1L1" inParent:self.workout];
    Group *group2 = (Group *)[Group activityWithName:@"G2L1" inParent:self.workout];
    Group *group3 = (Group *)[Group activityWithName:@"G3L2" inParent:group1];
    [Exercise activityWithName:@"Ex1" inParent:group3];
    [Exercise activityWithName:@"Ex2" inParent:group3];
    
    Group *group4 = (Group *) [Group activityWithName:@"G4L2" inParent:group2];
    
    //Exercise
    NSArray *invalidGroups = [Workout validateWorkout:self.workout];
    
    //Validate
    XCTAssertTrue([invalidGroups count] == 1, @"There is only one invalid group");
    XCTAssertEqual(invalidGroups[0], group4, @"Group4 is an invalid group");
}

- (void) testNextActiivtySingleExercise{
    
    //Setup
    Exercise *ex = (Exercise *)[Exercise activityWithName:@"Ex" inParent:self.workout];
    
    //Exercise
    Activity *next = [Workout activity:self.workout nextActivity:ex];
    
    //Validate
    XCTAssertNil(next, @"There is no next activity");
}

- (void) testNextActivitySingleGroup{
    //Setup
    Group *group = (Group *)[Group activityWithName:@"Gr" inParent:self.workout];
    
    //Exercise
    Activity *next = [Workout activity:self.workout nextActivity:group];
    
    //Validate
    XCTAssertNil(next, @"There is no next activity");
}

- (void) testNextActivityMultipleActivities{
    
    //Setup
    Group *grp1 = (Group *)[Group activityWithName:@"Group1" inParent:self.workout];
    Exercise *ex2 = (Exercise *)[Exercise activityWithName:@"Ex2" inParent:self.workout];
    Exercise *ex3 = (Exercise *)[Exercise activityWithName:@"Ex3" inParent:self.workout];
    
    //Exercise
    Activity *next = [Workout activity:self.workout nextActivity:grp1];
    XCTAssertEqual(next, ex2, @"Ex2 in next to grp1");
    
    next = [Workout activity:self.workout nextActivity:ex2];
    XCTAssertEqual(next, ex3, @"Ex3 is next to ex2");
    
    next = [Workout activity:self.workout nextActivity:ex3];
    XCTAssertNil(next, @"There is no exercise after ex3");
}

- (void) testNextLeafEmptyWorkout{
    
    //Setup
    
    //Exercise
    Activity *nextLeaf = [self.workout nextLeafAfterActivity:nil];
    
    //Validate
    XCTAssertNil(nextLeaf, @"Should be nil since the workout is empty");
    
}

- (void) testNextLeafSingleActivityWorkoutInitialVisit{
    
    //Setup
    Exercise *ex1 = (Exercise *)[Exercise activityWithName:@"Ex1" inParent:self.workout];
    
    //Exercise
    Activity *nextLeaf = [self.workout nextLeafAfterActivity:nil];
    
    //Validate
    XCTAssertNotNil(nextLeaf, @"Should return Ex1 node");
    XCTAssertEqual(nextLeaf, ex1, @"Should point to the same exercise");
}

- (void) testNextLeafSingleAcitivtyWorkout{
    
    //Setup
    Exercise *ex1 = (Exercise *)[Exercise activityWithName:@"Ex1" inParent:self.workout];
    
    //Exercise
    Activity *nextLeaf = [self.workout nextLeafAfterActivity:ex1];
    
    //Validate
    XCTAssertNil(nextLeaf, @"There are no more activities after Ex1");
    
}

- (void) testNextLeafMultipleActivitiesWorkout{
    
    //Setup
    Exercise *ex1 = (Exercise *)[Exercise activityWithName:@"Ex1" inParent:self.workout];
    Exercise *ex2 = (Exercise *)[Exercise activityWithName:@"Ex2" inParent:self.workout];
    
    //Exercise
    Activity *nextLeaf = [self.workout nextLeafAfterActivity:ex1];
    
    //Validate
    XCTAssertEqual(nextLeaf, ex2, @"Ex2 is the next leaf after ex1");
}

- (void) testNextLeafSingleGroupInitialVisit{
    
    //Setup
    Group *grp1 = (Group *)[Group activityWithName:@"Group1" inParent:self.workout];
    Exercise *ex1 = (Exercise *)[Exercise activityWithName:@"Ex1" inParent:grp1];
    
    //Exercise
    Activity *nextLeaf = [self.workout nextLeafAfterActivity:nil];
    
    //Validate
    XCTAssertNotNil(nextLeaf, @"Ex1 is the first leaf");
    XCTAssertEqual(nextLeaf, ex1, @"Ex1 is the first leaf");
}

- (void) testNextLeafSingleGroup{
    
    //Setup
    Group *grp1 = (Group *)[Group activityWithName:@"Group1" inParent:self.workout];
    Exercise *ex1 = (Exercise *)[Exercise activityWithName:@"Ex1" inParent:grp1];
    
    //Exercise
    Activity *nextLeaf = [grp1 nextLeafAfterActivity:ex1];
    
    //Validate
    XCTAssertNil(nextLeaf, @"There should be no leafs after ex1");
    
}

- (void) testNextLeafDoubleLevelGroupInitialVisit{
    
    //Setup
    Group *grp1 = (Group *)[Group activityWithName:@"Group1" inParent:self.workout];
    Group *grp2 = (Group *)[Group activityWithName:@"Group2" inParent:grp1];
    Exercise *ex1 = (Exercise *)[Exercise activityWithName:@"Ex1" inParent:grp2];
    
    //Exercise
    Activity *nextLeaf = [self.workout nextLeafAfterActivity:nil];
    
    //Validate
    XCTAssertEqual(nextLeaf, ex1, @"Ex1 is the first leaf in the workout");
    
}

- (void) testNextLeafDoubleLevelGroup{
    
    //Setup
    Group *grp1 = (Group *)[Group activityWithName:@"Group1" inParent:self.workout];
    Group *grp2 = (Group *)[Group activityWithName:@"Group2" inParent:grp1];
    Exercise *ex1 = (Exercise *)[Exercise activityWithName:@"Ex1" inParent:grp2];
    
    //Exercise
    Activity *nextLeaf = [grp2 nextLeafAfterActivity:ex1];
    
    //Validate
    XCTAssertNotNil(nextLeaf, @"Group should cycle though its activites and return ex1 again");
    XCTAssertEqual(nextLeaf, ex1, @"Should point to the same object");
    
}

- (void) testInitWithWorkout{
    
    //Setup
    self.workout = [Workout workoutWithName:@"Advanced" inMangedObjectContext:self.delegate.managedObjectContext];

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

    //Validate
    NSError *error;
    NSUInteger workoutNodes = [[Workout workoutsInManagedObjectContext:self.delegate.managedObjectContext error:&error] count];
    XCTAssertTrue(workoutNodes == 1, @"There should be only one workout created");
    NSUInteger groupNodes = [[Group groupsInManagedObjectContext:self.delegate.managedObjectContext error:&error] count];
    XCTAssertTrue(groupNodes == 7, @"There should be 7 groups created");
    NSUInteger exerciseNodes = [[Exercise exercisesInManagedObjectContext:self.delegate.managedObjectContext error:&error] count];
    XCTAssertTrue(exerciseNodes == 17, @"There should be 17 groups created");
    
    //Exercise
    
    Workout *workoutCopy = [Workout initWithWorkout:self.workout];
    
    //Validate
    XCTAssertNotNil(workoutCopy, @"Make sure the new workout is not nil");
    workoutNodes = [[Workout workoutsInManagedObjectContext:self.delegate.managedObjectContext error:&error] count];
    XCTAssertTrue(workoutNodes == 2, @"There should be only one workout created");
    groupNodes = [[Group groupsInManagedObjectContext:self.delegate.managedObjectContext error:&error] count];
    XCTAssertTrue(groupNodes == 14, @"There should be 14 groups created");
    exerciseNodes = [[Exercise exercisesInManagedObjectContext:self.delegate.managedObjectContext error:&error] count];
    XCTAssertTrue(exerciseNodes == 34, @"There should be 34 groups created");
    
}

- (void) testInitWithWorkoutCorrectness{
    
    //Setup
    self.workout = [Workout workoutWithName:@"Copy" inMangedObjectContext:self.delegate.managedObjectContext];
    
    Group *warmUp = (Group *) [Group activityWithName:@"WarmUp" inParent:self.workout];
    
    Group *lowerWarmUp = (Group *) [Group activityWithName:@"LowerWarmUp" inParent:warmUp];
    [Exercise activityWithName:@"Quads Stretch" inParent:lowerWarmUp];
    [Exercise activityWithName:@"Hams Stretch" inParent:lowerWarmUp];
    [Exercise activityWithName:@"Calves Stretch" inParent:lowerWarmUp];
    
    Group *upperWarmUp = (Group *) [Group activityWithName:@"UpperWarmUp" inParent:warmUp];
    [Exercise activityWithName:@"Chest Stretch" inParent:upperWarmUp];
    [Exercise activityWithName:@"Shoulder Stretch" inParent:upperWarmUp];
    [Exercise activityWithName:@"Arms Stretch" inParent:upperWarmUp];
    
    Exercise *rest = (Exercise *)[Exercise activityWithName:@"Rest" inParent:self.workout];
    
    //Exercise
    Workout *workoutCopy = [Workout initWithWorkout:self.workout];
    
    //Validate
    XCTAssertEqualObjects(workoutCopy.name, @"Copy", @"Name should match");
    XCTAssertTrue([workoutCopy.activities count] == 2, @"It only has one group and an exercise as immediate children");
    XCTAssertNotEqual(workoutCopy.activities[0], warmUp, @"These should be two different objects");
    XCTAssertNotEqual(workoutCopy.activities[1], rest, @"These should be two different objects");
    
    Group *warmUpCopy = workoutCopy.activities[0];
    
    XCTAssertEqualObjects([warmUpCopy name], @"WarmUp", @"Name should match");
    XCTAssertTrue([[warmUpCopy activities] count] == 2, @"It has LowerWarmUp and UpperWarmUp as children");
    XCTAssertEqual([Activity parent:warmUpCopy], workoutCopy, @"WorkoutCopy should be the parent of warmUpCopy");
    XCTAssertTrue([Activity isKindOfParentEntity:warmUpCopy], @"Object should be of Group class type");
    
    Group *lowerWarmUpCopy = warmUpCopy.activities[0];
    
    XCTAssertEqualObjects([lowerWarmUpCopy name], @"LowerWarmUp", @"Name should match");
    XCTAssertTrue([[lowerWarmUpCopy activities] count] == 3, @"It has 3 stretches as children");
    XCTAssertEqual([Activity parent:lowerWarmUpCopy], warmUpCopy, @"WarmUpCopy should be the parent of lowerWarmUpCopy");
    
    Exercise *stretchCopy = lowerWarmUpCopy.activities[0];
    
    XCTAssertEqualObjects(stretchCopy.name, @"Quads Stretch", @"Name should match");
    XCTAssertEqual([Activity parent:stretchCopy], lowerWarmUpCopy, @"LowerWarmUpCopy should be the parent of stretchCopy");
    XCTAssertTrue([Activity isKindOfLeafEntity:stretchCopy], @"Object should be of Exercise class type");
    
    
}

@end
