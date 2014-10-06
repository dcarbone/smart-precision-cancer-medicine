//
//  FHIRDataHelper.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/29/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import "FHIRDataHelper.h"

@interface FHIRDataHelper()

+ (NSArray *) getFHIRExtensionURLs;

@end

static NSArray *extensionURLs;

@implementation FHIRDataHelper

+ (BOOL)isValidResource:(NSString *)resourceName
{
    if (resourceName == nil)
        return NO;
    else if (NSClassFromString([NSString stringWithFormat:@"FHIR%@", resourceName]))
        return YES;
    
    return NO;
}

+ (NSArray *) getFHIRExtensionURLs
{
    if (extensionURLs == nil)
        extensionURLs  = @[@"https://fhir/Mutation#assessed.gene",
                           @"https://fhir/Mutation#assessed.referenceSeq",
                           @"https://fhir/Mutation#assessed.variant"];
    
    return extensionURLs;
}

+ (NSString *) getFullNameForPatient:(FHIRPatient *)patient withLeadingLastName:(BOOL)leadingLastName
{
    NSString *lastName = [self getLastNameForPatient:patient];
    NSString *firstName = [self getFirstNameForPatient:patient];
    NSString *middleName = [self getMiddleNameForPatient:patient];

    NSString *firstMiddle;
    
    NSMutableString *displayName = [[NSMutableString alloc] init];
    
    
    if (firstName != nil && middleName != nil)
    {
        if ([firstName isEqual:middleName])
            firstMiddle = [NSString stringWithFormat:@"%@", firstName];
        else
            firstMiddle = [NSString stringWithFormat:@"%@ %@", firstName, middleName];
    }
    
    if (leadingLastName)
    {
        if (lastName)
        {
            [displayName appendString:lastName];
            if (firstMiddle)
                [displayName appendFormat:@", %@", firstMiddle];
        }
        else if (firstMiddle)
        {
            [displayName appendFormat:@"%@", firstMiddle];
        }
    }
    else if (firstMiddle)
    {
        [displayName appendString:firstMiddle];
        if (lastName)
            [displayName appendFormat:@" %@", lastName];
    }
    
    return displayName;
}

+ (NSString *) getFirstNameForPatient:(FHIRPatient *)patient
{
    if ([patient.name count] > 0)
    {
        FHIRHumanName *humanName = patient.name[0];
    
        if (humanName.givenElement != nil && [humanName.givenElement count] > 0)
            return [NSString stringWithFormat:@"%@", [humanName.givenElement firstObject]];
    }

    return nil;
}

+ (NSString *) getLastNameForPatient:(FHIRPatient *)patient
{
    if ([patient.name count] > 0)
    {
        FHIRHumanName *humanName = patient.name[0];
        
        if (humanName.familyElement != nil && [humanName.familyElement count] > 0)
            return [NSString stringWithFormat:@"%@", humanName.familyElement[0]];
    }
    
    return nil;
}

+ (NSString *) getMiddleNameForPatient:(FHIRPatient *)patient
{
    if ([patient.name count] > 0)
    {
        FHIRHumanName *humanName = patient.name[0];
        
        if (humanName.givenElement != nil && [humanName.givenElement count] > 0)
            return [NSString stringWithFormat:@"%@", [humanName.givenElement lastObject]];
    }
    
    return nil;
}

+ (NSString *) getGenderOfPatient:(FHIRPatient *)patient
{
    FHIRCoding *genderCode;
    
    if ([patient.gender.coding count] > 0)
    {
        genderCode = patient.gender.coding[0];
        
        if (genderCode.displayElement != nil)
            return [NSString stringWithFormat:@"%@", genderCode.displayElement];
    }
    return nil;
}


+ (NSString *) getStringBirthdateOfPatient:(FHIRPatient *)patient
{
    // TODO: This probably needs improvement.
    return (NSString *) patient.birthDateElement;
}

+ (NSString *) getPatientIDFromPatientResource:(FHIRPatient *)patient
{
    NSString *patientId = [[patient idElement] description];
    NSArray *patientIdSplit = [patientId componentsSeparatedByString:@"/"];
    
    return [patientIdSplit lastObject];
}

+ (NSString *) getPatientIDFromObservationResource:(FHIRObservation *)observation
{
    FHIRResource *subject = [observation subject];
    
    NSString *ID = [[subject referenceElement] description];
    NSArray *split = [ID componentsSeparatedByString:@"/"];
    
    return [split lastObject];
}

+ (NSArray *) genomicExtensionObservationArrayFromBundleEntryComponent:(NSArray *)bundleEntryComponents
{
    NSMutableArray *genomicExtensionObservations = [[NSMutableArray alloc] init];
    
    for (id object in bundleEntryComponents)
    {
        if ([object isKindOfClass:[FHIRBundleEntryComponent class]])
        {
            FHIRBundleEntryComponent *bundleEntry = (FHIRBundleEntryComponent *)object;
            
            if (bundleEntry.content != nil && [bundleEntry.content isKindOfClass:[FHIRObservation class]])
            {
                FHIRObservation *observation = (FHIRObservation *)bundleEntry.content;
                
                if ([self containsGenomicObservationExtension:observation])
                    [genomicExtensionObservations addObject:observation];
            }
        }
    }

    return genomicExtensionObservations;
}

+ (NSArray *) genomicExtensionObservationArrayFromArrayOfObservations:(NSArray *)observationArray
{
    NSMutableArray *genomicExtensionObservations = [[NSMutableArray alloc] init];
    
    for (id object in observationArray)
    {
        FHIRObservation *observation = (FHIRObservation *)object;
        
        if ([self containsGenomicObservationExtension:observation])
            [genomicExtensionObservations addObject:observation];
    }
    
    return genomicExtensionObservations;
}

+ (BOOL) containsGenomicObservationExtension:(FHIRObservation *)observation
{
    if (observation.name != nil && observation.name.extension != nil && [observation.name.extension count] > 0)
    {
        NSDictionary *dict = observation.name.extension[0];
        if (dict[@"url"] != nil && [dict[@"url"] isEqualToString:FHIRGenomicExtUrl])
            return YES;
    }
    
    return NO;
}

+ (NSDictionary *) getGenomicExtensionDataFromGenomicObservations:(NSArray *)genomicObservations
{
    __block NSMutableDictionary *genomicExtensionData = [[NSMutableDictionary alloc]
                                                         initWithDictionary:@{@"disease" : [[NSMutableDictionary alloc] init],
                                                                              @"gene" : [[NSMutableDictionary alloc] init],
                                                                              @"nucleotide" : [[NSMutableDictionary alloc] init],
                                                                              @"aminoAcid" : [[NSMutableDictionary alloc] init],}];
    __block NSDictionary *genomicData;
    __block NSString *diseaseName, *geneName, *nucleotideName, *aminoAcidName;
    
    for (FHIRObservation *observation in genomicObservations)
    {
        genomicData = [self parseGenomicExtensionDataFromObservation:observation];
        
        if (genomicData)
        {
            [genomicData enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *obj, BOOL *stop) {
                if ([key isEqualToString:@"disease"] && genomicExtensionData)
                {
                    diseaseName = obj[@"text"];
                    if (!genomicExtensionData[@"disease"][diseaseName])
                        [genomicExtensionData[@"disease"] setObject:obj forKey:diseaseName];
                }
                else if ([key isEqualToString:@"gene"])
                {
                    geneName = obj[@"display"];
                    if (!genomicExtensionData[@"gene"][geneName])
                        [genomicExtensionData[@"gene"] setObject:obj forKey:geneName];
                }
                else if ([key isEqualToString:@"nucleotide"])
                {
                    nucleotideName = obj[@"display"];
                    if (!genomicExtensionData[@"nucleotide"][nucleotideName])
                        [genomicExtensionData[@"nucleotide"] setObject:obj forKey:nucleotideName];
                }
                else if ([key isEqualToString:@"aminoAcid"])
                {
                    aminoAcidName = obj[@"display"];
                    if (!genomicExtensionData[@"aminoAcid"][aminoAcidName])
                        [genomicExtensionData[@"aminoAcid"] setObject:obj forKey:aminoAcidName];
                }
            }];
        }
    }
    
    return genomicExtensionData;
}

+ (NSDictionary *) getDiseaseDataFromGenomicExtension:(NSArray *)genomicObservations
{
    NSDictionary *genomicData;
    NSString *diseaseName;
    
    NSMutableDictionary *diseaseData = [[NSMutableDictionary alloc] init];
    
    for (FHIRObservation *observation in genomicObservations)
    {
        genomicData = [self parseGenomicExtensionDataFromObservation:observation];
        
        if (genomicData && genomicData[@"disease"])
        {
            diseaseName = genomicData[@"disease"][@"text"];
            
            if (!diseaseData[diseaseName])
                [diseaseData setObject:[NSDictionary dictionaryWithDictionary:genomicData[@"disease"]] forKey:diseaseName];
        }
    }
    
    return diseaseData;
}

+ (NSDictionary *) getGeneDataFromGenomicExtension:(NSArray *)genomicObservations
{
    NSDictionary *genomicData;
    NSString *geneName;
    
    NSMutableDictionary *geneData = [[NSMutableDictionary alloc] init];
    
    for (FHIRObservation *observation in genomicObservations)
    {
        genomicData = [self parseGenomicExtensionDataFromObservation:observation];
        
        if (genomicData && genomicData[@"gene"])
        {
            geneName = genomicData[@"gene"][@"display"];
            if (!geneData[geneName])
                [geneData setObject:[NSDictionary dictionaryWithDictionary:genomicData[@"gene"]] forKey:geneName];
        }
    }
    
    return geneData;
}

+ (NSDictionary *) getNucleotideDataFromGenomicExtension:(NSArray *)genomicObservations
{
    NSDictionary *genomicData;
    NSString *nucleotideName;
    
    NSMutableDictionary *nucleotideData = [[NSMutableDictionary alloc] init];
    
    for (FHIRObservation *observation in genomicObservations)
    {
        genomicData = [self parseGenomicExtensionDataFromObservation:observation];
        
        if (genomicData && genomicData[@"nucleotide"])
        {
            nucleotideName = genomicData[@"nucleotide"][@"display"];
            if (!nucleotideData[nucleotideName])
                [nucleotideData setObject:[NSDictionary dictionaryWithDictionary:genomicData[@"nucleotide"]] forKey:nucleotideName];
        }
    }
        
    return nucleotideData;
}

+ (NSDictionary *) getAminoAcidDataFromGenomicExtension:(NSArray *)genomicObservations
{
    NSDictionary *genomicData;
    NSString *aminoAcidName;
    
    NSMutableDictionary *aminoAcidData = [[NSMutableDictionary alloc] init];
    
    for (FHIRObservation *observation in genomicObservations)
    {
        genomicData = [self parseGenomicExtensionDataFromObservation:observation];
        
        if (genomicData && genomicData[@"aminoAcid"])
        {
            aminoAcidName = genomicData[@"aminoAcid"][@"display"];
            if (!aminoAcidData[aminoAcidName])
                [aminoAcidData setObject:[NSDictionary dictionaryWithDictionary:genomicData[@"aminoAcid"]] forKey:aminoAcidName];
        }
    }
    
    return aminoAcidData;
}

+ (NSDictionary *) parseGenomicExtensionDataFromObservation:(FHIRObservation *)observation
{
    NSMutableDictionary *genomicExtData = [[NSMutableDictionary alloc] init];
    FHIRCodeableConcept *observationConcept = observation.valueCodeableConcept;
    FHIRCoding *diseaseValueCoding = observationConcept.coding[0];
    NSDictionary *extDict, *innerExtDict, *codingDict;
    NSString *code;
    NSArray *codings;
    long index;
    
    [genomicExtData setObject:@{@"system"  : (NSString *)diseaseValueCoding.systemElement,
                                @"code"    : (NSString *)diseaseValueCoding.codeElement,
                                @"display" : (NSString *)diseaseValueCoding.displayElement,
                                @"text"    : [observationConcept.textElement description],}
                       forKey:@"disease"];
    
    
    if (observation.name && observation.name.extension && [observation.name.extension count] > 0)
    {
        extDict = observation.name.extension[0];
        if (extDict[@"extension"] && [extDict[@"extension"] count] > 0)
        {
            for (id ext in extDict[@"extension"])
            {
                innerExtDict = (NSDictionary *)ext;
                if (innerExtDict[@"url"] && innerExtDict[@"valueCodeableConcept"] && innerExtDict[@"valueCodeableConcept"][@"coding"] && [innerExtDict[@"valueCodeableConcept"][@"coding"] count] > 0)
                {
                    index = [[self getFHIRExtensionURLs] indexOfObject:innerExtDict[@"url"]];
                    
                    switch (index) {
                        case fhirExtGeneAssessed:
                            // For the moment assume the first value in GENE is the only relevant one.
                            codingDict = innerExtDict[@"valueCodeableConcept"][@"coding"][0];
                            [genomicExtData setObject:codingDict forKey:@"gene"];
                            break;
                            
                        case fhirExtVariantAssessed:
                            codings = innerExtDict[@"valueCodeableConcept"][@"coding"];
                            
                            if ([codings count] == 1)
                            {
                                [genomicExtData setObject:codings[0] forKey:@"nucleotide"];
                            }
                            else if ([codings count] > 1)
                            {
                                for (codingDict in codings)
                                {
                                    code = codingDict[@"code"];
                                    
                                    if ([[code lowercaseString] hasPrefix:@"c"])
                                    {
                                        [genomicExtData setObject:codingDict
                                                           forKey:@"nucleotide"];
                                    }
                                    else if ([[code lowercaseString] hasPrefix:@"p"])
                                    {
                                        [genomicExtData setObject:codingDict
                                                           forKey:@"aminoAcid"];
                                    }
                                }
                            }
                            break;
                            
                        default:
                            break;
                    }
                }
            }
        }
    }
    
    return genomicExtData;
}

@end
