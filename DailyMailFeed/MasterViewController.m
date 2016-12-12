
#import "MasterViewController.h"
#import "FeedTableViewCell.h"
#import "DetailViewController.h"
#import "FeedModel.h"

@interface MasterViewController () {
    NSXMLParser *xmlParser;
    
    NSMutableArray *feeds;
    NSMutableDictionary *feedItem;
    NSMutableString *feedTitle;
    NSMutableString *feedUrl;
    NSMutableString *feedThumbUrl;
    NSMutableString *feedDescription;
    Boolean *feedHasBeenMarkedAsRead;
    NSString *element;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // setup the feed model
    FeedModel *feedModel = [FeedModel alloc];
    
    // fetch the feeds from RSS feed
    [feedModel fetchFeeds:^(NSMutableArray* feedsFetched) {
        feeds = feedsFetched;
      
        [self.tableView reloadData];
        
    }];
    
    
      self.feedMasterTableView.allowsMultipleSelectionDuringEditing = NO;

    [self.feedMasterTableView setDelegate:self];
    [self.feedMasterTableView setDataSource:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[FeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.feedTitle.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];

    
    
    cell.feedDescription.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"description"];

    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [[feeds objectAtIndex:indexPath.row] objectForKey: @"thumb"]]];
    NSLog(@"url: %@",[[feeds objectAtIndex:indexPath.row] objectForKey: @"thumb"]);
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    FeedTableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell)
                        updateCell.thumbImage.image = image;
                });
            }
        }
    }];
    [task resume];
   
    
   //  cell.feedDescription.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
    
    
    
    // cell.imageView.thumb =[[feeds objectAtIndex:indexPath.row] objectForKey: @""];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES becouse we wan't specified item to be editable.
    return YES;
}

// Editing the cells
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // remove
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        // remove it from our feed collection
           [feeds removeObjectAtIndex:indexPath.row];
        
        // remove and animate the cell
            
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:(indexPath), nil] withRowAnimation:UITableViewRowAnimationFade];

        
    }
}


     


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        // TODO
        
     //   NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //    NSString *string = [feeds[indexPath.row] objectForKey: @"link"];
        [segue destinationViewController];
        
    }
}

@end
