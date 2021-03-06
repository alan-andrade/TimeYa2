//
//  WorkoutListController.h
//  TimeYa2
//
//  Created by PartyMan on 12/25/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Workout+CRUD.h"
#import "WorkoutListActivity+CRUD.h"

@interface WorkoutListController : NSObject

@property (strong, nonatomic) Workout* workout;

/** Designated initializer to instantiate a WorkoutListController
 @param workout Workout used to instantiate the WorkoutListController
 @return A WorkoutListController instance
 */

- (WorkoutListController *) initWithWorkout:(Workout *) workout;

/** Returns the WorkoutListActivity for a given activity, which will be added as child of the WorkoutList
 @param activity Acitivity to instantiate a WorkoutListActivity
 @return WorkoutListActivity
 
 Subclasses need to override this method to use a subclass of WorkoutListActivity as items in the WorkoutList
 
 */
- (WorkoutListActivity *) workoutListItem:(Activity *) activity;

/** Return a WorkoutListActivity at a specific position in the workout list
 @param position Position in the workout list
 @param error Pointer to a NSError
 @return WorkoutListActivity at a specific postion in the workout list
 */
- (WorkoutListActivity *) activityAtPosition:(NSUInteger) position error:(NSError**) error;

/** Delete a WorkoutListActivity at a specific position in the workout list
 @param position Position in the workout list
 @param error Pointer to a NSError
 @return YES if the activity is deleted, otherwise NO
 */

- (BOOL) deleteActivityAtPosition:(NSUInteger) position error: (NSError**) error;

/** Insert a
 */

- (WorkoutListActivity *) insertActivityAtPosition:(NSInteger) position ofType:(Class) type withName:(NSString *) name error:(NSError **)error;


/** Return the total number of activities in the workout list
 @return Number of activities in the workout list
 */

- (NSInteger) activityCount;

@end
