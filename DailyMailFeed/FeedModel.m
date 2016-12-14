//
//  FeedModel.m
//  DailyMailFeed
//
//  Created by emmanuel on 2016-12-12.
//  Copyright © 2016 Prosper Development. All rights reserved.
//

#import "FeedModel.h"


@interface FeedModel () {
    NSXMLParser *xmlParser;
}
@end
@implementation FeedModel

NSXMLParser *xmlParser;

NSMutableArray *feeds;
NSMutableDictionary *feedItem;
NSMutableString *feedTitle;
NSMutableString *feedOrgIndex;
NSMutableString *feedUrl;
NSMutableString *feedDate;
NSMutableString *feedTime;
NSMutableString *feedThumbUrl;
NSMutableString *feedDescription;
NSMutableString *feedHasBeenMarkedAsRead;

NSString *element;


- (void) fetchFeeds:(void(^)(NSMutableArray*))handler
{
    
    
    feeds    = [[NSMutableArray alloc] init];
    
    
    NSURL *rssUrl = [NSURL URLWithString:@"http://www.dailymail.co.uk/sport/index.rss"];
    
    xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:rssUrl];
    
    // make a copy of the handler
    _completionHandler = [handler copy];
    
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:NO];
    
    [xmlParser parse];
    
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    // debug
    NSLog(@"element: %@", elementName);
    
    // alloc the diffrent objects in a feed item
    
    if ([element isEqualToString:@"item"]) {
        
        feedItem    = [[NSMutableDictionary alloc] init];
        feedTitle   = [[NSMutableString alloc] init];
        feedDate   = [[NSMutableString alloc] init];

        feedUrl   = [[NSMutableString alloc] init];
        feedDescription = [[NSMutableString alloc] init];
        feedHasBeenMarkedAsRead = [[NSMutableString alloc] init];
        feedThumbUrl =[[NSMutableString alloc] init];
    }
    
    // alloc the attribute url from the media:thumbnail tag
    
    if ([element isEqualToString:@"media:thumbnail"]) {
        
        feedThumbUrl = [attributeDict objectForKey:@"url"];
    }
    
}


// when parser ends an element
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    
    // check if we reach the end of item object
    
    if ([elementName isEqualToString:@"item"]) {
        
        
        // remove linebreaks
        feedTitle = [self trimLineBreaks:feedTitle];
        feedDescription = [self trimLineBreaks:feedDescription];
        feedDate = [self trimLineBreaks:feedDate];
        
        //format time and date
        
        
            // Convert string to date object
        NSDateFormatter *dateInputFormat = [[NSDateFormatter alloc] init];
        [dateInputFormat setDateFormat:@"EE, d LLLL yyyy HH:mm:ss Z"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"HH:mm:ss"];
        
        NSLog(@"FeedDate: %@",feedDate);
        
        
        NSDate *aDate = [dateInputFormat dateFromString:feedDate];
        
         
         feedDate = [[dateFormat stringFromDate:aDate] mutableCopy];
         feedTime = [[timeFormat stringFromDate:aDate] mutableCopy];
        
        
        
        // create new feed item
        
        [feedItem setObject:feedTitle forKey:@"title"];
        [feedItem setObject:feedUrl forKey:@"link"];
        [feedItem setObject:feedDescription forKey:@"description"];
        [feedItem setObject:feedThumbUrl forKey:@"thumb"];
             [feedItem setObject:feedDate forKey:@"date"];
             [feedItem setObject:feedTime forKey:@"time"];
        [feedItem setObject:@"NO" forKey:@"hasBeenMarkedAsRead"];
        [feedItem setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[feeds count]] forKey:@"orginalIndex"];
        
        // add it to the collection
        
        [feeds addObject:[feedItem mutableCopy]];
        
    }
    
}

-(NSMutableString*)trimLineBreaks:(NSMutableString*)mutableString {
    NSString *string = mutableString;
    
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    return [string mutableCopy];
}



- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    NSLog(@"element fc %@", element);
    
    
    
    if ([element isEqualToString:@"title"]) [feedTitle appendString:string];
    
    if ([element isEqualToString:@"link"]) [feedUrl appendString:string];
    
    if ([element isEqualToString:@"pubDate"]) [feedDate appendString:string];
    
    
    
    if ([element isEqualToString:@"description"]) [feedDescription appendString:string];
    
    
    
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    // Call completion handler.
    _completionHandler(feeds);
    
    
}


// for debugging error in xml

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSString * errorString = [NSString stringWithFormat:@"Unable to download story feed from web site (Error code %li )", (long)[parseError code]];
    NSLog(@"error parsing XML: %@", errorString);
    
    NSLog(@"NotPARSED");
}



@end
