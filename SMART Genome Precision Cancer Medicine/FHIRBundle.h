//
//  FHIRBundle.h
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/28/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import "FHIRBaseResource.h"

@class FHIRString;
@class FHIRInteger;
@class FHIRDateTime;
@class FHIRResource;

@interface FHIRBundle : FHIRBaseResource

/*
 * Type of resource being returned.
 */
@property (nonatomic, strong) FHIRString *resourceTypeElement;

@property (nonatomic, strong) NSString *resourceType;

/*
 * Title of Bundle
 */
@property (nonatomic, strong) FHIRString *titleElement;

@property (nonatomic, strong) NSString *title;

/*
 * Local ID for element
 */
@property (nonatomic, strong) FHIRId *idElement;

@property (nonatomic, strong) NSString *id;

/*
 * Number of results in this bundle
 */
@property (nonatomic, strong) FHIRInteger *totalResultsElement;

@property (nonatomic, strong) NSNumber *totalResults;

/*
 * Last updated Date and Time of bundled resources
 */
@property (nonatomic, strong) FHIRDateTime *updatedElement;

@property (nonatomic, strong) NSString *updated;

/*
 * Who and/or what authored the document
 */
@property (nonatomic, strong) NSArray/*<ResourceReference>*/ *author;

/*
 * Array of resources included in this bundle
 */
@property (nonatomic, strong) NSArray *entry;

- (FHIRErrorList *)validate;

@end
