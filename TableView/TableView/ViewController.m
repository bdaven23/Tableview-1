//
//  ViewController.m
//  TableView
//
//  Created by Sunayna Jain on 10/26/13.
//  Copyright (c) 2013 LittleAuk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) UISearchDisplayController *searchController;


@end

@implementation ViewController


-(void)searchBarSetup {
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    self.tableView.tableHeaderView = self.searchBar;
    
    CGPoint offset = CGPointMake(0, self.searchBar.frame.size.height);
    
    self.tableView.contentOffset = offset;
    
    self.searchController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar
                                                             contentsController:self];
    
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(preferredContentSizeChanged:)
                                                name:UIContentSizeCategoryDidChangeNotification
                                              object:nil];

    
    [self searchBarSetup];
    
    self.searchResults = [[NSMutableArray alloc]initWithCapacity:[DataStore sharedStore].fetchedResultsController.fetchedObjects.count];
    
    if ([[DataStore sharedStore].fetchedResultsController.fetchedObjects count]==0)
    {
    
    [[DataStore sharedStore] addingTestData];
        
    }
    
    Item *item =[[DataStore sharedStore].fetchedResultsController.fetchedObjects objectAtIndex:0];
    
    [[DataStore sharedStore] differenceInDaysfromTimeStamp:item.timeStamp];
}

-(void)preferredContentSizeChanged:(NSNotification*)notification {
    
    [self.view setNeedsLayout];
    
    [self.tableView reloadData];
}

#pragma mark-TableView methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView ==self.tableView){
    
    return [DataStore sharedStore].fetchedResultsController.fetchedObjects.count;
    } else {
       return self.searchResults.count;
    }
    
}

-(void)cellSetUpForItem:(Item*)item andCell:(UITableViewCell*)cell ForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    UIImageView *itemImageView = (UIImageView*)[cell viewWithTag:100];
    
    NSString *imageName = [NSString stringWithFormat:@"%@", item.name];
    
    NSString *image = [imageName stringByAppendingString:@".jpg"];
    
    itemImageView.image = [UIImage imageNamed:image];
    
    UILabel *itemNameLabel = (UILabel*)[cell viewWithTag:101];
    
    itemNameLabel.text = item.name;
    
    UILabel *itemDateLabel = (UILabel*)[cell viewWithTag:102];
    
    itemDateLabel.text = [[DataStore sharedStore] differenceInDaysfromTimeStamp:item.timeStamp];
    
    UILabel *itemCategoryLabel = (UILabel*)[cell viewWithTag:103];
    
    itemCategoryLabel.text = [NSString stringWithFormat:@"Category: %@",item.category];
}


-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (tableView ==self.tableView){
    
    Item *item = [[DataStore sharedStore].fetchedResultsController objectAtIndexPath:indexPath];
                
        [self cellSetUpForItem:item andCell:cell ForRowAtIndexPath:indexPath];
        
    } else {
        Item *item = [self.searchResults objectAtIndex:indexPath.row];
        
        
        [self cellSetUpForItem:item andCell:cell ForRowAtIndexPath:indexPath];
        
    }
    
    return cell;
}

#pragma mark - search display methods 

-(void)filterItemForString:(NSString*)string {
    [self.searchResults removeAllObjects];
    
    DataStore *myStore = [DataStore sharedStore];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:myStore.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains [cd] %@", string];
    
    fetchRequest.predicate = predicate;
    
    NSError *error = nil;

    NSArray *resultsArray = [myStore.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    [self.searchResults addObjectsFromArray:resultsArray];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterItemForString:searchString];
    
    return YES;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Item *item = [[DataStore sharedStore].fetchedResultsController objectAtIndexPath:indexPath];
    
    UIFont *nameLabelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    CGSize nameLabelFontSize = [[item name] sizeWithAttributes:[NSDictionary dictionaryWithObject:nameLabelFont forKey:NSFontAttributeName]];
    
    UIFont *dateLabelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    CGSize dateLAbelFontSize = [[item dateAdded] sizeWithAttributes:[NSDictionary dictionaryWithObject:dateLabelFont forKey:NSFontAttributeName]];
    
    UIFont *categoryLabelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    
    CGSize categoryLabelFontSize = [[item category] sizeWithAttributes:[NSDictionary dictionaryWithObject:categoryLabelFont forKey:NSFontAttributeName]];
    
    CGFloat padding = 25;
    
    CGFloat totalHeight = padding + nameLabelFontSize.height+ dateLAbelFontSize.height+categoryLabelFontSize.height+    padding;
    
    return totalHeight;
}

@end
