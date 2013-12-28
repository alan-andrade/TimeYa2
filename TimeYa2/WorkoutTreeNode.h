//
//  WorkoutTreeNode.h
//  TimeYa2
//
//  Created by PartyMan on 12/27/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Activity, WorkoutTreeRoot;

@interface WorkoutTreeNode : NSManagedObject

@property (nonatomic, retain) NSNumber * allowChildren;
@property (nonatomic, retain) NSNumber * depth;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) Activity *activity;
@property (nonatomic, retain) WorkoutTreeRoot *root;

@end
