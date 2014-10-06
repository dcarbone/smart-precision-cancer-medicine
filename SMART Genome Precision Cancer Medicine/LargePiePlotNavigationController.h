//
//  LargePiePlotNavigationController.h
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/23/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GeneData.h"

#import "CorePlot-CocoaTouch.h"


@interface LargePiePlotNavigationController : UINavigationController

- (void) closeSelf:(id)sender;

- (void) renderBigGenePieChartWithIdentifier:(NSString *)identifier
                               andDataSource:(id<CPTPieChartDataSource>)pieChartDataSource
                                 andDelegate:(id<CPTPieChartDelegate>)delegate
                                    andTitle:(NSString *)title;

@end
