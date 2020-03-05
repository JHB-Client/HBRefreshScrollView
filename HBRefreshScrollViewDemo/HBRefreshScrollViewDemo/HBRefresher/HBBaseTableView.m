//
//  HBBaseTableView.m
//  HBRefreshScrollViewDemo
//
//  Created by admin on 2020/3/5.
//  Copyright © 2020 admin. All rights reserved.
//

#import "HBBaseTableView.h"
#import "HBRefresher.h"
@implementation HBBaseTableView
- (void)setRefresher:(HBRefresher *)refresher {
    if (_refresher == nil) {
        [self addSubview:refresher];
    }
    _refresher = refresher;
}

- (void)didAddSubview:(UIView *)subview {
    if(subview && [subview isKindOfClass:HBRefresher.class]) {
        _refresher = (HBRefresher *)subview;
    }
}

@end
