//
//  CoreDataManagedDocument.m
//  TimeYa2
//
//  Created by PartyMan on 12/1/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "CoreDataManagedDocument.h"
#import "DDLog.h"
#import "TimeYaConstants.h"

static int ddLogLevel = APP_LOG_LEVEL;

@implementation CoreDataManagedDocument


- (void)handleError:(NSError *)error userInteractionPermitted:(BOOL)userInteractionPermitted{
    DDLogError(@"[%@ %@] [ERROR] FATAL error while trying to save document. Error:%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error);
    
}

@end
