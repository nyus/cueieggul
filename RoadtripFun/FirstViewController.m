//
//  FirstViewController.m
//  RoadtripFun
//
//  Created by Jason Huang on 7/15/13.
//  Copyright (c) 2013 Sihang Huang. All rights reserved.
//

#import "FirstViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "APIHelper.h"
@interface FirstViewController ()<UISearchDisplayDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate,APIHelperDelegate>{
    CLLocationManager *localManager;
    CLAuthorizationStatus locationManagerAuthorizeStatus;
}

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if(!CLLocationManager.locationServicesEnabled){
        //alert: location service is off!
                
        return;
    }else{
        localManager = [[CLLocationManager alloc] init];
        localManager.delegate = self;
        localManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;//every 2 miles
        localManager.activityType = CLActivityTypeAutomotiveNavigation;
        [localManager startMonitoringSignificantLocationChanges];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

#pragma mark - searchbar delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //hit maps api to search for places
    APIHelper *helper=[[APIHelper alloc] init];
    helper.delegate = self;
    [helper launchGoogleMapsRadarSearchWithLocation:localManager.location.coordinate radiusInMiles:5 keyword:nil name:searchBar.text];
    //store the search item so that can display it next time as history search
}

#pragma mark - cllocation manager

-(void)userAuthorizedRoadTripFun{
}

-(void)userUnauthorizedRoadTripFun{

}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    locationManagerAuthorizeStatus = status;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //An array of CLLocation objects containing the location data. The most recent location update is at the end of the array.
    CLLocation *latestLocal =(CLLocation *)[locations objectAtIndex:0];
    [self.mapview setCenterCoordinate:latestLocal.coordinate animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"fail to update location with error:\n%@",error.description);
}

#pragma mark - api helper delegate
-(void)didRecieveJsonOjbectFromURLConnection:(id)jsonObject{
    //OK indicates that no errors occurred; the place was successfully detected and at least one result was returned.
    //ZERO_RESULTS indicates that the search was successful but returned no results. This may occur if the search was passed a latlng in a remote location.
    //OVER_QUERY_LIMIT indicates that you are over your quota.
    //REQUEST_DENIED indicates that your request was denied, generally because of lack of a sensor parameter.
    //INVALID_REQUEST generally indicates that a required query parameter (location or radius) is missing.
}
-(void)didFailWithError:(NSError *)error{}
@end
