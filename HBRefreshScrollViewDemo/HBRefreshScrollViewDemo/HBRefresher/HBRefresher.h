//
//  HBRefresher.h
//  HBRefreshScrollViewDemo
//
//  Created by admin on 2020/3/5.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBRefresher : UIControl
- (void)beginRefresh;
- (void)endRefresh;
@property (nonatomic, copy) void(^refreshDataBlock)(void);
- (void)addTarget:(id)target refreshAction:(SEL)action;
@end

NS_ASSUME_NONNULL_END
