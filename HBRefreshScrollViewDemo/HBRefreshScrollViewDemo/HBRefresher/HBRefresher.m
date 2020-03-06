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
static BOOL hasNavigationBar;
static BOOL hasStatusBar;
@interface HBRefresher() <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL refreshAction;
@property (nonatomic, assign) CGFloat refreshOffsetY;
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
        self.scrollView.delegate = self;
        UIViewController *vctr = [self currentViewController:newSuperview];
        hasNavigationBar = [self hasNavigationBar:vctr];
        
        CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
        hasStatusBar = !CGRectEqualToRect(statusBarFrame, CGRectZero);
        
        self.refreshOffsetY = (self.bounds.size.height + (hasNavigationBar == true ? (hasStatusBar == true ? 64 : 44) : 0));
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < - self.refreshOffsetY) {
        [UIView animateWithDuration:0.25 animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
        } completion:^(BOOL finished) { // 下拉刷新
            [self refreshInnerAction];
        }];
    }
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
- (UIViewController *)currentViewController:(UIView *)superView {
    for (UIView* next = superView; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (BOOL)hasNavigationBar:(UIViewController *)VCtr{
    if (VCtr.navigationController == nil) {
        return false;
    }
    
    BOOL hasNavigationBar1 = [[UIApplication sharedApplication].keyWindow.rootViewController isEqual:VCtr.navigationController];
    
    BOOL hasNavigationBar2 = [[UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers containsObject:VCtr.navigationController];
    if ((hasNavigationBar1 || hasNavigationBar2) == true) {
        return !VCtr.navigationController.navigationBar.hidden;
    } else {
        return false;
    }
}
@end
