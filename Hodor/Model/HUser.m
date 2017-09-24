//
//  HUser.m
//  Hodor
//
//  Created by Antrov on 23.09.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

#import "HUser.h"
#import <UIKit/UIKit.h>

@interface JSONValueTransformer (Base64Image)
@end

@implementation JSONValueTransformer (CustomTransformer)

- (UIImage *)UIImageFromNSString:(NSString *)string {
    NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    return [UIImage imageWithData:base64Data];
}

- (NSString *)JSONObjectFromUIImage:(UIImage *)image {
    NSData *imageData = UIImagePNGRepresentation(image);
    return [imageData base64EncodedStringWithOptions:0];
}

@end

@implementation HUser

@end
