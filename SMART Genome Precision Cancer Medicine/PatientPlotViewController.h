//
//  PatientPlotViewController.h
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/25/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CorePlot-CocoaTouch.h"

#import "FHIRBundle.h"
#import "FHIRBundleEntryComponent.h"
#import "FHIRExtension.h"
#import "FHIRUri.h"
#import "FHIRObservation.h"

#import "FHIRDataServiceDelegate.h"
#import "FHIRDataService.h"
#import "FHIRPopulationDataService.h"

#import "GeneData.h"
#import "AminoAcidData.h"

#import "LargePiePlotNavigationController.h"

@interface PatientPlotViewController : UIViewController <UIWebViewDelegate, FHIRDataServiceDelegate, CPTPieChartDelegate, CPTPieChartDataSource, CPTLegendDelegate, CPTPlotSpaceDelegate>

@property (nonatomic, weak) NSDictionary *patientDiseaseData;
@property (nonatomic, weak) NSDictionary *patientGeneData;
@property (nonatomic, weak) NSDictionary *patientNucleotideData;
@property (nonatomic, weak) NSDictionary *patientAminoAcidData;

@end
