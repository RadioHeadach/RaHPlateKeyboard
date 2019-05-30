//
//  PlateBackgroundView.h
//  Pods
//
//  Created by CageLin on 2018/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlateBackgroundView : UIView
@property (nonatomic, copy) void(^onKeyPressInBGView)(NSString *plateString);/**< 键盘按键点按回调 */
@property (nonatomic, copy) void(^onDeleteInBGView)(NSString *deleteString);/**< 删除按键点按回调 */
@property (nonatomic, assign) BOOL isNewEnergy;/**< 是否为新能源 */

- (void)enterBackground;/**< 键盘进入后台方法 */
- (void)setKeyboardByPlateString:(NSMutableArray *)plate;/**< 根据输入的值修改显示的键盘 */

@end

NS_ASSUME_NONNULL_END
