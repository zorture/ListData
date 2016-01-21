//
//  ListTableViewCell.m
//  ListData
//
//  Created by Kanwar Zorawar Singh Rana on 1/18/16.
//  Copyright © 2016 Kanwar Zorawar Singh Rana. All rights reserved.
//

#import "ListTableViewCell.h"

@interface ListTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@end

@implementation ListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(ListDataModel*)model BizAdapter:(ListBizAdapter*)listBA{
    
    [self.mTitleLabel setText:model.mTitle];
    [self.mImageView setImage:model.mImage];

    UIImage* image = [listBA.mCacheData.mCache objectForKey:model.mId];
    if (!image) {
        [listBA fetchImageWithURL:model.mImageUrl Image:^(UIImage *image) {
            [listBA.mCacheData.mCache setObject:image forKey:model.mId];
            dispatch_async(dispatch_get_main_queue(), ^(){
                [self.mImageView setImage:image];
            });
        }];
    }
    else
        [self.mImageView setImage:image];

}

@end
