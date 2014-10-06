//
//  FHIRDataConnection.h
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/24/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import <Foundation/Foundation.h>

#define fhirEndpoint @""

@interface FHIRDataConnection : NSObject

@property (nonatomic, assign) id<NSURLConnectionDataDelegate> connectionDelegate;

+ (void) setToken:(NSString *)token;
+ (NSString *) getToken;

- (void) executeQuery:(NSString *)requestURLString withKeys:(NSArray *)paramKeys andValues:(NSArray *)paramValues;

- (void) cancel;

@end
