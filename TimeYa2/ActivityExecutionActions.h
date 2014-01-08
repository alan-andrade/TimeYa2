//
//  ActivityExecutionActions.h
//  TimeYa2
//
//  Created by PartyMan on 1/4/14.
//  Copyright (c) 2014 PartyMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ActivityExecutionActions <ActivityActions>

@optional

- (NSNumber *) reps;

- (NSNumber *) time;

@end
