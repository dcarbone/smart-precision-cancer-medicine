//
//  PatientDetailView.h
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/29/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PatientDetailLabel.h"
#import "PatientViewTitleLabel.h"

#import "FHIRPatient.h"

#import "FHIRDataHelper.h"

@interface PatientDetailView : UIView

- (id) initWithPatient:(FHIRPatient *)patient;

@end
