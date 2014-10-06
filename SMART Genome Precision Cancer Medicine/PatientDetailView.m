//
//  PatientDetailView.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/29/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
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
