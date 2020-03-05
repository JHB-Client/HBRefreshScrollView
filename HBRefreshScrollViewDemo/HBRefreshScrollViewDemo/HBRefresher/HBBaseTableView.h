//
//  HBBaseTableView.h
//  HBRefreshScrollViewDemo
//
//  Created by admin on 2020/3/5.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HBRefresher;
NS_ASSUME_NONNULL_BEGIN

@interface HBBaseTableView : UITableView
@property (nonatomic, strong) HBRefresher *refresher;
@end

NS_ASSUME_NONNULL_END
