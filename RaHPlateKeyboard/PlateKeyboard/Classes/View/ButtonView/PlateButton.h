//
// Created by CageLin on 2018/9/12.
//

#import <UIKit/UIKit.h>

@interface PlateButton : UIButton

/** 按钮的标题 */
@property(nonatomic, copy, nullable) NSString *chars;
/** 是否为shift状态 */
@property(nonatomic, assign) BOOL isShift;

@property (nonatomic, assign) BOOL isDisable;

/**
 * @return 字母键盘按键的实例
 */
+ (PlateButton *)createKeysWithBackgroundColor;

/**
 * @param image 传入当作背景图
 */
+ (PlateButton *)createKeysWithBackgroundImage:(UIImage *)image;

/**
 * 创建按钮
 */
+ (PlateButton *)createKeys;

/**
 * shift按钮的方法
 * @param shift 是否l为shift状态
 */
- (void)shift:(BOOL)shift;

- (void)touchable:(BOOL)touch;

/**
 * 更新按钮的标题
 * @param chars 传入的按钮标题
 * @param shift 是否点击了shift按钮
 */
- (void)updateChar:(nullable NSString *)chars shift:(BOOL)shift;

@end
