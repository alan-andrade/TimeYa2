//
//  ActivityActions.h
//  TimeYa2
//
//  Created by PartyMan on 12/19/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkoutElementActions.h"

/** Protocol that defines methods that MUST be overridden by Activity child entities
*/

@protocol ActivityActions <WorkoutElementActions>

/**Create an activity of the recevier's type with a name in the specified parent element
 @param name Name of the activity
 @param parent Parent element where the activity will be created
 @return An activity entity of the type of the receiver
 
 This is an abstract method that MUST be overridden by child classes
 
 */

+ (Activity *) activityWithName:(NSString *) name inParent:(id <WorkoutParentElementActions>) parent;

/** Update an activity attributes that passed in the values dictionary
 @param activity Acitity to update
 @param values Dictionary that contains key/values to update
 @return Updated activity. Nil if the activity class is unkown
 
 This is an abstract method that MUST be overridden by child classes
 
 */

+ (Activity *) updateActivity:(Activity *) activity withValues:(NSDictionary *) values;

/** Validate attributes on the specified activity
 @param activity Activity to validate
 @return Empty if there are no errors. Otherwise it returns error messages found
 
 This is an abstract method that MUST be overridden by child classes
 
 */
+ (NSArray*) validateActivity:(Activity *) activity;


@end

