//
//  WorkoutList.h
//  TimeYa2
//
//  Created by PartyMan on 1/4/14.
//  Copyright (c) 2014 PartyMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Workout, WorkoutListActivity;

@interface WorkoutList : NSManagedObject

@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) Workout *workout;
@end

@interface WorkoutList (CoreDataGeneratedAccessors)

- (void)addItemsObject:(WorkoutListActivity *)value;
- (void)removeItemsObject:(WorkoutListActivity *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
