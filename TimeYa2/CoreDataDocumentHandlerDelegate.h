//
//  CoreDataDocumentHandlerDelegate.h
//  TimeYa2
//
//  Created by PartyMan on 11/25/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CoreDataDocumentHandlerDelegate <NSObject>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSError *documentError;

- (void) coreDataDocumentReady:(NSManagedObjectContext *) managedObjectContext;
- (void) coreDataDocumentCreationFailedWithError:(NSError *)error;
- (void) coreDataDocumentDeletionFailedWithError:(NSError *)error;

@end
