//
//  MenuCell.m
//  MenuTableView
//
//  Created by Henry on 15-2-11.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import "MenuCell.h"

@interface MenuCell ()<UIGestureRecognizerDelegate>
@property(nonatomic, assign) CGFloat memuWidth;
@property(nonatomic, assign) CGFloat panGestureInitialX;
@end

@implementation MenuCell

#pragma mark - 初始化

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        if (height > 0) {
            CGRect frame = self.frame;
            frame.size.height = height;
            self.frame = frame;
        }
        [self setupContent];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithReuseIdentifier:reuseIdentifier height:0];
}

- (void)setupContent
{
    self.editable = YES;
    self.menusHidden = YES;
    self.shouldShowMenus = NO;
    self.animationDuration = 0.3;
    self.bounceValue = 0;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.menuView];
    [self.contentView addSubview:self.disPlayView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    panGesture.delegate = self;
    [self.disPlayView addGestureRecognizer:panGesture];
}

- (void)cellButtonAction:(UIButton *)button
{
    [self setMenusHidden:YES animated:YES finishBlock:nil];
    [self.delegate menuCell:self didSelectedButton:button];
}

#pragma mark - 

- (UIView *)disPlayView
{
    if (!_disPlayView) {
        _disPlayView = [[UIView alloc]initWithFrame:self.bounds];
        _disPlayView.backgroundColor = [UIColor orangeColor];
    }
    return _disPlayView;
}

- (UIView *)menuView
{
    if (!_menuView) {
        CGRect frame = self.bounds;
        frame.origin.x = frame.size.width - 80;
        frame.size.width = 80;
        _menuView = [[UIView alloc]initWithFrame:frame];
        _menuView.backgroundColor = [UIColor redColor];
    }
    return _menuView;
}

- (CGFloat)memuWidth
{
    return CGRectGetWidth(self.menuView.frame);
}

- (void)setMenusHidden:(BOOL)hidden animated:(BOOL)animated finishBlock:(void (^)(void))finishBlock
{
    if (self.selected) {
        [self setSelected:NO animated:NO];
    }
    
    CGRect frame = self.bounds;
    if (!hidden) {
        frame.origin.x = -self.memuWidth;
    }
    
    [UIView animateWithDuration:(animated ? self.animationDuration : 0)
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.disPlayView.frame = frame;
                     } completion:^(BOOL finished) {
                         self.menusHidden = hidden;
                         self.shouldShowMenus = !hidden;
                         
                         if (!hidden) {
                             [self.delegate menuCellDidShow:self];
                         }else{
                             [self.delegate menuCellDidHide:self];
                         }
                         
                         if (finishBlock) {
                             finishBlock();
                         }
    }];
}

#pragma mark - 父类方法

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupContent];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self setMenusHidden:YES animated:NO finishBlock:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 手势处理

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    if (![recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return;
    }
    
    CGPoint currentTouchPoint = [recognizer locationInView:self.contentView];
    CGFloat currentTouchPositionX = currentTouchPoint.x;
    CGPoint velocity = [recognizer velocityInView:self.contentView];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.panGestureInitialX = currentTouchPositionX;
        if (velocity.x > 0) {
            [self.delegate menuCellWillHide:self];
        }else{
            [self.delegate menuCellWillShow:self];
        }
        NSLog(@"UIGestureRecognizerStateBegan");
    }else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint velocity = [recognizer velocityInView:self.contentView];
        if (self.menusHidden || (velocity.x > 0 || [self.delegate shouldShowMenus:self])) {
            
            if (self.selected) {
                [self setSelected:NO animated:NO];
            }
            CGFloat panAmount = currentTouchPositionX - self.panGestureInitialX;
            self.panGestureInitialX = currentTouchPositionX;
            CGFloat minOriginX = -self.memuWidth - self.bounceValue;
            CGFloat maxOriginX = 0;
            CGFloat originX = CGRectGetMinX(self.disPlayView.frame) + panAmount;
            NSLog(@"panAmount : %f  originX : %f", panAmount, originX);
            if (originX > maxOriginX) {
                originX = maxOriginX;
            }
            if (originX < minOriginX) {
                originX = minOriginX;
            }
            
            if ((originX < -0.5 * self.memuWidth && velocity.x < 0) || (velocity.x < -100)) {
                self.shouldShowMenus = YES;
            }
            
            CGRect frame = self.disPlayView.frame;
            frame.origin.x = originX;
            NSLog(@"originX : %f", originX);
//            self.disPlayView.frame = frame;
            
            CGPoint point = [recognizer translationInView:self.disPlayView];
            self.disPlayView.center = CGPointMake(self.disPlayView.center.x + point.x, self.disPlayView.center.y);
            [recognizer setTranslation:CGPointMake(0, 0) inView:self.disPlayView];
        }
        NSLog(@"UIGestureRecognizerStateChanged");
    }else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateFailed) {
        [self setMenusHidden:!self.shouldShowMenus animated:YES finishBlock:nil];
        NSLog(@"UIGestureRecognizerStateEnded");
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return YES;
    }
    
    if (self.menusHidden) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return fabs(translation.x) > fabs(translation.y);
    }else{
        return NO;
    }
}

@end
