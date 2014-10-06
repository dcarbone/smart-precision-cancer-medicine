//
//  PatientDetailView.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/29/14.
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

#import "PatientDetailView.h"

@interface PatientDetailView ()

@property (nonatomic, strong) FHIRPatient *patient;

@property (nonatomic, strong) PatientViewTitleLabel *viewTitle;
@property (nonatomic, strong) PatientDetailLabel *genderDOB;

@end

@implementation PatientDetailView

- (id) initWithPatient:(FHIRPatient *)patient
{
    self = [super init];
    
    if (self)
    {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];
        _patient = patient;
        
        [self createPatientDataSubviews];
    }
    
    return self;
}

- (void) createPatientDataSubviews
{
    _viewTitle = [[PatientViewTitleLabel alloc] initWithText:[NSString stringWithFormat:@"%@ (MRN: %@)",
                                                              [FHIRDataHelper getFullNameForPatient:_patient withLeadingLastName:NO],
                                                              [FHIRDataHelper getPatientIDFromPatientResource:_patient]]];
    [self addSubview:_viewTitle];
    
    
    _genderDOB = [[PatientDetailLabel alloc] initWithText:[NSString stringWithFormat:@"%@, %@",
                                                           [FHIRDataHelper getGenderOfPatient:_patient],
                                                           [[[FHIRDataHelper getStringBirthdateOfPatient:_patient] componentsSeparatedByString:@"T"] firstObject]]];
    [self addSubview:_genderDOB];
}

- (void) layoutSubviews
{
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_viewTitle]-[_genderDOB]|"
                                                                 options:NSLayoutFormatAlignAllLeft
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_viewTitle, _genderDOB)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_viewTitle]"
                                                                 options:NSLayoutFormatAlignAllTop
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_viewTitle)]];
    
    [super layoutSubviews];
}

@end
