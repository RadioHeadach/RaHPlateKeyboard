//
//  PlateKeyboardView.m
//  Pods
//
//  Created by CageLin on 2018/11/22.
//

#import "PlateKeyboardView.h"
#import "sys/utsname.h"
#import "PlateButton.h"
#import "NSString+Plate.h"

#define MDSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

@interface PlateKeyboardView ()
@end

@implementation PlateKeyboardView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(1, 1, 1, 1)]) {

    }
    return self;
}

#pragma mark - 布局方法

// 设定键盘的间隔
- (void)layoutSubviews
{
    [super layoutSubviews];
    UIInterfaceOrientation currentOrient = [UIApplication sharedApplication].statusBarOrientation;
    if (currentOrient == UIInterfaceOrientationLandscapeLeft || currentOrient == UIInterfaceOrientationLandscapeRight) {
        self.keyboardH = self.frame.size.height;
        self.keyboardW = self.frame.size.width;
        if (IS_IPAD) {
            self.horizontalInternal = 16;
            self.verticalInternal = 16;
        } else {
            self.horizontalInternal = 7;
            self.verticalInternal = 7;
        }
    } else {
        self.keyboardH = self.frame.size.height;
        self.keyboardW = self.frame.size.width;
        if (IS_IPAD) {
            self.horizontalInternal = 11;
            self.verticalInternal = 11;
        } else {
            self.horizontalInternal = 5;
            self.verticalInternal = 5;
        }
    }
    [self setupKeys];
}

// 按键布局方法
- (void)setupKeys
{
    [NSException raise:NSInternalInconsistencyException format:@"必须重写该 %@ 方法以进行键盘的布局", NSStringFromSelector(_cmd)];
}

// 设置键盘按键圆角
- (void)setButtonWtihRoundrdCorner {
    UIButton *btn = self.plateBtnArray[0];
    if (IS_IPAD) {
        UIImage *iPadKeyNormalImage = [[UIImage Modu_plate_imageWithColor:[UIColor whiteColor]] Modu_plate_drawRectWithRoundCorner:8 toSize:btn.frame.size];
        UIImage *iPadKeyHighlightImage = [[UIImage Modu_plate_imageWithColor:[UIColor colorWithRed:169 / 255.0 green:175 / 255.0 blue:186 / 255.0 alpha:1]] Modu_plate_drawRectWithRoundCorner:7 toSize:btn.frame.size];

        for (int j = 0; j < self.plateBtnArray.count; j++) {
            UIButton *btn = self.plateBtnArray[j];
            [btn setBackgroundImage:iPadKeyNormalImage forState:UIControlStateNormal];
            [btn setBackgroundImage:iPadKeyHighlightImage forState:UIControlStateHighlighted];
        }

    } else {
        UIImage *iPhoneKeyImage = [[UIImage Modu_plate_imageWithColor:[UIColor whiteColor]] Modu_plate_drawRectWithRoundCorner:5.0 toSize:btn.frame.size];

        for (int j = 0; j < self.plateBtnArray.count; j++) {
            UIButton *btn = self.plateBtnArray[j];
            [btn setBackgroundImage:iPhoneKeyImage forState:UIControlStateNormal];
        }
    }
}

// 为按键填充字体
- (void)loadCharacters:(NSArray *)array {
    NSInteger len = [array count];
    if (!array || len == 0) {
        return;
    }
    NSArray *subviews = self.subviews;
    [subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (obj && [obj isKindOfClass:[PlateButton class]]) {
            PlateButton *tmp = (PlateButton *) obj;
            NSInteger __tag = tmp.tag;
            if (__tag < len) {
                NSString *tmpTitle = [array objectAtIndex:__tag];
                [tmp updateChar:tmpTitle shift:NO];
            }
        }
    }];
}

- (UIButton *)createPlateFunctionKey:(UIButton *)key WithBGImage:(UIImage *)image
{
    key.exclusiveTouch = true;
    key.userInteractionEnabled = YES;
    key.titleLabel.font = [UIFont systemFontOfSize:18];
    key.titleLabel.textAlignment = NSTextAlignmentCenter;
    [key setBackgroundImage:image forState:UIControlStateNormal];
    return key;
}


#pragma mark - 全键盘触控方法
- (PlateBubble *)bubble {
    if (!_bubble)
    {
        _bubble = [[PlateBubble alloc] init];
    }
    return _bubble;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!IS_IPAD) {
        CGPoint touchPoint = [[touches anyObject] locationInView:self];
        for (PlateButton *tmp in self.plateBtnArray) {
            NSArray *subs = [tmp subviews];

            if (subs.count == 3) {
                [[subs lastObject] removeFromSuperview];
            }
            if (CGRectContainsPoint(tmp.frame, touchPoint) && !tmp.isDisable) {
                [self.bubble showFromButton:tmp];
                UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
                [window addSubview:self.bubble];
//                if (tmp.isDisable) {
//                    [self.bubble removeFromSuperview];
//                }
            }
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!IS_IPAD) {
        CGPoint touchPoint = [[touches anyObject] locationInView:self];
        for (PlateButton *tmp in self.plateBtnArray) {
            if (tmp.isDisable) {
//                return;
            }
            NSArray *subs = [tmp subviews];
            if (subs.count == 3) {
                [[subs lastObject] removeFromSuperview];
            }
            if (CGRectContainsPoint(tmp.frame, touchPoint) && !tmp.isDisable) {
                [self.bubble showFromButton:tmp];
                UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
                [window addSubview:self.bubble];
            }
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!IS_IPAD) {
        [self.bubble removeFromSuperview];
        CGPoint touchPoint = [[touches anyObject] locationInView:self];
        for (PlateButton *tmp in self.plateBtnArray) {
            if (tmp.isDisable) {
//                return;
            }
            NSArray *subs = [tmp subviews];
            if (subs.count == 3) {
                [[subs lastObject] removeFromSuperview];
            }
            if (CGRectContainsPoint(tmp.frame, touchPoint) && !tmp.isDisable) {
                [self.bubble removeFromSuperview];
                [self characterTouchAction:tmp];
            }
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!IS_IPAD) {
        CGPoint touchPoint = [[touches anyObject] locationInView:self];
        for (PlateButton *tmp in self.plateBtnArray) {
            NSArray *subs = [tmp subviews];
            if (subs.count == 3) {
                [[subs lastObject] removeFromSuperview];
            }
            if (CGRectContainsPoint(tmp.frame, touchPoint)) {
                [self.bubble removeFromSuperview];
            }
        }
    }
}

- (void)touchCancelAction:(PlateButton *)btn {
    [btn setBackgroundColor:[UIColor clearColor]];
}

- (void)characterTouchAction:(PlateButton *)btn{
    if (btn.isDisable) {
        return;
    }
    NSString *title = [btn titleLabel].text;
    //    NSString *key = [NSString stringWithFormat:@"%@", title];
    
    if (self.onKeyPressCallback) {
        self.onKeyPressCallback(title);
    }
}

- (void)deleteAction
{
    NSString *key = @"backspace";
    if (self.onDeletePressCallback) {
        self.onDeletePressCallback(key);
    }
}
// 长按删除方法
- (void)longPressDelete:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                      target:self
                                                    selector:@selector(deleteAction)
                                                    userInfo:nil
                                                     repeats:YES];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state ==
               UIGestureRecognizerStateCancelled) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)KeyboardEnterBackGround
{
    [self.bubble removeFromSuperview];
}

#pragma mark - 按键失效方法

- (void)unTouchableAction:(NSArray *)disableArray {
    UIImage *iPadKeyNormalImage = [UIImage pureColorImageWithSize:CGSizeMake(100, 100) color:[UIColor whiteColor] cornerRadius:8];
    NSArray *subChars = [self subviews];
    [subChars enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:[PlateButton class]]) {
            PlateButton *tmp = (PlateButton *) obj;
            if ([disableArray containsObject:tmp.titleLabel.text]) {                
                tmp.isDisable = YES;
                [tmp setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                if (IS_IPAD) {
                    [tmp setBackgroundImage:iPadKeyNormalImage forState:UIControlStateHighlighted];
                }
            } else {
                tmp.isDisable = NO;
                [tmp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }];
}

#pragma mark - iPhone X判断

- (BOOL)isiPhoneX {
    static BOOL isiPhoneX = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
#if TARGET_IPHONE_SIMULATOR
        // 获取模拟器所对应的 device model
        NSString *model = NSProcessInfo.processInfo.environment[@"SIMULATOR_MODEL_IDENTIFIER"];
#else
        // 获取真机设备的 device model
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *model = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
#endif
        // 判断 device model 是否为 "iPhone10,3" 和 "iPhone10,6" 或者以 "iPhone11," 开头
        // 如果是，就认为是 iPhone X
        isiPhoneX = [model isEqualToString:@"iPhone10,3"] || [model isEqualToString:@"iPhone10,6"] || [model hasPrefix:@"iPhone11,"];
    });
    
    return isiPhoneX;
}
@end
