/*
  Copyright (c) 2011-2013, HL7, Inc.
  All rights reserved.
  
  Redistribution and use in source and binary forms, with or without modification, 
  are permitted provided that the following conditions are met:
  
   * Redistributions of source code must retain the above copyright notice, this 
     list of conditions and the following disclaimer.
   * Redistributions in binary form must reproduce the above copyright notice, 
     this list of conditions and the following disclaimer in the documentation 
     and/or other materials provided with the distribution.
   * Neither the name of HL7 nor the names of its contributors may be used to 
     endorse or promote products derived from this software without specific 
     prior written permission.
  
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT 
  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
  POSSIBILITY OF SUCH DAMAGE.
  

 * Generated on Fri, May 9, 2014 11:14+1000 for FHIR v0.0.81
 */
/*
 * Measurements and simple assertions
 *
 * [FhirResource("Observation")]
 * [Serializable]
 */

#import "FHIRBaseResource.h"


@class FHIRCodeableConcept;
@class FHIRElement;
@class FHIRString;
@class FHIRInstant;
@class FHIRCode;
@class FHIRIdentifier;
@class FHIRResource;
@class FHIRObservationReferenceRangeComponent;
@class FHIRObservationRelatedComponent;

@interface FHIRObservation : FHIRBaseResource

/*
 * Codes that provide an estimate of the degree to which quality issues have impacted on the value of an observation
 */
typedef enum 
{
    kObservationReliabilityOk, // The result has no reliability concerns.
    kObservationReliabilityOngoing, // An early estimate of value; measurement is still occurring.
    kObservationReliabilityEarly, // An early estimate of value; processing is still occurring.
    kObservationReliabilityQuestionable, // The observation value should be treated with care.
    kObservationReliabilityCalibrating, // The result has been generated while calibration is occurring.
    kObservationReliabilityError, // The observation could not be completed because of an error.
    kObservationReliabilityUnknown, // No observation value was available.
} kObservationReliability;

/*
 * Codes providing the status of an observation
 */
typedef enum 
{
    kObservationStatusRegistered, // The existence of the observation is registered, but there is no result yet available.
    kObservationStatusPreliminary, // This is an initial or interim observation: data may be incomplete or unverified.
    kObservationStatusFinal, // The observation is complete and verified by an authorized person.
    kObservationStatusAmended, // The observation has been modified subsequent to being Final, and is complete and verified by an authorized person.
    kObservationStatusCancelled, // The observation is unavailable because the measurement was not started or not completed (also sometimes called "aborted").
    kObservationStatusEnteredInError, // The observation has been withdrawn following previous Final release.
} kObservationStatus;

/*
 * Codes specifying how two observations are related
 */
typedef enum 
{
    kObservationRelationshipTypeHasComponent, // The target observation is a component of this observation (e.g. Systolic and Diastolic Blood Pressure).
    kObservationRelationshipTypeHasMember, // This observation is a group observation (e.g. a battery, a panel of tests, a set of vital sign measurements) that includes the target as a member of the group.
    kObservationRelationshipTypeDerivedFrom, // The target observation is part of the information from which this observation value is derived (e.g. calculated anion gap, Apgar score).
    kObservationRelationshipTypeSequelTo, // This observation follows the target observation (e.g. timed tests such as Glucose Tolerance Test).
    kObservationRelationshipTypeReplaces, // This observation replaces a previous observation (i.e. a revised value). The target observation is now obsolete.
    kObservationRelationshipTypeQualifiedBy, // The value of the target observation qualifies (refines) the semantics of the source observation (e.g. a lipaemia measure target from a plasma measure).
    kObservationRelationshipTypeInterferedBy, // The value of the target observation interferes (degardes quality, or prevents valid observation) with the semantics of the source observation (e.g. a hemolysis measure target from a plasma potassium measure which has no value).
} kObservationRelationshipType;

/*
 * Type of observation (code / type)
 */
@property (nonatomic, strong) FHIRCodeableConcept *name;

/*
 * Something...?
 */
@property (nonatomic, strong) FHIRCodeableConcept *valueCodeableConcept;

/*
 * Actual result
 */
@property (nonatomic, strong) FHIRElement *value;

/*
 * High, low, normal, etc.
 */
@property (nonatomic, strong) FHIRCodeableConcept *interpretation;

/*
 * Comments about result
 */
@property (nonatomic, strong) FHIRString *commentsElement;

@property (nonatomic, strong) NSString *comments;

/*
 * Physiologically Relevant time/time-period for observation
 */
@property (nonatomic, strong) FHIRElement *applies;

/*
 * Date/Time this was made available
 */
@property (nonatomic, strong) FHIRInstant *issuedElement;

@property (nonatomic, strong) NSDate *issued;

/*
 * registered | preliminary | final | amended +
 */
@property (nonatomic, strong) FHIRCode/*<code>*/ *statusElement;

@property (nonatomic) kObservationStatus status;

/*
 * ok | ongoing | early | questionable | calibrating | error +
 */
@property (nonatomic, strong) FHIRCode/*<code>*/ *reliabilityElement;

@property (nonatomic) kObservationReliability reliability;

/*
 * Observed body part
 */
@property (nonatomic, strong) FHIRCodeableConcept *bodySite;

/*
 * How it was done
 */
@property (nonatomic, strong) FHIRCodeableConcept *method;

/*
 * Unique Id for this particular observation
 */
@property (nonatomic, strong) FHIRIdentifier *identifier;

/*
 * Who and/or what this is about
 */
@property (nonatomic, strong) FHIRResource *subject;

/*
 * Specimen used for this observation
 */
@property (nonatomic, strong) FHIRResource *specimen;

/*
 * Who did the observation
 */
@property (nonatomic, strong) NSArray/*<ResourceReference>*/ *performer;

/*
 * Provides guide for interpretation
 */
@property (nonatomic, strong) NSArray/*<ObservationReferenceRangeComponent>*/ *referenceRange;

/*
 * Observations related to this observation
 */
@property (nonatomic, strong) NSArray/*<ObservationRelatedComponent>*/ *related;

- (FHIRErrorList *)validate;

@end
