//
//  Item.h
//  TableView
//
//  Created by Sunayna Jain on 10/26/13.
//  Copyright (c) 2013 LittleAuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * dateAdded;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSDate * timeStamp;

@end
