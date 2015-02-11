//
//  MenuTableView.m
//  MenuTableView
//
//  Created by Henry on 15-2-11.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import "MenuTableView.h"


@interface MenuTableView ()<MenuCellDelegate, OverlayViewDelegate, UITableViewDataSource, UITableViewDelegate>
/**
 *  是否有一个Cell是显示菜单选项
 */
@property(nonatomic) BOOL cellEditing;
/**
 *  Cell正在进行动画中
 */
@property(nonatomic, assign) BOOL cellAnimationInProgress;

@property(nonatomic, strong) OverlayView *overlayView;
@end

@implementation MenuTableView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 50;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    CJCell *cell = (CJCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CJCell alloc]initWithReuseIdentifier:cellIdentifier height:tableView.rowHeight];
    }
    cell.keyLabel.text = [NSString stringWithFormat:@"Cellxxxxxxxxxxxxxxxxxxx----%ld", (long)indexPath.row];
    cell.delegate = self;
    return cell;
}

- (OverlayView *)overlayView
{
    if (!_overlayView) {
        _overlayView = [[OverlayView alloc]initWithFrame:self.bounds];
        _overlayView.backgroundColor = [UIColor clearColor];
        _overlayView.hidden = YES;
        _overlayView.delegate = self;
        _overlayView.backgroundColor = [UIColor grayColor];
        [self addSubview:_overlayView];
    }
    return _overlayView;
}

- (void)hideMenuAnimated:(BOOL)animated
{
    __block typeof(self) blockSelf = self;
    [self.selectCell setMenusHidden:YES animated:animated finishBlock:^{
        blockSelf.cellEditing = NO;
    }];
}

- (void)setCellEditing:(BOOL)cellEditing
{
    if (_cellEditing == cellEditing) {
        return;
    }
    
    _cellEditing = cellEditing;
    self.scrollEnabled = !cellEditing;
    
    if (cellEditing) {
        self.overlayView.hidden = NO;
        self.selectCell.disPlayView.userInteractionEnabled = !self.shouldDisableUserInteractionWhileEditing;
    }else{
        self.overlayView.hidden = YES;
        [self.overlayView removeFromSuperview];
        self.selectCell = nil;
        self.overlayView = nil;
        self.selectCell.disPlayView.userInteractionEnabled = YES;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView cellForRowAtIndexPath:indexPath] == self.selectCell) {
        [self hideMenuAnimated:YES];
        return NO;
    }
    return YES;
}

- (void)menuCell:(MenuCell *)cell didSelectedButton:(UIButton *)button
{
    NSLog(@"title : %@", button.titleLabel.text);
}

#pragma mark - MenuCellDelegate

- (void)menuCellDidHide:(MenuCell *)cell
{
    self.cellAnimationInProgress = NO;
    self.cellEditing = NO;
}

- (void)menuCellDidShow:(MenuCell *)cell
{
    self.cellAnimationInProgress = NO;
    self.cellEditing = YES;
    self.selectCell = cell;
}

- (void)menuCellWillHide:(MenuCell *)cell
{
    self.cellAnimationInProgress = YES;
}

- (void)menuCellWillShow:(MenuCell *)cell
{
    self.cellAnimationInProgress = YES;
}

- (BOOL)shouldShowMenus:(MenuCell *)cell
{
    return self.cellEditing && !self.cellAnimationInProgress;
}

#pragma mark

- (UIView *)overlayView:(OverlayView *)view didHitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL shouldInterceptTouches = YES;
    CGPoint location = [self convertPoint:point fromView:view];
    CGRect rect = [self convertRect:self.selectCell.frame toView:self];
    shouldInterceptTouches = CGRectContainsPoint(rect, location);
    if (!shouldInterceptTouches) {
        //点击了选择的Cell的外部
        [self hideMenuAnimated:YES];
    }
    return shouldInterceptTouches ? [self.selectCell hitTest:point withEvent:event] : view;
}
@end
