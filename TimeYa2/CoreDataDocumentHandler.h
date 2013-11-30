//
//  CoreDataDocumentHandler.h
//  TimeYa2
//
//  Created by PartyMan on 11/25/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataDocumentHandlerDelegate.h"

/** Singleton class that handles the core data document for this app
 
 If a document name is not specified, it uses the default document name.
 
 An instance of this class supports creating and deleting a document multiple times.
 
 */

@interface CoreDataDocumentHandler : NSObject

@property (strong, nonatomic) NSString *documentName;
@property (strong, nonatomic) id <CoreDataDocumentHandlerDelegate> delegate;

/** Class method that retunds a shared instance
 
 @return CoreDataDocumentHandler shared instance
 */
+ (CoreDataDocumentHandler *) sharedInstance;


/** Returns app's core data document
 
 @return The managed document with TimeYa's core data model
 */
- (UIManagedDocument *) getCoreDataSharedDocument;


/** Deletes app's core data document
 
 @return YES if the managed document was successfully deleted, otherwise NO
 */
- (BOOL) deleteSharedDocument;


@end
