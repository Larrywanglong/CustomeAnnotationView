//
//  MyAnnotation.m
//  CustomeAnnotationView
//
//  Created by 王龙 on 16/3/19.
//  Copyright © 2016年 Larry（Lawrence）. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation


- (instancetype)initWithAnnotationModelWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        
        
        self.coordinate = CLLocationCoordinate2DMake([dict[@"coordinate"][@"latitute"] doubleValue], [dict[@"coordinate"][@"longitude"] doubleValue]);
        self.title = dict[@"detail"];
        self.name = dict[@"name"];
        self.type = dict[@"type"];
        
    }
    return self;
}

@end
