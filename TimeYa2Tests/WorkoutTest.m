//
//  WorkoutTest.m
//  TimeYa2
//
//  Created by PartyMan on 11/30/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "Workout+CRUD.h"
#import "CoreDataTest.h"

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
    
    //Exercise
    [Workout deleteWorkout:self.workout inManagedObjectContext:self.delegate.managedObjectContext];
    
    //Verify
    NSArray *workouts = [Workout workoutsInManagedObjectContext:self.delegate.managedObjectContext];
    
    XCTAssertTrue([workouts count] == 0, @"There should be no workouts created");
    
}



@end
