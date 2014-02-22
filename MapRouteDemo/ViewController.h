//
//  ViewController.h
//  MapRouteDemo
//
//  Created by 5dscape on 12-11-26.
//  Copyright (c) 2012年 kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapView.h"
#import "Place.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController : UIViewController<CLLocationManagerDelegate>
{
    MapView* mapView;
    Place *home;
    Place* office;
    CLLocationManager *locmanager;
}
@property (strong, nonatomic) Place* office;
@property (strong, nonatomic) Place *home;
@property (strong, nonatomic) IBOutlet UITextField *fromText;
- (IBAction)search:(id)sender;
- (IBAction)userCurrentLocation:(id)sender;
@end
