//
//  AppDelegate.h
//  AdBlockerPro
//
//  Created by Passion on 9/29/15.
//  Copyright © 2015 jimmylab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "GAI.h"
#import "Appirater.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, AppiraterDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong) id<GAITracker> tracker;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

