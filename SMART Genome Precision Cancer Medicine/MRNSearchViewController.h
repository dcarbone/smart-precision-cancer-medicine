//
//  MRNViewController.h
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/24/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MRNSearchView.h"
#import "FHIRDataService.h"
#import "PatientViewController.h"

@interface MRNSearchViewController : UIViewController <FHIRDataServiceDelegate, MRNSearchDelegate>

@end
