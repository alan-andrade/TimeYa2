//
//  CoreDataDocumentHandler.m
//  TimeYa2
//
//  Created by PartyMan on 11/25/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "CoreDataDocumentHandler.h"
#import "TimeYaConstants.h"
#import <CoreData/CoreData.h>

@implementation CoreDataDocumentHandler

static CoreDataDocumentHandler *singleton = nil;
static UIManagedDocument *sharedDocument  = nil;

static NSUInteger maxNoDeleteTries = MAX_NO_DELETE_TRIES;
static NSUInteger noDeleteTries = 0;

+ (CoreDataDocumentHandler *) sharedInstance{
    
    if(!singleton){
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            singleton = [[CoreDataDocumentHandler alloc] init];
        });
        
    }
    
    return singleton;
}

- (NSString *) documentName{
    
    if (!_documentName) {
        _documentName = DEFAULT_DOCUMENT_NAME;
    }
    
    return _documentName;
}

- (NSURL *) documentURL{
    
    NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
    NSURL *documentURL = [URLs lastObject];
    
    if(!documentURL){
        if (CORE_DATA_DOCUMENT_DEBUG) NSLog(@"[%@ %@] [ERROR] Unable to find root folder to create core data managed document.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    }
    
    documentURL = [documentURL URLByAppendingPathComponent:self.documentName];
    
    return documentURL;
}

- (void) setDelegate:(id)delegate{
    
    if(delegate && ![delegate conformsToProtocol:@protocol(CoreDataDocumentHandlerDelegate)]){
        [[NSException exceptionWithName: NSInvalidArgumentException reason: @"Delegate object does not respond to managedObjectContext selector" userInfo: nil] raise];
    }
    
    _delegate = delegate;
}

/*Method refactored from getCoreDataSharedDocument for testing purposes
 */
- (UIManagedDocument * ) managedDocument{
    return [[UIManagedDocument alloc] initWithFileURL:[self documentURL]];
}

- (UIManagedDocument *) getCoreDataSharedDocument{
    
    if(!self.delegate) {
        [[NSException exceptionWithName: NSInternalInconsistencyException reason: @"Delegate property should be set before trying to get a UIManagedDocument instance" userInfo: nil] raise];
    }
    
    if (!sharedDocument) {
        
        
        sharedDocument = [self managedDocument];
        
        if (![[self fileManager] fileExistsAtPath:[self documentURL].path]) {
            [sharedDocument saveToURL:[self documentURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
                if(success){
                    [self coreDataDocumentSuccessWithObjectContext:sharedDocument.managedObjectContext];
                }else{
                    [self coreDataDocumentCreationFailed];
                }
            }];
        }else if (sharedDocument.documentState == UIDocumentStateClosed){
            [sharedDocument openWithCompletionHandler:^(BOOL success) {
                if(success){
                    [self coreDataDocumentSuccessWithObjectContext:sharedDocument.managedObjectContext];
                }else{
                    [self coreDataDocumentCreationFailed];
                }
            }];
        }else if (sharedDocument.documentState == UIDocumentStateNormal){
            [self coreDataDocumentSuccessWithObjectContext:sharedDocument.managedObjectContext];
        }else{
            
            [self coreDataDocumentCreationFailed];
            
        }
        
    }else{
        if (sharedDocument.documentState == UIDocumentStateNormal){
            [self coreDataDocumentSuccessWithObjectContext:sharedDocument.managedObjectContext];
        }else{
            [self coreDataDocumentCreationFailed];
        }
    }
    
    return sharedDocument;
    
}

-(void) coreDataDocumentSuccessWithObjectContext:(NSManagedObjectContext *) context{
    
    [self.delegate coreDataDocumentReady:context];
    
}

-(void) coreDataDocumentCreationFailed{
    
    sharedDocument = nil;
    
    if(CORE_DATA_DOCUMENT_DEBUG) NSLog(@"[%@ %@] Document in an invalid state (%u)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), sharedDocument.documentState);
    
    [self coreDataDocumentCreationFailedWithError:[NSNumber numberWithInt:sharedDocument.documentState]];
}

-(void) coreDataDocumentCreationFailedWithError:(NSNumber *) errorCode{
    
    NSError *error = [NSError errorWithDomain:CORE_DATA_DOCUMENT_ERROR_DOMAIN code:errorCode.intValue userInfo:nil];
    
    [self.delegate coreDataDocumentCreationFailedWithError:error];
    
}

- (BOOL) deleteSharedDocument{
    
    BOOL success = NO;
    
    if (sharedDocument) {
        NSError *error;
        success = [[self fileManager] removeItemAtURL:[self documentURL] error:&error];
        
        if(!success){
            noDeleteTries++;
            if (noDeleteTries < maxNoDeleteTries) {
                return [self deleteSharedDocument];
            }else{
                noDeleteTries = 0;
                NSError *deleteError = [NSError errorWithDomain:CORE_DATA_DOCUMENT_ERROR_DOMAIN code:error.code userInfo:error.userInfo];
                [self.delegate coreDataDocumentDeletionFailedWithError:deleteError];
                return success;
            }
        }else{
            sharedDocument = nil;
            noDeleteTries = 0;
            return success;
        }
    }else{
        noDeleteTries = 0;
        return YES;
    }
    
}

- (NSFileManager *) fileManager{
    return [NSFileManager defaultManager];
}

#pragma mark - Test methods

- (void) createDummyDocument{
    sharedDocument = (UIManagedDocument*) [[NSObject alloc] init];
}

- (void) deleteDummyDocument{
    sharedDocument = nil;
}

@end
