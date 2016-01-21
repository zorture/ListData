//
//  APICacheData.m
//  ListData
//
//  Created by Kanwar Zorawar Singh Rana on 1/20/16.
//  Copyright © 2016 Kanwar Zorawar Singh Rana. All rights reserved.
//

#import "APICacheData.h"

@implementation APICacheData

- (instancetype)init{
    self = [super init];
    if (self) {
        self.mCache = [[NSCache alloc] init];
    }
    return self;
}
@end
