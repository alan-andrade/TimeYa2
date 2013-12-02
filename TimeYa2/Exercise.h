//
//  Exercise.h
//  TimeYa2
//
//  Created by PartyMan on 11/29/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Activity.h"

@class Group;

@interface Exercise : Activity

@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * distanceUnit;
@property (nonatomic, retain) NSNumber * reps;
@property (nonatomic, retain) NSNumber * rounds;
@property (nonatomic, retain) NSNumber * setRestTime;
@property (nonatomic, retain) NSNumber * setRestTimeUnit;
@property (nonatomic, retain) NSNumber * sets;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSNumber * timeUnit;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * weightUnit;
@property (nonatomic, retain) Group *group;

@end
