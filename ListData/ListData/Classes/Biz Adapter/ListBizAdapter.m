//
//  ListBizAdapter.m
//  ListData
//
//  Created by Kanwar Zorawar Singh Rana on 1/19/16.
//  Copyright © 2016 Kanwar Zorawar Singh Rana. All rights reserved.
//

#import "ListBizAdapter.h"

#define kURL @"https://itunes.apple.com/us/rss/topalbums/limit=40/json"


@interface ListBizAdapter()
@property (nonatomic, strong) NSMutableSet* mData;
@property (nonatomic, weak) APISessionManager* mSessionManager;
@end

@implementation ListBizAdapter

- (instancetype)init{
    self = [super init];
    if (self) {
        self.mSessionManager = [APISessionManager sharedManager];
        self.mData = [[NSMutableSet alloc] init];
        self.mCacheData = [[APICacheData alloc] init];
    }
    return self;
}


- (void)fetchData:(void (^)(NSArray* data))data{
    
    __weak typeof(self) weakSelf = self;
    
    [self.mSessionManager GET:kURL parameters:nil
      success:^(NSURLResponse *response, id responseObject) {
          
          NSArray* tempArray = [[responseObject objectForKey:@"feed"] objectForKey:@"entry"];
          
          for (id entry in tempArray) {
              ListDataModel* listBA = [[ListDataModel alloc] init];
              listBA.mTitle =  [[entry objectForKey:@"title"] objectForKey:@"label"];
              NSArray* imgAr = [entry objectForKey:@"im:image"];
              NSString* imageURL = [imgAr.lastObject objectForKey:@"label"];
              listBA.mImageUrl = imageURL;
              listBA.mId = [[[entry objectForKey:@"id"] objectForKey:@"attributes"] objectForKey:@"im:id"];
              [weakSelf.mData addObject:listBA];
          
            }
          
          data([weakSelf.mData allObjects]);
    } failure:^(NSURLResponse *response, NSError *error) {
        NSLog(@"Failure Loading Data %@", error.description);
    }];
    
    
}
 

- (void)fetchImageWithURL:(NSString*)imageURL IntoModel:(ListDataModel*)listDM{
    
    __weak typeof(ListDataModel*) weakListDM = listDM;
    [self.mSessionManager Download:imageURL parameters:nil success:^(NSURLResponse *response, NSData *responseObject) {
        weakListDM.mImage = [UIImage imageWithData:responseObject];
    } failure:^(NSURLResponse *response, NSError *error) {
        NSLog(@"Failure Loading Image %@", error.description);
    }];
}

- (void)fetchImageWithURL:(NSString*)imageURL Image:(void (^)(UIImage* image))imageData {
    
    [self.mSessionManager Download:imageURL parameters:nil success:^(NSURLResponse *response, NSData *responseObject) {
        imageData([UIImage imageWithData:responseObject]);
    } failure:^(NSURLResponse *response, NSError *error) {
        NSLog(@"Image failure");
    }];
}


@end
