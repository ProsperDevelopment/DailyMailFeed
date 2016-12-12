//
//  MasterViewController.h
//  DailyMailFeed
//
//  Created by emmanuel on 2016-12-10.
//  Copyright © 2016 Prosper Development. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DetailViewController;

@interface MasterViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *feedMasterTableView;


@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) IBOutlet UITableView *feedTableView;

@end

