//
//  CoreDataTest.h
//  TimeYa2
//
//  Created by PartyMan on 11/30/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FakeCoreDataDocumentDelegate.h"
#import "CoreDataDocumentHandler.h"

@interface CoreDataTest : XCTestCase

@property (strong, nonatomic) CoreDataDocumentHandler *documentHandler;
@property (strong, nonatomic) FakeCoreDataDocumentDelegate *delegate;

@end
