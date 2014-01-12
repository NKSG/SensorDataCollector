//
//  SelectActivityViewController.m
//  SensorDataCollector
//
//  Created by momo on 3/26/13.
//  Copyright (c) 2013 RPI. All rights reserved.
//

#import "SelectActivityViewController.h"
#import "NaviViewController.h"
#import "StatsViewController.h"
#import "activityInfo.h"

@interface SelectActivityViewController ()

@end

@implementation SelectActivityViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    activityList = [[NSMutableArray alloc] init];
    [activityList addObject:@"Jumping"];
    [activityList addObject:@"Walking"];
    [activityList addObject:@"Running"];
    [activityList addObject:@"Stepping_up"];
    [activityList addObject:@"Stepping_down"];
    [activityList addObject:@"Turning_left"];
    [activityList addObject:@"Turning_right"];
    self.activityPicker.delegate = self;
    /*
    self.currentActivityLabel.text = [[activityInfo sharedInstance] activityName];
    */
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [activityList count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [activityList objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.activityName = [activityList objectAtIndex:row];
    //NSLog(@"%@",self.activityName);
}

- (IBAction)ActionPressed:(id)sender {
    
    
    [[activityInfo sharedInstance] setActivityName:self.activityName];
    
    //[[activityInfo sharedInstance] setActivityName:self.activityName];
    //[globalInfo setActivityName:[NSString stringWithFormat:@"%@",self.activityName]];
    
    //NSLog(@"Button has been pressed,current activity is %@",[[activityInfo sharedInstance] activityName]);
    
    StatsViewController *nextView = [[StatsViewController alloc] initWithNibName:@"StatsViewController" bundle:nil];
    
    [self.navigationController pushViewController:nextView animated:YES];
    
}

@end
