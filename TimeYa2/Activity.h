//
//  Activity.h
//  TimeYa2
//
//  Created by PartyMan on 12/27/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group, Workout, WorkoutTreeNode;

@interface Activity : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) WorkoutTreeNode *activityNode;
@property (nonatomic, retain) Group *group;
@property (nonatomic, retain) Workout *workout;

@end
