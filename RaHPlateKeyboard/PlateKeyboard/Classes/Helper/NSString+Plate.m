//
//  NSString+Plate.m
//  PlateKeyboard
//
//  Created by CageLin on 2018/11/26.
//

#import "NSString+Plate.h"

@implementation NSString (Plate)

+ (NSString *)Modu_Plate_unicodeStringWithString:(NSString *)string {
    NSString *result = [NSString string];
    for (int i = 0; i < [string length]; i++) {
        result = [result stringByAppendingFormat:@"\\u%04x", [string characterAtIndex:i]];
        /*
         因为 Unicode 用 16 个二进制位（即 4 个十六进制位）表示字符,对于小于 0x1000 字符要用 0 填充空位,
         所以使用 %04x 这个转换符, 使得输出的十六进制占 4 位并用 0 来填充开头的空位.
         */
    }
    return result;
}

@end
