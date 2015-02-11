//
//  MenuTableView.h
//  MenuTableView
//
//  Created by Henry on 15-2-11.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CJCell.h"

#import "OverlayView.h"

@interface MenuTableView : UITableView
/**
 *  显示菜单的Cell
 */
@property(nonatomic, strong) MenuCell *selectCell;
/**
 *  显示菜单的时候是否禁用其他交互
 */
@property(nonatomic, assign) BOOL shouldDisableUserInteractionWhileEditing;

@end
