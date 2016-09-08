//
//  Annotation.h
//  mapViewProject
//
//  Created by amir sankar on 7/26/16.
//  Copyright © 2016 amir sankar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/Mapkit.h>

@interface Annotation : NSObject <MKAnnotation>

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;

@property(nonatomic, strong) NSString *urlString;

@end
