//
//  Student.h
//  CSVDemo
//
//  Created by Guo Feng on 13-4-30.
//  Copyright (c) 2013年 CUIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Student : NSManagedObject

@property (nonatomic, retain) NSString * num;
@property (nonatomic, retain) NSString * name;

@end
