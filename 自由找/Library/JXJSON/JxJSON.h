//
//  JxJSON.h
//  奔跑兄弟
//
//  Created by guojie on 16/4/25.
//  Copyright © 2016年 yutonghudong. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface NSObject (JXJSON)
- (NSString *)prettyJSONString;
- (NSString *)JSONStringRepresentation;
@end

@interface NSString (JXJSON)
- (id)JSONObject;
@end

@interface NSData (JXJSON)
- (id)JSONData;
@end
