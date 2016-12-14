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
   if (self.feed) {
        self.titleLabel.text = [self.feed valueForKey:@"title"];
        self.dateLabel.text = [self.feed valueForKey:@"date"];
        self.timeLabel.text = [self.feed valueForKey:@"time"];
        self.descriptionLabel.text = [self.feed valueForKey:@"description"];
       NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [self.feed valueForKey:@"thumb"]]];

       
       NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
           if (data) {
               UIImage *image = [UIImage imageWithData:data];
               if (image) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView.image = image;
                   });
               }
           }
       }];
       [task resume];
       
    }
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
