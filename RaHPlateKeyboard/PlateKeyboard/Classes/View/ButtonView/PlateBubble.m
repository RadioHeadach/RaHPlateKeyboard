//
//  PlateBubble.m
//  testAPP
//
//  Created by huanyu.li on 2017/9/12.
//  Copyright © 2017年 huanyu.li. All rights reserved.
//

#import "PlateBubble.h"
#import "Masonry.h"

#define IS_IPHONE6 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 667 || [UIScreen mainScreen].bounds.size.width == 667)
#define IS_IPHONE6_PLUS ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 736 || [UIScreen mainScreen].bounds.size.width == 736)
#define AUTO_ADAPT_SIZE_VALUE(iPhone4_5, iPhone6, iPhone6plus) (IS_IPHONE6 ? iPhone6 : (IS_IPHONE6_PLUS ? iPhone6plus : iPhone4_5))

@interface PlateBubble ()




@end

@implementation PlateBubble

#pragma mark - =============生命周期================

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setBubbleUI];
    }
    return self;
}

- (void)setBubbleUI
{
    //------  添加背景和文字  ------//
    [self addSubview:self.imgageView];
    [self addSubview:self.titleLabel];
    
    [_imgageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_offset(0);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.top.mas_offset(8);
    }];
}

/**
 显示气泡
 
 @param button 按钮
 */
- (UIView *)showFromButton:(UIButton *)button
{
    self.titleLabel.text = button.currentTitle;

    CGRect btnFrame = [button convertRect:button.bounds toView:nil];
    
    CGFloat popViewW = btnFrame.size.width * 2.48;

    CGFloat popViewH = AUTO_ADAPT_SIZE_VALUE(100, 108, 118);
    CGFloat popViewX = 0;
    
    CGFloat popViewY = btnFrame.origin.y - (popViewH - btnFrame.size.height);

    if ([button.currentTitle isEqualToString:@"京"] || [button.currentTitle isEqualToString:@"浙"] || [button
            .currentTitle isEqualToString:@"川"] || [button.currentTitle
            isEqualToString:@"1"] || [button.currentTitle isEqualToString:@"Q"] || [button.currentTitle
            isEqualToString:@"A"])
    {
        // 按钮在左边的情形
        self.imgageView.image = [self setImage:[UIImage imageNamed:@"plate-keyboard_resource_keyboard_pop_left"]
                toColor:[UIColor colorWithRed:146 / 255.0
                                        green:146 / 255.0
                                         blue:146 / 255.0
                                        alpha:1]] ;
        popViewX = btnFrame.origin.x - 4;
    }
    else if ([button.currentTitle isEqualToString:@"苏"] || [button.currentTitle isEqualToString:@"琼"] || [button.currentTitle isEqualToString:@"新"] || [button.currentTitle isEqualToString:@"0"] || [button.currentTitle isEqualToString:@"P"] || [button.currentTitle isEqualToString:@"L"])
    {
        // 按钮在右边的情形
        self.imgageView.image = [self setImage:[UIImage imageNamed:@"plate-keyboard_resource_keyboard_pop_right"]
                                       toColor:[UIColor colorWithRed:146 / 255.0
                                                               green:146 / 255.0
                                                                blue:146 / 255.0
                                                               alpha:1]] ;
        popViewX = btnFrame.origin.x + btnFrame.size.width - btnFrame.size.width * 2.3;
        
    }
    else
    {
        // 按钮在中间部分
        self.imgageView.image = [self setImage:[UIImage imageNamed:@"plate-keyboard_resource_keyboard_pop"]
                                       toColor:[UIColor colorWithRed:146 / 255.0
                                                               green:146 / 255.0
                                                                blue:146 / 255.0
                                                               alpha:1]] ;
        popViewX = btnFrame.origin.x - (popViewW - btnFrame.size.width) * 0.5;
    }
    
    CGRect frame = CGRectMake(popViewX, popViewY, popViewW, popViewH);
    
    self.frame = frame;

    return self;
}

#pragma mark - setter and getter
- (UIImageView *)imgageView
{
    if (!_imgageView)
    {
        _imgageView = [[UIImageView alloc] init];
    }
    return _imgageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:30.f];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

/**
 * 纯色化图片
 * @param image 源图片
 * @param color 目标颜色
 * @return 返回UIImage
 * Special Thanks to WangWL
 */
- (UIImage *)setImage:(UIImage *)image toColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    //没有这部分图片会跳动
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);

    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return colorImage;
}

@end
