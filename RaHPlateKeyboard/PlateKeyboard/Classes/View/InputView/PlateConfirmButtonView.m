//
//  PlateConfirmButtonView.m
//  PlateKeyboard
//
//  Created by CageLin on 2018/11/25.
//

#import "PlateConfirmButtonView.h"
#import "Masonry.h"
#import "sys/utsname.h"
#import "PlateInputView.h"
#import "SVProgressHUD.h"


@interface PlateConfirmButtonView ()
@property (nonatomic, strong) PlateInputView *input;
@property (nonatomic, strong) NSMutableArray *plateString;


@end

@implementation PlateConfirmButtonView

#pragma mark - 生命周期

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self =  [super initWithFrame:CGRectMake(1, 1, 1, 1)]) {
        // 初始化确认按键View
        self.backgroundColor = [UIColor colorWithRed:211 / 255.0 green:213 / 255.0 blue:219 / 255.0 alpha:1];

        // 初始化确认按键
        self.confirmButton = [[UIButton alloc] init];
        [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [self.confirmButton setBackgroundColor:[UIColor colorWithRed:94 / 255.0 green:94 / 255.0 blue:94 / 255.0 alpha:1]];
        [self.confirmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.confirmButton.userInteractionEnabled = NO;
        [self.confirmButton.layer setCornerRadius:14];
        [self.confirmButton setTintColor:[UIColor blackColor]];
        self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.confirmButton];
        
        // 初始化车牌选择按钮
        self.changePlateButton = [[UIButton alloc] init];
        UIImage *newImage = [self setImage:[UIImage imageNamed:@"plate-keyboard_resource_round_background"] toColor:[UIColor colorWithRed:134 / 255.0 green:192 / 255.0 blue:125 / 255.0 alpha:1]];
        UIImage *commonImage = [self setImage:[UIImage imageNamed:@"plate-keyboard_resource_round_background"] toColor:[UIColor colorWithRed:94 / 255.0 green:94 / 255.0 blue:94 / 255.0 alpha:1]];
        [self.changePlateButton setBackgroundImage:newImage forState:UIControlStateSelected];
        [self.changePlateButton setBackgroundImage:commonImage forState:UIControlStateNormal];
        [self.changePlateButton setTitle:@"普" forState:UIControlStateNormal];
        [self.changePlateButton setTitle:@"新" forState:UIControlStateSelected];
        [self.changePlateButton addTarget:self action:@selector(changePlate) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.changePlateButton];
        
        // 初始化输入框
        self.input = [[PlateInputView alloc] init];
//        self.input.num = [NSNumber numberWithInt:7];
        [self addSubview:self.input];
        [self.input isNewEnergyCar:self.changePlateButton];
        
        // 初始化字符数组
        self.plateString = [NSMutableArray array];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).with.offset(-5);
        } else {
            make.right.equalTo(self.mas_right).with.offset(-5);
        }
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(50);
    }];
    
    [self.changePlateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).with.offset(10);
        } else {
            make.left.equalTo(self.mas_left).with.offset(10);
        }
        make.width.height.mas_equalTo(33);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.input mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(220);
        make.height.mas_equalTo(33);
//        make.top.equalTo(self.mas_top).with.offset(5);
//        make.bottom.equalTo(self.mas_bottom).with.offset(-5);
    }];
    
}

#pragma mark - 按钮方法

// 确认键方法
- (void)confirm {
    if (self.onConfirm) {
        self.onConfirm();
    }
}

// 新能源按键方法
- (void)changePlate {
    if (self.onChangePlateRule) {
        self.onChangePlateRule(self.changePlateButton);
    }
}

- (void)changeButtonStatus {
    [self.changePlateButton setSelected:!self.changePlateButton.isSelected];
    if (self.changePlateButton.isSelected) {
        [SVProgressHUD showInfoWithStatus:@"当前输入新能源车牌"];
        [SVProgressHUD dismissWithDelay:1.0];
    } else {
        [SVProgressHUD showInfoWithStatus:@"当前输入普通车车牌"];
        [SVProgressHUD dismissWithDelay:1.0];
    }


    [self.input isNewEnergyCar:self.changePlateButton];
}
#pragma mark - 输入框填入文字 
- (void)setPlateTextToLabel:(NSMutableArray *)stringArray {
    NSArray *plate = [NSArray arrayWithArray:stringArray];
    
    if (plate.count >= 1) {
        if ([plate[0] isEqualToString:@"W"]) {
            [self.input isArmyCar];
        }
    } else if (plate.count == 0) {
        [self.input isNewEnergyCar:self.changePlateButton];
    }
    
    // 判断是否输入完整，若输入完整，按钮则可点击
    if (self.changePlateButton.isSelected && plate.count == 8) {
        [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.confirmButton.userInteractionEnabled = YES;
    } else if (!self.changePlateButton.isSelected && plate.count == 7 && ![plate[0] isEqualToString:@"W"]) {
        [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.confirmButton.userInteractionEnabled = YES;
    } else if (!self.changePlateButton.isSelected && plate.count == 8 && [plate[0] isEqualToString:@"W"]) {
        [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.confirmButton.userInteractionEnabled = YES;
    }
    else {
        [self.confirmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.confirmButton.userInteractionEnabled = NO;
    }
    
    for (UILabel *label in self.input.labelArray) {
        switch (label.tag) {
            case 0:
                label.text = plate.count < 1 ? @"" : plate[0];
                break;
                
            case 1:
                label.text = plate.count < 2 ? @"" : plate[1];
                break;
                
            case 2:
                label.text = plate.count < 3 ? @"" : plate[2];
                break;
                
            case 3:
                label.text = plate.count < 4 ? @"" : plate[3];
                break;
                
            case 4:
                label.text = plate.count < 5 ? @"" : plate[4];
                break;
                
            case 5:
                label.text = plate.count < 6 ? @"" : plate[5];
                break;
                
            case 6:
                label.text = plate.count < 7 ? @"" : plate[6];
                break;
                
            case 7:
                label.text = plate.count < 8 ? @"" : plate[7];
                break;
                
            default:
                break;
        }
    }
}

- (void)setValue:(NSMutableString *)value {
    _value = value;
    [self.plateString removeAllObjects];
    NSLog(@"%@", value);
    for (int i = 0; i < 7; i ++) {
        NSRange range = NSMakeRange(i, 1);
        if (i < value.length) {
            NSString *string = [value substringWithRange:range];
            [self.plateString addObject:string];
        } else if ([self.plateString count] < 7) {
            [self.plateString addObject:@""];
        }
    }

    [self showPlateString];
}

- (void)showPlateString {
    NSLog(@"%@", self.plateString);
    for (int i = 0; i < [self.plateString count]; i ++) {
        UILabel *label = [self.input.labelArray objectAtIndex:i];
        NSString *string = [self.plateString objectAtIndex:i];
        label.text = string;
    }
}

// 触发空白区域时，就是取消事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

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
