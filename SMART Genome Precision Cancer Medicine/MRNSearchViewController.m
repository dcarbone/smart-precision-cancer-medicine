//
//  MRNViewController.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/24/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
// 
//  Licensed to the Apache Software Foundation (ASF) under one
//  or more contributor license agreements.  See the NOTICE file
//  distributed with this work for additional information
//  regarding copyright ownership.  The ASF licenses this file
//  to you under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in compliance
//  with the License.  You may obtain a copy of the License at
//  
//    http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on an
//  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied.  See the License for the
//  specific language governing permissions and limitations
//  under the License.
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
