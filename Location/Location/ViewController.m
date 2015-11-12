//
//  ViewController.m
//  Location
//
//  Created by Akanksha Nagpal on 11/5/15.
//  Copyright © 2015 Akanksha Nagpal. All rights reserved.
//

#import "ViewController.h"
# import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *longitude;
@property (weak, nonatomic) IBOutlet UILabel *address;
- (IBAction)buttonPressed:(id)sender;

@end

@implementation ViewController
{
    CLLocationManager *manager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    manager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(id)sender {
    
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [manager startUpdatingLocation];
    [manager requestWhenInUseAuthorization];
}


#pragma mark CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
    NSLog(@"Failed to get Location! :(");
}

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
     NSLog(@"Location: %@", newLocation);
     CLLocation *currentLocation = newLocation;
    
    if(currentLocation != nil)
    {
        self.latitude.text = [NSString stringWithFormat:@"%.8f",currentLocation.coordinate.latitude];
        
        self.longitude.text = [NSString stringWithFormat:@"%.8f",currentLocation.coordinate.longitude];
    }
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler: ^(NSArray *placemarks, NSError *error)
     {
         if(error == nil && [placemarks count] > 0)
         {
             placemark = [placemarks lastObject];
             self.address.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",placemark.subThoroughfare,
                                  placemark.thoroughfare,placemark.postalCode, placemark.locality, placemark.administrativeArea,placemark.country];
         }
         else
         {
             NSLog(@"%@",error.debugDescription);
         }
     }];
}


@end
