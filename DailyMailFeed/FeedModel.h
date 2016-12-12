//
//  FeedModel.h
//  DailyMailFeed
//
//  Created by emmanuel on 2016-12-12.
//  Copyright © 2016 Prosper Development. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedModel : NSObject <NSXMLParserDelegate>

{
    void (^_completionHandler)(NSMutableArray* someParameter);
}

- (void) fetchFeeds:(void(^)(NSMutableArray*))handler;

@end
