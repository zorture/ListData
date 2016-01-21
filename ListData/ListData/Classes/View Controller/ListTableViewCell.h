//
//  ListTableViewCell.h
//  ListData
//
//  Created by Kanwar Zorawar Singh Rana on 1/18/16.
//  Copyright © 2016 Kanwar Zorawar Singh Rana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListDataModel.h"
#import "ListBizAdapter.h"
@interface ListTableViewCell : UITableViewCell

- (void)updateCellWithData:(ListDataModel*)model BizAdapter:(ListBizAdapter*)listBA;
@end
