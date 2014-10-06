//
//  FHIRPopulationDataService.h
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/24/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FHIRParser.h"
#import "FHIRBundle.h"
#import "FHIRResource.h"

#import "FHIRDataHelper.h"
#import "FHIRDataConnection.h"
#import "FHIRDataServiceDelegate.h"

@interface FHIRPopulationDataService : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, assign) id<FHIRDataServiceDelegate> fhirDataServiceDelegate;

- (void) queryPopulationForResource:(NSString *)resource
                         withParams:(NSDictionary *)params
                      andIDProperty:(NSString *)idProperty
                        andIDValues:(NSArray *) idValues;

- (void) searchPopulationForResource:(NSString *)resource
                          withParams:(NSDictionary *)params
                       andIDProperty:(NSString *)idProperty
                         andIDValues:(NSArray *) idValues;

- (void) cancelConnection;

@end
