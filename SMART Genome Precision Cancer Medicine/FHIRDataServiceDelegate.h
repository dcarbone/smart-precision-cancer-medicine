//
//  FHIRDataServiceDelegate.h
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/24/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef SMART_Genomics_Precision_Cancer_Medicine_FHIRDataServiceDelegate_h
#define SMART_Genomics_Precision_Cancer_Medicine_FHIRDataServiceDelegate_h

@protocol FHIRDataServiceDelegate <NSObject>

- (void) fhirResourceResponseReceived:(FHIRResource *)data;
- (void) fhirErrorEncountered:(NSError *)error;
- (void) fhirServiceConnectionCancelled;

- (void) fhirPartialResponseReceived:(NSNumber *)current ofTotal:(NSNumber *)total;

@end

#endif
