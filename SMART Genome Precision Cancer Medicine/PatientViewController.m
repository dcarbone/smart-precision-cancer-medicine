//
//  PatientViewController.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/29/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import "PatientViewController.h"

#import "SVProgressHUD.h"

typedef enum {
    pvcSourcePatientObservations,
} PatientDataQueryStatus;

@interface PatientViewController ()

@property (nonatomic, strong) FHIRPatient *patient;
@property (nonatomic, strong) NSString *patientId;
@property (nonatomic, strong) NSArray *patientObservations;

@property (nonatomic, strong) FHIRDataService *fhirDataService;

@property (nonatomic, strong) NSDictionary *patientDiseaseData;
@property (nonatomic, strong) NSDictionary *patientGeneData;
@property (nonatomic, strong) NSDictionary *patientNucleotideData;
@property (nonatomic, strong) NSDictionary *patientAminoAcidData;

@property (nonatomic, strong) PatientContainerView *patientContainerView;

@property (nonatomic, strong) NSString *status;


@end


@implementation PatientViewController

- (id) initWithPatient: (FHIRPatient *)patient
{
    self = [super init];
    
    if (self)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.title = [FHIRDataHelper getFullNameForPatient:patient withLeadingLastName:NO];
        
        _patient = patient;
        
        _fhirDataService = [[FHIRDataService alloc] init];
        _fhirDataService.fhirDataServiceDelegate = self;
        
        _patientId = [FHIRDataHelper getPatientIDFromPatientResource:_patient];
        
        _status = [NSString stringWithFormat:@"%i", pvcSourcePatientObservations];
        
        // Get Observations for this patient
        [_fhirDataService searchForResource:@"Observation"
                              withParamKeys:@[@"subject",
                                              @"_skip",
                                              @"_count",]
                             andParamValues:@[_patientId,
                                              @"0",
                                              @"100",]
                          andShouldFetchAll:YES];
    }
    
    return self;
}

- (void) loadView
{
    _patientContainerView = [[PatientContainerView alloc] init];
    _patientContainerView.backgroundColor = [UIColor whiteColor];
    _patientContainerView.translatesAutoresizingMaskIntoConstraints = YES;
    _patientContainerView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    
    self.view = _patientContainerView;
    
    [_patientContainerView setPatientDetailView:[[PatientDetailView alloc] initWithPatient:_patient]];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [_fhirDataService cancelConnection];
    [SVProgressHUD dismiss];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Patient Observations

- (void) patientObservationsReceived
{
    NSArray *patientGenomicExtensionObservations = [[NSArray alloc] initWithArray:[FHIRDataHelper genomicExtensionObservationArrayFromBundleEntryComponent:_patientObservations]];
    
    // If we have traits, render view
    if ([patientGenomicExtensionObservations count] > 0)
    {
        NSDictionary *genomicData = [FHIRDataHelper getGenomicExtensionDataFromGenomicObservations:patientGenomicExtensionObservations];
        
        _patientDiseaseData = genomicData[@"disease"];
        _patientGeneData = genomicData[@"gene"];
        _patientNucleotideData = genomicData[@"nucleotide"];
        _patientAminoAcidData = genomicData[@"aminoAcid"];
        
        [_patientContainerView setGenomePhenomeDataView:[[PatientGenomePhenomeDataView alloc]initWithDiseaseData:_patientDiseaseData
                                                                                                     andGeneData:_patientGeneData
                                                                                               andNucleotideData:_patientNucleotideData
                                                                                                andAminoAcidData:_patientAminoAcidData]];
    }
    
    if ([_patientDiseaseData count] > 0 && [_patientGeneData count] > 0)
    {
        PatientPlotViewController *plotViewController = [[PatientPlotViewController alloc] init];
        
        plotViewController.patientDiseaseData = _patientDiseaseData;
        plotViewController.patientGeneData = _patientGeneData;
        plotViewController.patientNucleotideData = _patientNucleotideData;
        plotViewController.patientAminoAcidData = _patientAminoAcidData;
        
        [self addChildViewController:plotViewController];
        [_patientContainerView setPopulationPlotView:plotViewController.view];
    }
}


#pragma mark - FHIRDataServiceDelegate implementation
- (void) fhirServiceConnectionCancelled
{
    
}

- (void) fhirResourceResponseReceived:(FHIRResource *)data
{
    if ([data isKindOfClass:[FHIRBundle class]])
    {
        FHIRBundle *bundle = (FHIRBundle *)data;
        
        if (bundle.entry != nil && [bundle.entry count] > 0)
        {
            switch ([_status intValue]) {
                case pvcSourcePatientObservations:
                    _patientObservations = [NSArray arrayWithArray:bundle.entry];
                    [self patientObservationsReceived];
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (void) fhirErrorEncountered:(NSError *)error
{
    
}

- (void) fhirPartialResponseReceived:(NSNumber *)current ofTotal:(NSNumber *)total
{
    
}

@end
