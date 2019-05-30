//
//  PlateKeyboardController.m
//  Pods
//
//  Created by CageLin on 2018/11/22.
//

#import "PlateKeyboardController.h"
#import "PlateKeyboardView.h"
#import "PlateBackgroundView.h"
#import "sys/utsname.h"
#import "PlateConfirmButtonView.h"
#import "SVProgressHUD.h"
#import "Masonry.h"


#define IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

@interface PlateKeyboardController ()
@property (nonatomic, strong) PlateBackgroundView *background;/**< 键盘背景View */

@property (nonatomic, assign) UIInterfaceOrientation currentOrient;/**< 全局旋转 */
@property (nonatomic, strong) PlateConfirmButtonView *confirmButtonView;/**< 确认按钮View */

@end

@implementation PlateKeyboardController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化View
    self.background = [[PlateBackgroundView alloc] init];
    self.confirmButtonView = [[PlateConfirmButtonView alloc] init];
    self.background.isNewEnergy = NO;
    
    // 添加到Subview
    [self.view addSubview:self.background];
    [self.view addSubview:self.confirmButtonView];
        
    //设置背景View的Frame
    [self setupBackgroundFrame:self.background];
    
    // 初始化returnString
    NSMutableString *returnString = self.value.mutableCopy ?: [NSMutableString new];
    self.returnString = returnString;
    
    // 初始化 plateStringArray
    NSMutableArray *plateArray = [NSMutableArray array];
    self.plateStringArray = plateArray;
    
    // 设定文字按键回调的Block
    weak(self)
    self.background.onKeyPressInBGView = ^(NSString *plateString) {
        strong(self)
        if (!self.confirmButtonView.changePlateButton.isSelected) {
            if (self.plateStringArray.count >= 1) {
                if ([self.plateStringArray[0] isEqualToString:@"W"]) {
                    if (self.plateStringArray.count < 8) {
                        [self.plateStringArray addObject:plateString];
                    }
                } else {
                    if (self.plateStringArray.count < 7) {
                        [self.plateStringArray addObject:plateString];
                    }
                }
            } else {
                [self.plateStringArray addObject:plateString];
            }

        } else {
            if (self.plateStringArray.count < 8) {
                [self.plateStringArray addObject:plateString];
            }
        }
        // 把输入的文字填入输入框 label
        [self.confirmButtonView setPlateTextToLabel:self.plateStringArray];
        
        // 根据输入的文字修改显示的键盘
        [self.background setKeyboardByPlateString:self.plateStringArray];
    };
    
    // 设定删除按键的回调
    self.background.onDeleteInBGView = ^(NSString *plateString) {
        strong(self)
        [self.plateStringArray removeLastObject];
        
        // 把输入的文字填入输入框 label
        [self.confirmButtonView setPlateTextToLabel:self.plateStringArray];
        
        // 根据输入的文字修改显示的键盘
        [self.background setKeyboardByPlateString:self.plateStringArray];
    };
    
    // 设定确认按键的回调
    // FIXME: 需要修改
    self.confirmButtonView.onConfirm = ^() {
        strong(self)
        NSMutableString *plate = [[NSMutableString alloc] init];
        for (NSString *plateString in self.plateStringArray) {
            [plate appendString:plateString];
        }
        NSDictionary *returnDic = @{
                                    @"value": plate,
                                    };
        self.ay_onControllerResult(self, ModuStatusOK, returnDic);
    };
    
    // 设定修改车牌规则的回调
    // FIXME: 此处增加判断第三位是否符合新能源的规则
    self.confirmButtonView.onChangePlateRule = ^(UIButton *button) {
        strong(self)
        
        if (self.plateStringArray.count >= 1) {
            if ([self plateIsNumber:self.plateStringArray[0]] || [self plateIsAlphabet:self.plateStringArray[0]]) {
                [self failToChangePlateRule];
            } else if (self.plateStringArray.count >= 3) {
                if ([self plateIsNewEnergy:self.plateStringArray[2]]) {
                    [self failToChangePlateRule];
                } else {
                    [self changePlateRuleSuccessfully:button];
                }
            } else {
                [self changePlateRuleSuccessfully:button];
            }
        } else {
            [self changePlateRuleSuccessfully:button];
        }
    };
}

- (void)changePlateRuleSuccessfully:(UIButton *)button {
    if (!button.isSelected && self.plateStringArray.count == 8) {
        [self.plateStringArray removeLastObject];
    }
    [self.confirmButtonView changeButtonStatus];
    
    self.background.isNewEnergy = button.isSelected;
    [self.background setKeyboardByPlateString:self.plateStringArray];
    [self.confirmButtonView setPlateTextToLabel:self.plateStringArray];
}

- (void)failToChangePlateRule {
    [SVProgressHUD showErrorWithStatus:@"当前车牌不符合新能源车牌规则\n 请删除后再切换类型"];
    [SVProgressHUD dismissWithDelay:1.0];
    [self.background setKeyboardByPlateString:self.plateStringArray];
    [self.confirmButtonView setPlateTextToLabel:self.plateStringArray];
}

- (void)setInputLabel:(NSDictionary *)dictionary {
    [self.confirmButtonView setPlateLabelTextWithDic:dictionary];
}

- (void)viewWillLayoutSubviews
{
    UIInterfaceOrientation currentOrient = [UIApplication  sharedApplication].statusBarOrientation;
    self.currentOrient = currentOrient;
    [self setupBackgroundFrame:self.background];
    [self setupConfirmView];

}

- (void)setupBackgroundFrame:(UIView *)view
{
    if (self.currentOrient == UIInterfaceOrientationLandscapeLeft || self.currentOrient == UIInterfaceOrientationLandscapeRight) {
            if (IS_IPAD) {
            view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height / 2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 2);
        } else {
            view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height * (1 - 4.5/10), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 4.5/10);
        }
    } else {
        if (IS_IPAD) {
            view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height * (1 - 1 / 3.5), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 1 / 3.5);
        } else if ([self isiPhoneX]) {
            view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height * (1 - 2.7 /10), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 2.7 /10);
        } else {
            view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height * (1 - 3.4/10), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 3.4/10);
        }
    }
}

- (void)setupConfirmView
{
    [self.confirmButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.background.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    self.confirmButtonView.currentOrient = self.currentOrient;
}

// 解决边缘触控延迟问题
- (void)viewDidAppear:(BOOL)animated {
    UIGestureRecognizer *gr0 = self.view.window.gestureRecognizers[0];
    UIGestureRecognizer *gr1 = self.view.window.gestureRecognizers[1];
    
    gr0.delaysTouchesBegan = false;
    gr1.delaysTouchesBegan = false;
}

// 触发空白区域时，就是取消事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.ay_onControllerResult(self, ModuStatusCanceled, nil);
}

- (void)keyboardEnterBackground
{
    [self.background enterBackground];
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
    NSString *regex = @"[A-Z]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

- (BOOL)plateIsNewEnergy:(NSString *)str
{
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[A-C,G-Z]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

#pragma mark - 判断是否为全面屏机型
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
