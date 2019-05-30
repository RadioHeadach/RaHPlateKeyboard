//
//  LastKeyboardView.h
//  PlateKeyboard
//
//  Created by CageLin on 2018/12/18.
//

#import "PlateKeyboardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LastKeyboardView : PlateKeyboardView
@property (nonatomic, copy) void(^onSwitchTonumLetter)(void);
@property(nonatomic, strong) UIButton *backBtn;/**< 返回键 */

@end

NS_ASSUME_NONNULL_END
