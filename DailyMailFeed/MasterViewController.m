
#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
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
    feeds = [[NSMutableArray alloc] init];
  //  NSURL *rssUrl = [NSURL URLWithString:@"http://images.apple.com/main/rss/hotnews/hotnews.rss"];
    NSURL *rssUrl = [NSURL URLWithString:@"http://www.dailymail.co.uk/sport/index.rss"];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:rssUrl];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
    return cell;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    // debug
    NSLog(@"element: %@", elementName);
    
    if ([element isEqualToString:@"item"]) {
        
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    
    // debug
    NSLog(@"element end: %@", elementName);

    
    if ([elementName isEqualToString:@"item"]) {
        
        title = [[title componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];

        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        
        [feeds addObject:[item copy]];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    NSLog(@"element fc %@", element);
    
    if ([element isEqualToString:@"title"]) {
        
        [title appendString:string];
         NSLog(@"title: %@", title);
    } else if ([element isEqualToString:@"link"]) {
        [link appendString:string];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [self.tableView reloadData];
    
}

// for debugging error in xml

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %li )", (long)[parseError code]];
    NSLog(@"error parsing XML: %@", errorString);
  
    NSLog(@"NotPARSED");
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *string = [feeds[indexPath.row] objectForKey: @"link"];
        [segue destinationViewController];
        
    }
}

@end
