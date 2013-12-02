//
//  AppDelegate.h
//  TimeYa2
//
//  Created by PartyMan on 11/27/13.
//  Copyright (c) 2013 PartyMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDFileLogger.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//Logger
@property (strong, nonatomic) DDFileLogger *fileLogger;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
