//
//  KBViewController.m
//  SensorDataCollector
//
//  Created by Yu Chen on 1/12/14.
//  Copyright (c) 2014 RPI. All rights reserved.
//

#import "KBViewController.h"
#define sampleRate 100
#define interestsInterval 0.5

@interface KBViewController ()

@end

@implementation KBViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Initialize keyboard notification
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyPressed:) name: UITextViewTextDidChangeNotification object: nil];

    
    // Initialize sensors
    flag = false;
    accX = [[NSMutableArray alloc] init];
    accY = [[NSMutableArray alloc] init];
    accZ = [[NSMutableArray alloc] init];
    gyroX = [[NSMutableArray alloc] init];
    gyroY = [[NSMutableArray alloc] init];
    gyroZ = [[NSMutableArray alloc] init];
    allData = [[NSMutableArray alloc] init];
    OnePatchData = [[NSDictionary alloc] init];
    
    self.accelerometer = [UIAccelerometer sharedAccelerometer];
    self.accelerometer.updateInterval = 0.01;
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
    
    //Gyroscope
    if([self.motionManager isGyroAvailable])
    {
        /* Start the gyroscope if it is not active already */
        if([self.motionManager isGyroActive] == NO)
        {
            /* Update us 2 times a second */
            [self.motionManager setGyroUpdateInterval:1.0f / 100.0f];
            
            /* And on a handler block object */
            
            /* Receive the gyroscope data on this block */
            [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue]
                                            withHandler:^(CMGyroData *gyroData, NSError *error)
             {
                 gyroXReading = gyroData.rotationRate.x;
                 gyroYReading = gyroData.rotationRate.y;
                 gyroZReading = gyroData.rotationRate.z;
             }];
        }
    }
    else
    {
        NSLog(@"Gyroscope not Available!");
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) keyPressed: (NSNotification*) notification
{
    NSString *tmpStr = [[notification object] text];
    key = [tmpStr substringFromIndex:([tmpStr length]-1)];
    flag = true;
    NSLog(@"%@ pressed",key);
    
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    if(flag){
        //Add values if flag is true
        [accX addObject:[NSString stringWithFormat:@"%f",acceleration.x]];
        [accY addObject:[NSString stringWithFormat:@"%f",acceleration.y]];
        [accZ addObject:[NSString stringWithFormat:@"%f",acceleration.z]];
        [gyroX addObject:[NSString stringWithFormat:@"%f",gyroXReading]];
        [gyroY addObject:[NSString stringWithFormat:@"%f",gyroYReading]];
        [gyroZ addObject:[NSString stringWithFormat:@"%f",gyroZReading]];
        NSLog(@"%d",[accX count]);
        if ([accX count]>=50) {
            flag = false;
            
        }
        
    }
    
    if (!flag) {
        if ([accX count]!=0) {
            // Encapsulate the data the reset the mutable array
            OnePatchData = @{@"key":key,
                             @"accX":[accX componentsJoinedByString:@","],
                             @"accY":[accY componentsJoinedByString:@","],
                             @"accZ":[accZ componentsJoinedByString:@","],
                             @"gyroX":[gyroX componentsJoinedByString:@","],
                             @"gyroY":[gyroY componentsJoinedByString:@","],
                             @"gyroZ":[gyroZ componentsJoinedByString:@","],
                             };
            
            [allData addObject:OnePatchData];
            OnePatchData = [[NSDictionary alloc] init];
            NSLog(@"Wrapping up...");
            [accX removeAllObjects];
            [accY removeAllObjects];
            [accZ removeAllObjects];
            [gyroX removeAllObjects];
            [gyroY removeAllObjects];
            [gyroZ removeAllObjects];
        }
        
    }
    
    
}

- (IBAction)sendData:(id)sender {
    
    //Convert the data to json and send to email receiver
    NSError *error;
    NSLog(@"Reading...%@",[allData objectAtIndex:([allData count]-1)][@"accX"]);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:allData options:NSJSONWritingPrettyPrinted error:&error];
    [allData removeAllObjects];
    if (!jsonData) {
        NSLog(@"Got and error: %@",error);
    }else{
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Object being sent: %@",jsonString);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSLog(@"Data stored at: %@/data.json",documentsDirectory);
        //NSString *jsonPath=[[NSSearchPathForDirectoriesInDomains(NSUserDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingFormat:@"/data.json"];
        
        [jsonData writeToFile:[documentsDirectory stringByAppendingString:@"/data.json"] atomically:YES];
        
    }
   
}


@end
