//
//  CustomAnimator.h
//  PushAndPopDemo
//
//  Created by mantou on 15/12/2.
//  Copyright © 2015年 tq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, weak) UITableViewCell *selectionCell;
@property (nonatomic, assign) UINavigationControllerOperation navigationOperation;

@end
