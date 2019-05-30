//
//  UIImage+PlateKeyboard.h
//  PlateKeyboard
//
//  Created by CageLin on 2018/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (PlateKeyboard)
+ (nullable UIImage *)Modu_plate_imageWithColor:(nullable UIColor *)color;

+ (UIImage *)pureColorImageWithSize:(CGSize)size color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

- (nullable UIImage *)Modu_plate_drawRectWithRoundCorner:(CGFloat)radius toSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
