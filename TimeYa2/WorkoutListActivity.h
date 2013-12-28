//
//  WorkoutListActivity.h
//  TimeYa2
//
//  Created by PartyMan on 12/28/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity, WorkoutList;

@interface WorkoutListActivity : NSManagedObject

@property (nonatomic, retain) NSNumber * allowChildren;
@property (nonatomic, retain) NSNumber * depth;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) Activity *activity;
@property (nonatomic, retain) WorkoutList *list;

@end
