//
//  MenuCell.h
//  MenuTableView
//
//  Created by Henry on 15-2-11.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuCellDelegate;

@interface MenuCell : UITableViewCell
/**
 *  显示内容的View
 */
@property(nonatomic, strong) UIView *disPlayView;
/**
 *  隐藏的菜单的View
 */
@property(nonatomic, strong) UIView *menuView;
/**
 *  是否可以滑出显示菜单
 */
@property(nonatomic, assign) BOOL editable;
/**
 *  菜单是否隐藏
 */
@property(nonatomic, assign) BOOL menusHidden;
/**
 *  是否应该显示菜单
 */
@property(nonatomic, assign) BOOL shouldShowMenus;
/**
 *  显示/隐藏 菜单的动画时间
 */
@property(nonatomic, assign) CGFloat animationDuration;
/**
 *  弹力
 */
@property(nonatomic, assign) CGFloat bounceValue;

@property(nonatomic, weak) id<MenuCellDelegate> delegate;

/**
 *  自定义初始化方法
 *
 *  @param reuseIdentifier 重用Cell指定的字符串
 *  @param height          cell的高度
 *
 *  @return MenuCell
 */
- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height;

/**
 *  显示或隐藏菜单操作
 *
 *  @param hidden      YES表示隐藏 NO表示显示
 *  @param animated    是否有动画效果
 *  @param finishBlock 动画结束的处理
 */
- (void)setMenusHidden:(BOOL)hidden
              animated:(BOOL)animated
           finishBlock:(void (^)(void))finishBlock;

/**
 *  初始化界面
 */
- (void)setupContent;

/**
 *  隐藏菜单按钮事件
 *
 *  @param button 点击的按钮
 */
- (void)cellButtonAction:(UIButton *)button;

@end

/**
 *  MenuCell委托
 */
@protocol MenuCellDelegate <NSObject>
//状态处理
- (void)menuCellDidHide:(MenuCell *)cell;
- (void)menuCellDidShow:(MenuCell *)cell;
- (void)menuCellWillHide:(MenuCell *)cell;
- (void)menuCellWillShow:(MenuCell *)cell;
- (BOOL)shouldShowMenus:(MenuCell *)cell;
//事件处理
- (void)menuCell:(MenuCell *)cell didSelectedButton:(UIButton *)button;

@end
