//
//  TTImportHelper.h
//  TeatimeHelper
//
//  Created by Jay Chen on 16/10/18.
//  Copyright © 2016年 Jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTImportHelper : NSObject

+ (NSString *)importClass:(NSString *)text;

+ (NSString *)importHeader:(NSString *)text;

@end
