//
//  FHIRDataConnection.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/24/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import "FHIRDataConnection.h"

@interface FHIRDataConnection()

@property (nonatomic, strong) NSURLConnection *connection;

@end

static NSString *oauthToken;

@implementation FHIRDataConnection

+ (void)setToken:(NSString *)token
{
    oauthToken = token;
}
+ (NSString *)getToken
{
    return oauthToken;
}

- (void) executeQuery:(NSString *)requestURLString
             withKeys:(NSArray *)paramKeys
            andValues:(NSArray *)paramValues
{
    // Parse and then store the query uri string
    if (![@"/" isEqualToString:[requestURLString substringFromIndex: [requestURLString length] - 1]])
        requestURLString = [NSString stringWithFormat:@"%@/", requestURLString];
    
    [self executeQuery:[NSMutableString stringWithFormat:@"%@?%@", requestURLString, [self createQueryParamsWithKeys:paramKeys andValues:paramValues]]];
}

- (NSString *) createQueryParamsWithKeys:(NSArray *)paramKeys andValues:(NSArray *)paramValues
{
    NSMutableArray *keys, *values;
    NSMutableString *urlQueryParams = [[NSMutableString alloc] init];
    Class arrayClass = [NSArray class];
    Class stringClass = [NSString class];
    
    // Get some mutable arrays
    if (paramKeys == nil || paramValues == nil)
    {
        keys = [NSMutableArray array];
        values = [NSMutableArray array];
    }
    else
    {
        keys = [NSMutableArray arrayWithArray:paramKeys];
        values = [NSMutableArray arrayWithArray:paramValues];
    }
    
    long authIndex = [values indexOfObject:@"token_type"];
    
    if (authIndex == NSNotFound)
    {
        [keys addObject:@"token_type"];
        [values addObject:@"Bearer"];
    }
    
    if ([keys count] != [values count])
        [NSException raise:@"Invalid query parameter arguments" format:@"paramKeys and paramValues count does not match"];
    
    long paramCount = [values count];
    
    for (int i = 0; i < paramCount; i++)
    {
        NSString *key = keys[i];
        if ([values[i] isKindOfClass:stringClass])
        {
            [urlQueryParams appendFormat:@"%@=%@&", key, [(NSString *)values[i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        else if ([values[i] isKindOfClass:arrayClass])
        {
            [urlQueryParams appendFormat:@"%@=%@&", key, [[(NSArray *)values[i] componentsJoinedByString:@","] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    NSRange trailingAmpersand = [urlQueryParams rangeOfString:@"&" options:NSBackwardsSearch];
    
    if(trailingAmpersand.location != NSNotFound)
        return [urlQueryParams stringByReplacingCharactersInRange:trailingAmpersand withString: @""];
    
    return urlQueryParams;
}

- (void) executeQuery:(NSString *)requestURLString
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURLString]];
    
    urlRequest.HTTPShouldHandleCookies = NO;
    
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [urlRequest setValue:[NSString stringWithFormat:@"Bearer %@", oauthToken] forHTTPHeaderField:@"Authorization"];
    
    _connection = [NSURLConnection connectionWithRequest:urlRequest delegate:_connectionDelegate];
}

- (void) cancel
{
    if (_connection)
        [_connection cancel];
}

@end
