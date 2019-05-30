//
//  PlateInputView.m
//  PlateKeyboard
//
//  Created by CageLin on 2018/12/4.
//

#import "PlateInputView.h"
#import "PlateLabel.h"
#import "Masonry.h"

@interface PlateInputView ()
@property (nonatomic, assign) CGFloat internal;
@property (nonatomic, assign) CGFloat labelWidth;

@end

@implementation PlateInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self =  [super initWithFrame:CGRectMake(1, 1, 1, 1)]) {
        self.labelArray = [NSMutableArray array];
    }
    return self;
}

// 创建输入键盘的Label
- (void)createPlateLabelWithNum:(int)num {
    
    for (int i = 0; i < num; i ++) {
        PlateLabel *label = [[PlateLabel alloc] init];
        label.userInteractionEnabled = false;
        [label setTag:i];
        [self.labelArray addObject:label];
        [self addSubview:label];
        if (num == 7) {
            self.internal = 7;
            self.labelWidth = 24;
        } else {
            self.internal = 4;
            self.labelWidth = 23;
        }
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).with.offset(i * (self.labelWidth + self.internal));
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            make.width.mas_equalTo(self.labelWidth);
        }];
//        label.frame = CGRectMake(i * (labelWidth + internal), 0, labelWidth, self.frame.size.height);

    }
}

- (void)isNewEnergyCar:(UIButton *)changePlateBtn {
    for (id object in self.subviews) {
        [object removeFromSuperview];
    }
    if (changePlateBtn.isSelected) {
        [self createPlateLabelWithNum:8];
    } else {
        [self createPlateLabelWithNum:7];
    }
}

- (void)isArmyCar {
    for (id object in self.subviews) {
        [object removeFromSuperview];
    }
    [self createPlateLabelWithNum:8];
}
@end
