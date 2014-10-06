//
//  PatientGenomePhenomeDataView.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/3/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FHIRObservation.h"
#import "FHIRPatient.h"
#import "FHIRCode.h"
#import "FHIRCoding.h"
#import "FHIRCodeableConcept.h"
#import "FHIRExtension.h"
#import "FHIRNarrative.h"
#import "FHIRUri.h"

#import "FHIRDataHelper.h"

#import "PatientDetailLabel.h"
#import "PatientViewTitleLabel.h"

@interface PatientGenomePhenomeDataView : UIView

- (id) initWithDiseaseData:(NSDictionary *)diseaseData andGeneData:(NSDictionary *)geneData andNucleotideData:(NSDictionary *)nucleotideData andAminoAcidData:(NSDictionary *)aminoAcidData;

@end
