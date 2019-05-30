//
//  PlateBackgroundView.m
//  Pods
//
//  Created by CageLin on 2018/11/22.
//

#import "PlateBackgroundView.h"
#import "sys/utsname.h"
#import "PlateKeyboardView.h"
#import "HansKeyboardView.h"
#import "NumLetterKeyboardView.h"
#import "SecondKeyboardView.h"
#import "LastKeyboardView.h"
#import <AYCategory/AYCategory.h>
#import "Masonry.h"



#define IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)


@interface PlateBackgroundView()

@property(nonatomic, assign) UIInterfaceOrientation currentOrient;/**< 全局旋转 */
@property (nonatomic, strong) HansKeyboardView *hansKeyboard;/**< 中文键盘 */
@property (nonatomic, strong) NumLetterKeyboardView *numletterKeyboard;/**< 数字和字母键盘 */
@property (nonatomic, strong) SecondKeyboardView *secondKeyboardView;/**< 第二位数字字母键盘 */
@property (nonatomic, strong) LastKeyboardView *lastkeyboardView;/**< 最后一位键盘，包含中文数字和字母 */
@property (nonatomic, strong) NSArray *keyboardArray;/**< 存放所有键盘的数组 */


@end

@implementation PlateBackgroundView

#pragma mark - 生命周期

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(1, 1, 1, 1)]) {
        self.backgroundColor = [UIColor colorWithRed:211 / 255.0 green:213 / 255.0 blue:219 / 255.0 alpha:1];
        
        // 初始化中文键盘
        self.hansKeyboard = [[HansKeyboardView alloc] init];
        [self addSubview:self.hansKeyboard];
        
        // 初始化数字字母键盘
        self.numletterKeyboard = [[NumLetterKeyboardView alloc] init];
        [self addSubview:self.numletterKeyboard];
        self.numletterKeyboard.alpha = 0;
        
        // 初始化第二位数字字母键盘
        self.secondKeyboardView = [[SecondKeyboardView alloc] init];
        [self addSubview:self.secondKeyboardView];
        self.secondKeyboardView.alpha = 0;
        
        // 初始化最后一位键盘
        self.lastkeyboardView = [[LastKeyboardView alloc] init];
        [self addSubview:self.lastkeyboardView];
        self.lastkeyboardView.alpha = 0;
        
        weak(self)
        // 设定键盘切换回调Block
        self.hansKeyboard.onSwitchToNumletter = ^{
            strong(self)
            self.hansKeyboard.alpha = 0;
            self.numletterKeyboard.alpha = 1;
        };
        
        self.numletterKeyboard.onSwitchToHans = ^{
            strong(self)
            self.numletterKeyboard.alpha = 0;
            self.hansKeyboard.alpha = 1;
        };
        self.lastkeyboardView.onSwitchTonumLetter = ^{
            strong(self)
            self.lastkeyboardView.alpha = 0;
            self.numletterKeyboard.alpha = 1;
        };
        
        // 设定键盘按键的Block回调
        id block = ^(NSString *str) {
            strong(self)
            if (self.onKeyPressInBGView) {
                self.onKeyPressInBGView(str);
            }
        };
        self.hansKeyboard.onKeyPressCallback = block;
        self.numletterKeyboard.onKeyPressCallback = block;
        self.secondKeyboardView.onKeyPressCallback = block;
        self.lastkeyboardView.onKeyPressCallback = block;
        
        // 设定删除按键的Block回调
        id blockDelete = ^(NSString *str){
            strong(self)
            if (self.onDeleteInBGView) {
                self.onDeleteInBGView(str);
            }
        };
        self.hansKeyboard.onDeletePressCallback = blockDelete;
        self.numletterKeyboard.onDeletePressCallback = blockDelete;
        self.secondKeyboardView.onDeletePressCallback = blockDelete;
        self.lastkeyboardView.onDeletePressCallback = blockDelete;
        
        NSArray *array = @[@"台"];
        [self.hansKeyboard unTouchableAction:array];
        
        // 初始化存放键盘的数组
        self.keyboardArray = [NSArray arrayWithObjects:self.hansKeyboard, self.numletterKeyboard, self.secondKeyboardView, self.lastkeyboardView, nil];
    }
    return self;
}

- (void)layoutSubviews
{    
    if ([self isiPhoneX]) {
        UIInterfaceOrientation currentOrient = [UIApplication sharedApplication].statusBarOrientation;
        if (currentOrient == UIInterfaceOrientationLandscapeLeft || currentOrient == UIInterfaceOrientationLandscapeRight) {
            self.hansKeyboard.frame = CGRectMake(45, 0, self.frame.size.width - 90, self.frame.size.height - 20);
            self.numletterKeyboard.frame = CGRectMake(45, 0, self.frame.size.width - 90, self.frame.size.height - 20);
            self.secondKeyboardView.frame = CGRectMake(45, 0, self.frame.size.width - 90, self.frame.size.height - 20);
            self.lastkeyboardView.frame = CGRectMake(45, 0, self.frame.size.width - 90, self.frame.size.height - 20);

        } else {
            self.hansKeyboard.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 20);
            self.numletterKeyboard.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 20);
            self.secondKeyboardView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 20);
            self.lastkeyboardView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 20);

        }
    } else {
        self.hansKeyboard.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.numletterKeyboard.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.secondKeyboardView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.lastkeyboardView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    }
}



#pragma mark - 根据输入字符修改键盘

- (void)setKeyboardByPlateString:(NSMutableArray *)plate {
    
    NSUInteger plateLength = [plate count];
    
    switch (plateLength) {
        case 0:
        {
            NSArray *taiwanString = @[@"台"];
            if (self.isNewEnergy) {
                self.hansKeyboard.numleterBtn.alpha = 0;
            } else {
                self.hansKeyboard.numleterBtn.alpha = 1;
            }
            self.numletterKeyboard.backBtn.alpha = 1;
            [self.hansKeyboard unTouchableAction:taiwanString];
            [self showKeyboard:self.hansKeyboard];
        }
            break;
        case 1:
        {
            if ([plate[0] isEqualToString:@"民"]) {
                NSArray *lastArray = @[@"学", @"警", @"港", @"澳", @"挂", @"试", @"超", @"使", @"领" ,@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"J", @"K", @"W", @"X", @"Y", @"Z"];
                [self.lastkeyboardView unTouchableAction:lastArray];

                [self showKeyboard:self.lastkeyboardView];
                
            } else if ([plate[0] isEqualToString:@"使"]) {
                NSArray *disableSecondString = @[@"4", @"5", @"6", @"7", @"8", @"9", @"0",@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"Z",@"X",@"C",@"V",@"B",@"N",@"M"];
                [self.secondKeyboardView unTouchableAction:disableSecondString];
                [self showKeyboard:self.secondKeyboardView];
            } else if ([self plateIsNumber:plate[0]]) {
                NSArray *lingString = @[@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S", @"D", @"F",@"G",@"H",@"J",@"K",@"L",@"Z",@"X",@"C",@"V",@"B",@"N",@"M"];
                [self.secondKeyboardView unTouchableAction:lingString];
                [self showKeyboard:self.secondKeyboardView];
            } else if ([self plateIsAlphabet:plate[0]]) {
                NSArray *alphabetString = @[@"1", @"2", @"3",@"4", @"5", @"6", @"7", @"8", @"9", @"0",@"I"];
                [self.secondKeyboardView unTouchableAction:alphabetString];
                [self showKeyboard:self.secondKeyboardView];
            } else if ([plate[0] isEqualToString:@"W"]) {
                NSArray *wujingArray = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0",@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",@"G",@"H",@"K",@"L",@"Z",@"X",@"C",@"V",@"B",@"N",@"M"];
                [self.secondKeyboardView unTouchableAction:wujingArray];
                [self showKeyboard:self.secondKeyboardView];
            } else if (self.isNewEnergy) {
                NSArray *newArray = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", @"I"];
                [self.secondKeyboardView unTouchableAction:newArray];
                [self showKeyboard:self.secondKeyboardView];
            }
            else {
                NSArray *secondString = @[@"4", @"5", @"6", @"7", @"8", @"9", @"0",@"I"];
                [self.secondKeyboardView unTouchableAction:secondString];
                [self showKeyboard:self.secondKeyboardView];
            }
        }
            break;
            
        case 2:
        {
            if (self.isNewEnergy) {
                NSArray *newEnergyString = @[@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"G",@"H",@"J",@"K",@"L",@"Z",@"X",@"C",@"V",@"B",@"N",@"M"];
                [self.secondKeyboardView unTouchableAction:newEnergyString];
                [self showKeyboard:self.secondKeyboardView];
            } else if ([plate[1] isEqualToString:@"1"] || [plate[1] isEqualToString:@"2"] || [plate[1] isEqualToString:@"3"]){
                NSArray *lingString = @[@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S", @"D", @"F",@"G",@"H",@"J",@"K",@"L",@"Z",@"X",@"C",@"V",@"B",@"N",@"M"];
                [self.secondKeyboardView unTouchableAction:lingString];
                [self showKeyboard:self.secondKeyboardView];
            } else if ([self plateIsNumber:plate[1]]) {
                [self showKeyboard:self.secondKeyboardView];
            } else if ([plate[1] isEqualToString:@"J"]) {
                NSArray *wujingArray = @[@"使", @"民", @"台"];
                [self.hansKeyboard unTouchableAction:wujingArray];
                self.hansKeyboard.numleterBtn.alpha = 0;
                [self showKeyboard:self.hansKeyboard];
            }
            else {
                NSArray *thirdString = @[@"I", @"O"];
                [self.secondKeyboardView unTouchableAction:thirdString];
                [self showKeyboard:self.secondKeyboardView];
            }
        }
            break;
            
        case 3:
        {
            if ([plate[0] isEqualToString:@"使"]) {
                NSArray *lingString = @[@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S", @"D", @"F",@"G",@"H",@"J",@"K",@"L",@"Z",@"X",@"C",@"V",@"B",@"N",@"M"];
                [self.secondKeyboardView unTouchableAction:lingString];
                [self showKeyboard:self.secondKeyboardView];
            } else {
                NSArray *thirdString = @[@"I", @"O"];
                [self.secondKeyboardView unTouchableAction:thirdString];
                [self showKeyboard:self.secondKeyboardView];
            }
        }
            break;
        
        case 4:
        {
            NSArray *thirdString = @[@"I", @"O"];
            [self.secondKeyboardView unTouchableAction:thirdString];
            [self showKeyboard:self.secondKeyboardView];
        }
            break;
        
        case 5:
        {
            [self.numletterKeyboard.backBtn setTitle:@"返回" forState:UIControlStateNormal];
            [self.numletterKeyboard unTouchableAction:[NSArray array]];
            
            weak(self)
            self.numletterKeyboard.onSwitchToHans = ^{
                strong(self)
                self.numletterKeyboard.alpha = 0;
                self.hansKeyboard.alpha = 1;
            };
            [self showKeyboard:self.secondKeyboardView];
        }
            break;
        
        case 6:
        {
            if ([self plateIsNumber:plate[0]]) {
                NSArray *lingLastArray = @[@"学", @"警", @"港", @"澳", @"航", @"挂", @"试", @"超", @"领" ,@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"J", @"K", @"W", @"X", @"Y", @"Z"];
                [self.lastkeyboardView unTouchableAction:lingLastArray];
                self.lastkeyboardView.backBtn.alpha = 0;
                [self showKeyboard:self.lastkeyboardView];
                
            } else if ([self plateIsAlphabet:plate[0]] || [plate[0] isEqualToString:@"使"]) {
                [self showKeyboard:self.secondKeyboardView];
            } else if ([plate[1] isEqualToString:@"J"]) {
                
            } else if ([plate[0] isEqualToString:@"粤"] && [plate[1] isEqualToString:@"Z"]) {
                NSArray *yuegangArray = @[@"学", @"警", @"航", @"挂", @"试", @"超", @"使", @"领" ,@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"J", @"K", @"W", @"X", @"Y", @"Z"];
                [self.lastkeyboardView unTouchableAction:yuegangArray];
                self.lastkeyboardView.backBtn.alpha = 0;
                [self showKeyboard:self.lastkeyboardView];
            }
            else {
                [self.numletterKeyboard.backBtn setTitle:@"更多" forState:UIControlStateNormal];
                
                if (self.isNewEnergy) {
                    self.numletterKeyboard.backBtn.alpha = 0;
                } else {
                    self.numletterKeyboard.backBtn.alpha = 1;
                }
                
                weak(self)
                self.numletterKeyboard.onSwitchToHans = ^{
                    strong(self)
                    self.numletterKeyboard.alpha = 0;
                    self.lastkeyboardView.alpha = 1;
                };
                
                NSArray *lastArray = @[@"港", @"澳", @"航", @"使"];
                [self.lastkeyboardView unTouchableAction:lastArray];
                self.lastkeyboardView.backBtn.alpha = 1;

                NSArray *ioArray = @[@"I", @"O"];
                [self.numletterKeyboard unTouchableAction:ioArray];
                
                [self showKeyboard:self.numletterKeyboard];
            }
        }
            break;
            
        case 7:
        {
            if (self.isNewEnergy) {
                NSArray *newEnergyString = @[@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"G",@"H",@"J",@"K",@"L",@"Z",@"X",@"C",@"V",@"B",@"N",@"M"];
                [self.secondKeyboardView unTouchableAction:newEnergyString];
                [self showKeyboard:self.secondKeyboardView];
            } else if ([plate[0] isEqualToString:@"W"]) {
                NSArray *armyArray = @[@"Q",@"W",@"E",@"R",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"G",@"K",@"L",@"Z",@"C",@"V",@"N",@"M"];
                [self.secondKeyboardView unTouchableAction:armyArray];
                [self showKeyboard:self.secondKeyboardView];
            }
            else {
                [self showKeyboard:self.numletterKeyboard];
            }

        }
            break;
        default:
            break;
    }
}

- (void)enterBackground
{
    [self.hansKeyboard KeyboardEnterBackGround];
    [self.numletterKeyboard KeyboardEnterBackGround];
    [self.secondKeyboardView KeyboardEnterBackGround];
    [self.lastkeyboardView KeyboardEnterBackGround];
}

- (void)showKeyboard:(PlateKeyboardView *)showKeyboard {
    for (PlateKeyboardView *keyboard in self.keyboardArray) {
        if (keyboard == showKeyboard) {
            keyboard.alpha = 1;
        } else {
            keyboard.alpha = 0;
        }
    }
}

#pragma mark - 字符判断规则

// 判断是否为数字

- (BOOL)plateIsNumber:(NSString *)str
{
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

- (BOOL)plateIsAlphabet:(NSString *)str
{
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[A-V,X-Z]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
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
