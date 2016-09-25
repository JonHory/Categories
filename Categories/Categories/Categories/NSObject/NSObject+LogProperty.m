//
//  NSObject+LogProperty.m
//  fusionWealthApp
//
//  Created by 未来、再续 on 16/9/22.
//  Copyright © 2016年 rhcf. All rights reserved.
//

#import "NSObject+LogProperty.h"

@implementation NSObject (LogProperty)

+ (void)printPropertyListWithDict:(NSDictionary *)dict
{
    NSArray *temp = [dict allKeys];
    
    NSMutableArray *propertyArray = [NSMutableArray array];
    
    [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *option = @"assign";
        // 判断obj的真实类型
        if ([dict[obj] isKindOfClass:[NSArray class]] || [dict[obj] isKindOfClass:[NSDictionary class]])
        {
            option = @"strong";
        }
        if ([dict[obj] isKindOfClass:[NSString class]] ||
            [dict[obj] isKindOfClass:[NSNumber class]]  ||
            [NSStringFromClass([dict[obj] class]) isEqualToString:@"NSTaggedPointerString"] ||
            [NSStringFromClass([dict[obj] class]) isEqualToString:@"__NSCFString"])
        {
            option = @"copy";
        }
        
        NSString *classStr;
        if ([dict[obj] isKindOfClass:[NSArray class]])
        {
            classStr = NSStringFromClass([NSArray class]);
        }
        if ([dict[obj] isKindOfClass:[NSDictionary class]])
        {
            classStr = NSStringFromClass([NSDictionary class]);
        }
        
        if ([dict[obj] isKindOfClass:[NSString class]] ||
            [NSStringFromClass([dict[obj] class]) isEqualToString:@"NSTaggedPointerString"] ||
            [NSStringFromClass([dict[obj] class]) isEqualToString:@"__NSCFString"])
        {
            classStr = NSStringFromClass([NSString class]);
        }
        if ([dict[obj] isKindOfClass:[NSNumber class]])
        {
            classStr = NSStringFromClass([NSNumber class]);
        }
        
        if (!classStr) {
            classStr = NSStringFromClass([obj class]);
            if ([classStr isEqualToString:@"NSTaggedPointerString"] ||
                [classStr isEqualToString:@"__NSCFString"]) {
                classStr = NSStringFromClass([NSString class]);
                
                option = @"copy";
            }
            
        }
        
        [propertyArray addObject:[NSString stringWithFormat:@"@property (nonatomic, %@) %@ *%@",option , classStr, obj]];
    }];
    
    [propertyArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        printf("/*** <#注释#> **/\n%s;\n",[obj cStringUsingEncoding:NSUTF8StringEncoding]);
    }];
}

@end
