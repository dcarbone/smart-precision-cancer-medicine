//
//  AminoAcidData.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/25/14.
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

#import "AminoAcidData.h"

static NSArray *aminoAcidPieSliceColors;
static NSArray *aminoAcidPieLabelColors;
static long pieColorCount;

@implementation AminoAcidData

- (id) init
{
    self = [super init];
    
    if (self)
    {
        if (!aminoAcidPieSliceColors)
        {
            aminoAcidPieSliceColors = @[[UIColor colorWithRed:166.0f/255.0f green:206.0f/255.0f blue:227.0f/255.0f alpha:1.0f],   //A6CEE3
                                        [UIColor colorWithRed:31.0f/255.0f green:120.0f/255.0f blue:180.0f/255.0f alpha:1.0f],    //1F78B4
                                        [UIColor colorWithRed:178.0f/255.0f green:223.0f/255.0f blue:128.0f/255.0f alpha:1.0f],   //B2DF8A
                                        [UIColor colorWithRed:51.0f/255.0f green:160.0f/255.0f blue:44.0f/255.0f alpha:1.0f],     //33A02C
                                        [UIColor colorWithRed:251.0f/255.0f green:154.0f/255.0f blue:153.0f/255.0f alpha:1.0f],   //FB9A99
                                        [UIColor colorWithRed:227.0f/255.0f green:26.0f/255.0f blue:28.0f/255.0f alpha:1.0f],     //E31A1C
                                        [UIColor colorWithRed:253.0f/255.0f green:191.0f/255.0f blue:111.0f/255.0f alpha:1.0f],   //FDBF6F
                                        [UIColor colorWithRed:1.0f green:127.0f/255.0f blue:0.0f alpha:1.0f],                     //FF7F00
                                        [UIColor colorWithRed:202.0f/255.0f green:128.0f/255.0f blue:214.0f/255.0f alpha:1.0f],   //CAB2D6
                                        [UIColor colorWithRed:106.0f/255.0f green:61.0f/255.0f blue:154.0f/255.0f alpha:1.0f],    //6A3D9A
                                        [UIColor colorWithRed:1.0f green:1.0f blue:153.0f/255.0f alpha:1.0f],                     //FFFF99
                                        [UIColor colorWithRed:177.0f/255.0f green:89.0f/255.0f blue:40.0f/255.0f alpha:1.0f],     //B15928
                                        ];
            
            aminoAcidPieLabelColors = @[[UIColor blackColor],
                                        [UIColor blackColor],
                                        [UIColor blackColor],
                                        [UIColor blackColor],
                                        [UIColor blackColor],
                                        [UIColor blackColor],
                                        [UIColor blackColor],
                                        [UIColor blackColor],
                                        [UIColor blackColor],
                                        [UIColor blackColor],
                                        [UIColor blackColor],
                                        [UIColor blackColor],
                                        ];
            
            pieColorCount = [aminoAcidPieSliceColors count];
        }
    }
    
    return self;
}

- (UIColor *)aminoAcidColorWithIndex:(NSUInteger)index
{
    long colorIndex;
    if (index >= pieColorCount)
        colorIndex = pieColorCount % index;
    else
        colorIndex = index;
    
    return aminoAcidPieSliceColors[colorIndex];
}

- (UIColor *)aminoAcidLabelColorWithIndex:(NSUInteger)index
{
    long colorIndex;
    
    if (index >= pieColorCount)
        colorIndex = pieColorCount % index;
    else
        colorIndex = index;
    
    return aminoAcidPieLabelColors[colorIndex];
}

- (NSString *)aminoAcidDisplayValue:(NSString *)aminoAcidName
{
    if ([aminoAcidName isEqualToString:@"-"])
        return @"Not Detected";
    
    return aminoAcidName;
}

@end
