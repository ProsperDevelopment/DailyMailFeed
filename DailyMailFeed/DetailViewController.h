//
//  DetailViewController.h
//  DailyMailFeed
//
//  Created by macbookpro on 2016-12-10.
//  Copyright © 2016 Prosper Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSDate *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

