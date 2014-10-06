//
//  LargePiePlotNavigationController.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/23/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import "LargePiePlotNavigationController.h"

@interface LargePiePlotNavigationController ()

@property (nonatomic, strong) UIViewController *pieChartHostController;
@property (nonatomic, strong) CPTPieChart *outerPiePlot;
@property (nonatomic, strong) CPTPieChart *innerPiePlot;

@end

@implementation LargePiePlotNavigationController

- (id) init
{
    self = [super init];
    
    if (self)
    {
        self.modalPresentationStyle = UIModalPresentationPageSheet;
        
        _pieChartHostController = [[UIViewController alloc] init];
        _pieChartHostController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                                                style:UIBarButtonItemStylePlain
                                                                                               target:self
                                                                                               action:@selector(closeSelf:)];
        self.viewControllers = @[_pieChartHostController];
    }
    
    return self;
}

- (void) renderBigGenePieChartWithIdentifier:(NSString *)identifier
                               andDataSource:(id<CPTPieChartDataSource>)pieChartDataSource
                                 andDelegate:(id<CPTPieChartDelegate>)delegate
                                    andTitle:(NSString *)title
{
    [self popToRootViewControllerAnimated:NO];
    
    _pieChartHostController.title = title;
    if (!_outerPiePlot)
    {
        CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
        borderLineStyle.lineColor = [CPTColor blackColor];
        
        CPTGraphHostingView *plotHostingView = [[CPTGraphHostingView alloc] init];
        plotHostingView.backgroundColor = [UIColor whiteColor];
        plotHostingView.translatesAutoresizingMaskIntoConstraints = NO;
        plotHostingView.userInteractionEnabled = YES;
        plotHostingView.autoresizesSubviews = YES;
        plotHostingView.allowPinchScaling = NO;
        
        [_pieChartHostController.view addSubview:plotHostingView];
        
        [_pieChartHostController.view addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[plotHostingView(>=500)]|"
                                                 options:NSLayoutFormatAlignAllCenterX
                                                 metrics:nil
                                                   views:NSDictionaryOfVariableBindings(plotHostingView)]];
        [_pieChartHostController.view addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[plotHostingView(>=500)]|"
                                                 options:NSLayoutFormatAlignAllCenterY
                                                 metrics:nil
                                                   views:NSDictionaryOfVariableBindings(plotHostingView)]];
        
        CPTXYGraph *graph = [[CPTXYGraph alloc] init];
        [plotHostingView setHostedGraph:graph];
        
        graph.borderLineStyle = nil;
        graph.paddingTop = 0;
        graph.paddingRight = 0;
        graph.paddingLeft = 0;
        graph.paddingBottom = 0;
        
        graph.axisSet = nil;
        graph.plotAreaFrame.masksToBorder = YES;
        graph.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
        graph.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
        
        graph.plotAreaFrame.borderLineStyle = nil;
        graph.plotAreaFrame.borderWidth = 0.0f;
        graph.plotAreaFrame.paddingBottom = 0;
        graph.plotAreaFrame.paddingLeft = 0;
        graph.plotAreaFrame.paddingRight = 0;
        graph.plotAreaFrame.paddingTop = 0;
        
        _outerPiePlot = [[CPTPieChart alloc] init];
        
        _outerPiePlot.pieRadius = 325.0f;
        _outerPiePlot.pieInnerRadius = 225.0f;
        _outerPiePlot.startAngle = M_PI_2;
        _outerPiePlot.sliceDirection = CPTPieDirectionClockwise;
        _outerPiePlot.labelRotationRelativeToRadius = NO;
        _outerPiePlot.labelRotation = 0.0f;
        _outerPiePlot.labelOffset = -90.0f;
        _outerPiePlot.borderLineStyle = borderLineStyle;
        _outerPiePlot.centerAnchor = CGPointMake(0.5f, 0.48f);
        
        _innerPiePlot = [[CPTPieChart alloc] init];
        
        _innerPiePlot.pieRadius = 150.0f;
        _innerPiePlot.startAngle = M_PI_2;
        _innerPiePlot.sliceDirection = CPTPieDirectionClockwise;
        _innerPiePlot.labelRotationRelativeToRadius = NO;
        _innerPiePlot.labelRotation = 0.0f;
        _innerPiePlot.labelOffset = 5.0f;
        _innerPiePlot.borderLineStyle = borderLineStyle;
        _innerPiePlot.centerAnchor = CGPointMake(0.5f, 0.48f);
        

        [graph addPlot:_outerPiePlot];
        [graph addPlot:_innerPiePlot];
    }
    
    _outerPiePlot.identifier = [NSString stringWithFormat:@"BIG%@OUTER", identifier];
    _outerPiePlot.delegate = delegate;
    _outerPiePlot.dataSource = pieChartDataSource;
    
    _innerPiePlot.identifier = [NSString stringWithFormat:@"BIG%@INNER", identifier];
    _innerPiePlot.delegate = delegate;
    _innerPiePlot.dataSource = pieChartDataSource;
    
    [_outerPiePlot reloadData];
    [_innerPiePlot reloadData];
}

- (void)closeSelf:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
