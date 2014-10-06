//
//  PatientPlotViewController.m
//  SMART Genomics Precision Cancer Medicine
//
//  Created by Daniel Carbone on 9/25/14.
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import "PatientPlotViewController.h"

#import "SVProgressHUD.h"

typedef enum {
    pvcPopulationGeneObservations,
    pvcPopulationPatientLookup,
    pvcPopulationPatientObservationLookup,
} PopulationDataQueryStatus;

@interface PatientPlotViewController()

@property (nonatomic, strong) FHIRDataService *fhirDataService;
@property (nonatomic, strong) FHIRPopulationDataService *fhirPopulationDataService;


@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSMutableArray *patientIDs;
@property (nonatomic, strong) NSMutableDictionary *populationPatientsAndObservations;


@property (nonatomic, strong) NSMutableDictionary *chartGeneData;
@property (nonatomic, strong) NSMutableDictionary *bigOuterChartGeneData;
@property (nonatomic, strong) NSMutableDictionary *bigInnerChartGeneData;
@property (nonatomic, strong) NSArray *geneList;
@property (nonatomic, strong) NSArray *bigOuterGeneList;
@property (nonatomic, strong) NSArray *bigInnerGeneList;
@property (nonatomic) long largestGene;

@property (nonatomic, strong) NSMutableDictionary *chartAminoAcidData;
@property (nonatomic, strong) NSMutableDictionary *bigOuterChartAminoAcidData;
@property (nonatomic, strong) NSMutableDictionary *bigInnerChartAminoAcidData;
@property (nonatomic, strong) NSArray *aminoAcidList;
@property (nonatomic, strong) NSArray *bigOuterAminoAcidList;
@property (nonatomic, strong) NSArray *bigInnerAminoAcidList;
@property (nonatomic) long largestAminoAcid;


@property (nonatomic, strong) UIView *rootView;

@property (nonatomic, strong) CPTGraphHostingView *genePlotHostingView;
@property (nonatomic, strong) CPTGraphHostingView *aminoAcidPlotHostingView;

@property (nonatomic, strong) NSLayoutConstraint *geneChartWidthConstraint;


@property (nonatomic, strong) NSMutableArray *geneChartOnlyPortraitConstraints;
@property (nonatomic, strong) NSMutableArray *geneChartOnlyLandscapeConstraints;

@property (nonatomic, strong) NSMutableArray *bothChartPortraitConstraints;
@property (nonatomic, strong) NSMutableArray *bothChartLandscapeConstraints;

@property (nonatomic, strong) UIViewController *webViewController;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSString *currentURLString;

- (void) closeLargeChart:(id)sender;

@end

static GeneData *geneData;
static AminoAcidData *aminoAcidData;

static LargePiePlotNavigationController *largePiePlotNavController;

@implementation PatientPlotViewController

- (id) init
{
    self = [super init];
    
    if (self)
    {
        if (!geneData)
            geneData = [[GeneData alloc] init];
        
        if (!aminoAcidData)
            aminoAcidData = [[AminoAcidData alloc] init];
        
        if (!largePiePlotNavController)
            largePiePlotNavController = [[LargePiePlotNavigationController alloc] init];
        
        _largestGene = 0;
        _largestAminoAcid = 0;
        
        _fhirDataService = [[FHIRDataService alloc] init];
        _fhirDataService.fhirDataServiceDelegate = self;
        
        _fhirPopulationDataService = [[FHIRPopulationDataService alloc] init];
        _fhirPopulationDataService.fhirDataServiceDelegate = self;
        
        _webViewController = [[UIViewController alloc] init];
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webViewController.view = _webView;
        _webViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                                                style:UIBarButtonItemStylePlain
                                                                                               target:self
                                                                                               action:@selector(closeLargeChart:)];
    }
    return self;
}

- (void)loadView
{
    _rootView = [[UIView alloc] init];
    _rootView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _rootView.backgroundColor = [UIColor whiteColor];
    
    self.view = _rootView;
}

- (void) viewDidLoad
{
    _status = [NSString stringWithFormat:@"%i", pvcPopulationGeneObservations];
    
    NSArray *keys = [_patientDiseaseData allKeys];
    NSString *disease = keys[0];
    
    [SVProgressHUD showWithStatus:@"Querying for Population Data"];
    
    [_fhirDataService searchForResource:@"Observation"
                          withParamKeys:@[@"value-concept:text",
                                          @"_skip",
                                          @"_count",]
                         andParamValues:@[disease,
                                          @"0",
                                          @"100",]
                      andShouldFetchAll:YES];
    
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_fhirDataService cancelConnection];
    [_fhirPopulationDataService cancelConnection];
    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews
{
    BOOL isInPortrait = UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    
    if (isInPortrait)
        [self portraitLayout];
    else
        [self landscapeLayout];
}

- (void) populationPatientsReceived:(NSArray *)entryComponents
{
    // Not used currently
}

- (void) portraitLayout
{
    if (_genePlotHostingView && _aminoAcidPlotHostingView)
    {
        [_rootView.superview removeConstraints:_bothChartLandscapeConstraints];
        [_rootView.superview addConstraints:_bothChartPortraitConstraints];
    }
    else if (_genePlotHostingView)
    {
        [_rootView.superview removeConstraints:_geneChartOnlyLandscapeConstraints];
        [_rootView.superview addConstraints:_geneChartOnlyPortraitConstraints];
    }
}

- (void) landscapeLayout
{
    if (_genePlotHostingView && _aminoAcidPlotHostingView)
    {
        [_rootView.superview removeConstraints:_bothChartPortraitConstraints];
        [_rootView.superview addConstraints:_bothChartLandscapeConstraints];
    }
    else if (_genePlotHostingView)
    {
        [_rootView.superview removeConstraints:_geneChartOnlyPortraitConstraints];
        [_rootView.superview addConstraints:_geneChartOnlyLandscapeConstraints];
    }
}

#pragma mark - Population Observation Lookup
- (void) populationGenomeObservationsReceived:(NSArray *)entryComponents
{
    _patientIDs = [[NSMutableArray alloc] init];
    
    if ([entryComponents count] > 0)
    {
        for (FHIRBundleEntryComponent *entryComponent in entryComponents)
        {
            if (entryComponent.content != nil)
            {
                NSString *patientID = [FHIRDataHelper getPatientIDFromObservationResource:(FHIRObservation *)entryComponent.content];
                
                if (patientID != nil && [_patientIDs indexOfObject:patientID] == NSNotFound)
                    [_patientIDs addObject:[NSString stringWithString:patientID]];
            }
        }
        
        if ([_patientIDs count] > 0)
        {
            
            _status = [NSString stringWithFormat:@"%i", pvcPopulationPatientObservationLookup];
            
            [SVProgressHUD showProgress:0.0f status:@"Loading Relevant Observations"];
            
            [_fhirPopulationDataService searchPopulationForResource:@"Observation"
                                                         withParams:@{@"_count" : @"100",}
                                                      andIDProperty:@"subject"
                                                        andIDValues:_patientIDs];
        }
    }
}


- (void) populationPatientObservationsReceived:(NSArray *)entryComponents
{
    NSMutableArray *observations;
    
    if (_populationPatientsAndObservations == nil)
        _populationPatientsAndObservations = [[NSMutableDictionary alloc] init];
    
    if ([entryComponents count] > 0)
    {
        for (FHIRBundleEntryComponent *entryComponent in entryComponents)
        {
            if (entryComponent.content != nil)
            {
                FHIRObservation *observation = (FHIRObservation *) entryComponent.content;
                
                NSString *patientID = [FHIRDataHelper getPatientIDFromObservationResource:observation];
                
                if (patientID != nil)
                {
                    if (_populationPatientsAndObservations[patientID] == nil)
                    {
                        [_populationPatientsAndObservations setObject:[[NSMutableDictionary alloc]
                                                                       initWithObjects:@[[[NSMutableArray alloc] init]]
                                                                       forKeys:@[@"observations"]]
                                                               forKey:patientID];
                    }
                    
                    NSMutableDictionary *patientDict = (NSMutableDictionary *)_populationPatientsAndObservations[patientID];
                    
                    observations = (NSMutableArray *)patientDict[@"observations"];
                    
                    [observations addObject:observation];
                    
                    patientDict[@"observations"] = observations;
                    
                    [_populationPatientsAndObservations setObject:patientDict forKey:patientID];
                }
            }
        }
        
        [self createPopulationGenomeGraph];
        
        if (![[[[_patientGeneData allKeys] firstObject] lowercaseString] isEqualToString:@"none"])
            [self createPopulationAminoAcidGraph];
    }
    
    [SVProgressHUD dismiss];
}

#pragma mark - Population Graph Views
- (void) createPopulationGenomeGraph
{
    _chartGeneData = [[NSMutableDictionary alloc] init];
    _bigOuterChartGeneData = [[NSMutableDictionary alloc] init];
    _bigInnerChartGeneData = [[NSMutableDictionary alloc] init];
    
    [_populationPatientsAndObservations enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL* stop)
     {
         if ([value isKindOfClass:[NSMutableDictionary class]] && [value objectForKey:@"observations"])
         {
             NSArray *observationArray = [NSArray arrayWithArray:[FHIRDataHelper genomicExtensionObservationArrayFromArrayOfObservations:[value objectForKey:@"observations"]]];
             
             if ([observationArray count] > 0)
             {
                 NSMutableArray *geneTmp;
                 
                 for (FHIRObservation *observation in observationArray)
                 {
                     NSDictionary *genomicData = [FHIRDataHelper parseGenomicExtensionDataFromObservation:observation];
                     NSString *patientID = [FHIRDataHelper getPatientIDFromObservationResource:observation];
                     
                     if (genomicData && genomicData[@"gene"])
                     {
                         NSString *geneName = genomicData[@"gene"][@"display"];
                         
                         if (_chartGeneData[geneName])
                             geneTmp = (NSMutableArray *)_chartGeneData[geneName];
                         else
                             geneTmp = [[NSMutableArray alloc] init];
                         
                         if ([geneTmp indexOfObject:patientID] == NSNotFound)
                         {
                             [geneTmp addObject:patientID];
                             [_chartGeneData setObject:geneTmp forKey:geneName];
                             
                             long count = [_chartGeneData[geneName] count];
                             if (count > _largestGene)
                                 _largestGene = count;
                         }
                     }
                 }
             }
         }
     }];
    
    __block int minSize;
    if (_largestGene > 100)
        minSize = 100;
    else
        minSize = 50;
    
    [_chartGeneData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        long count = [(NSArray *)obj count];
        
        if (count > minSize)
            [_bigOuterChartGeneData setObject:obj forKey:key];
        else
            [_bigInnerChartGeneData setObject:obj forKey:key];
        
    }];
    
    _geneList = [[_chartGeneData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    _bigOuterGeneList = [[_bigOuterChartGeneData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    _bigInnerGeneList = [[_bigInnerChartGeneData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    _genePlotHostingView = [[CPTGraphHostingView alloc] init];
    _genePlotHostingView.backgroundColor = [UIColor clearColor];
    _genePlotHostingView.translatesAutoresizingMaskIntoConstraints = NO;
    _genePlotHostingView.userInteractionEnabled = YES;
    _genePlotHostingView.autoresizesSubviews = YES;
    _genePlotHostingView.allowPinchScaling = NO;
    [_rootView addSubview:_genePlotHostingView];
    
    CPTXYGraph *graph = [[CPTXYGraph alloc] init];
    [_genePlotHostingView setHostedGraph:graph];
    
    graph.borderLineStyle = nil;
    graph.paddingTop = 0;
    graph.paddingRight = 0;
    graph.paddingLeft = 0;
    graph.paddingBottom = 0;
    
    graph.axisSet = nil;
    graph.plotAreaFrame.masksToBorder = YES;
    graph.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    graph.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    
    graph.title = [NSString stringWithFormat:@"Mutated Genes Observed in %@", [[_patientDiseaseData allKeys] firstObject]];
    
    CPTMutableTextStyle *textStyle = [[CPTMutableTextStyle alloc] init];
    [textStyle setFontSize:18.0f];
    graph.titleTextStyle = textStyle;
    graph.titleDisplacement = CGPointMake(0.0f, 0.0f);
    
    graph.plotAreaFrame.borderLineStyle = nil;
    graph.plotAreaFrame.borderWidth = 0.0f;
    graph.plotAreaFrame.paddingBottom = 0;
    graph.plotAreaFrame.paddingLeft = 0;
    graph.plotAreaFrame.paddingRight = 0;
    graph.plotAreaFrame.paddingTop = 0;
    
    CPTPieChart *piePlot = [[CPTPieChart alloc] init];
    piePlot.delegate = self;
    piePlot.dataSource = self;
    piePlot.pieRadius = 125.0f;
    piePlot.startAngle = M_PI_2;
    piePlot.sliceDirection = CPTPieDirectionClockwise;
    piePlot.labelRotationRelativeToRadius = NO;
    piePlot.labelRotation = 0.0f;
    piePlot.labelOffset = 5.0f;
    piePlot.identifier = @"GENE";
    
    CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor = [CPTColor blackColor];
    piePlot.borderLineStyle = borderLineStyle;
    
    [graph addPlot:piePlot];
    
    _geneChartOnlyPortraitConstraints = [[NSMutableArray alloc] init];
    [_geneChartOnlyPortraitConstraints addObject:
     [NSLayoutConstraint constraintWithItem:_rootView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:375.0f]];
    [_geneChartOnlyPortraitConstraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_genePlotHostingView]|"
                                             options:NSLayoutFormatAlignAllTop
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_genePlotHostingView)]];
    [_geneChartOnlyPortraitConstraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_genePlotHostingView]|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_genePlotHostingView)]];
    
    
    _geneChartOnlyLandscapeConstraints = [[NSMutableArray alloc] init];
    [_geneChartOnlyLandscapeConstraints addObject:
     [NSLayoutConstraint constraintWithItem:_rootView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:375.0f]];
    [_geneChartOnlyLandscapeConstraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_genePlotHostingView]|"
                                             options:NSLayoutFormatAlignAllTop
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_genePlotHostingView)]];
    [_geneChartOnlyLandscapeConstraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_genePlotHostingView]|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_genePlotHostingView)]];
}

- (void) createPopulationAminoAcidGraph
{
    _chartAminoAcidData = [[NSMutableDictionary alloc] init];
    _bigOuterChartAminoAcidData = [[NSMutableDictionary alloc] init];
    _bigInnerChartAminoAcidData = [[NSMutableDictionary alloc] init];
    
    __block NSString *sourcePatientGene = [[_patientGeneData allKeys] firstObject];
    
    [_populationPatientsAndObservations enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop)
     {
         if ([value isKindOfClass:[NSDictionary class]] && [value objectForKey:@"observations"])
         {
             NSArray *observationArray = [NSArray arrayWithArray:[FHIRDataHelper genomicExtensionObservationArrayFromArrayOfObservations:[value objectForKey:@"observations"]]];
             
             if ([observationArray count] > 0)
             {
                 NSMutableArray *aminoAcidTmp;
                 
                 for (FHIRObservation *observation in observationArray)
                 {
                     NSDictionary *genomicData = [FHIRDataHelper parseGenomicExtensionDataFromObservation:observation];
                     NSString *patientID = [FHIRDataHelper getPatientIDFromObservationResource:observation];
                     
                     if (genomicData && genomicData[@"gene"] && genomicData[@"gene"][@"display"] && [genomicData[@"gene"][@"display"] isEqualToString:sourcePatientGene])
                     {
                         NSString *displayValue;
                         
                         if (genomicData[@"aminoAcid"] && ![genomicData[@"aminoAcid"][@"display"] isEqualToString:@"-"])
                             displayValue = genomicData[@"aminoAcid"][@"display"];
                         else if (genomicData[@"nucleotide"] && ![genomicData[@"nucleotide"][@"display"] isEqualToString:@"-"])
                             displayValue = genomicData[@"nucleotide"][@"display"];
                         else
                             continue;
                         
                         if (_chartAminoAcidData[displayValue])
                             aminoAcidTmp = (NSMutableArray *)_chartAminoAcidData[displayValue];
                         else
                             aminoAcidTmp = [[NSMutableArray alloc] init];
                         
                         if ([aminoAcidTmp indexOfObject:patientID] == NSNotFound)
                         {
                             [aminoAcidTmp addObject:patientID];
                             [_chartAminoAcidData setObject:aminoAcidTmp forKey:displayValue];
                             
                             long count = [_chartAminoAcidData[displayValue] count];
                             if (count > _largestAminoAcid)
                                 _largestAminoAcid = count;
                         }
                     }
                 }
             }
         }
     }];
    
    __block int minSize;
    if (_largestAminoAcid > 10)
        minSize = 10;
    else
        minSize = 5;
    
    [_chartAminoAcidData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        long count = [(NSArray *)obj count];
        
        if (count > minSize)
            [_bigOuterChartAminoAcidData setObject:obj forKey:key];
        else
            [_bigInnerChartAminoAcidData setObject:obj forKey:key];
        
    }];
    
    _aminoAcidList = [[_chartAminoAcidData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    _bigOuterAminoAcidList = [[_bigOuterChartAminoAcidData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    _bigInnerAminoAcidList = [[_bigInnerChartAminoAcidData allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    _aminoAcidPlotHostingView = [[CPTGraphHostingView alloc] init];
    _aminoAcidPlotHostingView.backgroundColor = [UIColor clearColor];
    _aminoAcidPlotHostingView.translatesAutoresizingMaskIntoConstraints = NO;
    _aminoAcidPlotHostingView.userInteractionEnabled = YES;
    _aminoAcidPlotHostingView.autoresizesSubviews = YES;
    _aminoAcidPlotHostingView.allowPinchScaling = NO;
    [_rootView addSubview:_aminoAcidPlotHostingView];
    
    CPTXYGraph *graph = [[CPTXYGraph alloc] init];
    [_aminoAcidPlotHostingView setHostedGraph:graph];
    
    graph.borderLineStyle = nil;
    graph.paddingTop = 0;
    graph.paddingRight = 0;
    graph.paddingLeft = 0;
    graph.paddingBottom = 0;
    
    graph.axisSet = nil;
    graph.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    graph.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    graph.title = [NSString stringWithFormat:@"Observed Variants in %@ Patients\nwith %@ Mutation",
                   [[_patientDiseaseData allKeys] firstObject],
                   [[_patientGeneData allKeys] firstObject]];
    
    CPTMutableTextStyle *textStyle = [[CPTMutableTextStyle alloc] init];
    textStyle.fontSize = 18.0f;
    textStyle.textAlignment = CPTTextAlignmentCenter;
    graph.titleTextStyle = textStyle;
    graph.titleDisplacement = CGPointMake(0.0f, 10.0f);
    
    
    graph.plotAreaFrame.borderLineStyle = nil;
    graph.plotAreaFrame.borderWidth = 0.0f;
    graph.plotAreaFrame.paddingBottom = 0;
    graph.plotAreaFrame.paddingLeft = 0;
    graph.plotAreaFrame.paddingRight = 0;
    graph.plotAreaFrame.paddingTop = 0;
    
    CPTPieChart *piePlot = [[CPTPieChart alloc] init];
    piePlot.pieRadius = 125.0f;
    piePlot.identifier = @"AMINOACID";
    piePlot.startAngle = M_PI_2;
    piePlot.sliceDirection = CPTPieDirectionClockwise;
    piePlot.labelRotationRelativeToRadius = NO;
    piePlot.labelRotation = 0.0f;
    piePlot.labelOffset = 5.0f;
    piePlot.delegate = self;
    piePlot.dataSource = self;
    
    CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor = [CPTColor blackColor];
    piePlot.borderLineStyle = borderLineStyle;
    
    [graph addPlot:piePlot];
    
    _bothChartPortraitConstraints = [[NSMutableArray alloc] init];
    [_bothChartPortraitConstraints addObject:
     [NSLayoutConstraint constraintWithItem:_rootView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1.0f
                                   constant:750.0f]];
    [_bothChartPortraitConstraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_genePlotHostingView(375)][_aminoAcidPlotHostingView(375)]|"
                                             options:NSLayoutFormatAlignAllCenterX
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_genePlotHostingView, _aminoAcidPlotHostingView)]];
    [_bothChartPortraitConstraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_genePlotHostingView]|"
                                             options:NSLayoutFormatAlignAllTop
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_genePlotHostingView)]];
    [_bothChartPortraitConstraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_aminoAcidPlotHostingView]|"
                                             options:NSLayoutFormatAlignAllTop
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_aminoAcidPlotHostingView)]];
    
    _bothChartLandscapeConstraints = [[NSMutableArray alloc] init];
    [_bothChartLandscapeConstraints addObject:
     [NSLayoutConstraint constraintWithItem:_rootView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:0.0f
                                   constant:375.0f]];
    [_bothChartLandscapeConstraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_genePlotHostingView][_aminoAcidPlotHostingView]|"
                                             options:NSLayoutFormatAlignAllTop
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_genePlotHostingView, _aminoAcidPlotHostingView)]];
    [_bothChartLandscapeConstraints addObject:
     [NSLayoutConstraint constraintWithItem:_genePlotHostingView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                     toItem:_rootView
                                  attribute:NSLayoutAttributeWidth
                                 multiplier:0.5f
                                   constant:0.0f]];
    [_bothChartLandscapeConstraints addObject:
     [NSLayoutConstraint constraintWithItem:_aminoAcidPlotHostingView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                     toItem:_rootView
                                  attribute:NSLayoutAttributeWidth
                                 multiplier:0.5f
                                   constant:0.0f]];
    [_bothChartLandscapeConstraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_genePlotHostingView]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_genePlotHostingView)]];
    [_bothChartLandscapeConstraints addObjectsFromArray:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_aminoAcidPlotHostingView]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_aminoAcidPlotHostingView)]];
}

#pragma mark - FHIRDataServiceDelegate implementation
- (void) fhirServiceConnectionCancelled
{
    
}

- (void) fhirResourceResponseReceived:(FHIRResource *)data
{
    if ([data isKindOfClass:[FHIRBundle class]])
    {
        FHIRBundle *bundle = (FHIRBundle *)data;
        
        if (bundle.entry != nil && [bundle.entry count] > 0)
        {
            switch ([_status intValue]) {
                case pvcPopulationGeneObservations:
                    [self populationGenomeObservationsReceived:[NSArray arrayWithArray:bundle.entry]];
                    break;
                    
                case pvcPopulationPatientLookup:
                    [self populationPatientsReceived:[NSArray arrayWithArray:bundle.entry]];
                    break;
                    
                case pvcPopulationPatientObservationLookup :
                    [self populationPatientObservationsReceived:[NSArray arrayWithArray:bundle.entry]];
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (void) fhirErrorEncountered:(NSError *)error
{
    
}

- (void) fhirPartialResponseReceived:(NSNumber *)current ofTotal:(NSNumber *)total
{
    float percent = ([current floatValue] / [total floatValue]);
    
    [SVProgressHUD showProgress:percent status:@"Loading Relevant Observations"];
}

#pragma mark - CPTPieChartDataSource implementation
- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    id identifier = plot.identifier;

    if (identifier)
    {
        if ([identifier isEqualToString:@"GENE"])
        {
            return (int)[_chartGeneData count];
        }
        else if ([identifier isEqualToString:@"BIGGENEOUTER"])
        {
            return (int)[_bigOuterChartGeneData count];
        }
        if ([identifier isEqualToString:@"BIGGENEINNER"])
        {
            return (int)[_bigInnerChartGeneData count];
        }
        else if ([identifier isEqualToString:@"AMINOACID"])
        {
            return (int)[_chartAminoAcidData count];
        }
        else if ([identifier isEqualToString:@"BIGAMINOACIDOUTER"])
        {
            return (int)[_bigOuterChartAminoAcidData count];
        }
        else if ([identifier isEqualToString:@"BIGAMINOACIDINNER"])
        {
            return (int)[_bigInnerChartAminoAcidData count];
        }
    }

    return 0;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    id identifier = plot.identifier;
    
    if (identifier)
    {
        if ([identifier isEqualToString:@"GENE"])
        {
            NSString *gene = _geneList[index];
            NSArray *data = _chartGeneData[gene];
            
            return [NSNumber numberWithInteger:[data count]];
        }
        else if ([identifier isEqualToString:@"BIGGENEOUTER"])
        {
            NSString *gene = _bigOuterGeneList[index];
            NSArray *data = _bigOuterChartGeneData[gene];
            
            return [NSNumber numberWithInteger:[data count]];
        }
        else if ([identifier isEqualToString:@"BIGGENEINNER"])
        {
            NSString *gene = _bigInnerGeneList[index];
            NSArray *data = _bigInnerChartGeneData[gene];
            
            return [NSNumber numberWithInteger:[data count]];
        }
        else if ([identifier isEqualToString:@"AMINOACID"])
        {
            NSString *aminoAcid = _aminoAcidList[index];
            NSArray *data = _chartAminoAcidData[aminoAcid];
            
            return [NSNumber numberWithInteger:[data count]];
        }
        else if ([identifier isEqualToString:@"BIGAMINOACIDOUTER"])
        {
            NSString *aminoAcid = _bigOuterAminoAcidList[index];
            NSArray *data = _bigOuterChartAminoAcidData[aminoAcid];
            
            return [NSNumber numberWithInteger:[data count]];
        }
        else if ([identifier isEqualToString:@"BIGAMINOACIDINNER"])
        {
            NSString *aminoAcid = _bigInnerAminoAcidList[index];
            NSArray *data = _bigInnerChartAminoAcidData[aminoAcid];
            
            return [NSNumber numberWithInteger:[data count]];
        }
    }
    
    return nil;
}

-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
    id identifier = pieChart.identifier;
    
    if (identifier)
    {
        if ([identifier isEqualToString:@"GENE"])
        {
            NSString *gene = _geneList[index];
            UIColor *sliceColor = [geneData geneColorWithName:gene];
            
            if (sliceColor)
                return [CPTFill fillWithColor:[CPTColor colorWithCGColor:[sliceColor CGColor]]];
        }
        else if ([identifier isEqualToString:@"BIGGENEOUTER"])
        {
            NSString *gene = _bigOuterGeneList[index];
            UIColor *sliceColor = [geneData geneColorWithName:gene];
            
            if (sliceColor)
                return [CPTFill fillWithColor:[CPTColor colorWithCGColor:[sliceColor CGColor]]];
        }
        else if ([identifier isEqualToString:@"BIGGENEINNER"])
        {
            NSString *gene = _bigInnerGeneList[index];
            UIColor *sliceColor = [geneData geneColorWithName:gene];
            
            if (sliceColor)
                return [CPTFill fillWithColor:[CPTColor colorWithCGColor:[sliceColor CGColor]]];
        }
        else if ([identifier isEqualToString:@"AMINOACID"])
        {
            return [CPTFill fillWithColor:[CPTColor colorWithCGColor:[[aminoAcidData aminoAcidColorWithIndex:index] CGColor]]];
        }
        else if ([identifier isEqualToString:@"BIGAMINOACIDOUTER"])
        {
            NSString *gene = _bigOuterAminoAcidList[index];
            long offset = [_aminoAcidList indexOfObject:gene];
            
            return [CPTFill fillWithColor:[CPTColor colorWithCGColor:[[aminoAcidData aminoAcidColorWithIndex:offset] CGColor]]];
        }
        else if ([identifier isEqualToString:@"BIGAMINOACIDINNER"])
        {
            NSString *gene = _bigInnerAminoAcidList[index];
            long offset = [_aminoAcidList indexOfObject:gene];
            
            return [CPTFill fillWithColor:[CPTColor colorWithCGColor:[[aminoAcidData aminoAcidColorWithIndex:offset] CGColor]]];
        }
    }
    
    return nil;
}

- (CPTLayer *) dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx
{
    id identifier = plot.identifier;
    
    if (identifier)
    {
        if ([identifier isEqualToString:@"GENE"])
        {
            NSString *gene = _geneList[idx];
            NSString *geneDisplayName = [geneData geneDisplayValue:gene];
            CPTMutableTextStyle *textStyle = [[CPTMutableTextStyle alloc] init];
            
            CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:geneDisplayName
                                                                   style:textStyle];
            [textLayer sizeToFit];
            
            return textLayer;
        }
        else if ([identifier isEqualToString:@"BIGGENEOUTER"])
        {
            NSString *gene = _bigOuterGeneList[idx];
            NSString *geneDisplayName = [geneData geneDisplayValue:gene];
            NSArray *data = _bigOuterChartGeneData[gene];
            UIColor *labelColor = [geneData geneLabelColorWithName:gene];
            CPTMutableTextStyle *textStyle = [[CPTMutableTextStyle alloc] init];
            
            if (labelColor)
                textStyle.color = [CPTColor colorWithCGColor:[labelColor CGColor]];
            
            CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@\n(%i pts.)",
                                                                          geneDisplayName,
                                                                          (int)[data count]]
                                                                   style:textStyle];
            [textLayer sizeToFit];
            
            return textLayer;
        }
        else if ([identifier isEqualToString:@"BIGGENEINNER"])
        {
            NSString *gene = _bigInnerGeneList[idx];
            NSString *geneDisplayName = [geneData geneDisplayValue:gene];
            NSArray *data = _bigInnerChartGeneData[gene];
            CPTMutableTextStyle *textStyle = [[CPTMutableTextStyle alloc] init];
            
            CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@\n(%i pts.)",
                                                                          geneDisplayName,
                                                                          (int)[data count]]
                                                                   style:textStyle];
            [textLayer sizeToFit];
            
            return textLayer;
        }
        else if ([identifier isEqualToString:@"AMINOACID"])
        {
            NSString *aminoAcid = _aminoAcidList[idx];
            NSString *aminoAcidDisplayName = [aminoAcidData aminoAcidDisplayValue:aminoAcid];
            CPTMutableTextStyle *textStyle = [[CPTMutableTextStyle alloc] init];
            
            CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:aminoAcidDisplayName
                                                                   style:textStyle];
            
            [textLayer sizeToFit];
            return textLayer;
        }
        else if ([identifier isEqualToString:@"BIGAMINOACIDOUTER"])
        {
            NSString *aminoAcid = _bigOuterAminoAcidList[idx];
            NSArray *data = _bigOuterChartAminoAcidData[aminoAcid];
            NSString *aminoAcidDisplayName = [aminoAcidData aminoAcidDisplayValue:aminoAcid];
            UIColor *labelColor = [aminoAcidData aminoAcidLabelColorWithIndex:idx];
            CPTMutableTextStyle *textStyle = [[CPTMutableTextStyle alloc] init];
            
            textStyle.color = [CPTColor colorWithCGColor:[labelColor CGColor]];
            
            CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@\n(%i pts.)",
                                                                          aminoAcidDisplayName,
                                                                          (int)[data count]]
                                                                   style:textStyle];
            
            [textLayer sizeToFit];
            return textLayer;
        }
        else if ([identifier isEqualToString:@"BIGAMINOACIDINNER"])
        {
            NSString *aminoAcid = _bigInnerAminoAcidList[idx];
            NSArray *data = _bigInnerChartAminoAcidData[aminoAcid];
            NSString *aminoAcidDisplayName = [aminoAcidData aminoAcidDisplayValue:aminoAcid];
            CPTMutableTextStyle *textStyle = [[CPTMutableTextStyle alloc] init];
            
            CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@\n(%i pts.)",
                                                                          aminoAcidDisplayName,
                                                                          (int)[data count]]
                                                                   style:textStyle];
            
            [textLayer sizeToFit];
            return textLayer;
        }
    }
    
    return nil;
}

- (CGFloat)radialOffsetForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx
{
    id identifier = pieChart.identifier;
    
    if (identifier)
    {
        if ([identifier isEqualToString:@"GENE"])
        {
            NSString *gene = _geneList[idx];
            NSString *sourcePatientGene = [[_patientGeneData allKeys] firstObject];
            
            if ([gene isEqualToString:sourcePatientGene])
                return 20.0f;
        }
        else if ([identifier isEqualToString:@"BIGGENEOUTER"])
        {
            NSString *gene = _bigOuterGeneList[idx];
            NSString *sourcePatientGene = [[_patientGeneData allKeys] firstObject];
            
            if ([_bigOuterGeneList count] > 1 && [gene isEqualToString:sourcePatientGene])
                return 20.0f;
        }
        else if ([identifier isEqualToString:@"BIGGENEINNER"])
        {
            NSString *gene = _bigInnerGeneList[idx];
            NSString *sourcePatientGene = [[_patientGeneData allKeys] firstObject];
            
            if ([_bigInnerGeneList count] > 1 && [gene isEqualToString:sourcePatientGene])
                return 20.0f;
        }
        else
        {
            NSString *aminoAcid, *source;
            long count;
            
            if ([identifier isEqualToString:@"AMINOACID"])
            {
                aminoAcid = _aminoAcidList[idx];
                count = [_aminoAcidList count];
            }
            else if ([identifier isEqualToString:@"BIGAMINOACIDOUTER"])
            {
                aminoAcid = _bigOuterAminoAcidList[idx];
                count = [_bigOuterAminoAcidList count];
            }
            else if ([identifier isEqualToString:@"BIGAMINOACIDINNER"])
            {
                aminoAcid = _bigInnerAminoAcidList[idx];
                count = [_bigInnerAminoAcidList count];
            }
            else
            {
                return 0.0f;
            }
            
            
            if (_patientAminoAcidData && [_patientAminoAcidData count] > 0)
            {
                source = [[_patientAminoAcidData allKeys] firstObject];
            }
            else if (_patientNucleotideData && [_patientNucleotideData count] > 0)
            {
                source = [[_patientNucleotideData allKeys] firstObject];
            }
            
            if (count > 1 && [aminoAcid isEqualToString:source])
                return 20.0f;
        }
    }
    
    return 0.0f;
}

#pragma mark - CPTPieChartDelegate implementation

- (void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)idx
{
    id identifier = plot.identifier;
    
    if ([identifier isEqualToString:@"GENE"])
    {
        [largePiePlotNavController renderBigGenePieChartWithIdentifier:@"GENE"
                                                         andDataSource:self
                                                           andDelegate:self
                                                              andTitle:[NSString stringWithFormat:@"Mutated Genes Observed in %@",
                                                                        [[_patientDiseaseData allKeys] firstObject]]];
        
        [self presentViewController:largePiePlotNavController animated:YES completion:nil];
    }
    else if ([identifier isEqualToString:@"BIGGENEOUTER"])
    {
        NSString *gene = _bigOuterGeneList[idx];
        NSURL *url = [geneData geneReferenceURLWithName:gene];
        
        if (url)
        {
            _webViewController.title = [NSString stringWithFormat:@"%@ Reference", gene];
            _currentURLString = [url absoluteString];
            [_webView loadRequest:[NSURLRequest requestWithURL:url]];
            [largePiePlotNavController pushViewController:_webViewController animated:YES];
        }
    }
    else if ([identifier isEqualToString:@"BIGGENEINNER"])
    {
        NSString *gene = _bigInnerGeneList[idx];
        NSURL *url = [geneData geneReferenceURLWithName:gene];
        
        if (url)
        {
            _webViewController.title = [NSString stringWithFormat:@"%@ Reference", gene];
            _currentURLString = [url absoluteString];
            [_webView loadRequest:[NSURLRequest requestWithURL:url]];
            [largePiePlotNavController pushViewController:_webViewController animated:YES];
        }
    }
    else if ([identifier isEqualToString:@"AMINOACID"])
    {
        [largePiePlotNavController renderBigGenePieChartWithIdentifier:@"AMINOACID"
                                                         andDataSource:self
                                                           andDelegate:self
                                                              andTitle:[NSString stringWithFormat:@"Observed Variants in %@ Pts. with %@ Mutation",
                                                                        [[_patientDiseaseData allKeys] firstObject],
                                                                        [[_patientGeneData allKeys] firstObject]]];
        
        [self presentViewController:largePiePlotNavController animated:YES completion:nil];
    }
}

- (void)plot:(CPTPlot *)plot dataLabelTouchDownAtRecordIndex:(NSUInteger)idx
{
    id identifier = plot.identifier;
    
    if ([identifier isEqualToString:@"GENE"])
    {
        [largePiePlotNavController renderBigGenePieChartWithIdentifier:@"GENE"
                                                         andDataSource:self
                                                           andDelegate:self
                                                              andTitle:[NSString stringWithFormat:@"Mutated Genes Observed in %@",
                                                                        [[_patientDiseaseData allKeys] firstObject]]];
        
        [self presentViewController:largePiePlotNavController animated:YES completion:nil];
    }
    else if ([identifier isEqualToString:@"BIGGENEOUTER"])
    {
        NSString *gene = _bigOuterGeneList[idx];
        NSURL *url = [geneData geneReferenceURLWithName:gene];
        
        if (url)
        {
            _webViewController.title = [NSString stringWithFormat:@"%@ Reference", gene];
            _currentURLString = [url absoluteString];
            [_webView loadRequest:[NSURLRequest requestWithURL:url]];
            [largePiePlotNavController pushViewController:_webViewController animated:YES];
        }
    }
    else if ([identifier isEqualToString:@"BIGGENEINNER"])
    {
        NSString *gene = _bigInnerGeneList[idx];
        NSURL *url = [geneData geneReferenceURLWithName:gene];
        
        if (url)
        {
            _webViewController.title = [NSString stringWithFormat:@"%@ Reference", gene];
            _currentURLString = [url absoluteString];
            [_webView loadRequest:[NSURLRequest requestWithURL:url]];
            [largePiePlotNavController pushViewController:_webViewController animated:YES];
        }
    }
    else if ([identifier isEqualToString:@"AMINOACID"])
    {
        [largePiePlotNavController renderBigGenePieChartWithIdentifier:@"AMINOACID"
                                                         andDataSource:self
                                                           andDelegate:self
                                                              andTitle:[NSString stringWithFormat:@"Observed Variants in %@ Pts. with %@ Mutation",
                                                                        [[_patientDiseaseData allKeys] firstObject],
                                                                        [[_patientGeneData allKeys] firstObject]]];
        
        [self presentViewController:largePiePlotNavController animated:YES completion:nil];
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *newURLString = [request.URL absoluteString];
    if ([newURLString isEqualToString:_currentURLString])
        return YES;
    
    [[UIApplication sharedApplication] openURL:request.URL];
    
    return NO;
}

- (void)closeLargeChart:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
