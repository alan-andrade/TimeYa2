//
//  WorkoutTreeRoot.h
//  TimeYa2
//
//  Created by PartyMan on 12/27/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Workout, WorkoutTreeNode;

@interface WorkoutTreeRoot : NSManagedObject

@property (nonatomic, retain) NSSet *nodes;
@property (nonatomic, retain) Workout *workout;
@end

@interface WorkoutTreeRoot (CoreDataGeneratedAccessors)

- (void)addNodesObject:(WorkoutTreeNode *)value;
- (void)removeNodesObject:(WorkoutTreeNode *)value;
- (void)addNodes:(NSSet *)values;
- (void)removeNodes:(NSSet *)values;

@end
