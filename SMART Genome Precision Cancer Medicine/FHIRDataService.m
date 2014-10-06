//
//  FHIRDataService.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 8/26/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import "FHIRDataService.h"

@interface FHIRDataService ()

@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) FHIRDataConnection *fhirDataConnection;


@property (nonatomic, strong) NSString *lastQueryURL;
@property (nonatomic, strong) NSMutableArray *lastQueryParams;
@property (nonatomic, strong) NSMutableArray *lastQueryValues;


@property (nonatomic) BOOL fetchAll;
@property (nonatomic, strong) FHIRBundle *bigBundle;

@end

@implementation FHIRDataService

- (id) init
{
    self = [super init];
    if (self)
    {
        _fetchAll = NO;
        
        _fhirDataConnection = [[FHIRDataConnection alloc] init];
        _fhirDataConnection.connectionDelegate = self;
    }
    return self;
}

- (void) queryForResource:(NSString *)resource andShouldFetchAll:(BOOL)fetchAll
{
    if ([FHIRDataHelper isValidResource:resource])
        [self executeQuery:[NSString stringWithFormat:@"%@%@/", fhirEndpoint, resource]
                  withKeys:nil
                 andValues:nil
         andShouldFetchAll:fetchAll];
    else
        [NSException raise:@"Invalid resource type" format:@"No resource class exists for \"%@\"", resource];
}

- (void) queryForResource:(NSString *)resource withID:(NSString *)resourceId andShouldFetchAll:(BOOL)fetchAll
{
    if ([FHIRDataHelper isValidResource:resource])
        [self executeQuery:[NSString stringWithFormat:@"%@%@/%@", fhirEndpoint, resource, resourceId]
                  withKeys:nil
                 andValues:nil
         andShouldFetchAll:fetchAll];
    else
        [NSException raise:@"Invalid resource type" format:@"No resource class exists for \"%@\"", resource];
}

- (void) queryForResource:(NSString *)resource
            withParamKeys:(NSArray *)paramKeys
           andParamValues:(NSArray *)paramValues
        andShouldFetchAll:(BOOL)fetchAll
{
    if ([FHIRDataHelper isValidResource:resource])
    {
        [self executeQuery:[[NSString alloc] initWithFormat:@"%@%@/", fhirEndpoint, resource]
                  withKeys:paramKeys
                 andValues:paramValues
         andShouldFetchAll:fetchAll];
    }
    else
    {
        [NSException raise:@"Invalid resource type" format:@"No resource class exists for \"%@\"", resource];
    }
}

- (void) searchForResource:(NSString *)resource
             withParamKeys:(NSArray *)paramKeys
            andParamValues:(NSArray *)paramValues
         andShouldFetchAll:(BOOL)fetchAll
{
    if ([FHIRDataHelper isValidResource:resource])
    {
        [self executeQuery:[[NSString alloc] initWithFormat:@"%@%@/_search/", fhirEndpoint, resource]
                  withKeys:paramKeys
                 andValues:paramValues
         andShouldFetchAll:fetchAll];
    }
    else
    {
        [NSException raise:@"Invalid resource type" format:@"No resource class exists for \"%@\"", resource];
    }
}

- (void) executeQuery:(NSString *)requestURLString
             withKeys:(NSArray *)paramKeys
            andValues:(NSArray *)paramValues
    andShouldFetchAll:(BOOL)fetchAll
{
    // Parse and then store the query uri string
    if (![@"/" isEqualToString:[requestURLString substringFromIndex: [requestURLString length] - 1]])
        requestURLString = [NSString stringWithFormat:@"%@/", requestURLString];
    
    _lastQueryParams = [NSMutableArray arrayWithArray:paramKeys];
    _lastQueryValues = [NSMutableArray arrayWithArray:paramValues];
    
    _lastQueryURL = [NSString stringWithString:requestURLString];
    
    _fetchAll = fetchAll;
    
    [_fhirDataConnection executeQuery:requestURLString withKeys:paramKeys andValues:paramValues];
}

- (void) cancelConnection
{
    [_fhirDataConnection cancel];
    [_fhirDataServiceDelegate fhirServiceConnectionCancelled];
}

#pragma mark NSURLConnection Delegate Methods
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _receivedData = [[NSMutableData alloc] init];
}

- (NSCachedURLResponse *) connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    return nil;
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    FHIRResource *resource = [FHIRParser mapInfoFromData:_receivedData];
    
    if (_fetchAll && [resource isKindOfClass:[FHIRBundle class]])
    {
        FHIRBundle *bundle = (FHIRBundle *)resource;
        
        NSNumber *totalResults = bundle.totalResults;
        long skipIndex = [_lastQueryParams indexOfObject:@"_skip"];
        long countIndex = [_lastQueryParams indexOfObject:@"_count"];
        int skip;
        int count;
        
        if (skipIndex == NSNotFound)
        {
            [_lastQueryParams addObject:@"_skip"];
            [_lastQueryValues addObject:@"0"];
            
            skipIndex = [_lastQueryParams indexOfObject:@"_skip"];
        }
        
        skip = [_lastQueryValues[skipIndex] intValue];
        
        if (countIndex == NSNotFound)
        {
            [_lastQueryParams addObject:@"_count"];
            [_lastQueryValues addObject:[NSString stringWithFormat:@"%i", (int)[bundle.entry count]]];
            
            countIndex = [_lastQueryParams indexOfObject:@"_count"];
        }
        
        count = [_lastQueryValues[countIndex] intValue];
        
        // If _bigBundle is null, this is the first pass
        if (_bigBundle == nil)
        {
            // If there are <= total # of results present in this response, just trigger delegate
            if ([totalResults intValue] <= count)
            {
                [_fhirDataServiceDelegate fhirResourceResponseReceived:resource];
                return;
            }
           
            // Otherwise, persist the base bundle and start making more queries............... :(
            _bigBundle = bundle;
        }

        // Increase skip value by current count value
        skip = (skip + count);

        if (skip > count)
            _bigBundle.entry = [_bigBundle.entry arrayByAddingObjectsFromArray:bundle.entry];
        
        // If this goes beyond the max results, return things!
        if ([totalResults intValue] < skip)
        {
            [_fhirDataServiceDelegate fhirResourceResponseReceived:(FHIRResource *)_bigBundle];
            _bigBundle = nil;
            return;
        }
    
        _lastQueryValues[skipIndex] = [NSString stringWithFormat:@"%i", skip];
        
        [self executeQuery:_lastQueryURL withKeys:_lastQueryParams andValues:_lastQueryValues andShouldFetchAll:_fetchAll];
        return;
    }
    
    [_fhirDataServiceDelegate fhirResourceResponseReceived:resource];
    _fetchAll = NO;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self cancelConnection];
    [_fhirDataServiceDelegate fhirErrorEncountered:error];
}

@end
