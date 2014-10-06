//
//  FHIRDataService.h
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/26/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FHIRParser.h"
#import "FHIRBundle.h"
#import "FHIRResource.h"

#import "FHIRDataHelper.h"
#import "FHIRDataServiceDelegate.h"
#import "FHIRDataConnection.h"

@interface FHIRDataService : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, assign) id<FHIRDataServiceDelegate> fhirDataServiceDelegate;

- (void) queryForResource:(NSString *)resource andShouldFetchAll:(BOOL)fetchAll;
- (void) queryForResource:(NSString *)resource withID:(NSString *)resourceId andShouldFetchAll:(BOOL)fetchAll;
- (void) queryForResource:(NSString *)resource withParamKeys:(NSArray *)paramKeys andParamValues:(NSArray *)paramValues andShouldFetchAll:(BOOL)fetchAll;
- (void) searchForResource:(NSString *)resource withParamKeys:(NSArray *)paramKeys andParamValues:(NSArray *)paramValues andShouldFetchAll:(BOOL)fetchAll;

- (void) executeQuery:(NSString *)requestURLString withKeys:(NSArray *)paramKeys andValues:(NSArray *)paramValues andShouldFetchAll:(BOOL)fetchAll;

- (void) cancelConnection;

@end
