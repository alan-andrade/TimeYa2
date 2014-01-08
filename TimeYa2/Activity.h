//
//  Activity.h
//  TimeYa2
//
//  Created by PartyMan on 1/4/14.
//  Copyright (c) 2014 PartyMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group, Workout, WorkoutListActivity;

@interface Activity : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) WorkoutListActivity *listNode;
@property (nonatomic, retain) Group *group;
@property (nonatomic, retain) Workout *workout;

@end
