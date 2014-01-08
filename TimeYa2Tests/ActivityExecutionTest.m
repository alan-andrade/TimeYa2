//
//  ActivityExecutionTest.m
//  TimeYa2
//
//  Created by PartyMan on 1/4/14.
//  Copyright (c) 2014 PartyMan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CoreDataTest.h"
#import "ActivityExecution+CRUD.h"
#import "Exercise+CRUD.h"
#import "Workout+CRUD.h"

@interface ActivityExecutionTest : CoreDataTest

@property (strong, nonatomic) Workout *workout;

@end

@implementation ActivityExecutionTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    
    self.workout = [Workout workoutWithName:@"Test" inMangedObjectContext:self.delegate.managedObjectContext];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void) testActiveOnNonRunningActivityExecution{
    
    //Setup
    Activity* exercise = [Exercise activityWithName:@"Ex1" inParent:self.workout];
    ActivityExecution *activityExecution = [ActivityExecution activityExecutionWithActivity:exercise];
    
    //Validate
    XCTAssertFalse([activityExecution.running boolValue], @"Confirm the activity is not running");
    XCTAssertFalse([activityExecution.active boolValue], @"Shouldn't be active because the activity is not running");
    
}

- (void) testActiveOnNonConstrainedExercises{
    
    //Setup
    Exercise* exercise = (Exercise *)[Exercise activityWithName:@"Ex1" inParent:self.workout];
    ActivityExecution *activityExecution = [ActivityExecution activityExecutionWithActivity:exercise];
    activityExecution.running = @YES;
    
    //Validate
    XCTAssertTrue([activityExecution.active boolValue], @"This is a non-timed activity. It should always be active while running");
}

- (void) testActiveOnTimedExercies{
    
    //Setup
    Exercise* exercise = (Exercise *)[Exercise activityWithName:@"Ex1" inParent:self.workout];
    exercise.time = @2;
    ActivityExecution *activityExecution = [ActivityExecution activityExecutionWithActivity:exercise];
    activityExecution.running = @YES;
    
    //Validate
    XCTAssertEqualObjects(activityExecution.elapsedTime, @0, @"Check that elapsed time is equal to 0");
    XCTAssertTrue([activityExecution.active boolValue], @"There are still two seconds left");
    
    activityExecution.elapsedTime = @1;
    //Validate
    XCTAssertTrue([activityExecution.active boolValue], @"There are still one seconds left");
    
    activityExecution.elapsedTime = @2;
    //Validate
    XCTAssertFalse([activityExecution.active boolValue], @"There is no time left to execute this activity thus it should not be active");
    
}

- (void) testActiveOnRepExercises{
    #warning Implement testActiveOnRepExercises test in ActivityExecutionTest
}

- (void) testActiveOnTimedGroups{
    #warning Implement testActiveOnTimedGroups test in ActivityExecutionTest
}

- (void) testActiveOnRepGroups{
    #warning Implement testActiveOnRepGroups test in ActivityExecutionTest
}



@end
