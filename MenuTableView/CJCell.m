//
//  CJCell.m
//  MenuTableView
//
//  Created by Henry on 15-2-11.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import "CJCell.h"

@interface CJCell ()
@property(nonatomic, strong) UIButton *deleteButton;
@property(nonatomic, strong) UIButton *followButton;
@end

@implementation CJCell

- (void)setupContent
{
    [super setupContent];
    
    CGRect frame = self.menuView.frame;
    frame.size.width = CGRectGetWidth(self.followButton.frame) + CGRectGetWidth(self.deleteButton.frame);
    frame.origin.x = CGRectGetWidth(self.contentView.frame) - frame.size.width;
    self.menuView.frame = frame;
    
    [self.menuView addSubview:self.followButton];
    [self.menuView addSubview:self.deleteButton];
 
    [self.disPlayView addSubview:self.keyLabel];
}

- (UIButton *)followButton
{
    if (!_followButton) {
        CGRect frame = self.bounds;
        frame.size.width = 100;
        _followButton = [[UIButton alloc]initWithFrame:frame];
        [_followButton setTitle:@"取消关注" forState:UIControlStateNormal];
        [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_followButton setBackgroundColor:[UIColor grayColor]];
        [_followButton setTag:1];
        [_followButton addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followButton;
}

- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        CGRect frame = self.bounds;
        frame.origin.x = CGRectGetWidth(self.followButton.frame);
        frame.size.width = 70;
        _deleteButton = [[UIButton alloc]initWithFrame:frame];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteButton setBackgroundColor:[UIColor redColor]];
        [_deleteButton setTag:2];
        [_deleteButton addTarget:self action:@selector(cellButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UILabel *)keyLabel
{
    if (!_keyLabel) {
        _keyLabel = [[UILabel alloc]initWithFrame:self.disPlayView.bounds];
    }
    return _keyLabel;
}

@end
