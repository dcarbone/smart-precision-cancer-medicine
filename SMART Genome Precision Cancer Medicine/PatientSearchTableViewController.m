//
//  PatientSearchTableViewController.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/26/14.
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

#import "PatientSearchTableViewController.h"
#import "FHIRBundle.h"
#import "FHIRPatient.h"
#import "FHIRBundleEntryComponent.h"
#import "FHIRHumanName.h"

#import "SVProgressHUD.h"

@interface PatientSearchTableViewController ()

@property (strong, nonatomic) FHIRDataService *fhirDataService;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *patientResources;

@end

@implementation PatientSearchTableViewController

- (id) init
{
    self = [super init];
    
    if (self)
    {
        self.title = @"Patient Search";
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        _fhirDataService = [[FHIRDataService alloc] init];
        _fhirDataService.fhirDataServiceDelegate = self;
    }
    
    return self;
}

- (void)loadView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.keyboardType = UIKeyboardTypeAlphabet;
    _searchBar.delegate = self;
    
    tableView.tableHeaderView = _searchBar;
    
    UISearchDisplayController *searchController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
    searchController.delegate = self;
    
    self.view = tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (_patientResources == nil)
        return 0;
    
    return [_patientResources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    long row = indexPath.row;
    FHIRBundleEntryComponent *entryComponent = _patientResources[row];
    FHIRPatient *patient = (FHIRPatient *)entryComponent.content;
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil )
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSString *string = [NSString stringWithFormat:@"%@ - %@",
                        [FHIRDataHelper getFullNameForPatient:patient withLeadingLastName:YES],
                        [FHIRDataHelper getPatientIDFromPatientResource:patient]];
    
    cell.textLabel.text = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    return cell;
}

#pragma mark UITableViewDelegate implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long row = indexPath.row;
    
    FHIRBundleEntryComponent *entryComponent = _patientResources[row];
    FHIRPatient *patient = (FHIRPatient *)entryComponent.content;
    
    [self.navigationController pushViewController:[[PatientViewController alloc] initWithPatient:patient] animated:YES];
}

#pragma mark FHIRDataServiceDelegate

- (void) fhirResourceResponseReceived:(FHIRResource *)data
{
    _patientResources = [NSArray arrayWithArray:((FHIRBundle *)data).entry];
    
    [self.tableView reloadData];
    
    [SVProgressHUD dismiss];
}

- (void) fhirServiceConnectionCancelled
{
    // FIXME: Implement this?
}

- (void) fhirErrorEncountered:(NSError *)error
{
    
}

- (void)fhirPartialResponseReceived:(NSNumber *)current ofTotal:(NSNumber *)total
{
    
}

#pragma mark UISearchDisplayDelegate implementation

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *trimmed = [searchText stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    if ([trimmed length] >= 3)
    {
        [SVProgressHUD showWithStatus:@"Loading Patients"];
        
        _patientResources = nil;
        
        [_fhirDataService cancelConnection];
        
        [_fhirDataService searchForResource:@"Patient"
                              withParamKeys:@[@"name",
                                              @"_sort:asc",
                                              @"_sort:asc",
                                              @"_skip",
                                              @"_count",]
                             andParamValues:@[trimmed,
                                              @"family",
                                              @"given",
                                              @"0",
                                              @"100",]
                          andShouldFetchAll:YES];
    }
    else
    {
        _patientResources = nil;
        
        [self.tableView reloadData];
    }
}

@end
