//
//  DataStore.h
//  TableView
//
//  Created by Sunayna Jain on 10/26/13.
//  Copyright (c) 2013 LittleAuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Item.h"

@interface DataStore : NSObject <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

+(DataStore*)sharedStore;

-(void)addingTestData;

-(NSString*)differenceInDaysfromTimeStamp:(NSDate*)timeStamp;



@end
