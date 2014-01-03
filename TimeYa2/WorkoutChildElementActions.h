//
//  WorkoutLeafElementActions.h
//  TimeYa2
//
//  Created by PartyMan on 12/28/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WorkoutLeafElementActions <NSObject>

/** Returns all the WorkoutElements in the workout tree branch of the WorkoutLeafElement receiver
 @return Returns a collection of all the WorkoutElements in the workout tree branch of the WorkoutLeafElement, including itself.
 */

- (NSOrderedSet *) leafWourkoutTreeBranch;

@end
