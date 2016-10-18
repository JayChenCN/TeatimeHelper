//
//  SourceEditorCommand.m
//  TTCompleteMethod
//
//  Created by Jay Chen on 16/10/18.
//  Copyright © 2016年 Jay. All rights reserved.
//

#import "TTCompleteMethodCommand.h"
#import "xTextModifier.h"
#import "TTCompleteMethodHelper.h"

@implementation TTCompleteMethodCommand

- (NSDictionary *)handlers {
    static NSDictionary *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = @{
                      @"TTCompleteMethod.Super": ^NSString *(NSString *text) {
                          return [TTCompleteMethodHelper completeSuperMethod:text];
                      },
                      
                      @"TTCompleteMethod.Setter": ^NSString *(NSString *text) {
                          return [TTCompleteMethodHelper completeSetter:text];
                      },
                      
                      };
    });
    return _instance;
}

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler {
    
    NSString *identifier = invocation.commandIdentifier;
    NSString *(^handler)(NSString *text) = self.handlers[identifier];
    if ([identifier hasSuffix:@"Super"]) {
        [xTextModifier any:invocation handler:handler];
    }
    else if ([identifier hasSuffix:@"Setter"]) {
        [xTextModifier any:invocation handler:handler];
    }
    
    
    
    completionHandler(nil);
}

@end
