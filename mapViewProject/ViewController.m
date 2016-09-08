//
//  ViewController.m
//  mapViewProject
//
//  Created by amir sankar on 7/25/16.
//  Copyright © 2016 amir sankar. All rights reserved.
//

#import "ViewController.h"
#import "Annotation.h"

@interface ViewController ()

@end

@implementation ViewController

#define TTT_LATITUDE 40.741434
#define TTT_LONGITUDE -73.990039

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager setDelegate:self];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    self.mapView.showsUserLocation = YES;
    self.searchBar.delegate = self;
    CLLocationCoordinate2D tttLocation;
    tttLocation.latitude = TTT_LATITUDE;
    tttLocation.longitude = TTT_LONGITUDE;
    
    MKCoordinateRegion myRegion;
    myRegion.center = tttLocation;
    myRegion.span.latitudeDelta = 0.01;
    myRegion.span.longitudeDelta = 0.01;
    self.mapView.delegate = self;

    [self.mapView setRegion:myRegion animated:YES];

    Annotation *tttech = [Annotation alloc];
    tttech.coordinate = tttLocation;
    tttech.title = @"TurnToTech";
    tttech.subtitle = @"iOS BootCamp";
    tttech.urlString = @"http://turntotech.io/";
    
    [self.mapView addAnnotation: tttech];
    [self hardCodePins];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (IBAction)segmentControlla:(id)sender
{
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}

-(void)hardCodePins
{
    Annotation *inday = [Annotation alloc];
    inday.coordinate = CLLocationCoordinate2DMake(40.743699, -73.989408);
    inday.title = @"Inday";
    inday.subtitle = @"Good Karma Served Daily";
    inday.urlString = @"http://indaynyc.com";
    
    [self.mapView addAnnotation:inday];
    
    Annotation *sushiro = [Annotation alloc];
    sushiro.coordinate = CLLocationCoordinate2DMake(40.740856, -73.985508);
    sushiro.title = @"Sushisro";
    sushiro.subtitle = @"Seasonal Japanese Kitchen";
    sushiro.urlString = @"http://www.sushiro.com";
    
    [self.mapView addAnnotation:sushiro];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *view = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"];
    
    view.enabled = YES;
    view.animatesDrop = YES;
    view.canShowCallout = YES;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AAPL.jpg"]];
    view.leftCalloutAccessoryView = imageView;
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return view;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"Location: %f, %f",
          userLocation.location.coordinate.latitude,
          userLocation.location.coordinate.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 250, 250);
    [self.mapView setRegion:region animated:YES];
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    Annotation *ann = (Annotation *)view.annotation;
    [self.mapView deselectAnnotation:ann animated:YES];
    self.wvc = [[WebView alloc]init];
    self.wvc.url = ann.urlString;
    
    [self presentViewController:self.wvc animated:YES completion:nil];
}

-(void)mapView:(MKMapView*)mapView didSelectAnnotationView:(MKAnnotationView*)view {
    
    if(![view.annotation isKindOfClass:[MKUserLocation class]]) {
        Annotation * myAnnotation = (Annotation*)view.annotation;
        UIImageView * leftCalloutView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 40, 40)];
        
        if ([myAnnotation.title isEqualToString:@"TurnToTech"]) {
            [leftCalloutView setImage:[UIImage imageNamed:@"ttttLogo.png"]];
            leftCalloutView.layer.masksToBounds = YES;
            leftCalloutView.layer.cornerRadius = 6;
            
        }else {
            
            [leftCalloutView setImage:[UIImage imageNamed:@"foodIcon.png"]];
            leftCalloutView.layer.masksToBounds = YES;
            leftCalloutView.layer.cornerRadius = 6;
            
        }
        view.leftCalloutAccessoryView = leftCalloutView;
        
    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if (!self.annArray) {
        self.annArray = [[NSMutableArray alloc]init];
    } else {
        [self.mapView removeAnnotations:self.annArray];
        [self.annArray removeAllObjects];
    }
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchBar.text;
    request.region = self.mapView.region;
    
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (!error) {
            for (MKMapItem *mapItem in [response mapItems]) {
                CLLocationCoordinate2D coord = [[[mapItem placemark]location] coordinate];
                Annotation *ann = [[Annotation alloc]init];
                ann.coordinate = coord;
                ann.title = [mapItem name];
                [self.annArray addObject:ann];
            }
            [self.mapView addAnnotations:self.annArray];
        } else {
            NSLog(@"Search Request Error: %@", [error localizedDescription]);
        }
    }];
}



@end
