//
//  activityInfo.h
//  SensorDataCollector
//
//  Created by momo on 3/26/13.
//  Copyright (c) 2013 RPI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface activityInfo : NSObject{
    NSString *activityName;
}

+ (activityInfo *) sharedInstance;

@property (nonatomic,retain) NSString *activityName;

@end
