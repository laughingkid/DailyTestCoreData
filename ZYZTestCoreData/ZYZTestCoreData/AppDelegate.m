//
//  AppDelegate.m
//  ZYZTestCoreData
//
//  Created by yinzezhang on 15/3/24.
//  Copyright (c) 2015年 yinzezhang. All rights reserved.
//

#import "AppDelegate.h"
#import "Photo.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [self inserObject];
//    [self queryObject];
    [self deleteObject];
//    [self createDocument];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.tencent.stock.ZYZTestCoreData" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ZYZTestCoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ZYZTestCoreData.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#define MaxCount 1000
-(void)inserObject{
    NSLog(@"start ...................");
    for (int i = 0; i < MaxCount; i++) {
        Photo* newPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:self.managedObjectContext];
        newPhoto.title = [NSString stringWithFormat:@"tilte = %d",i];
        newPhoto.subTitle = [NSString stringWithFormat:@"subtiltle = %d",i];
        newPhoto.photoURl = [NSString stringWithFormat:@"url = %d",i];
        [self.managedObjectContext insertObject:newPhoto];

    }
    NSLog(@"end ......................");
    
    NSError* error ;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"不能保存");
    }
   
    
    NSLog(@"save ...................");
}


-(void)queryObject{
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.fetchLimit = 10;
    fetchRequest.fetchOffset = 0;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"title = 'tilte = 123'"];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    NSArray* fetchObject = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    Photo* photo = [fetchObject firstObject];
    NSLog(@"%@,%@,%@",photo.photoURl,photo.title,photo.subTitle);
    
}

-(void)deleteObject{
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.fetchLimit = 10;
    fetchRequest.fetchOffset = 0;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"title = 'tilte = 123'"];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError* error;
    NSArray* fetchObject = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    Photo* photo = [fetchObject firstObject];
//    NSLog(@"%@,%@,%@",photo.photoURl,photo.title,photo.subTitle);
    
    [self.managedObjectContext deleteObject:photo];
    
    [self queryObject];
    
    
}

-(void)createDocument{
    NSFileManager* file = [NSFileManager defaultManager] ;
    
    NSURL* documentDictionary = [[file URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL* url = [documentDictionary URLByAppendingPathComponent:@"myDataBase"];
    UIManagedDocument* document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    BOOL fileExists = [file fileExistsAtPath:[url path]];
    
    if (fileExists) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                
            }
            if (!success) {
                NSLog(@"could not open");
            }
        }];
    }else{
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                
            }
            if (!success) {
                NSLog(@"could not create");
            }
        }];
    }
    
    Photo* newPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:document.managedObjectContext];
    
    newPhoto.title = @"title";
    newPhoto.subTitle = @"subtile";
    newPhoto.photoURl = @"URL";
    NSError* error ;
    if (![document.managedObjectContext save:&error]) {
        NSLog(@"save error");
    }
    
}

@end
