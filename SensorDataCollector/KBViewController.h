//
//  KBViewController.h
//  SensorDataCollector
//
//  Created by Yu Chen on 1/12/14.
//  Copyright (c) 2014 RPI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@interface KBViewController : UIViewController<UIAccelerometerDelegate,CLLocationManagerDelegate>{
    
    NSDictionary *OnePatchData;
    NSMutableArray *allData;
    CLLocationManager *locationManager;
    
    UIAccelerometer *accelerometer;
    CMMotionManager *motionManager;
    BOOL flag;
    NSMutableArray *accX;
    NSMutableArray *accY;
    NSMutableArray *accZ;
    NSMutableArray *gyroX;
    NSMutableArray *gyroY;
    NSMutableArray *gyroZ;
    
    float gyroXReading;
    float gyroYReading;
    float gyroZReading;
    
    NSString *key;
    
}

@property (nonatomic, retain) UIAccelerometer *accelerometer;
@property (nonatomic, retain) CMMotionManager *motionManager;
@property (nonatomic, retain) CLLocationManager *locationManager;

@end
