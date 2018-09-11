//
//  TrackRecord.m
//  CoreDataDemo
//
//  Created by sjimac01 on 2018/7/30.
//  Copyright © 2018年 sjimac01. All rights reserved.
//

#import "TrackRecord.h"

@implementation TrackRecord


+ (Class)transformedValueClass {
    
    return [NSArray class];
}

+ (BOOL)allowsReverseTransformation {
    
    //标志
    return YES;
}

- (id)transformedValue:(id)value {
    
    //转换成NSData保存到数据库
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (id)reverseTransformedValue:(id)value {
    
    //转换NSData成当前类型
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end
