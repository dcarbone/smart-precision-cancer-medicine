//
//  PatientGenomePhenomeDataView.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/3/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import "PatientGenomePhenomeDataView.h"

@interface PatientGenomePhenomeDataView ()

@property (nonatomic, strong) NSDictionary *patientDiseaseData;
@property (nonatomic, strong) NSDictionary *patientGeneData;
@property (nonatomic, strong) NSDictionary *patientNucleotideData;
@property (nonatomic, strong) NSDictionary *patientAminoAcidData;

@property (nonatomic, strong) PatientDetailLabel *diseaseLabel;
@property (nonatomic, strong) PatientDetailLabel *mutationLabel;

@end

@implementation PatientGenomePhenomeDataView

- (id) initWithDiseaseData:(NSDictionary *)diseaseData andGeneData:(NSDictionary *)geneData andNucleotideData:(NSDictionary *)nucleotideData andAminoAcidData:(NSDictionary *)aminoAcidData
{
    self = [super init];
    
    if (self)
    {
        _patientDiseaseData = diseaseData;
        _patientGeneData = geneData;
        _patientNucleotideData = nucleotideData;
        _patientAminoAcidData = aminoAcidData;
        
        self.backgroundColor = [UIColor whiteColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self createPatientObservationDataSubviews];
    }
    
    return self;
}

#pragma mark - Subview creation
- (void) createPatientObservationDataSubviews
{
    // For now just grab the first trait observation
    
    NSDictionary *data;
    NSArray *keys;

    if ([_patientDiseaseData count] > 0)
    {
        keys = [_patientDiseaseData allKeys];
        data = _patientDiseaseData[keys[0]];
        
        _diseaseLabel = [[PatientDetailLabel alloc] initWithText:[NSString stringWithFormat:@"Diagnosis: %@", data[@"text"]]];
        [self addSubview:_diseaseLabel];
        
        [self addConstraints:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"H:|-[diseaseLabel]"
                              options:NSLayoutFormatAlignAllTop
                              metrics:nil
                              views:@{@"diseaseLabel" : _diseaseLabel}]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[diseaseLabel]"
                                                                     options:kNilOptions
                                                                     metrics:nil
                                                                       views:@{@"diseaseLabel" : _diseaseLabel}]];
    }

    if ([_patientGeneData count] > 0)
    {
        keys = [_patientGeneData allKeys];
        data = _patientGeneData[keys[0]];
        
        NSString *gene = data[@"display"];
        if ([[gene lowercaseString] isEqualToString:@"none"])
        {
            _mutationLabel = [[PatientDetailLabel alloc] initWithText:@"Mutation: Not detected"];
            [self addSubview:_mutationLabel];
        }
        else
        {
            NSString *mutation;
            
            if ([_patientAminoAcidData count] > 0)
            {
                mutation = [[_patientAminoAcidData allKeys] firstObject];
            }
            else if ([_patientNucleotideData count] > 0)
            {
                mutation = [[_patientNucleotideData allKeys] firstObject];
            }
            
            _mutationLabel = [[PatientDetailLabel alloc] initWithText:[NSString stringWithFormat:@"Mutation: %@ %@", gene, mutation]];
            [self addSubview:_mutationLabel];
        }
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_diseaseLabel][_mutationLabel]|"
                                                                     options:NSLayoutFormatAlignAllLeft
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_diseaseLabel, _mutationLabel)]];
    }
}


@end
