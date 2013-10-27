//
//  ViewController.m
//  TableView
//
//  Created by Sunayna Jain on 10/26/13.
//  Copyright (c) 2013 LittleAuk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[DataStore sharedStore].fetchedResultsController.fetchedObjects count]==0)
    {
    
    [[DataStore sharedStore] addingTestData];
        
    }
    
    Item *item =[[DataStore sharedStore].fetchedResultsController.fetchedObjects objectAtIndex:0];
    
    [[DataStore sharedStore] differenceInDaysfromTimeStamp:item.timeStamp];
}


#pragma mark-TableView methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [DataStore sharedStore].fetchedResultsController.fetchedObjects.count;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    Item *item = [[DataStore sharedStore].fetchedResultsController objectAtIndexPath:indexPath];
    
    UIImageView *itemImageView = (UIImageView*)[cell viewWithTag:100];
    
    NSArray *imageArray = @[@"apple.jpg", @"orange.png", @"kiwi.jpg", @"mango.jpg", @"apricot.jpg"];
    
    itemImageView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    
    UILabel *itemNameLabel = (UILabel*)[cell viewWithTag:101];
    
    itemNameLabel.text = item.name;
    
    UILabel *itemDateLabel = (UILabel*)[cell viewWithTag:102];
    
    itemDateLabel.text = [[DataStore sharedStore] differenceInDaysfromTimeStamp:item.timeStamp];
    
    UILabel *itemCategoryLabel = (UILabel*)[cell viewWithTag:103];
    
    itemCategoryLabel.text = [NSString stringWithFormat:@"Category: %@",item.category];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
