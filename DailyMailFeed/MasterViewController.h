//
//  MasterViewController.h
//  DailyMailFeed
//
//  Created by emmanuel on 2016-12-10.
//  Copyright © 2016 Prosper Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController


@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) IBOutlet UITableView *rssMasterTableView;

@end

