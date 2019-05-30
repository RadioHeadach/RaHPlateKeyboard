//
//  PlateConfirmButtonView.h
//  PlateKeyboard
//
//  Created by CageLin on 2018/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlateConfirmButtonView : UIView
@property (nonatomic, strong) UIButton *confirmButton;/**< 确认按钮 */
@property (nonatomic, strong) UIButton *changePlateButton;/**< 切换车牌类型按钮 */
@property (nonatomic, assign) UIInterfaceOrientation currentOrient;/**< 全局旋转 */
@property (nonatomic, copy) void(^onConfirm)(void);/**< 确认键回调 */
@property (nonatomic, copy) void(^onChangePlateRule)(UIButton *);/**< 修改车牌规则 */


@property (nonatomic, strong) NSMutableString *value;/**< 输入车牌的历史值 */
@property (nonatomic, strong) NSMutableArray *plateStringArray;

- (void)setPlateTextToLabel:(NSMutableArray *)stringArray;
- (void)setPlateLabelTextWithDic:(NSDictionary *)dictionary;
- (void)changeButtonStatus;
@end

NS_ASSUME_NONNULL_END
