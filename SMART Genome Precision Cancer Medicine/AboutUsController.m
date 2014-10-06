//
//  AboutUsController.m
//  SMART Genomics Precision Cancer Medicine
//
//  Copyright (c) 2014 Vanderbilt-Ingram Cancer Center. All rights reserved.
//

#import "AboutUsController.h"

#import "AboutUsSectionHeaderLabel.h"
#import "AboutUsSpacerLabel.h"
#import "AboutUsBlueHeader.h"

@interface AboutUsController()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *aboutView;

@property (nonatomic, strong) NSArray *aboutViewWidthConstraints;

@end

@implementation AboutUsController

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.title = @"About this App";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"About" image:nil tag:4];
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _aboutView = [[UIView alloc] init];
    _aboutView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:_aboutView];
    
    UILabel *mainHeader, *legalHeader, *legalSpacer, *topBlurb, *topBlurb2, *termsHeader, *usageBlue, *usageText, *thirdPartyBlue, *thirdPartyText, *notForBlue, *notForText, *discBlue, *discText, *ackHeader, *ackText, *ackText2, *contrHeader, *devTeamBlue, *devTeamText;
    UIButton *licenseLink, *vandyLink, *smartOnFhirLink, *smartLink, *fhirLink, *jeremyLink;
    
    mainHeader = [[UILabel alloc] init];
    mainHeader.translatesAutoresizingMaskIntoConstraints = NO;
    [_aboutView addSubview:mainHeader];
    mainHeader.text = @"About this App";
    mainHeader.font = [UIFont systemFontOfSize:24.0f];
    
    legalHeader = [[AboutUsSectionHeaderLabel alloc] init];
    [_aboutView addSubview:legalHeader];
    legalHeader.text = @"LEGAL POLICIES";
    
    legalSpacer = [[AboutUsSpacerLabel alloc] init];
    [_aboutView addSubview:legalSpacer];
    
    topBlurb = [[UILabel alloc] init];
    [_aboutView addSubview:topBlurb];
    [self setWidthConstraint:topBlurb];
    topBlurb.translatesAutoresizingMaskIntoConstraints = NO;
    topBlurb.text = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@]",
                     @"SMART Genomics: Precision Cancer Medicine",
                     @"Copyright 2014 Vanderbilt University",
                     @"Licensed under the Apache License, Version 2.0 (the \"License\"); you may not use this file except in compliance with the License.",
                     @"You may obtain a copy of the License at"];
    
    licenseLink = [UIButton buttonWithType:UIButtonTypeSystem];
    [_aboutView addSubview:licenseLink];
    licenseLink.translatesAutoresizingMaskIntoConstraints = NO;
    [licenseLink setTitle:@"http://www.apache.org/licenses/LICENSE-2.0" forState:UIControlStateNormal];
    [licenseLink addTarget:self action:@selector(openLicenseLink:) forControlEvents:UIControlEventTouchUpInside];
    
    topBlurb2 = [[UILabel alloc] init];
    [_aboutView addSubview:topBlurb2];
    topBlurb2.translatesAutoresizingMaskIntoConstraints = NO;
    topBlurb2.numberOfLines = 0;
    [self setWidthConstraint:topBlurb2];
    topBlurb2.text = [NSString stringWithFormat:@"%@\n\n%@",
                      @"Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an \"AS IS\" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.",
                      @"See the License for the specific language governing permissions and limitations under the License."];
    
    termsHeader = [[AboutUsSectionHeaderLabel alloc] init];
    [_aboutView addSubview:termsHeader];
    termsHeader.text = @"TERMS OF USE";
    
    usageBlue = [[AboutUsBlueHeader alloc] init];
    [_aboutView addSubview:usageBlue];
    usageBlue.text = @"Use of SMART Genomics: Precision Cancer Medicine Mobile App Data";
    
    usageText = [[UILabel alloc] init];
    [_aboutView addSubview:usageText];
    usageText.translatesAutoresizingMaskIntoConstraints = NO;
    usageText.numberOfLines = 0;
    [self setWidthConstraint:usageText];
    usageText.text = @"The following Terms and Conditions apply for use of SMART Genomics: Precision Cancer Medicine mobile app data. Downloading data indicates your acceptance of the following Terms and Conditions. These Terms and Conditions apply to all data obtained from the SMART Genomics: Precision Cancer Medicine mobile app, independent of format and method of acquisition.";
    
    thirdPartyBlue = [[AboutUsBlueHeader alloc] init];
    [_aboutView addSubview:thirdPartyBlue];
    thirdPartyBlue.text = @"Third-Party Web Sites";
    
    thirdPartyText = [[UILabel alloc] init];
    [_aboutView addSubview:thirdPartyText];
    thirdPartyText.numberOfLines = 0;
    thirdPartyText.translatesAutoresizingMaskIntoConstraints = NO;
    [self setWidthConstraint:thirdPartyText];
    thirdPartyText.text = @"The SMART Genomics: Precision Cancer Medicine mobile app may provide links to third-party web sites, which are not under the control of Vanderbilt. Vanderbilt makes no representations about third-party web sites. When you access a third-party web site, you do so at your own risk. Vanderbilt is not responsible for the reliability of any data, opinions, advice, or statements made on third-party sites. Vanderbilt provides these links merely as a convenience. The inclusion of such links does not imply that Vanderbilt endorses, recommends, or accepts any responsibility for the content of such sites. Nor is Vanderbilt responsible for the privacy policies or practices these third-party websites.";
    
    notForBlue = [[AboutUsBlueHeader alloc] init];
    [_aboutView addSubview:notForBlue];
    notForBlue.numberOfLines = 0;
    [self setWidthConstraint:notForBlue];
    notForBlue.text = @"Not for Emergencies or Medical or Professional Advice";
    
    notForText = [[UILabel alloc] init];
    [_aboutView addSubview:notForText];
    notForText.translatesAutoresizingMaskIntoConstraints = NO;
    notForText.numberOfLines = 0;
    [self setWidthConstraint:notForText];
    notForText.text = @"The SMART Genomics: Precision Cancer Medicine mobile app does not provide any medical or healthcare products, services or advice, and is not for medical emergencies or urgent situations. IF YOU THINK YOU MAY HAVE A MEDICAL EMERGENCY, CALL YOUR DOCTOR OR 911 IMMEDIATELY. Also, information contained in this mobile app is not a substitute for a doctor's medical judgment or advice. Vanderbilt recommends that you discuss your specific, individual health concerns with your doctor or health care professional.";
    
    discBlue = [[AboutUsBlueHeader alloc] init];
    [_aboutView addSubview:discBlue];
    discBlue.numberOfLines = 0;
    [self setWidthConstraint:discBlue];
    discBlue.text = @"Disclaimers";
    
    discText = [[UILabel alloc] init];
    [_aboutView addSubview:discText];
    discText.numberOfLines = 0;
    discText.translatesAutoresizingMaskIntoConstraints = NO;
    [self setWidthConstraint:discText];
    discText.text = @"You acknowledge that your use of the SMART Genomics: Precision Cancer Medicine mobile app is at your sole risk, and that you assume full responsibility for all risk associated therewith. All information, products or services contained on or provided through this app are provided \"as is\" without any warranty of any kind, express or implied. To the fullest extent permissible under applicable law Vanderbilt and its affiliates, trustees, officers, managers, employees or other agents or representatives (collectively, \"affiliates\") hereby disclaim all representations and warranties, express or implied, statutory or otherwise, including but not limited to warranties of merchantability, fitness for a particular purpose, title, non-infringement and freedom from computer virus strains. Without limiting the foregoing, Vanderbilt and its affiliates make no warranty as to the reliability, accuracy, timeliness, usefulness, adequacy, completeness or suitability of the SMART Genomics: Precision Cancer Medicine mobile app, information received through the SMART Genomics: Precision Cancer Medicine mobile app, and other information provided hereunder. Vanderbilt assumes no responsibility for errors or omissions in the information or software or other documents which are referenced by or linked to this mobile app.";
    
    ackHeader = [[AboutUsSectionHeaderLabel alloc] init];
    [_aboutView addSubview:ackHeader];
    ackHeader.text = @"ACKNOWLEDGEMENTS";
    
    ackText = [[UILabel alloc] init];
    [_aboutView addSubview:ackText];
    ackText.translatesAutoresizingMaskIntoConstraints = NO;
    ackText.numberOfLines = 0;
    [self setWidthConstraint:ackText];
    ackText.text = @"The SMART Genomics: Precision Cancer Medicine Team would like to thank and acknowledge key organizations and contributors that have made this mobile application possible.";
    
    vandyLink = [UIButton buttonWithType:UIButtonTypeSystem];
    [_aboutView addSubview:vandyLink];
    vandyLink.translatesAutoresizingMaskIntoConstraints = NO;
    [vandyLink setTitle:@"Vanderbilt-Ingram Cancer Center" forState:UIControlStateNormal];
    [vandyLink addTarget:self action:@selector(openVandyLink:) forControlEvents:UIControlEventTouchUpInside];
    
    smartOnFhirLink = [UIButton buttonWithType:UIButtonTypeSystem];
    [_aboutView addSubview:smartOnFhirLink];
    smartOnFhirLink.translatesAutoresizingMaskIntoConstraints = NO;
    [smartOnFhirLink setTitle:@"SMART on FHIR®" forState:UIControlStateNormal];
    [smartOnFhirLink addTarget:self action:@selector(openSmartOnFhirLink:) forControlEvents:UIControlEventTouchUpInside];
    
    smartLink = [UIButton buttonWithType:UIButtonTypeSystem];
    [_aboutView addSubview:smartLink];
    smartLink.translatesAutoresizingMaskIntoConstraints = NO;
    [smartLink setTitle:@"Substitutable Medical Applications & Reusable Technology (SMART®)" forState:UIControlStateNormal];
    [smartLink addTarget:self action:@selector(openSmartLink:) forControlEvents:UIControlEventTouchUpInside];
    
    fhirLink = [UIButton buttonWithType:UIButtonTypeSystem];
    [_aboutView addSubview:fhirLink];
    fhirLink.translatesAutoresizingMaskIntoConstraints = NO;
    [fhirLink setTitle:@"FHIR™" forState:UIControlStateNormal];
    [fhirLink addTarget:self action:@selector(openFhirLink:) forControlEvents:UIControlEventTouchUpInside];
    
    ackText2 = [[UILabel alloc] init];
    [_aboutView addSubview:ackText2];
    ackText2.translatesAutoresizingMaskIntoConstraints = NO;
    ackText2.numberOfLines = 0;
    [self setWidthConstraint:ackText2];
    ackText2.text = @"This work was supported by grant ONC 90TR0001/01. The funder had no direct role in application design, software development, or decision to publish.";
    
    contrHeader = [[AboutUsSectionHeaderLabel alloc] init];
    [_aboutView addSubview:contrHeader];
    contrHeader.text = @"CONTRIBUTORS";
    
    devTeamBlue = [[AboutUsBlueHeader alloc] init];
    [_aboutView addSubview:devTeamBlue];
    devTeamBlue.text = @"Vanderbilt University Development Team";
    devTeamBlue.numberOfLines = 0;
    [self setWidthConstraint:devTeamBlue];
    
    jeremyLink = [UIButton buttonWithType:UIButtonTypeSystem];
    [_aboutView addSubview:jeremyLink];
    jeremyLink.translatesAutoresizingMaskIntoConstraints = NO;
    [jeremyLink setTitle:@"Jeremy L. Warner, M.D., M.S." forState:UIControlStateNormal];
    [jeremyLink addTarget:self action:@selector(openJeremyLink:) forControlEvents:UIControlEventTouchUpInside];
    
    devTeamText = [[UILabel alloc] init];
    [_aboutView addSubview:devTeamText];
    devTeamText.translatesAutoresizingMaskIntoConstraints = NO;
    devTeamText.numberOfLines = 0;
    [self setWidthConstraint:devTeamText];
    devTeamText.text = [NSString stringWithFormat:@"%@\n\n%@\n%@\n\n%@\n%@\n\n%@\n%@\n\n%@\n%@\n\n%@\n%@",
                        @"Assistant Professor of Medicine and Biomedical Informatics",
                        @"Joseph Burden",
                        @"Assistant Director, Research Informatics Core",
                        @"Daniel Carbone",
                        @"Software Developer",
                        @"Ross Oreto",
                        @"Software Developer",
                        @"Ariadne Kelarakis Taylor",
                        @"Project Manager",
                        @"Lucy L. Wang",
                        @"Software Developer"];
    
    
    [_aboutView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[mainHeader]-20-[legalHeader]-[legalSpacer]-[topBlurb]-[licenseLink]-[topBlurb2]-20-[termsHeader]-20-[usageBlue][usageText]-[thirdPartyBlue][thirdPartyText]-[notForBlue][notForText]-[discBlue][discText]-20-[ackHeader]-20-[ackText]-[vandyLink]-[smartOnFhirLink]-[smartLink]-[fhirLink]-[ackText2]-20-[contrHeader]-20-[devTeamBlue]-[jeremyLink][devTeamText]-|"
                                             options:NSLayoutFormatAlignAllLeft
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(mainHeader, legalHeader, legalSpacer, topBlurb, licenseLink, topBlurb2, termsHeader, usageBlue, usageText, thirdPartyBlue, thirdPartyText, notForBlue, notForText, discBlue, discText, ackHeader, ackText, vandyLink, smartOnFhirLink, smartLink, fhirLink, ackText2, contrHeader, devTeamBlue, jeremyLink, devTeamText)]];
    [_aboutView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[mainHeader]"
                                             options:NSLayoutFormatAlignAllTop
                                             metrics:nil
                                               views:@{@"mainHeader" : mainHeader}]];
    
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|"
                                                                      options:NSLayoutFormatAlignAllTop
                                                                      metrics:nil
                                                                        views:@{@"scrollView" : _scrollView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[scrollView]|"
                                                                      options:NSLayoutFormatAlignAllLeft
                                                                      metrics:nil
                                                                        views:@{@"scrollView" : _scrollView}]];
    
    [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[aboutView]|"
                                                                        options:kNilOptions
                                                                        metrics:nil
                                                                          views:@{@"aboutView" : _aboutView}]];
    [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[aboutView]|"
                                                                        options:kNilOptions
                                                                        metrics:nil
                                                                          views:@{@"aboutView" : _aboutView}]];
}

- (void) setWidthConstraint:(UILabel *)label
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeWidth
                                                          multiplier:0.95f
                                                            constant:0.0f]];
}

- (void)viewWillLayoutSubviews
{
    BOOL isInPortrait = UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    
    if (_aboutViewWidthConstraints)
        [self.view removeConstraints:_aboutViewWidthConstraints];
    
    if (isInPortrait)
    {
        _aboutViewWidthConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_aboutView(768)]|"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_aboutView)];
    }
    else
    {
        _aboutViewWidthConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_aboutView(1024)]|"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_aboutView)];
    }
    
    [self.view addConstraints:_aboutViewWidthConstraints];
    
    [super viewWillLayoutSubviews];
}

- (void) openLicenseLink:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.apache.org/licenses/LICENSE-2.0"]];
}

- (void) openVandyLink:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.vicc.org/"]];
}

- (void) openSmartOnFhirLink:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://smartplatforms.org/smart-on-fhir/"]];
}

- (void) openSmartLink:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://smartplatforms.org/"]];
}

- (void) openFhirLink:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.hl7.org/implement/standards/fhir/index.html"]];
}

- (void) openJeremyLink:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.vicc.org/dd/display.php?person=jeremy.warner"]];
}

@end
