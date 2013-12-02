//
//  CoreDataTest.m
//  TimeYa2
//
//  Created by PartyMan on 11/30/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import "CoreDataTest.h"
#import "AGWaitForAsyncTestHelper.h"

@implementation CoreDataTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    
    self.delegate = [[FakeCoreDataDocumentDelegate alloc] init];
	
	self.documentHandler = [CoreDataDocumentHandler sharedInstance];
	self.documentHandler.documentName = @"TestDocument";
	self.documentHandler.delegate = self.delegate;
	
	[self.documentHandler createCoreDataSharedDocument];
    
    WAIT_WHILE(![self.delegate managedObjectContext], 2.0);
    
    
}

- (void)tearDown
{
    XCTAssertTrue([self.documentHandler deleteSharedDocument], @"Document should've been deleted");
    self.delegate = nil;
    self.documentHandler.delegate = nil;
    self.documentHandler = nil;

    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}


@end
