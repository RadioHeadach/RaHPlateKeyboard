//
//  PlateKeyboardView.h
//  Pods
//
//  Created by CageLin on 2018/11/22.
//

#import <UIKit/UIKit.h>
#import "PlateButton.h"
#import "PlateBubble.h"
#import "UIImage+PlateKeyboard.h"

#define IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)


@interface PlateKeyboardView : UIView
@property (nonatomic, assign) CGFloat keyboardH;/**< 全局键盘高度 */
@property (nonatomic, assign) CGFloat keyboardW;/**< 全局键盘宽度 */

@property (nonatomic, assign) CGFloat horizontalInternal;/**< 按键水平间隔 */
@property (nonatomic, assign) CGFloat verticalInternal;/**< 按键垂直间隔 */

@property(nonatomic, strong) PlateBubble *bubble;/**< 按键气泡 */

@property(nonatomic, strong) NSMutableArray *plateBtnArray;/**< 键盘按键数组 */
@property(nonatomic, copy) NSArray *plateBtnStringArray;/**< 按键字符 */
@property(nonatomic, copy) NSArray *plateBtnange;/**< 每行按键的长度 */
@property (nonatomic, weak) NSTimer *timer;/**< 长按定时器 */

@property (nonatomic, copy) void(^onKeyPressCallback)(NSString *plateString);/**< 文字按键点按回调 */
@property (nonatomic, copy) void(^onDeletePressCallback)(NSString *deleteString);/**< 删除按键点按回调 */


- (void)loadCharacters:(NSArray *)array;/**< 按键添加字符的方法 */
- (void)deleteAction;/**< 删除键点击方法 */
- (void)characterTouchAction:(PlateButton *)btn;/**< 按键点击方法（无气泡） */
- (void)layoutSubviews;/**< 暴露方法 */
- (void)setupKeys;/**< 按键布局 */
- (UIButton *)createPlateFunctionKey:(UIButton *)key WithBGImage:(UIImage *)image;/**< 创建功能按键 */
- (void)KeyboardEnterBackGround;/**< 键盘进入后台方法 */
- (void)setButtonWtihRoundrdCorner;///< 设置键盘按键的圆角

// 全键盘触控方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
- (void)touchCancelAction:(PlateButton *)btn;
- (void)longPressDelete:(UILongPressGestureRecognizer *)gestureRecognizer;/**< 长按删除方法 */

- (void)unTouchableAction:(NSArray *)disableArray;/**< 按键失效方法 */
@end

