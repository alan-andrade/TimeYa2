//
//  FakeCoreDataDocumentDelegate.m
//  TimeYa
//
//  Created by PartyMan on 9/15/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "FakeCoreDataDocumentDelegate.h"

@implementation FakeCoreDataDocumentDelegate


- (void) coreDataDocumentReady:(NSManagedObjectContext *)managedObjectContext{
    self.managedObjectContext = managedObjectContext;
}

- (void) coreDataDocumentDeletionFailedWithError:(NSError *)error{
    self.documentError = error;
}

- (void) coreDataDocumentCreationFailedWithError:(NSError *)error{
    self.documentError = error;
}

@end
