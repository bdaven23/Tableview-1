//
//  DataStore.m
//  TableView
//
//  Created by Sunayna Jain on 10/26/13.
//  Copyright (c) 2013 LittleAuk. All rights reserved.
//

#import "DataStore.h"

@interface DataStore ()

@property (strong, nonatomic) NSString* returnString;

@end

@implementation DataStore



@synthesize managedObjectContext = _managedObjectContext;

@synthesize  managedObjectModel = _managedObjectModel;

@synthesize persistentStoreCoordinator =_persistentStoreCoordinator;

@synthesize fetchedResultsController =_fetchedResultsController;

+(DataStore*)sharedStore {
    
    static DataStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] init];
    });
    return sharedStore;
}

#pragma mark -FetchedResultsController 

- (NSFetchedResultsController *) fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateAdded" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    
    NSFetchedResultsController *myFetchedResultsController =
    [[NSFetchedResultsController alloc]
     initWithFetchRequest:fetchRequest
     managedObjectContext:self.managedObjectContext
     sectionNameKeyPath:nil
     cacheName:@"Item"];
    
    _fetchedResultsController = myFetchedResultsController;
    
    [_fetchedResultsController performFetch:nil];
    
    return _fetchedResultsController;
    
}

#pragma mark - DataStore methods

-(void)addingTestData {
    
    NSArray *itemName = @[@"Apples", @"Oranges", @"Kiwis", @"Mangoes", @"Apricots"];
    
    for (int i=0; i<[itemName count]; i++) {
        
        Item *item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
        
        item.name = [itemName objectAtIndex:i];
        
        item.timeStamp = [NSDate date];
        
        NSLog(@"today is:%@", item.timeStamp);
        
        item.category = @"Fruits";
        
        [self.managedObjectContext save:nil];
    }
    
    [self.fetchedResultsController performFetch:nil];
}

-(NSString*)differenceInDaysfromTimeStamp:(NSDate*)timeStamp {
    
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc]init];
    
    dateFormatter.dateFormat = @"MM/dd/YY";
    
    NSString *dateString = [dateFormatter stringFromDate:timeStamp];
    
    NSLog(@"date is:%@", dateString);
    
    NSDate *date = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                               fromDate:timeStamp
                                                 toDate:date
                                                options:0];
    
    NSLog(@"Difference in date components: %i/", components.day);
    
    if (components.day ==0) {
        
        _returnString = @"Added today";
        
    }
    
    else if (components.day!=0){
        
        _returnString = [NSString stringWithFormat:@"Added %ld days ago", (long)components.day];
    }
    
    NSLog(@"%@", _returnString);

    
    return _returnString;
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
