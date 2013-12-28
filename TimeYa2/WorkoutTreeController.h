//
//  WorkoutTreeController.h
//  TimeYa2
//
//  Created by PartyMan on 12/25/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Workout+CRUD.h"
#import "WorkoutTreeNode+CRUD.h"

@interface WorkoutTreeController : NSObject

/** Designated initializer to instantiate a WorkoutTreeController
 @param workout Workout to controll by the WorkoutTreeController
 @return A WorkoutTreeController instance
 */

- (WorkoutTreeController *) initWithWorkout:(Workout *) workout;


/** Returns a WorkoutTreeNode at a specific position in the workout
 @param position Position in the workout
 @param error Pointer to a NSError
 @return WorkoutTreeNode at a specific postion in the workout
 */
- (WorkoutTreeNode *) activityAtPosition:(NSUInteger) position error:(NSError**) error;

/** Deletes a WorkoutTreeNode at a specific position in the workout
 @param position Position in the workout
 @param erro Pointer to a NSError
 @return YES if the activity is deleted, otherwise NO
 */

- (BOOL) deleteActivityAtPosition:(NSUInteger) position error: (NSError**) error;

/** Return the total number of activities in the workout
 @return Number of activities in the workout
 */

- (NSInteger) activityCount;

@end
