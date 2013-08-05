//
//  FirstViewController.m
//  RoadtripFun
//
//  Created by Jason Huang on 7/15/13.
//  Copyright (c) 2013 Sihang Huang. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "APIHelper.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface MapViewController ()<UISearchDisplayDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate,APIHelperDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    CLLocationManager *localManager;
    CLAuthorizationStatus locationManagerAuthorizeStatus;
    CLLocation *previousLocal;
    NSMutableArray *locationsArray;
    UIImagePickerController *imagePicker;
}

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if(!CLLocationManager.locationServicesEnabled){
        //alert: location service is off!
                
        return;
    }else{
        
        locationsArray = [NSMutableArray array];
        
        localManager = [[CLLocationManager alloc] init];
        localManager.delegate = self;
        localManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;//every 2 miles
        localManager.activityType = CLActivityTypeAutomotiveNavigation;
        [localManager startUpdatingLocation];
        [self.mapview setUserTrackingMode:MKUserTrackingModeFollow];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - map view delegate

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView *lineView = [[MKPolylineView alloc] initWithPolyline:(MKPolyline *)overlay];
        lineView.fillColor = [UIColor redColor];
        lineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        lineView.lineWidth = 10;
        return lineView;
    }else{
        return nil;
    }
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
    //draw the path
//    if (previousLocal) {
//        CLLocation *currentLocal =(CLLocation *)[locations objectAtIndex:0];
//        CLLocationCoordinate2D coords[2];
//        coords[0] = previousLocal.coordinate;
//        coords[1] = currentLocal.coordinate;
//        MKPolyline *line = [MKPolyline polylineWithCoordinates:coords count:sizeof(coords)/sizeof(CLLocationCoordinate2D)];
//        [self.mapview addOverlay:line];
//    }
//    
//    //current location would be the next previous location
//    previousLocal = (CLLocation *)[locations objectAtIndex:0];
    
    [locationsArray addObject:[locations objectAtIndex:0]];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"fail to update location with error:\n%@",error.description);
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
    NSLog(@"fail");
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

#pragma mark - IBAction

- (IBAction)buttonTapped:(id)sender {
    CLLocationCoordinate2D coords[locationsArray.count];
    for (int i = 0; i<locationsArray.count; i++) {
        coords[i] = ((CLLocation *)locationsArray[i]).coordinate;
    }
    
    MKPolyline *line = [MKPolyline polylineWithCoordinates:coords count:sizeof(coords)/sizeof(CLLocationCoordinate2D)];
    [self.mapview addOverlay:line];
}

- (IBAction)cameraButtonTapped:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a photo",@"Add from gallery",@"Film a video", nil];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //take a photo
    if (buttonIndex == 0) {
        if ([self checkCameraAvailability]) {
            [self initImagePickerViewController];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        }
    }else if (buttonIndex ==1){//add from galerry
        if ([self checkGelleryAvailability]) {
            [self initImagePickerViewController];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }else if (buttonIndex == 2){//film a video
        if ([self checkCameraAvailability]) {
            [self initImagePickerViewController];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
        }
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - image picker view controller

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:@"UIImagePickerControllerMediaType"];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *editedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        NSURL *videoURL = [info objectForKey:@"UIImagePickerControllerMediaURL"];
    }
}

-(void)initImagePickerViewController{
    if (!imagePicker) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
    }
}

-(BOOL)checkCameraAvailability{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Camera not supported on this device" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show
         ];
        return NO;
    }else{
        return YES;
    }
}

-(BOOL)checkGelleryAvailability{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Photo gellery not supported on this device" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show
         ];
        return NO;
    }else{
        return YES;
    }
}

@end




