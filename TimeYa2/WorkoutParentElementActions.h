//
//  WorkoutParentElementActions.h
//  TimeYa2
//
//  Created by PartyMan on 12/28/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WorkoutParentElementActions <NSObject>

@property (nonatomic, retain) NSOrderedSet *activities;

- (NSManagedObjectContext *)managedObjectContext;
- (void) addActivitiesObject:(Activity *)value;

@end
