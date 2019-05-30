//
//  PlateLabel.m
//  PlateKeyboard
//
//  Created by CageLin on 2018/12/7.
//

#import "PlateLabel.h"
#import "Masonry.h"

@interface PlateLabel ()
@property (nonatomic, strong) UIView *bottomLine;

@end


@implementation PlateLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self =  [super initWithFrame:CGRectMake(1, 1, 1, 1)]) {
        self.font = [UIFont systemFontOfSize:16];
        self.textAlignment = NSTextAlignmentCenter;
//        self.backgroundColor = [UIColor yellowColor];
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:self.bottomLine];
    }
    return self;
}

- (void)layoutSubviews {
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1.5);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    self.bottomLine.frame = CGRectMake(0, self.frame.size.width - 2, self.frame.size.width, 2);
}

- (void)setText:(NSString *)text {
    // TODO: 使用 self.text = text 会导致循环，要调用 super 的 setText 方法才可行
    [super setText:text];
    if (text.length == 0) {
        self.bottomLine.hidden = NO;
    } else {
        self.bottomLine.hidden = YES;
    }
    
}
@end
