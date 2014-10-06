//
//  PlotItem.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/2/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import "PlotItem.h"
#import <tgmath.h>

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
#else
// For IKImageBrowser
#import <Quartz/Quartz.h>
#endif

NSString *const kDemoPlots      = @"Demos";
NSString *const kPieCharts      = @"Pie Charts";
NSString *const kLinePlots      = @"Line Plots";
NSString *const kBarPlots       = @"Bar Plots";
NSString *const kFinancialPlots = @"Financial Plots";

@interface PlotItem()

@property (nonatomic, retain) CPTGraphHostingView *defaultLayerHostingView;
@property (nonatomic, retain) NSMutableArray *graphs;
@property (nonatomic, retain) NSString *section;
@property (nonatomic, retain) NSString *title;


@property (nonatomic, retain) CPTNativeImage *cachedImage;

@end

@implementation PlotItem

@end
