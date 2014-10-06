//
//  PatientContainerView.h
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/23/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CorePlot-CocoaTouch.h"

#import "PatientDetailView.h"
#import "PatientGenomePhenomeDataView.h"

@interface PatientContainerView : UIView

@property (nonatomic, strong) PatientDetailView *patientDetailView;
@property (nonatomic, strong) PatientGenomePhenomeDataView *genomePhenomeDataView;
@property (nonatomic, weak) UIView *populationPlotView;

@end
