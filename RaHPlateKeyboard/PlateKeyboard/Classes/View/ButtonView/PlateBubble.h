//
//  PlateBubble.h
//  testAPP
//
//  Created by huanyu.li on 2017/9/12.
//  Copyright © 2017年 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PlateBubble : UIView
/** 背景图 **/
@property (nonatomic, strong) UIImageView *imgageView;

/** 文字标签 **/
@property (nonatomic, strong) UILabel *titleLabel;
/**
 显示气泡
 
 @param button 按钮
 */
- (UIView *)showFromButton:(UIButton *)button;
@end
