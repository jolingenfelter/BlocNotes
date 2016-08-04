//
//  CoreDataStack.h
//  BlocNotes
//
//  Created by Joanna Lingenfelter on 6/19/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataStack : NSObject

+(instancetype) defaultStack;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *localDataPersistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectContext *localDataManagedObjectContext;

- (void)saveContext;
- (void) localDataSaveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
