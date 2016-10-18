//
//  PropertyElement.h
//  xTextHandler
//
//  Created by apple on 16/10/6.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTPropertyElement : NSObject

@property (nonatomic, copy)NSString *className;//类名
@property (nonatomic, copy)NSString *instanceName;//实例名
@property (nonatomic, copy)NSString *annotation;//注释
@property (nonatomic, copy)NSString *superViewName;//父视图名
@property (nonatomic, copy)NSString *actionMethodName;//方法名

@end
