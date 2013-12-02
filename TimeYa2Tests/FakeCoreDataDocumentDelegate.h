//
//  FakeCoreDataDocumentDelegate.h
//  TimeYa
//
//  Created by PartyMan on 9/15/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataDocumentHandlerDelegate.h"

@interface FakeCoreDataDocumentDelegate : NSObject <CoreDataDocumentHandlerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSError *documentError;

@end
