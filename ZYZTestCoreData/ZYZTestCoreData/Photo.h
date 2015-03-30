//
//  Photo.h
//  ZYZTestCoreData
//
//  Created by yinzezhang on 15/3/26.
//  Copyright (c) 2015年 yinzezhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * photoURl;
@property (nonatomic, retain) NSString * subTitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSManagedObject *whoTook;

@end
