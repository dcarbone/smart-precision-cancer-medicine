//
//  GeneData.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/22/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
// 
//  Licensed to the Apache Software Foundation (ASF) under one
//  or more contributor license agreements.  See the NOTICE file
//  distributed with this work for additional information
//  regarding copyright ownership.  The ASF licenses this file
//  to you under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in compliance
//  with the License.  You may obtain a copy of the License at
//  
//    http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on an
//  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied.  See the License for the
//  specific language governing permissions and limitations
//  under the License.
//

#import "GeneData.h"

static NSArray *geneIndexList;
static NSDictionary *geneSynonymList;
static NSArray *genePieSliceColors;
static NSArray *genePieLabelColors;

static NSArray *geneReferenceURLs;

static long geneListCount;

@implementation GeneData

- (id) init
{
    self = [super init];
    
    if (self)
    {
        if (!geneIndexList)
        {
            geneIndexList = @[@"AKT1",
                              @"BRAF",
                              @"CTNNB1",
                              @"DNMT3A",
                              @"EGFR",
                              @"ERBB2",
                              @"FLT3",
                              @"GNA11",
                              @"GNAQ",
                              @"IDH1",
                              @"IDH2",
                              @"KIT",
                              @"KRAS",
                              @"MAP2K1",
                              @"NPM1",
                              @"NRAS",
                              @"PIK3CA",
                              @"PTEN",
                              @"SMAD4",
                              @"NONE",
                              ];
            
            geneSynonymList = @{@"MEK1" : @"MAP2K1",
                                @"NONE" : @"Not Detected",};
            
            genePieSliceColors = @[[UIColor colorWithRed:1.0f green:0.0f blue:1.0f alpha:1.0f],                          //AKT1   :#FF00FF
                                   [UIColor colorWithRed:16.0f/255.0f green:150.0f/255.0f blue:24.0f/255.0f alpha:1.0f], //BRAF   :#109618
                                   [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.0f],                          //CTNNB1 :#0000FF
                                   [UIColor colorWithRed:1.0f green:153.0f/255.0f blue:0.0f alpha:1.0f],                 //DNMT3A :#FF9900
                                   [UIColor colorWithRed:255.0f/255.0f green:1.0f blue:0.0f alpha:1.0f],                 //EGFR   :#FFFF00
                                   [UIColor colorWithRed:1.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0f],        //ERBB2  :#FFAFAF
                                   [UIColor colorWithRed:204.0f/255.0f green:64.0f/255.0f blue:51.0f/255.0f alpha:1.0f], //FLT3   :#CC4033
                                   [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:1.0f],                          //GNA11  :#00FF00
                                   [UIColor colorWithRed:153.0f/255.0f green:0.0f blue:0.0f alpha:1.0f],                 //GNAQ   :#990000
                                   [UIColor colorWithRed:153.0f/255.0f green:204.0f/255.0f blue:51.0f/255.0f alpha:1.0f],//IDH1   :#99CC33
                                   [UIColor colorWithRed:102.0f/255.0f green:51.0f/255.0f blue:204.0f/255.0f alpha:1.0f],//IDH2   :#6633CC
                                   [UIColor colorWithRed:0.0f green:153.0f/255.0f blue:204.0f/255.0f alpha:1.0f],        //KIT    :#0099CC
                                   [UIColor colorWithRed:153.0f/255.0f green:0.0f blue:153.0f/255.0f alpha:1.0],         //KRAS   :#990099
                                   [UIColor colorWithRed:0.0f green:1.0f blue:1.0f alpha:1.0f],                          //MAP2K1 :#00FFFF
                                   [UIColor colorWithRed:204.0f/255.0f green:51.0f/255.0f blue:191.0f/255.0f alpha:1.0f],//NPM1   :#CC33BF
                                   [UIColor colorWithRed:220.0f/255.0f green:57.0f/255.0f blue:18.0f/255.0f alpha:1.0f], //NRAS   :#DC3912
                                   [UIColor colorWithRed:0.0f green:85.0f/255.0f blue:254.0f/255.0f alpha:1.0f],         //PIK3CA :#0055FE
                                   [UIColor colorWithRed:1.0f green:204.0f/255.0f blue:17.0f/255.0f alpha:1.0f],         //PTEN   :#FFCC11
                                   [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f],                          //SMAD4  :#FF0000
                                   [UIColor colorWithRed:33.0f/255.0f green:124.0f/255.0f blue:126.0f/255.0f alpha:1.0f],//NONE   :#217C7E
                                   ];
            
            genePieLabelColors = @[[UIColor blackColor], //AKT1
                                   [UIColor blackColor], //BRAF
                                   [UIColor blackColor], //CTNNB1
                                   [UIColor blackColor], //DNMT3A
                                   [UIColor blackColor], //EGFR
                                   [UIColor blackColor], //ERBB2
                                   [UIColor blackColor], //FLT3
                                   [UIColor blackColor], //GNA11
                                   [UIColor blackColor], //GNAQ
                                   [UIColor blackColor], //IDH1
                                   [UIColor blackColor], //IDH2
                                   [UIColor blackColor], //KIT
                                   [UIColor whiteColor], //KRAS
                                   [UIColor blackColor], //MAP2K1
                                   [UIColor blackColor], //NPM1
                                   [UIColor blackColor], //NRAS
                                   [UIColor blackColor], //PIK3CA
                                   [UIColor blackColor], //PTEN
                                   [UIColor blackColor], //SMAD4
                                   [UIColor whiteColor], //NONE
                                   ];
            
            geneReferenceURLs = @[[NSURL URLWithString:@"http://en.m.wikipedia.org/wiki/AKT1"],
                                  [NSURL URLWithString:@"http://en.m.wikipedia.org/wiki/BRAF_(gene)"],
                                  [NSURL URLWithString:@"http://en.m.wikipedia.org/wiki/Beta-catenin"],
                                  [NSURL URLWithString:@"http://en.m.wikipedia.org/wiki/DNMT3A"],
                                  [NSURL URLWithString:@"http://en.m.wikipedia.org/wiki/Epidermal_growth_factor_receptor"],
                                  [NSURL URLWithString:@"http://en.m.wikipedia.org/wiki/HER2/neu"],
                                  [NSURL URLWithString:@"http://en.m.wikipedia.org/wiki/CD135"],
                                  [NSURL URLWithString:@"http://en.m.wikipedia.org/wiki/GNA11"],
                                  [NSURL URLWithString:@"http://en.m.wikipedia.org/wiki/GNAQ"],
                                  [NSURL URLWithString:@"http://en.m.wikipedia.org/wiki/IDH1"],
                                  [NSURL URLWithString:@"http://en.m.wikipedia.org/wiki/IDH2"],
                                  [NSURL URLWithString:@"http://en.m.wikipedia.org/wiki/CD117"],
                                  [NSURL URLWithString:@"http://en.m.wikipedia.org/wiki/KRAS"],
                                  [NSURL URLWithString:@"http://en.m.wikipedia.org/wiki/MAP2K1"],
                                  [NSURL URLWithString:@"http://en.m.wikipedia.org/wiki/NPM1"],
                                  [NSURL URLWithString:@"http://en.m.wikipedia.org/wiki/Neuroblastoma_RAS_viral_oncogene_homolog"],
                                  [NSURL URLWithString:@"http://en.m.wikipedia.org/wiki/P110%CE%B1"],
                                  [NSURL URLWithString:@"http://en.m.wikipedia.org/wiki/PTEN_(gene)"],
                                  [NSURL URLWithString:@"http://en.m.wikipedia.org/wiki/Mothers_against_decapentaplegic_homolog_4"],
                                  ];
            
            geneListCount = [geneIndexList count];
        }
    }
    
    return self;
}


#pragma mark - Gene Color (Pie Slice Color)
- (UIColor *)geneColorWithName:(NSString *)geneName
{
    long geneIndex = [geneIndexList indexOfObject:[geneName uppercaseString]];
    
    if(geneIndex == NSNotFound)
        return nil;
    
    return genePieSliceColors[geneIndex];
}

- (UIColor *)geneColorWithIndex:(NSUInteger)index
{
    if(index <= geneListCount)
        return genePieSliceColors[index];
    
    return nil;
}

#pragma mark - Gene Label Color
- (UIColor *)geneLabelColorWithName:(NSString *)geneName
{
    long geneIndex = [geneIndexList indexOfObject:[geneName uppercaseString]];
    
    if(geneIndex == NSNotFound)
        return nil;
    
    return genePieLabelColors[geneIndex];
}

- (UIColor *)geneLabelColorWithIndex:(NSUInteger)index
{
    if (index <= geneListCount)
        return genePieLabelColors[index];
    
    return nil;
}

#pragma mark - Gene Display Name
- (NSString *)geneDisplayValue:(NSString *)geneName
{
    if (geneSynonymList[[geneName uppercaseString]])
        return geneSynonymList[geneName];
    
    return geneName;
}

#pragma mark - Gene Reference URL
- (NSURL *)geneReferenceURLWithName:(NSString *)geneName
{
    NSString *tmpName = [geneName uppercaseString];
    
    if ([tmpName isEqualToString:@"NONE"])
        return nil;
    
    long geneIndex = [geneIndexList indexOfObject:[geneName uppercaseString]];
    
    if (geneIndex == NSNotFound)
        return nil;
    
    return geneReferenceURLs[geneIndex];
}
- (NSURL *)geneReferenceURLWithIndex:(NSUInteger)index
{
    if (index <= geneListCount && ![geneIndexList[index] isEqualToString:@"NONE"])
        return geneReferenceURLs[index];
    
    return nil;
}

@end
