//
//  FHIRBundleEntryComponent.h
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/28/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import "FHIRElement.h"

#import "FHIRBundle.h"
#import "FHIRErrorList.h"

@class FHIRCodeableConcept;
@class FHIRBoolean;
@class FHIRDateTime;
@class FHIRResource;

@interface FHIRBundleEntryComponent : FHIRElement

/*
 * Title of Bundle Entry
 */
@property (nonatomic, strong) FHIRString *titleElement;

@property (nonatomic, strong) NSString *title;

/*
 * Last updated date
 */
@property (nonatomic, strong) FHIRDateTime *updatedElement;

@property (nonatomic, strong) NSString *updated;

/*
 * The content for this bundle entry
 */
@property (nonatomic, strong) FHIRBaseResource *content;

- (FHIRErrorList *)validate;

@end
