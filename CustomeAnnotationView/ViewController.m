//
//  ViewController.m
//  CustomeAnnotationView
//
//  Created by 王龙 on 16/3/19.
//  Copyright © 2016年 Larry（Lawrence）. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyAnnotation.h"
#import "CustomPinAnnotationView.h"

@interface ViewController ()<MKMapViewDelegate>
{
    CLLocationManager *_locationManager;
    
    MKMapView *_mapView;
}

@property (nonatomic,retain) NSMutableArray *locationArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    定位授权
    
    _locationManager = [[CLLocationManager alloc]init];
    [_locationManager requestWhenInUseAuthorization];
    
    
//    地图视图
    _mapView = [[MKMapView alloc]initWithFrame:self.view.frame];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    
}

- (void)loadData{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"PinData" ofType:@"plist"];
    NSArray *tempArray = [NSArray arrayWithContentsOfFile:filePath];
    
//    把plist数据转换成大头针model
    for (NSDictionary *dict in tempArray) {
        MyAnnotation *myAnnotationModel = [[MyAnnotation alloc]initWithAnnotationModelWithDict:dict];
        
        [self.locationArray addObject:myAnnotationModel];
    }
    
//    核心代码
    [_mapView addAnnotations:self.locationArray];
    
}

#pragma mark ------ delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    userLocation.title  =@"你好";
    
    _mapView.centerCoordinate = userLocation.coordinate;
    
    [_mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.3, 0.3)) animated:YES];
    
    
//    如果在ViewDidLoad中调用  添加大头针的话会没有掉落效果  定位结束后再添加大头针才会有掉落效果
    [self loadData];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    /*
     
     * 大头针分两种
     
     * 1. MKPinAnnotationView：他是系统自带的大头针，继承于MKAnnotationView，形状跟棒棒糖类似，可以设置糖的颜色，和显示的时候是否有动画效果
     
     * 2. MKAnnotationView：可以用指定的图片作为大头针的样式，但显示的时候没有动画效果，如果没有给图片的话会什么都不显示
     
     * 3. mapview有个代理方法，当大头针显示在试图上时会调用，可以实现这个方法来自定义大头针的动画效果，我下面写有可以参考一下
     
     * 4. 在这里我为了自定义大头针的样式，使用的是MKAnnotationView
     
     */
    
    
    //    判断是不是用户的大头针数据模型
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc]init];
        annotationView.image = [UIImage imageNamed:@"acc"];
        
//        是否允许显示插入视图*********
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    
    CustomPinAnnotationView *annotationView = (CustomPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"otherAnnotationView"];
    if (annotationView == nil) {
        annotationView = [[CustomPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"otherAnnotationView"];
    }
    MyAnnotation *myAnnotation = annotation;
    switch ([myAnnotation.type intValue]) {
        case SUPER_MARKET:
            annotationView.image = [UIImage imageNamed:@"super"];
            annotationView.label.text = @"超市";
            break;
        case CREMATORY:
            annotationView.image = [UIImage imageNamed:@"chang"];
            annotationView.label.text = @"火场";
            break;
        case INTEREST:
            annotationView.image = [UIImage imageNamed:@"jingqu"];
            annotationView.label.text = @"风景区";
            break;
            
        default:
            break;
    }
    
    return annotationView;
}


//大头针显示在视图上时调用，在这里给大头针设置显示动画
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views{
    
    
//    获得mapView的Frame
    CGRect visibleRect = [mapView annotationVisibleRect];
    
    for (MKAnnotationView *view in views) {
        
        CGRect endFrame = view.frame;
        CGRect startFrame = endFrame;
        startFrame.origin.y = visibleRect.origin.y - startFrame.size.height;
        view.frame = startFrame;
        [UIView beginAnimations:@"drop" context:NULL];
        [UIView setAnimationDuration:1];
        view.frame = endFrame;
        [UIView commitAnimations];
        
        
    }
    
    
}



#pragma mark lazy load

- (NSMutableArray *)locationArray{
    
    if (_locationArray == nil) {
        
        _locationArray = [NSMutableArray new];
        
    }
    return _locationArray;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
