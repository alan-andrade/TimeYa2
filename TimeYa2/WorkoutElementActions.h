//
//  WorkoutElementActions.h
//  TimeYa2
//
//  Created by PartyMan on 12/28/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkoutParentElementActions.h"
#import "WorkoutChildElementActions.h"

@protocol WorkoutElementActions <NSObject>

/** Returns an activity at the next index position relative to the child activity in the parent.
 @param parent Activity node that contains child activity
 @param child Activity used used as reference to get the next activity in the parent activity
 @return Returns the next activity in the parent relative to the child's position. If the child activity is at the last index position of the parent, meaning there is no next activty, the method returns nil.
 */

+ (Activity *) activity:(id <WorkoutParentElementActions>) parent nextActivity:(Activity *) child;



@end
