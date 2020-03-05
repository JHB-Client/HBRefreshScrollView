//
//  HBRefresher.m
//  HBRefreshScrollViewDemo
//
//  Created by admin on 2020/3/5.
//  Copyright © 2020 admin. All rights reserved.
//

#import "HBRefresher.h"
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
static CGFloat lastOffsetY = 0;
static BOOL naviBarHidden = false;
@interface HBRefresher()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL refreshAction;
@end

@implementation HBRefresher

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor blueColor];
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview && [newSuperview isKindOfClass:UIScrollView.class]) {
        self.scrollView = (UIScrollView *)newSuperview;
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        //
        UIViewController *vctr = [self currentViewController];
        naviBarHidden = vctr.navigationController.navigationBar.hidden;
        
        NSLog(@"----fffffffff--:%d", naviBarHidden);
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    UIScrollView *scrollView = self.scrollView;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (scrollView.dragging) {
        if (lastOffsetY > offsetY) { // 向下拖动
            
        } else if(lastOffsetY < offsetY){ // 向上拖动
            
        }
        lastOffsetY = offsetY;
    }
    
    if (scrollView.decelerating) { //在减速
        if (scrollView.contentOffset.y < - 164) {
            [UIView animateWithDuration:0.25 animations:^{
                scrollView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
            } completion:^(BOOL finished) { // 下拉刷新
                [self refreshInnerAction];
            }];
        }
    }
}
- (void)dealloc{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}
#pragma mark -- 实例方法
- (void)beginRefresh {
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    } completion:^(BOOL finished) {
        [self refreshInnerAction];
    }];
}

- (void)refreshInnerAction {
    if (self.scrollView != nil) {
        if (self.refreshDataBlock && self.target == nil) {
            self.refreshDataBlock();
        }
        if (self.refreshDataBlock == nil && self.target != nil) {
            SuppressPerformSelectorLeakWarning(
                                               [self.target performSelector:self.refreshAction];
                                               );
        }
        if (self.refreshDataBlock != nil && self.target != nil) {
            @throw [NSException exceptionWithName:@"YTRefresher duplicates action" reason:@"target action and block can only keep one" userInfo:nil];
        }
    }
}
- (void)endRefresh {
    if (self.scrollView == nil) return;
    [UIView animateWithDuration:0.55 animations:^{
        self.scrollView.contentInset = UIEdgeInsetsZero;
    }];
}

- (void)addTarget:(id)target refreshAction:(SEL)action {
    if (self.scrollView == nil) return;
    if (target && action != NULL) {
        _target = target;
        _refreshAction = action;
    }
}

#pragma mark -- 辅助方法
- (UIViewController *)currentViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
