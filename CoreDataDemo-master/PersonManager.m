//
//  PersonManager.m
//  CoreDataDemo
//
//  Created by sjimac01 on 2018/5/2.
//  Copyright © 2018年 sjimac01. All rights reserved.
//

#import "PersonManager.h"
@implementation PersonManager


static PersonManager *personManager;
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        personManager =[[self alloc] init];
    });
    return personManager;
}

- (instancetype)init {
    if (self =[super init]) {
        //1、创建模型对象获、取模型路径
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PersonData" withExtension:@"momd"];
        //根据模型文件创建模型对象
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        //2、创建持久化助理、利用模型对象创建助理对象
        NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        //数据库的名称和路径
        NSString *docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *sqlPath = [docStr stringByAppendingPathComponent:@"coreData.sqlite"];
        NSLog(@"path = %@", sqlPath);
        NSURL *sqlUrl = [NSURL fileURLWithPath:sqlPath];
        //设置数据库相关信息
        [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlUrl options:nil error:nil];
        //3、创建上下文
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        //关联持久化助理
        [context setPersistentStoreCoordinator:store];
        self.context = context;
        self.request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    }
    return self;
}


#pragma mark - 读取全部数据

- (NSArray <Person *>*)readAllData {
    // 检索条件制空就是搜索全部
    self.request.predicate = nil;
    return [self.context executeFetchRequest:self.request error:nil];
}


#pragma mark - 插入数据

- (BOOL)insertDataWithPersonID:(NSString *)personID name:(NSString *)name age:(int16_t)age photo:(NSString *)photo {
    Person * person =[NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.context];
    person.personID =personID;
    person.name     =name;
    person.age      =age;
    person.photo    =photo;
    NSMutableArray *records =[NSMutableArray arrayWithCapacity:2];
    NSDictionary *recode1 =@{@"company":@"xxx科技有限公司",@"date":@"2011-1013"};
    NSDictionary *recode2 =@{@"company":@"xxx集团",@"date":@"2013-1018"};
    [records addObjectsFromArray:@[recode1,recode2]];
    person.trackRecord =records;
    
    NSError *error = nil;
    if ([self.context save:&error]) {
        return YES;
    }
    return NO;
}


#pragma mark - 删除数据

- (BOOL)deleteDataWithPersonID:(NSString *)personID {
    //删除条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"personID = %@",personID];
    self.request.predicate = pre;
    //返回需要删除的对象数组
    NSArray *deleArray = [_context executeFetchRequest:self.request error:nil];
    //从数据库中删除
    for (Person *person in deleArray) {
        [self.context deleteObject:person];
    }
    NSError *error = nil;
    if ([self.context save:&error]) {
        return YES;
    }
    return NO;
}


#pragma mark - 修改数据、更新数据

- (BOOL)upDateDataWithPersonID:(NSString *)personID dict:(NSDictionary *)updateDict {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"personID = %@",personID];
    self.request.predicate = pre;
    NSArray *resArray = [self.context executeFetchRequest:self.request error:nil];
    for (Person *person in resArray) {
        for (NSString *key in [updateDict allKeys]) {
            [person setValue:updateDict[key] forKey:key];
        }
    }
    NSError *error = nil;
    if ([self.context save:&error]) {
        return YES;
    }
    return NO;
}


#pragma mark - 查询

- (Person *)searchDataWithPersonID:(NSString *)personID {
    //查询条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"personID = %@",personID];
    self.request.predicate = pre;
    //发送查询请求,并返回结果
    NSArray *resArray = [self.context executeFetchRequest:self.request error:nil];
    if (resArray.count>0) {
        return [resArray firstObject];
    }
    return nil;
}


@end
