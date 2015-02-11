//
//  OverlayView.h
//  MenuTableView
//
//  Created by Henry on 15-2-11.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OverlayViewDelegate;

@interface OverlayView : UIView

@property(nonatomic, weak) id<OverlayViewDelegate> delegate;

@end

@protocol OverlayViewDelegate <NSObject>

- (UIView *)overlayView:(OverlayView *)view didHitTest:(CGPoint)point withEvent:(UIEvent *)event;

@end
