//
//  SourceEditorCommand.m
//  TT_UISource
//
//  Created by Jay Chen on 16/10/18.
//  Copyright © 2016年 Jay. All rights reserved.
//

#import "TTUISourceEditorCommand.h"
#import "xTextModifier.h"
#import "TTUIHelper.h"

@implementation TTUISourceEditorCommand


- (NSDictionary *)handlers {
    static NSDictionary *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = @{
                      
                      @"TTUISource.LazyGetter": ^NSString *(NSString *text) {
                          return [TTUIHelper lazyGetter:text];
                      },
                      
                      @"TTUISource.AddSubviews": ^NSString *(NSString *text) {
                          return [TTUIHelper addSubviews:text];
                      },
                      
                      @"TTUISource.MakeConstraint": ^NSString *(NSString *text) {
                          return [TTUIHelper makeConstraint:text];
                      },
                      
                      @"TTUISource.EventActions": ^NSString *(NSString *text) {
                          return [TTUIHelper eventActions:text];
                      },
                      
                      @"TTUISource.CleanProperty": ^NSString *(NSString *text) {
                          return [TTUIHelper cleanProperty:text];
                      },
                      
            };
    });
    return _instance;
}

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler {
    
    NSString *identifier = invocation.commandIdentifier;
    NSString *(^handler)(NSString *text) = self.handlers[identifier];
    if ([identifier hasSuffix:@"LazyGetter"]) {
        [xTextModifier any:invocation handler:handler];
    }
    else if ([identifier hasSuffix:@"AddSubviews"]) {
        [xTextModifier any:invocation handler:handler];
    }
    else if ([identifier hasSuffix:@"MakeConstraint"]) {
        [xTextModifier any:invocation handler:handler];
    }
    else if ([identifier hasSuffix:@"EventActions"]) {
        [xTextModifier any:invocation handler:handler];
    }
    else if ([identifier hasSuffix:@"CleanProperty"]) {
        [xTextModifier any:invocation handler:handler];
    }
    
    
    completionHandler(nil);
}


@end
