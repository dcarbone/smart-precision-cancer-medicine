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
 * A request to perform an action
 *
 * [FhirResource("Order")]
 * [Serializable]
 */

#import "FHIRBaseResource.h"


@class FHIRIdentifier;
@class FHIRDateTime;
@class FHIRResource;
@class FHIRElement;
@class FHIROrderWhenComponent;

@interface FHIROrder : FHIRBaseResource

/*
 * Identifiers assigned to this order by the orderer or by the receiver
 */
@property (nonatomic, strong) NSArray/*<Identifier>*/ *identifier;

/*
 * When the order was made
 */
@property (nonatomic, strong) FHIRDateTime *dateElement;

@property (nonatomic, strong) NSString *date;

/*
 * Patient this order is about
 */
@property (nonatomic, strong) FHIRResource *subject;

/*
 * Who initiated the order
 */
@property (nonatomic, strong) FHIRResource *source;

/*
 * Who is intended to fulfill the order
 */
@property (nonatomic, strong) FHIRResource *target;

/*
 * Text - why the order was made
 */
@property (nonatomic, strong) FHIRElement *reason;

/*
 * If required by policy
 */
@property (nonatomic, strong) FHIRResource *authority;

/*
 * When order should be fulfilled
 */
@property (nonatomic, strong) FHIROrderWhenComponent *when;

/*
 * What action is being ordered
 */
@property (nonatomic, strong) NSArray/*<ResourceReference>*/ *detail;

- (FHIRErrorList *)validate;

@end
