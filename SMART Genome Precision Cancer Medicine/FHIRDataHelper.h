//
//  FHIRDataHelper.h
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/29/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FHIRBaseResource.h"
#import "FHIRPatient.h"
#import "FHIRCodeableConcept.h"
#import "FHIRCoding.h"
#import "FHIRString.h"
#import "FHIRDate.h"
#import "FHIRDateTime.h"
#import "FHIRHumanName.h"
#import "FHIRIdentifier.h"
#import "FHIRId.h"
#import "FHIRBundle.h"
#import "FHIRBundleEntryComponent.h"
#import "FHIRExtension.h"
#import "FHIRObservation.h"
#import "FHIRResource.h"

#define FHIRGenomicExtUrl @"https://fhir/Mutation#assessed"

typedef enum {
    fhirExtGeneAssessed,
    fhirExtReferenceSeq,
    fhirExtVariantAssessed
} FHIRGenomicExtensionType;

@interface FHIRDataHelper : NSObject

+ (BOOL) isValidResource:(NSString *)resourceName;

+ (NSString *) getFullNameForPatient:(FHIRPatient *)patient withLeadingLastName:(BOOL)leadingLastName;
+ (NSString *) getFirstNameForPatient:(FHIRPatient *)patient;
+ (NSString *) getLastNameForPatient:(FHIRPatient *)patient;
+ (NSString *) getMiddleNameForPatient:(FHIRPatient *)patient;

+ (NSString *) getPatientIDFromPatientResource:(FHIRPatient *)patient;
+ (NSString *) getGenderOfPatient:(FHIRPatient *)patient;

+ (NSString *) getStringBirthdateOfPatient:(FHIRPatient *)patient;

+ (NSArray *) genomicExtensionObservationArrayFromBundleEntryComponent:(NSArray *)bundleEntryComponents;
+ (BOOL) containsGenomicObservationExtension:(FHIRObservation *)observation;
+ (NSArray *) genomicExtensionObservationArrayFromArrayOfObservations:(NSArray *)observationArray;

+ (NSDictionary *) getGenomicExtensionDataFromGenomicObservations:(NSArray *)genomicObservations;
+ (NSDictionary *) parseGenomicExtensionDataFromObservation:(FHIRObservation *)observation;

+ (NSDictionary *) getDiseaseDataFromGenomicExtension:(NSArray *)genomicObservations;
+ (NSDictionary *) getGeneDataFromGenomicExtension:(NSArray *)genomicObservations;
+ (NSDictionary *) getNucleotideDataFromGenomicExtension:(NSArray *)genomicObservations;
+ (NSDictionary *) getAminoAcidDataFromGenomicExtension:(NSArray *)genomicObservations;

+ (NSString *) getPatientIDFromObservationResource:(FHIRObservation *)observation;

@end
