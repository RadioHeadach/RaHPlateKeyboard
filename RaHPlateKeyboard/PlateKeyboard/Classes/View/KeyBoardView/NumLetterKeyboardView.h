//
//  NumLetterKeyboardView.h
//  PlateKeyboard
//
//  Created by CageLin on 2018/11/22.
//

#import "PlateKeyboardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NumLetterKeyboardView : PlateKeyboardView
@property (nonatomic, copy) void(^onSwitchToHans)(void);
@property(nonatomic, strong) UIButton *backBtn;/**< 返回键 */

@end

NS_ASSUME_NONNULL_END
