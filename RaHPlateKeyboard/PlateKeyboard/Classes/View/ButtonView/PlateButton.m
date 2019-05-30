//
// Created by CageLin on 2018/9/12.
//

#import "PlateButton.h"
#import "UIImage+PlateKeyboard.h"

#define MDColor(r, g, b) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1]

#define IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)


enum {
    MDKBImageLeft = 0,
    MDKBImageInner,
    MDKBImageRight,
    MDKBImageMax
};

@implementation PlateButton

+ (PlateButton *)createKeys {
    PlateButton *btn = [PlateButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = true;
    if (!IS_IPAD) {
        btn.userInteractionEnabled = false;
    }
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.textColor = MDColor(0, 0, 0);
    [btn setTitleColor:MDColor(0, 0, 0) forState:UIControlStateNormal];
    return btn;
}

+ (PlateButton *)createKeysWithBackgroundColor {
    PlateButton *btn = [PlateButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = true;
    if (!IS_IPAD) {
        btn.userInteractionEnabled = false;
    }
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.textColor = MDColor(0, 0, 0);
    [btn setTitleColor:MDColor(0, 0, 0) forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1]];
    return btn;
}

+ (PlateButton *)createKeysWithBackgroundImage:(UIImage *)image {
    PlateButton *btn = [PlateButton buttonWithType:UIButtonTypeCustom];
    btn.exclusiveTouch = true;
    if (!IS_IPAD) {
        btn.userInteractionEnabled = false;
    }
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.textColor = MDColor(0, 0, 0);
    [btn setTitleColor:MDColor(0, 0, 0) forState:UIControlStateNormal];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    return btn;
}

//更新字符和大小写状态
- (void)updateChar:(nullable NSString *)chars shift:(BOOL)shift {
    if (chars.length > 0) {
        _chars = [chars copy];
        [self updateTitleState];
    }
}

- (void)updateTitleState {
    // 转大小写
//    NSString *tmp = self.isShift ? [self.chars uppercaseString] : [self.chars lowercaseString];
    NSString *tmp = self.chars;

    if ([[NSThread currentThread] isMainThread]) {
        [self setTitle:tmp forState:UIControlStateNormal];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setTitle:tmp forState:UIControlStateNormal];
        });
    }
}

// shift方法
- (void)shift:(BOOL)shift {
    if (shift == self.isShift) {
        return;
    }
    self.isShift = shift;
    [self updateTitleState];
}


@end
