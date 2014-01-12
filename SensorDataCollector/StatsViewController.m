//
//  NaviViewController.m
//  SensorDataCollector
//
//  Created by momo on 3/13/13.
//  Copyright (c) 2013 RPI. All rights reserved.
//

#import "StatsViewController.h"
#import "activityInfo.h"
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@interface StatsViewController ()

@end

@implementation StatsViewController
@synthesize locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.accelerometer = [UIAccelerometer sharedAccelerometer];
    self.accelerometer.updateInterval = .1;
    self.accelerometer.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if (locationManager.headingAvailable && locationManager.locationServicesEnabled)
    {
        locationManager.headingFilter = kCLHeadingFilterNone;
        [locationManager startUpdatingHeading];
    }
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.flag = true;
    
    activityName = [[activityInfo sharedInstance] activityName];
    
    if([activityName isEqualToString:@"Jumping"]){
        self.activityCode = 0;
    }else if ([activityName isEqualToString:@"Walking"]){
        self.activityCode = 1;
    }else if ([activityName isEqualToString:@"Running"]){
        self.activityCode = 2;
    }else if ([activityName isEqualToString:@"Stepping_up"]){
        self.activityCode = 3;
    }else if ([activityName isEqualToString:@"Steppiing_down"]){
        self.activityCode = 4;
    }else if ([activityName isEqualToString:@"Turning_left"]){
        self.activityCode = 5;
    }else if ([activityName isEqualToString:@"Turning_right"]){
        self.activityCode = 6;
    }
    
    NSLog(@"Activity is %@ and code is %d",activityName,self.activityCode);
    
    //Gyroscope
    if([self.motionManager isGyroAvailable])
    {
        /* Start the gyroscope if it is not active already */
        if([self.motionManager isGyroActive] == NO)
        {
            /* Update us 2 times a second */
            [self.motionManager setGyroUpdateInterval:1.0f / 2.0f];
            
            /* And on a handler block object */
            
            /* Receive the gyroscope data on this block */
            [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue]
                                            withHandler:^(CMGyroData *gyroData, NSError *error)
             {
                 NSString *x = [[NSString alloc] initWithFormat:@"%.02f",gyroData.rotationRate.x];
                 self.gyroLabelX.text = x;
                 
                 NSString *y = [[NSString alloc] initWithFormat:@"%.02f",gyroData.rotationRate.y];
                 self.gyroLabelY.text = y;
                 
                 NSString *z = [[NSString alloc] initWithFormat:@"%.02f",gyroData.rotationRate.z];
                 self.gyroLabelZ.text = z;
                 
                 self.progressGyroX.progress = ABS(gyroData.rotationRate.x);
                 self.progressGyroY.progress = ABS(gyroData.rotationRate.y);
                 self.progressGyroZ.progress = ABS(gyroData.rotationRate.z);
                 
                 
                 //[self sendDataAcc:0 withTime:[[NSDate date] timeIntervalSince1970] withAccX:gyroData.rotationRate.x withAccY:gyroData.rotationRate.y withAccZ:gyroData.rotationRate.z];
             }];
        }
    }
    else
    {
        NSLog(@"Gyroscope not Available!");
    }
    
}

- (void)sendDataAcc:(int)id withTime:(double)currenttime withAccX:(double)accX withAccY:(double)accY withAccZ:(double)accZ{
    
    if (true){
        NSString* dbURL = @"http://128.113.106.108:10035/web-motion-learner/get_data.php";
        
        NSURL *url = [NSURL URLWithString:dbURL];
        //Prepare reqeust
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        
        
        //Read current time
        //Triple looks like
        //<observation-time> <observed-property> <observed-value>
        //
        
        //[[\"<http://observation#measure>\", \"<http://observation#id>\", \"\"0\"^^xsd:integer\"],\
        
        //NSString *jsonRequest = [NSString stringWithFormat:@"\
        <http://observation#measure> <http://observation#type> <http://observation#acc> .\
        <http://observation#measure> <http://observation#time> \"%f\" .\
        <http://observation#measure> <http://observation#accX> \"%f\" .\
        <http://observation#measure> <http://observation#accY> \"%f\" .\
        <http://observation#measure> <http://observation#accZ> \"%f\" .",currenttime,accX,accY,accZ];
        
        
        NSMutableArray *accData = [[NSMutableArray alloc] initWithCapacity:0];
        [accData addObject:[NSNumber numberWithDouble:currenttime]];
        [accData addObject:[NSNumber numberWithDouble:accX]];
        [accData addObject:[NSNumber numberWithDouble:accY]];
        [accData addObject:[NSNumber numberWithDouble:accZ]];
        
        NSData *requestData = [NSData dataWithBytes:(__bridge const void *)(accData) length:sizeof(accData)];
        
        //Set header
        [request setHTTPBody:requestData];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
        [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        
        //Send message
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        //Get response
        NSHTTPURLResponse* urlResponse = nil;
        NSError *error = [[NSError alloc] init];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSLog(@"Response code:%d",[urlResponse statusCode]);
        NSLog(@"Response content:%@",result);
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    // Use the true heading if it is valid.
    self.heandingInfo.text = [NSString stringWithFormat:@"%f",newHeading.trueHeading];
    
}

- (void)sendDataGyro:(int)id withTime:(double)currenttime withGyroX:(double)gyroX withGyroY:(double)gyroY withGyroZ:(double)gyroZ{
    
    if(true){
        
        NSString* dbURL = @"http://128.113.106.82:10035/web-motion-learner/get_data.php";
        
        NSURL *url = [NSURL URLWithString:dbURL];
        //Prepare reqeust
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        
        
        //Read current time
        //Triple looks like
        //<observation-time> <observed-property> <observed-value>
        //
        
        //NSString *jsonRequest = [NSString stringWithFormat:@"\
        <http://observation#measure> <http://observation#type> <http://observation#gyro> .\
        <http://observation#measure> <http://observation#time> \"%f\" .\
        <http://observation#measure> <http://observation#gyroX> \"%f\" .\
        <http://observation#measure> <http://observation#gyroY> \"%f\" .\
        <http://observation#measure> <http://observation#gyroZ> \"%f\" .",currenttime,gyroX,gyroY,gyroZ];
        
        NSMutableArray *gyroData = [[NSMutableArray alloc] initWithCapacity:0];
        [gyroData addObject:[NSNumber numberWithDouble:currenttime]];
        [gyroData addObject:[NSNumber numberWithDouble:gyroX]];
        [gyroData addObject:[NSNumber numberWithDouble:gyroY]];
        [gyroData addObject:[NSNumber numberWithDouble:gyroZ]];
        
        NSData *requestData = [NSData dataWithBytes:(__bridge const void *)(gyroData) length:sizeof(gyroData)];
        
        //Set header
        [request setHTTPBody:requestData];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
        [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        //Send message
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        //Get response
        NSHTTPURLResponse* urlResponse = nil;
        NSError *error = [[NSError alloc] init];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSLog(@"Response code:%d",[urlResponse statusCode]);
        NSLog(@"Response content:%@",result);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    //NSLog(@"updateInterval: %f", acceleration.x);
    
    self.labelX.text = [NSString stringWithFormat:@"%f", acceleration.x];
    
    self.labelY.text = [NSString stringWithFormat:@"%f", acceleration.y];
    self.labelZ.text = [NSString stringWithFormat:@"%f", acceleration.z];
    
    self.progressX.progress = ABS(acceleration.x);
    self.progressY.progress = ABS(acceleration.y);
    self.progressZ.progress = ABS(acceleration.z);
    
    //if(self.flag){
    NSLog(@"%f",[[NSDate date] timeIntervalSince1970]);
    
        [self sendDataToServer:1 withTime:[[NSDate date] timeIntervalSince1970] withAccX:acceleration.x withAccY:acceleration.y withAccZ:acceleration.z withGyroX:[self.gyroLabelX.text doubleValue] withGyroY:[self.gyroLabelY.text doubleValue] withGyroZ:[self.gyroLabelZ.text doubleValue] withHeading:[self.heandingInfo.text doubleValue]];
        //self.flag = !self.flag;
    //}else{
      //  self.flag = true;
    //}
    
    //Get the current label of gyro regarding this as the current value
    
    //[self sendDataGyro:1 withTime:[[NSDate date] timeIntervalSince1970] withGyroX:acceleration.x withGyroY:acceleration.y withGyroZ:acceleration.z];
    
}

- (void)sendDataToServer:(int)id withTime:(double)currentTime withAccX:(double)accX withAccY:(double)accY withAccZ:(double)accZ withGyroX:(double)gyroX withGyroY:(double)gyroY withGyroZ:(double)gyroZ withHeading:(double)heading{
    
    
    NSLog(@"Sending request");
    //NSString* dbURL = @"http://128.113.106.26/web-motion-learner/get_data.php?";
    NSString* dbURL = @"http://128.113.106.26:8080/motion-detector/services/data/add";
    
    NSURL *url = [NSURL URLWithString:dbURL];
    //Prepare reqeust
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSMutableArray *requestDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    [requestDataArray addObject:[NSNumber numberWithDouble:currentTime]];
    [requestDataArray addObject:[NSNumber numberWithDouble:accX]];
    [requestDataArray addObject:[NSNumber numberWithDouble:accY]];
    [requestDataArray addObject:[NSNumber numberWithDouble:accZ]];
    [requestDataArray addObject:[NSNumber numberWithDouble:gyroX]];
    [requestDataArray addObject:[NSNumber numberWithDouble:gyroY]];
    [requestDataArray addObject:[NSNumber numberWithDouble:gyroZ]];
    //NSLog(@"%d",(int)self.activityCode);
    [requestDataArray addObject:[NSNumber numberWithInteger:self.activityCode]];
    
    
    //NSString *dataInString = [NSString stringWithFormat:@"data=%f,%f,%f,%f,%f,%f,%f,%f,%d\r\n",currentTime,accX,accY,accZ,gyroX,gyroY,gyroZ,heading,self.activityCode];
    NSString *dataInString = [NSString stringWithFormat:@"<sensorData><timeStamp>%f</timeStamp><accX>%f</accX><accY>%f</accY><accZ>%f</accZ><gyroX>%f</gyroX><gyroY>%f</gyroY><gyroZ>%f</gyroZ><compass>%f</compass><action>%d</action></sensorData>\r\n",currentTime,accX,accY,accZ,gyroX,gyroY,gyroZ,heading,self.activityCode];
    
    //NSData *requestData = [NSData dataWithBytes:(__bridge const void *)(requestDataArray) length:sizeof(requestDataArray)];
    NSData *requestData = [NSData dataWithBytes:[dataInString UTF8String] length:[dataInString length]];
    //Set header
    [request setHTTPBody:requestData];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
    
    //Send message
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    //Get response
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    self.responseCode.text = [NSString stringWithFormat:@"%d",[urlResponse statusCode]];
    self.responseContent.text =[NSString stringWithFormat:@"%@",requestData];
    
    NSLog(@"Response code:%d",[urlResponse statusCode]);
    //NSLog(@"Response content:%@",requestData);
    
}



@end
