//
//  CoreDataDocumentHandlerTest.m
//  TimeYa2
//
//  Created by PartyMan on 11/27/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "CoreDataDocumentHandler.h"
#import "TimeYaConstants.h"
#import "AGWaitForAsyncTestHelper.h"

@interface CoreDataDocumentHandler (Test)

- (UIManagedDocument*) managedDocument;
- (void) coreDataDocumentCreationFailed;
- (NSFileManager *) fileManager;
- (void) createDummyDocument;
- (void) deleteDummyDocument;

@end



@interface CoreDataDocumentHandlerTest : XCTestCase

@property (strong, nonatomic) CoreDataDocumentHandler *sharedInstance;

@end


#define TEST_DOC_NAME @"TestDocument"

@implementation CoreDataDocumentHandlerTest

- (void) setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    self.sharedInstance = [CoreDataDocumentHandler sharedInstance];
    self.sharedInstance.documentName = TEST_DOC_NAME;

}

- (void) tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    self.sharedInstance.delegate = nil;
    self.sharedInstance = nil;
    
    [super tearDown];
}

- (void) testSharedInstance{
    CoreDataDocumentHandler *anotherInstance = [CoreDataDocumentHandler sharedInstance];
    XCTAssertEqual(anotherInstance, self.sharedInstance, @"Pointers should be the same");
}

- (void) testDocumentCanHaveAName{
    XCTAssertEqualObjects(self.sharedInstance.documentName, TEST_DOC_NAME, @"User should be able to specify a name");
}

- (void) testDocumentDefaultName{
    self.sharedInstance.documentName = nil;
    XCTAssertEqualObjects(self.sharedInstance.documentName, (NSString *)DEFAULT_DOCUMENT_NAME, @"Default name should be used in no document name is specified");
}

- (void) testDocumentHasADelegate{
    XCTAssertTrue([self.sharedInstance respondsToSelector:@selector(delegate)], @"Core data document handler should have a delegate that is notified upon document creation");
}


- (void) testGetSharedDocumentWithoutDelegate{
    self.sharedInstance.delegate = nil;
    XCTAssertThrows([self.sharedInstance getCoreDataSharedDocument], @"Delegate should be set before asking for a document");
}

- (void) testDocumentSucccessfullySavedandDeleted{
    
    //setUp
    __block NSManagedObjectContext *managedObjectContext;
    
    id delegateMock = [OCMockObject mockForProtocol:@protocol(CoreDataDocumentHandlerDelegate)];
    [[[delegateMock expect] andDo:^(NSInvocation *invocation){
        [invocation getArgument:&managedObjectContext atIndex:2];
    }] coreDataDocumentReady:[OCMArg any]];

    
    self.sharedInstance.delegate = delegateMock;
    
    //exercise
    [self.sharedInstance getCoreDataSharedDocument];
    
    //verify
    WAIT_WHILE(!managedObjectContext, 2.0);
    [delegateMock verify];
    
    BOOL success = [self.sharedInstance deleteSharedDocument];
    XCTAssertTrue(success, @"Shared Document was not deleted");
    
}

- (void) testDeleteDocumentMaxTries{
    
    //setUp
    //Document handler stub
    id invalidDocumentHandler = [OCMockObject partialMockForObject:self.sharedInstance];
    
    
    //FileManager stub
    id fileManagerStub = [OCMockObject mockForClass:[NSFileManager class]];

    BOOL value = NO;
    //FileManager stub - Can't delete files
    [[[fileManagerStub stub] andReturnValue:[NSValue valueWithBytes:&value objCType:@encode(BOOL)]] removeItemAtURL:OCMOCK_ANY error:(NSError *__autoreleasing *)[OCMArg anyPointer]];
    
    //Document Handler stub uses the file manager stub
    [[[invalidDocumentHandler stub] andReturn:fileManagerStub] fileManager];

    
    id delegateMock = [OCMockObject mockForProtocol:@protocol(CoreDataDocumentHandlerDelegate)];
    [[delegateMock expect] coreDataDocumentDeletionFailedWithError:OCMOCK_ANY];
    
    self.sharedInstance.delegate = delegateMock;
    
    //Simulate a document was already created
    [self.sharedInstance createDummyDocument];
    
    //exercise
    [self.sharedInstance deleteSharedDocument];
    
    //validate
    [delegateMock verify];
    
    //tearDown
    [self.sharedInstance deleteDummyDocument];
    [invalidDocumentHandler stopMocking];
    
}

-(void) testDocumentHandlerNotAbletToSave{
    
    //setup
    
    id errorManagedDocument = [OCMockObject niceMockForClass:[UIManagedDocument class]];
    [[[errorManagedDocument stub] andDo:^(NSInvocation *invocation)
      {
          [self.sharedInstance coreDataDocumentCreationFailed];
      }] saveToURL:OCMOCK_ANY forSaveOperation:UIDocumentSaveForCreating completionHandler:OCMOCK_ANY];
    
    
    id invalidDocumentHandler = [OCMockObject partialMockForObject:self.sharedInstance];
    [[[invalidDocumentHandler stub] andReturn:errorManagedDocument] managedDocument];
    
    
    id delegateMock = [OCMockObject mockForProtocol:@protocol(CoreDataDocumentHandlerDelegate)];
    [[delegateMock expect] coreDataDocumentCreationFailedWithError:OCMOCK_ANY];
    
    self.sharedInstance.delegate = delegateMock;
    
    //exercise
    [self.sharedInstance getCoreDataSharedDocument];
    
    //validate
    [delegateMock verify];
    
    //tearDown
    [self.sharedInstance deleteDummyDocument];
    [invalidDocumentHandler stopMocking];
    
    
}



@end
