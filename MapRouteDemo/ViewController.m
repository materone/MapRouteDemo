//
//  ViewController.m
//  MapRouteDemo
//
//  Created by 5dscape on 12-11-26.
//  Copyright (c) 2012年 kai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize home,office;
@synthesize fromText;
- (void)viewDidLoad
{
    [super viewDidLoad];
    mapView = [[MapView alloc] initWithFrame:
               CGRectMake(0, 44, self.view.frame.size.width,460-44)] ;
	[self.view addSubview:mapView];
	
	home = [[Place alloc] init] ;
	home.name = @"Home";
	home.description = @"Sweet home";
	home.latitude = 32.0409922;
	home.longitude = 118.7840290;
	
	office = [[Place alloc] init] ;
	office.name = @"Office";
	office.description = @"Bad office";
	office.latitude = 31.9824290;
	office.longitude = 118.7449390;
	[mapView showRouteFrom:home to:office];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAct:)];
    longPress.minimumPressDuration = 1;
    [mapView addGestureRecognizer:longPress];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == fromText) {
        [self search:nil];
    }
    return YES;
}

- (void)longPressAct:(UILongPressGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"longlonglonglonglong");
        CGPoint touchPoint = [recognizer locationInView:mapView.mapView];
        CLLocationCoordinate2D coordinate = [mapView.mapView convertPoint:touchPoint toCoordinateFromView:mapView.mapView];
        office.longitude = coordinate.longitude;
        office.latitude = coordinate.latitude;
        [mapView showRouteFrom:home to:office];
    }
}

- (IBAction)search:(id)sender
{
    [fromText resignFirstResponder];
    
    NSString *urlStr = [[NSString stringWithFormat:@"http://maps.apple.com/maps/geo?q=%@&output=csv",fromText.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *apiResponse = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlStr] encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",apiResponse);
    if (apiResponse.length != 0) {
        NSArray *array = [apiResponse componentsSeparatedByString:@","];
        NSLog(@"%@",array);
        office.latitude = [[array objectAtIndex:2] floatValue];
        office.longitude = [[array objectAtIndex:3] floatValue];
        [mapView showRouteFrom:home to:office];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"无法查找路线，请检查输入或网络连接" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)userCurrentLocation:(id)sender {
    locmanager = [[CLLocationManager alloc] init];
    [locmanager setDelegate:self];
    [locmanager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locmanager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D loc = [newLocation coordinate];
    
    NSString *latitude = [NSString stringWithFormat: @"%f", loc.latitude];//获取纬度
    NSString *longitude = [NSString stringWithFormat: @"%f", loc.longitude];//获取经度
    
    NSLog(@"%@,%@",latitude,longitude);
    
    office = [[Place alloc] init] ;
	office.name = @"Office";
	office.description = @"Bad office";
	office.latitude = loc.latitude;
	office.longitude = loc.longitude;
	[mapView showRouteFrom:home to:office];
}


@end
