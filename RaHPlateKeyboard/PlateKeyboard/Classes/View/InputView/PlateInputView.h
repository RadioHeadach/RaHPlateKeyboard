//
//  PlateInputView.h
//  PlateKeyboard
//
//  Created by CageLin on 2018/12/4.
//

#import <UIKit/UIKit.h>
typedef void(^CallBackBlcok) (NSString *text);


@interface PlateInputView : UIView <UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *labelArray;/**< 存放UILabel的数组 */
@property (nonatomic,copy)CallBackBlcok callBackBlock;

- (void)isNewEnergyCar:(UIButton *)changePlateBtn;/**< 判断是否为新能源车车牌 */
- (void)isArmyCar;/**< 判断是否为武警车牌 */
@end

