//
//  SLQrImage.h
//  xiaocao
//
//  Created by X.T.X on 2017/5/15.
//  Copyright © 2017年 北京脐橙科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SLQrImage : NSObject

+ (UIImage *)createQrImageWithString: (NSString *)str;

@end
