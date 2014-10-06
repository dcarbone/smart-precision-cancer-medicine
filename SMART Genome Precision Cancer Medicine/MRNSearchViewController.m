//
//  MRNViewController.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/24/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import "MRNSearchViewController.h"

@interface MRNSearchViewController ()

@property (nonatomic, strong) FHIRDataService *fhirDataService;

@end

@implementation MRNSearchViewController

- (id) init
{
    self = [super init];
    
    if (self)
    {
        self.title = @"MRN Search";
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        _fhirDataService = [[FHIRDataService alloc] init];
        _fhirDataService.fhirDataServiceDelegate = self;
    }
    
    return self;
}

- (void) loadView
{
    MRNSearchView *searchView = [[MRNSearchView alloc] init];
    
    [searchView setMrnSearchDelegate:self];
    
    self.view = searchView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MRNSearchDelegate

- (void) mrnSearchAction:(NSString *)mrnNumber
{
    [_fhirDataService queryForResource:@"Patient" withID:mrnNumber andShouldFetchAll:NO];
}

#pragma mark FHIRDataServiceDelegate

- (void) fhirServiceConnectionCancelled
{
    
}

- (void) fhirResourceResponseReceived:(FHIRResource *)data
{
    if (data)
    {
        [self.navigationController pushViewController:[[PatientViewController alloc] initWithPatient:(FHIRPatient *)data] animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Search"
                                                        message:@"Patient not found"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void) fhirErrorEncountered:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Sorry, an error has occurred"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)fhirPartialResponseReceived:(NSNumber *)current ofTotal:(NSNumber *)total
{
    
}



@end
