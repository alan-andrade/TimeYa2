//
//  CoreDataDocumentHandler.m
//  TimeYa2
//
//  Created by PartyMan on 11/25/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "DDLog.h"
#import "CoreDataDocumentHandler.h"
#import "TimeYaConstants.h"
#import <CoreData/CoreData.h>
#import "CoreDataManagedDocument.h"

static int ddLogLevel = APP_LOG_LEVEL;

@interface CoreDataDocumentHandler ()

@property (strong, nonatomic) CoreDataManagedDocument *sharedDocument;
@property (strong, nonatomic) NSFileManager* fileManager;

@end

@implementation CoreDataDocumentHandler

static CoreDataDocumentHandler *singleton = nil;
static CoreDataManagedDocument *coreDataDocument;
static NSUInteger maxNoDeleteTries = MAX_NO_DELETE_TRIES;
static NSUInteger maxNoSaveTries = MAX_NO_SAVE_TRIES;
static NSUInteger noDeleteTries = 0;
static NSUInteger noSaveTries = 0;

+ (CoreDataDocumentHandler *) sharedInstance{
    
    if(!singleton){
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            singleton = [[CoreDataDocumentHandler alloc] init];
        });
        
    }
    
    return singleton;
}

- (void) createCoreDataSharedDocument{
    
    if(!self.delegate) {
        [[NSException exceptionWithName: NSInternalInconsistencyException reason: @"Delegate property should be set before trying to get a UIManagedDocument instance" userInfo: nil] raise];
    }
    
    
    if(!self.sharedDocument){
        
        self.sharedDocument = [self coreDataDocument];
        
        DDLogVerbose(@"[%@ %@] [VERBOSE] Shared document variable is nil. New document was created", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        
        if (![self.fileManager fileExistsAtPath:[self documentURL].path]) {
            DDLogVerbose(@"[%@ %@] [VERBOSE] Shared document doesn't exist in disk. Attempting to save a new one", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            [self.sharedDocument saveToURL:[self documentURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
                if(success){
                    DDLogVerbose(@"[%@ %@] [VERBOSE] Shared document successfully saved to disk", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
                    [self coreDataDocumentSuccessWithObjectContext:self.sharedDocument.managedObjectContext];
                }else{
                    DDLogWarn(@"[%@ %@] [WARN] Shared document can't be saved to disk.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
                    [self coreDataDocumentCreationFailed];
                }
            }];
        }else{
            [self deleteSharedDocument];
            [self createCoreDataSharedDocument];
        }
        
    }else{
        
        DDLogVerbose(@"[%@ %@] [VERBOSE] Shared document variable not nil", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        
        if([self.fileManager fileExistsAtPath:[self documentURL].path]){
            
            DDLogVerbose(@"[%@ %@] [VERBOSE] Shared document does exist in file.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            
            if (self.sharedDocument.documentState == UIDocumentStateClosed){
                DDLogVerbose(@"[%@ %@] [VERBOSE] Shared document is closed. Opening it.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
                [self.sharedDocument openWithCompletionHandler:^(BOOL success) {
                    if(success){
                        DDLogVerbose(@"[%@ %@] [VERBOSE] Shared document successfully opened.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
                        [self coreDataDocumentSuccessWithObjectContext:self.sharedDocument.managedObjectContext];
                    }else{
                        DDLogWarn(@"[%@ %@] [WARN] Core data document can't be opened.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
                        [self coreDataDocumentOpenOperationFailed];
                    }
                }];
            }else if (self.sharedDocument.documentState == UIDocumentStateNormal){
                DDLogVerbose(@"[%@ %@] [VERBOSE] Shared document is open already.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
                [self coreDataDocumentSuccessWithObjectContext:self.sharedDocument.managedObjectContext];
            }else{
                DDLogError(@"[%@ %@] [ERROR] Core data document exists but is in conflict.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
                [self coreDataDocumentConflict];
                
            }
        }else{
            [[NSException exceptionWithName:NSInternalInconsistencyException reason:@"IncosistentState" userInfo:nil] raise];
        }
        
    }
    
}

-(void) coreDataDocumentSuccessWithObjectContext:(NSManagedObjectContext *) context{
    
    noSaveTries=0;
    [self.delegate coreDataDocumentReady:context];
    
}

-(void) coreDataDocumentCreationFailed{
    
    
    //Error handling
    noSaveTries++;
    if (noSaveTries <= maxNoSaveTries) {
        DDLogWarn(@"[%@ %@] [WARN] Creating shared document again. Attempt #%u. Attempts left #%u ",NSStringFromClass([self class]), NSStringFromSelector(_cmd), noSaveTries, maxNoSaveTries - noSaveTries);
        _sharedDocument = nil;
        [self createCoreDataSharedDocument];
        
    }else{
        noSaveTries = 0;
        DDLogError(@"[%@ %@] [ERROR] Core data document could not be created. Document state (%u)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.sharedDocument.documentState);
        [self coreDataDocumentCreationFailedWithError:[NSNumber numberWithInt:self.sharedDocument.documentState]];
    }
}

- (void) coreDataDocumentOpenOperationFailed{
    noSaveTries++;
    if (noSaveTries <= maxNoSaveTries) {
        DDLogWarn(@"[%@ %@] [WARN] Opening shared document again. Attempt #%u. Attempts left #%u",NSStringFromClass([self class]), NSStringFromSelector(_cmd), noSaveTries, maxNoSaveTries - noSaveTries);
        [self createCoreDataSharedDocument];
    }else{
        noSaveTries = 0;
        DDLogError(@"[%@ %@] [ERROR] Core data document could not be opened. Document state (%u)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.sharedDocument.documentState);
        [self coreDataDocumentCreationFailedWithError:[NSNumber numberWithInt:self.sharedDocument.documentState]];
    }
    
}

- (void) coreDataDocumentConflict{
    DDLogError(@"[%@ %@] [ERROR] Core data document conflict. Document state (%u)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.sharedDocument.documentState);
    [self coreDataDocumentCreationFailedWithError:[NSNumber numberWithInt:self.sharedDocument.documentState]];
}


-(void) coreDataDocumentCreationFailedWithError:(NSNumber *) errorCode{
    
    NSError *error = [NSError errorWithDomain:CORE_DATA_DOCUMENT_ERROR_DOMAIN code:errorCode.intValue userInfo:nil];
    [self.delegate coreDataDocumentCreationFailedWithError:error];
    self.sharedDocument = nil;
    
}

- (BOOL) deleteSharedDocument{
    
    BOOL success = NO;
    
    if (self.sharedDocument) {
        
        DDLogVerbose(@"[%@ %@] [VERBOSE] Deleting shared document.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        
        NSError *error;
        success = [self.fileManager removeItemAtURL:[self documentURL] error:&error];
        
        if(!success){
            DDLogVerbose(@"[%@ %@] [VERBOSE] Shared document can't be deleted from disk.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            noDeleteTries++;
            if (noDeleteTries < maxNoDeleteTries) {
                DDLogCWarn(@"[%@ %@] [WARN] Core data document deletion failed. Number of tries: %u", NSStringFromClass([self class]), NSStringFromSelector(_cmd), noDeleteTries);
                return [self deleteSharedDocument];
            }else{
                noDeleteTries = 0;
                NSError *deleteError = [NSError errorWithDomain:CORE_DATA_DOCUMENT_ERROR_DOMAIN code:error.code userInfo:error.userInfo];
                DDLogError(@"[%@ %@] [ERROR] Core data document can't be deleted. Error:%@ User Info:%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error, error.userInfo);
                [self.delegate coreDataDocumentDeletionFailedWithError:deleteError];
                return success;
            }
        }else{
            DDLogVerbose(@"[%@ %@] [VERBOSE] Shared document successfully deleted from disk.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            self.sharedDocument = nil;
            self.documentName = nil;
            noDeleteTries = 0;
            return success;
        }
    }else{
        
        DDLogVerbose(@"[%@ %@] [VERBOSE] Deleting nonexistent shared document.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        self.sharedDocument = nil;
        self.documentName = nil;
        noDeleteTries = 0;
        return YES;
    }
    
}

#pragma mark - Helper Methods

- (NSURL *) documentURL{
    
    NSArray *URLs = [self.fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
    NSURL *documentURL = [URLs lastObject];
    
    if(!documentURL){
        DDLogError(@"[%@ %@] [ERROR] Unable to find root folder to create core data managed document.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    }
    
    documentURL = [documentURL URLByAppendingPathComponent:self.documentName];
    
    return documentURL;
}

#pragma mark - Properties setters and getters

- (NSString *) documentName{
    
    if (!_documentName) {
        _documentName = DEFAULT_DOCUMENT_NAME;
    }
    
    return _documentName;
}

- (void) setDelegate:(id)delegate{
    
    if(delegate && ![delegate conformsToProtocol:@protocol(CoreDataDocumentHandlerDelegate)]){
        [[NSException exceptionWithName: NSInvalidArgumentException reason: @"Delegate object does not conform to CoreDataDocumentHandlerDelegate protocol" userInfo: nil] raise];
    }
    
    _delegate = delegate;
}

- (NSFileManager *) fileManager{
    NSFileManager*fileManager = [[NSFileManager alloc] init];
    fileManager.delegate = self;
    return fileManager;
}

- (CoreDataManagedDocument *) coreDataDocument{
    if(!coreDataDocument){
        coreDataDocument = [[CoreDataManagedDocument alloc] initWithFileURL:[self documentURL]];
    }
    
    return  coreDataDocument;
}

- (void) setSharedDocument:(CoreDataManagedDocument *)sharedDocument{
    _sharedDocument = sharedDocument;
    coreDataDocument = sharedDocument;
}


#pragma mark - File Manager Delegate

-(BOOL) fileManager:(NSFileManager *)fileManager shouldRemoveItemAtURL:(NSURL *)URL{
    DDLogVerbose(@"[%@ %@][VERBOSE] Shared document delete operation will start. URL: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [URL lastPathComponent]);
    return YES;
}

- (BOOL) fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error removingItemAtPath:(NSString *)path{
    DDLogError(@"[%@ %@][ERROR] Shared document delete operation failed. Error:%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error);
    return NO;
}

- (BOOL) fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error removingItemAtURL:(NSURL *)URL{
    DDLogError(@"[%@ %@][ERROR] Shared document delete operation failed. Error:%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error);
    return NO;
}

#pragma mark - Private methods for testing purposes

- (void) createDummyDocument{
    self.sharedDocument = (CoreDataManagedDocument*) [[NSObject alloc] init];
}

- (void) deleteDummyDocument{
    self.sharedDocument = nil;
}

@end
