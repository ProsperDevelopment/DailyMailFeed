//
//  FeedTableViewCell.h
//  DailyMailFeed
//
//  Created by emmanuel on 2016-12-11.
//  Copyright © 2016 Prosper Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *thumbImage;
@property (strong, nonatomic) IBOutlet UILabel *feedTitle;
@property (strong, nonatomic) IBOutlet UILabel *feedDescription;

@end
