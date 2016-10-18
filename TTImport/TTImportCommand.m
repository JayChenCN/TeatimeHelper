//
//  SourceEditorCommand.m
//  TTImport
//
//  Created by Jay Chen on 16/10/18.
//  Copyright © 2016年 Jay. All rights reserved.
//

#import "TTImportCommand.h"
#import "xTextModifier.h"
#import "TTImportHelper.h"

@implementation TTImportCommand

- (NSDictionary *)handlers {
    static NSDictionary *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = @{
                      
                      @"TTImport.Class": ^NSString *(NSString *text) {
                          return [TTImportHelper importClass:text];
                      },
                      
                      @"TTImport.Header": ^NSString *(NSString *text) {
                          return [TTImportHelper importHeader:text];
                      },

                      };
    });
    return _instance;
}

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler {
    
    NSString *identifier = invocation.commandIdentifier;
    NSString *(^handler)(NSString *text) = self.handlers[identifier];
    if ([identifier hasSuffix:@"Class"]) {
        [xTextModifier any:invocation handler:handler];
    }
    else if ([identifier hasSuffix:@"Header"]) {
        [xTextModifier any:invocation handler:handler];
    }

    
    
    completionHandler(nil);
}
@end
