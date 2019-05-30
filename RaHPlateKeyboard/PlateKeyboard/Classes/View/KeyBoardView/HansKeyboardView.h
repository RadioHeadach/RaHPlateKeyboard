//
//  HansKeyboardView.h
//  PlateKeyboard
//
//  Created by CageLin on 2018/11/22.
//

#import "PlateKeyboardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HansKeyboardView : PlateKeyboardView
@property (nonatomic, copy) void(^onSwitchToNumletter)(void);
@property(nonatomic, strong) UIButton *numleterBtn;/**< 数字字母键盘切换键 */


@end

NS_ASSUME_NONNULL_END
