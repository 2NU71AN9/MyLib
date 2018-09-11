//
//  PersonManager.h
//  CoreDataDemo
//
//  Created by sjimac01 on 2018/5/2.
//  Copyright © 2018年 sjimac01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Person+CoreDataClass.h"
@interface PersonManager : NSObject
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSFetchRequest *request;

+ (instancetype)shareManager;


/**
 读取全部数据

 @return persons
 */
- (NSArray <Person *>*)readAllData;


/**
 插入数据

 @param personID id
 @param name name
 @param age age
 @param photo url
 @return YES or NO
 */
- (BOOL)insertDataWithPersonID:(NSString *)personID name:(NSString *)name age:(int16_t)age photo:(NSString *)photo;


/**
 删除数据

 @param personID id
 @return YES or NO
 */
- (BOOL)deleteDataWithPersonID:(NSString *)personID;


/**
 修改数据、更新数据

 @param personID id
 @param updateDict 更新内容
 @return YES or NO
 */
- (BOOL)upDateDataWithPersonID:(NSString *)personID dict:(NSDictionary *)updateDict;

/**
 条件查找

 @param personID id
 @return person
 */
- (Person *)searchDataWithPersonID:(NSString *)personID;


@end
