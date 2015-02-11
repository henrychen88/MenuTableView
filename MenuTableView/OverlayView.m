//
//  OverlayView.m
//  MenuTableView
//
//  Created by Henry on 15-2-11.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import "OverlayView.h"

@implementation OverlayView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return [self.delegate overlayView:self didHitTest:point withEvent:event];
}

@end
