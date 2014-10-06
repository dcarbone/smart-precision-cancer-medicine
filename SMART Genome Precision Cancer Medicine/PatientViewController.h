//
//  PatientViewController.h
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/29/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PatientDetailView.h"
#import "PatientContainerView.h"

#import "FHIRBundle.h"
#import "FHIRBundleEntryComponent.h"
#import "FHIRExtension.h"
#import "FHIRUri.h"
#import "FHIRObservation.h"

#import "FHIRDataService.h"
#import "FHIRDataHelper.h"

#import "PatientPlotViewController.h"

@interface PatientViewController : UIViewController <FHIRDataServiceDelegate>

- (id) initWithPatient: (FHIRPatient *)patient;

@end
