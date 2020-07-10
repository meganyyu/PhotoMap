//
//  PhotoMapViewController.m
//  PhotoMap
//
//  Created by emersonmalca on 7/8/18.
//  Copyright © 2018 Codepath. All rights reserved.
//

#import "PhotoMapViewController.h"

#import "FullImageViewController.h"
#import "LocationsViewController.h"
#import <MapKit/MapKit.h>
#import "PhotoAnnotation.h"

static NSString *const kTagSegueID = @"tagSegue";
static NSString *const kFullImageSegueID = @"fullImageSegue";

#pragma mark - Interface

@interface PhotoMapViewController () <LocationsViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *const mapView;
@property (strong, nonatomic) UIImage *selectedImage;

@end

#pragma mark - Implementation

@implementation PhotoMapViewController

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapView.delegate = self;
    
    //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
    MKCoordinateRegion const sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1));
    [_mapView setRegion:sfRegion animated:false];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - User Interaction

- (IBAction)didTapCamera:(id)sender {
    UIImagePickerController *const imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *const editedImage = info[UIImagePickerControllerEditedImage];
    
    _selectedImage = editedImage;
    
    [self performSegueWithIdentifier:kTagSegueID sender:_selectedImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LocationsViewControllerDelegate

- (void)locationsViewController:(LocationsViewController *const)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude {
    CLLocationCoordinate2D const coordinate = CLLocationCoordinate2DMake(latitude.floatValue, longitude.floatValue);
    
    PhotoAnnotation *const point = [[PhotoAnnotation alloc] init];
    point.coordinate = coordinate;
    point.photo = [self resizeImage:_selectedImage withSize:CGSizeMake(50.0, 50.0)];
    [_mapView addAnnotation:point];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage *)resizeImage:(UIImage *const)image withSize:(CGSize)size {
    UIImageView *const resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - MapView

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        annotationView.canShowCallout = true;
        annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    UIImageView *imageView = (UIImageView*)annotationView.leftCalloutAccessoryView;
    //imageView.image = [UIImage imageNamed:@"camera-icon"];
    imageView.image = _selectedImage;
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(nonnull MKAnnotationView *)view calloutAccessoryControlTapped:(nonnull UIControl *)control {
    [self performSegueWithIdentifier:kFullImageSegueID sender:((UIImageView*)view.leftCalloutAccessoryView).image];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:kTagSegueID]) {
        LocationsViewController *locationsViewController = [segue destinationViewController];
        locationsViewController.delegate = self;
    } else if ([[segue identifier] isEqualToString:kFullImageSegueID]) {
        FullImageViewController *fullImageViewController = [segue destinationViewController];
        UIImage *image = (UIImage*)sender;
        fullImageViewController.selectedImage = image;
    }
}

@end
