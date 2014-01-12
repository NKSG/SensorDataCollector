//
//  NaviViewController.h
//  SensorDataCollector
//
//  Created by momo on 3/13/13.
//  Copyright (c) 2013 RPI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface NaviViewController : UIViewController<UIAccelerometerDelegate>{
    
    IBOutlet UILabel *labelX;
    IBOutlet UILabel *labelY;
    IBOutlet UILabel *labelZ;
    
    IBOutlet UILabel *gyroLabelX;
    IBOutlet UILabel *gyroLabelY;
    IBOutlet UILabel *gyroLabelZ;
    
    IBOutlet UIProgressView *progressX;
    IBOutlet UIProgressView *progressY;
    IBOutlet UIProgressView *progressZ;
    
    IBOutlet UIProgressView *progressGyroX;
    IBOutlet UIProgressView *progressGyroY;
    IBOutlet UIProgressView *progressGyroZ;
   
    int state;
    IBOutlet UILabel *responseCode;
    
    IBOutlet UILabel *responseContent;
    
    UIAccelerometer *accelerometer;
    CMMotionManager *motionManager;
    NSString *activityName;
    NSInteger *activityCode;
    
}

@property (nonatomic, retain) IBOutlet UILabel *labelX;
@property (nonatomic, retain) IBOutlet UILabel *labelY;
@property (nonatomic, retain) IBOutlet UILabel *labelZ;

@property (nonatomic, retain) IBOutlet UIProgressView *progressX;
@property (nonatomic, retain) IBOutlet UIProgressView *progressY;
@property (nonatomic, retain) IBOutlet UIProgressView *progressZ;

@property (nonatomic, retain) IBOutlet UILabel *gyroLabelX;
@property (nonatomic, retain) IBOutlet UILabel *gyroLabelY;
@property (nonatomic, retain) IBOutlet UILabel *gyroLabelZ;

@property (nonatomic, retain) IBOutlet UIProgressView *progressGyroX;
@property (nonatomic, retain) IBOutlet UIProgressView *progressGyroY;
@property (nonatomic, retain) IBOutlet UIProgressView *progressGyroZ;

@property (nonatomic, retain) IBOutlet UILabel *responseCode;
@property (nonatomic, retain) IBOutlet UILabel *responseContent;

@property (nonatomic, retain) UIAccelerometer *accelerometer;
@property (nonatomic, retain) CMMotionManager *motionManager;

@property (nonatomic) int state;
@property (nonatomic,retain) NSString *activityName;
@property (nonatomic) NSInteger activityCode;

@end
