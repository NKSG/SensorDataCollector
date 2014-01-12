//
//  activityInfo.m
//  SensorDataCollector
//
//  Created by momo on 3/26/13.
//  Copyright (c) 2013 RPI. All rights reserved.
//

#import "activityInfo.h"

@implementation activityInfo
@synthesize activityName;

static activityInfo *_sharedInstance;

-(id)init{
    if (self = [super init]) {
        activityName = [[NSString alloc] initWithFormat:@"Jumping"];
        
    }
    
    return self;
}

+ (activityInfo *) sharedInstance{
    
    if (!_sharedInstance) {
        _sharedInstance = [[activityInfo alloc] init];
    }
    return _sharedInstance;
}

@end
