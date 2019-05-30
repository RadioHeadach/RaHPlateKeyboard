//
//  PlateKeyboardController.h
//  Pods
//
//  Created by CageLin on 2018/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSInteger const ModuStatusPartialContent = 299;/** <键盘按键点按时的状态码 */

@interface PlateKeyboardController : UIViewController
@property(nonatomic, copy) NSString *value; /**< 输入框初始值，用于修改已输入文字，不传则会覆盖原有的值 */
@property(nonatomic, strong) NSMutableString *returnString;/**< 输入框初始值 */
@property (nonatomic, strong) NSMutableArray *plateStringArray;/**< 存储输入键盘的值 */

- (void)keyboardEnterBackground;/**< 键盘进入后台方法 */

@end

NS_ASSUME_NONNULL_END
