//
//  SelectActivityViewController.h
//  SensorDataCollector
//
//  Created by momo on 3/26/13.
//  Copyright (c) 2013 RPI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "activityInfo.h"

@interface SelectActivityViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UINavigationControllerDelegate>{
    IBOutlet UIPickerView *activityPicker;
    NSMutableArray *activityList;
    NSString *activityName;
    IBOutlet UILabel *currentActivityLabel;
}
@property (strong, nonatomic) IBOutlet UIPickerView *activityPicker;
@property (strong, nonatomic) NSMutableArray *activityList;
@property (nonatomic,retain) NSString *activityName;
@property (nonatomic,retain) IBOutlet UILabel *currentActivityLabel;
@property (nonatomic,retain) IBOutlet UIButton *tSensor;
@end
