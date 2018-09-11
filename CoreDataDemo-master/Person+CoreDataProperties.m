//
//  Person+CoreDataProperties.m
//  CoreDataDemo
//
//  Created by sjimac01 on 2018/7/30.
//  Copyright © 2018年 sjimac01. All rights reserved.
//
//

#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Person"];
}

@dynamic age;
@dynamic name;
@dynamic personID;
@dynamic photo;
@dynamic trackRecord;

@end
