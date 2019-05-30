//
//  NSString+Plate.h
//  PlateKeyboard
//
//  Created by CageLin on 2018/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Plate)
/**
 * 生成unicode值
 * @param string 按键的标题
 * @return 返回按键的ASCII码
 */
+ (NSString *)Modu_Plate_unicodeStringWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
