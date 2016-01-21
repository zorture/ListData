//
//  ListDataModel.h
//  ListData
//
//  Created by Kanwar Zorawar Singh Rana on 1/19/16.
//  Copyright © 2016 Kanwar Zorawar Singh Rana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ListDataModel : NSObject

@property(nonatomic, strong) NSString* mTitle;
@property(nonatomic, strong) UIImage* mImage;
@property(nonatomic, strong) NSString* mImageUrl;
@property(nonatomic, strong) NSString* mId;
@end
