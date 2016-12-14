//
//  DetailViewController.m
//  DailyMailFeed
//
//  Created by emmanuel on 2016-12-10.
//  Copyright © 2016 Prosper Development. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)configureView {
    // Update the user in   terface for the detail item.
 /*   if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }  */
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(NSDate *)newDetailItem {

    /*
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
       */
    
        // Update the view.
        [self configureView];
    // }
}


@end
