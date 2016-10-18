//
//  TeatimeHelper.m
//  xTextHandler
//
//  Created by apple on 16/10/6.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import "TTUIHelper.h"
#import "TTPropertyElement.h"

@implementation TTUIHelper

+(NSString *)cleanProperty:(NSString *)selectedString{
    NSString *resultString = @"";//最后输出的串
    
    NSArray *selectedlineArray = [selectedString componentsSeparatedByString:@"\n"];
    
    for (NSString *lineString in selectedlineArray) {
        NSLog(@"选中行:->%@",lineString);
        TTPropertyElement *propertyElement = [self convertPropertyElement:lineString];
        
        if(propertyElement){
            
//            NSRange selectRange = [fileText rangeOfString:selectString];
            
            NSRange range = [lineString rangeOfString:@"->"];
            if (range.location != NSNotFound) {
                NSString *newString = [lineString substringToIndex:range.location];

                resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@"%@\n",newString]];
            }else{
                resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@"%@\n",lineString]];
            }
            
       
        }
        
    }
    
    return resultString;

}

+(NSString *)eventActions:(NSString *)selectedString{
    NSString *resultString = @"";//最后输出的串
    
    NSArray *selectedlineArray = [selectedString componentsSeparatedByString:@"\n"];
    
    for (NSString *lineString in selectedlineArray) {
        
        TTPropertyElement *propertyElement = [self convertPropertyElement:lineString];
        
        if(propertyElement && propertyElement.actionMethodName){

            NSString *code = [NSString stringWithFormat:@"%@事件方法\n- (void)%@{\n\n\n   \n}",propertyElement.annotation,propertyElement.actionMethodName];
            
            resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@"%@\n\n",code]];
        }
        
    }
    
    return resultString;
}

+(NSString *)addSubviews:(NSString *)selectedString{
    NSString *resultString = @"";//最后输出的串
    
    NSArray *selectedlineArray = [selectedString componentsSeparatedByString:@"\n"];
    
    for (NSString *lineString in selectedlineArray) {
        
        TTPropertyElement *propertyElement = [self convertPropertyElement:lineString];
        
        if(propertyElement){
            NSString *dotSuperView = @"";
            if (propertyElement.superViewName) {
                dotSuperView = [NSString stringWithFormat:@".%@",propertyElement.superViewName];
            }
            NSString *code = [NSString stringWithFormat:@"\t%@\n\t[self%@ addSubview:self.%@];",propertyElement.annotation,dotSuperView,propertyElement.instanceName];
            
            resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@"%@\n\n",code]];
        }
        
    }
    
    return resultString;
}

+(NSString *)makeConstraint:(NSString *)selectedString{
    
    NSString *resultString = @"";//最后输出的串
    
    NSArray *selectedlineArray = [selectedString componentsSeparatedByString:@"\n"];
    
    for (NSString *lineString in selectedlineArray) {
        
        TTPropertyElement *propertyElement = [self convertPropertyElement:lineString];
        
        if(propertyElement){
            NSString *code = [NSString stringWithFormat:@"\t%@\n\t[_%@ makeConstraints:^(MASConstraintMaker *make) {\n\n \t}];",propertyElement.annotation,propertyElement.instanceName];
      
            resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@"%@\n\n",code]];
        }
        
    }
    
    return resultString;
}

/**
 获得懒加载字符串

 @param selectedString 选中的字符串

 @return 懒加载字符串
 */
+(NSString *)lazyGetter:(NSString *)selectedString{
    
    NSString *resultString = @"";//最后输出的串
    
    NSArray *selectedlineArray = [selectedString componentsSeparatedByString:@"\n"];
    
    for (NSString *lineString in selectedlineArray) {
        
        TTPropertyElement *propertyElement = [self convertPropertyElement:lineString];
        
        if(propertyElement){
            NSBundle *bundle = [NSBundle mainBundle];
            
            NSDictionary *viewTypeDic = [NSDictionary dictionaryWithContentsOfFile:[bundle pathForResource:@"ViewType" ofType:@"plist"]];
            
            NSString *code = viewTypeDic[propertyElement.className];
            if (!code) {
                code = viewTypeDic[@"Default"];
            }
            
            //替换注释
            code = [code stringByReplacingOccurrencesOfString:@"<#annotation#>" withString:propertyElement.annotation];
            
            //替换实例名
            code = [code stringByReplacingOccurrencesOfString:@"<#instanceName#>" withString:propertyElement.instanceName];
            
            //替换类名
            code = [code stringByReplacingOccurrencesOfString:@"<#className#>" withString:propertyElement.className];
            
            resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@"%@\n\n",code]];
        }

    }
    
    return resultString;
}


/**
 把属性串转换成对象

 @param lineString 一行

 @return 对象
 */
+ (TTPropertyElement *)convertPropertyElement:(NSString *)lineString{
    
    TTPropertyElement *element = nil;
    
    NSString *newLineString = [lineString stringByReplacingOccurrencesOfString:@" " withString:@""];//去空格
    
    if ([newLineString hasPrefix:@"@property"]) {
        element = [TTPropertyElement new];
        NSRange range = [newLineString rangeOfString:@")"];
        if (range.location != NSNotFound) {
            newLineString = [newLineString substringFromIndex:range.location+1];
            
            //取得类名和实例名
            range = [newLineString rangeOfString:@";"];
            if (range.location != NSNotFound) {
                NSString *classAndInstanceName = [newLineString substringToIndex:range.location];
                NSArray *classAndInstanceNameArray = [classAndInstanceName componentsSeparatedByString:@"*"];
                if (classAndInstanceNameArray.count > 0) {
                    element.className = classAndInstanceNameArray[0];
                    element.instanceName = classAndInstanceNameArray[1];
                }
            }
            
            //取得注释
            range = [newLineString rangeOfString:@"//"];
            if (range.location != NSNotFound) {
                NSString *annotationAndSuperViewName = [newLineString substringFromIndex:range.location];
                NSArray *annotationAndSuperViewNameArray = [annotationAndSuperViewName componentsSeparatedByString:@"->"];
                if (annotationAndSuperViewNameArray.count > 1) {
                    element.annotation = annotationAndSuperViewNameArray[0];//注释
                    element.superViewName = annotationAndSuperViewNameArray[1];//父视图
                    
                    //取得方法名
                    if(annotationAndSuperViewNameArray.count > 2){
                        NSString *actionName = annotationAndSuperViewNameArray[2];
                        if (actionName.length>0) {
                            element.actionMethodName =  [NSString stringWithFormat:@"%@Action",actionName];
                        }else{
                            element.actionMethodName = [NSString stringWithFormat:@"%@Action",element.instanceName];
                        }
                        
                    }
                }else{
                    element.annotation = annotationAndSuperViewName;
                }
            }
        }
        
    }
    
    return element;
}

@end
