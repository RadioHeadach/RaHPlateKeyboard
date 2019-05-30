//
//  HansKeyboardView.m
//  PlateKeyboard
//
//  Created by CageLin on 2018/11/22.
//

#import "HansKeyboardView.h"


#define IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)


@interface HansKeyboardView ()

@property(nonatomic, strong) UIButton *backSpaceBtn;/**< 退格键 */
@end

@implementation HansKeyboardView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(1, 1, 1, 1)]) {
        // 创建按键字符
        self.plateBtnStringArray = @[@"京", @"津", @"渝", @"沪", @"冀", @"晋", @"辽", @"吉", @"黑", @"苏", @"浙", @"皖", @"闽", @"赣", @"鲁", @"豫", @"鄂", @"湘", @"粤", @"琼", @"川", @"贵", @"云", @"陕", @"甘", @"青", @"蒙", @"桂", @"宁", @"新", @"藏", @"使", @"民", @"台"];
        
        self.plateBtnArray = [NSMutableArray arrayWithCapacity:37];
        
        
        // 创建文字按键
        int keyNumbers = 0;
        for (int i = 0; i < 34; i ++) {
            PlateButton *btn = [PlateButton createKeys];
            [btn setTag: keyNumbers + i];
            if (IS_IPAD){
                btn.titleLabel.font = [UIFont systemFontOfSize:20];
                [btn addTarget:self action:@selector(characterTouchAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.plateBtnArray addObject:btn];
            } else {
                [self.plateBtnArray addObject:btn];
            }
            [self addSubview:btn];
        }
        [self loadCharacters:self.plateBtnStringArray];
        
        // 创建功能按键
        //      功能按键背景图片
        UIImage *funcBtnBackgroundImage = [UIImage Modu_plate_imageWithColor:[UIColor colorWithRed:175 / 255.0 green:178 / 255.0 blue:186 / 255.0 alpha:1]];

        //      退格键
        self.backSpaceBtn = [[UIButton alloc] init];
        [self createPlateFunctionKey:self.backSpaceBtn WithBGImage:funcBtnBackgroundImage];
        [self.backSpaceBtn setImage:[UIImage imageNamed:@"plate-keyboard_resource_delete"] forState:UIControlStateNormal];
        [self.backSpaceBtn.layer setCornerRadius:5];
        self.backSpaceBtn.layer.masksToBounds = YES;
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDelete:)];
        longPressGestureRecognizer.allowableMovement = 500;
        [self.backSpaceBtn addGestureRecognizer:longPressGestureRecognizer];
        [self.backSpaceBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        
        //      键盘切换键
        self.numleterBtn = [[UIButton alloc] init];
        [self createPlateFunctionKey:self.numleterBtn WithBGImage:funcBtnBackgroundImage];
        [self.numleterBtn setTitle:@"更多" forState:UIControlStateNormal];
        self.numleterBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.numleterBtn.layer setCornerRadius:5];
        [self.numleterBtn addTarget:self action:@selector(switchToNumLetterKeyboard) forControlEvents:UIControlEventTouchUpInside];
        self.numleterBtn.layer.masksToBounds = YES;
        
        //       添加到视图
        [self addSubview:self.numleterBtn];
        [self addSubview:self.backSpaceBtn];

    }
    return self;
}

- (void)setupKeys
{
    [self.bubble removeFromSuperview];
//    CGFloat charBtnBoarderInternal = [UIScreen mainScreen].bounds.size.height * 0.017;
    CGFloat charBtnBoarderInternal = 10;
    //按键index
    NSArray *range = @[@10, @20, @30, @34];
    //数组分割起点
    NSInteger loc = 0;
    // 第一行数组长度
    NSInteger lengthRowOne = [[range objectAtIndex:0] integerValue];
    // 第一行按键字符
    NSArray *charsRowOne = [self.plateBtnArray subarrayWithRange:NSMakeRange(loc, lengthRowOne)];
    // 第一行按键字符数
    NSInteger rowOnwCharsCount = [charsRowOne count];
    // 按键宽度
    CGFloat charBtnWidth = (self.keyboardW - self.horizontalInternal * rowOnwCharsCount) / rowOnwCharsCount;
    // 按键高度
    CGFloat charBtnHeight = (self.keyboardH - charBtnBoarderInternal - self.verticalInternal * 3) / 4;
    // 按键的Y坐标
    CGFloat yLocation = 0;
    
    // 第一行布局
    int n = 0;
    for (int i = 0; i < rowOnwCharsCount; i ++) {
        PlateButton *btn = [charsRowOne objectAtIndex:i];
        btn.frame = CGRectMake(self.horizontalInternal * 0.5 + (charBtnWidth + self.horizontalInternal) * i, yLocation, charBtnWidth, charBtnHeight);
    }
    n += rowOnwCharsCount;
    
    // 第二行
    yLocation += charBtnHeight + self.verticalInternal;
    // 第二行起点
    loc = [[range objectAtIndex:0] integerValue];
    // 第二行数组的长度
    NSInteger lengthRowTwo = [[range objectAtIndex:1] integerValue];
    // 第二行的按键字符
    NSArray *charsRowTwo = [self.plateBtnArray subarrayWithRange:NSMakeRange(loc, lengthRowTwo - loc)];
    // 第二行的按键字符数
    NSInteger rowTwoCharsCount = [charsRowTwo count];
    // 第二行布局
    for (int i = 0; i < rowTwoCharsCount; i ++) {
        UIButton *btn = [charsRowTwo objectAtIndex:i];
        btn.frame = CGRectMake(self.horizontalInternal * 0.5 + (charBtnWidth + self.horizontalInternal) * i, yLocation, charBtnWidth, charBtnHeight);
    }
    n += rowTwoCharsCount;
    
    // 第三行
    yLocation += charBtnHeight + self.verticalInternal;
    // 数组分割起点
    loc = [[range objectAtIndex:1] integerValue];
    // 第三行数组长度
    NSInteger lenthRowThree = [[range objectAtIndex:2] integerValue];
    // 第三行按键字符
    NSArray *charsRowThree = [self.plateBtnArray subarrayWithRange:NSMakeRange(loc, lenthRowThree - loc)];
    // 第三行按键字符数
    NSInteger rowThreeCharsCount = [charsRowThree count];
    // 第三行布局
    for (int i = 0; i < rowThreeCharsCount; i++) {
        UIButton *btn = [charsRowThree objectAtIndex:i];
        btn.frame = CGRectMake(self.horizontalInternal * 0.5 + (charBtnWidth + self.horizontalInternal) * i, yLocation, charBtnWidth, charBtnHeight);
    }
    n += rowThreeCharsCount;
    
    // 第四行
    yLocation += charBtnHeight + self.verticalInternal;
    CGFloat funcBtnWidth = charBtnWidth * 2;
    self.numleterBtn.frame = CGRectMake(self.horizontalInternal * 0.5, yLocation, funcBtnWidth, charBtnHeight);
    self.backSpaceBtn.frame = CGRectMake(self.keyboardW - self.horizontalInternal * 0.5 - funcBtnWidth, yLocation, funcBtnWidth, charBtnHeight);
    // 数组分割起点
    loc = [[range objectAtIndex:2] integerValue];
    // 第四行数组长度
    NSInteger lengthRowFour = [[range objectAtIndex:3] integerValue];
    // 第四行按键字符
    NSArray *charsRowFour = [self.plateBtnArray subarrayWithRange:NSMakeRange(loc, lengthRowFour - loc)];
    // 第四行的按键字符数
    NSInteger rowFourCharsCount = [charsRowFour count];
    // 第四行布局
    for (int i = 0; i < rowFourCharsCount; i++) {
        UIButton *btn = [charsRowFour objectAtIndex:i];
        btn.frame =CGRectMake(self.keyboardW - (charBtnWidth * 1.5 + self.horizontalInternal * 2) - (charBtnWidth * 5.5 + self.horizontalInternal * 4.5) + ((charBtnWidth + self.horizontalInternal) * i), yLocation, charBtnWidth, charBtnHeight);
    }

    // 设置按钮圆角
    [self setButtonWtihRoundrdCorner];
}

- (void)switchToNumLetterKeyboard
{
    if (self.onSwitchToNumletter) {
        self.onSwitchToNumletter();
    }
}

@end
