//
//  ViewController.h
//  mapViewProject
//
//  Created by amir sankar on 7/25/16.
//  Copyright © 2016 amir sankar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/Mapkit.h>
#import "WebView.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate>

@property(nonatomic,strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) WebView *wvc;
@property (strong, nonatomic) NSMutableArray *annArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)segmentControlla:(id)sender;

@end

