
#import "MasterViewController.h"
#import "FeedTableViewCell.h"
#import "DetailViewController.h"
#import "FeedModel.h"

@interface MasterViewController () {
    NSXMLParser *xmlParser;
    
    NSMutableArray *feeds;
    NSMutableArray *displayFeeds;
    NSString *element;
    NSString *searchQuery;
    UIColor *colorHasBeenMarkedAsRead;
    
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
    // init searchbar
    [self.searchBar setShowsScopeBar:YES];
    self.searchBar.delegate = self;
    

    // setup the feed model
    FeedModel *feedModel = [FeedModel alloc];
    
    // fetch the feeds from RSS feed
    [feedModel fetchFeeds:^(NSMutableArray* feedsFetched) {
        feeds = feedsFetched;
        displayFeeds = [feeds mutableCopy];
        // refresh the tableview
        [self.tableView reloadData];
    }];
    
    
    // init table
    self.feedMasterTableView.allowsMultipleSelectionDuringEditing = NO;
    
    [self.feedMasterTableView setDelegate:self];
    [self.feedMasterTableView setDataSource:self];
    
    
    // set markedAsRead color
    
    colorHasBeenMarkedAsRead  = [UIColor colorWithRed:205.0f/255.0f
                      green:231.0f/255.0f
                       blue:180.0f/255.0f
                      alpha:1.0f];
    

    
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
    return displayFeeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // get this cells feedData
    NSMutableDictionary *feedData = [displayFeeds objectAtIndex:indexPath.row];
    
    if (!cell) {
        cell = [[FeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    // set title
    cell.feedTitle.text = [feedData objectForKey: @"title"];
    
    
    // marked as read with grey background
    if ([[feedData objectForKey: @"hasBeenMarkedAsRead"] isEqualToString:@"YES"]) {
        [cell setBackgroundColor:colorHasBeenMarkedAsRead]; } else {
             [cell setBackgroundColor:[UIColor whiteColor]];
        }
    
    
    
    
    // get thumb image
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [feedData objectForKey: @"thumb"]]];
    
    
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
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES becouse we wan't specified item to be editable.
    return YES;
}


// Show detail
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}


// Editing the cells
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // remove
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // TODO remove by title instead
        // remove it from our feed collection
        
        NSLog(@"orginalIndex %@",[[displayFeeds objectAtIndex:indexPath.row] objectForKey:@"orginalIndex"] );
        NSLog(@"orginalIndex int %i",[[[displayFeeds objectAtIndex:indexPath.row] objectForKey:@"orginalIndex"] intValue]);
        
        [feeds removeObject:[displayFeeds objectAtIndex:indexPath.row]];
        
        
        [displayFeeds removeObjectAtIndex:indexPath.row];
        // remove and animate the cell
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:(indexPath), nil] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}


// method for execute search

- (void)searchFeeds {
    
    
    // setup a new array to store the results in
    NSMutableArray *displayFeedsNew = [[NSMutableArray alloc] init];
    
    
    // itarete our array of feeds
    for (int i = 0; i < [feeds count]; i++)
    {
        NSString *title = [[feeds objectAtIndex:i] objectForKey: @"title"];
        
        // make the search case insensitive
        title = [title lowercaseString];
        searchQuery = [searchQuery lowercaseString];
        if ([title rangeOfString:searchQuery].location != NSNotFound) {
            [displayFeedsNew addObject:[feeds objectAtIndex:i]];
        }
        
    }
    
    // set the search results to be displayed
    
    displayFeeds = displayFeedsNew;
    
    
    
    
    // update the table
    [self.tableView reloadData];
    
    
}


-(void)resetSearch {
    
    displayFeeds = feeds;
    
    // update the table
    [self.tableView reloadData];
    
}


// searchbar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"Text change - %d",isSearching);
    
    
    if([searchText length] != 0) {
        isSearching = YES;
        searchQuery = searchText;   }
    else {
        isSearching = NO;
        [self resetSearch];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [self searchFeeds];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        // TODO
        
        //   NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //    NSString *string = [feeds[indexPath.row] objectForKey: @"link"];
        
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *destViewController = segue.destinationViewController;
        destViewController.feed = [displayFeeds objectAtIndex:indexPath.row];
        
        [[self.tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:colorHasBeenMarkedAsRead];
        
        [[displayFeeds objectAtIndex:indexPath.row] setValue:@"YES" forKey:@"hasBeenMarkedAsRead"];
        
        
        [segue destinationViewController];
        
    }
}

@end
