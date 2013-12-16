//
//  Activity.h
//  TimeYa2
//
//  Created by PartyMan on 12/14/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group, Workout;

@interface Activity : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Workout *workout;
@property (nonatomic, retain) Group *group;

@end
