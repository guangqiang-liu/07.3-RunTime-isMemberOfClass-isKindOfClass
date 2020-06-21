//
//  main.m
//  07.3-Runtime isMemberOfClass isKindOfClass
//
//  Created by 刘光强 on 2020/2/8.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import <objc/runtime.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        Person *person = [[Person alloc] init];
        
//        NSLog(@"%d", [person isMemberOfClass:[Person class]]); // 1
//        NSLog(@"%d", [person isMemberOfClass:[NSObject class]]); // 0
//
//        NSLog(@"%d", [person isKindOfClass:[Person class]]); // 1
//        NSLog(@"%d", [person isKindOfClass:[NSObject class]]); // 1
        
        NSLog(@"%d", [Person isMemberOfClass:[Person class]]); // 0
        NSLog(@"%d", [Person isKindOfClass:[Person class]]); // 0
        
        NSLog(@"%d", [Person isMemberOfClass:object_getClass([Person class])]); // 1
        
        NSLog(@"%d", [Person isKindOfClass:object_getClass([Person class])]); // 1
        
        NSLog(@"%d", [Person isKindOfClass:object_getClass([NSObject class])]); // 1
        
        
        NSLog(@"%d", [[NSObject class] isKindOfClass:[NSObject class]]); // 1
        
        NSLog(@"%d", [[Person class] isKindOfClass:[NSObject class]]); // 1
    }
    return 0;
}
