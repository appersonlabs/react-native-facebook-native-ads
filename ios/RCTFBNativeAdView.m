//
//  FBAdChoicesView.m
//  RNFacebookNativeAds
//
//  Created by Matt Apperson on 9/20/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTFBNativeAdView.h"
#import "RCTLog.h"
#import "RCTBridge.h"

@implementation RCTFBNativeAdView {
    FBNativeAd *_nativeAd;
    NSString *_placementID;
    NSDictionary *_attributes;
}


- (id)init {
    if ((self = [super initWithFrame: CGRectMake(100, 100, 320, 300)])) {
        self.clipsToBounds=YES;
    }
    return self;
}


-(void)setPlacementID: (NSString*) placementID
{
    if(!_placementID) {
        _placementID = placementID;
        
        _nativeAd = [[FBNativeAd alloc] initWithPlacementID:placementID];
        _nativeAd.delegate = self;
        [_nativeAd loadAd];
    } else if(![_placementID isEqualToString:placementID]) {
        NSLog(@"You cant re-set a placementID");
    }
}

-(void)setNativeAdViewStyle: (NSDictionary*) attributes
{
    
    if(!_attributes) {
        NSLog(@"%@", attributes);
        _attributes = @{
              @"backgroundColor": [RCTConvert  UIColor: attributes[@"backgroundColor"]],
              @"titleColor": [RCTConvert  UIColor: attributes[@"titleColor"]],
              @"titleFont": [UIFont fontWithName:@"Helvetica" size:17.0], //[RCTConvert UIFont:attributes[@"titleFont"]],
              @"descriptionColor": [RCTConvert  UIColor: attributes[@"descriptionColor"]],
              @"descriptionFont": [UIFont fontWithName:@"Helvetica" size:17.0],//[RCTConvert UIFont: attributes[@"descriptionFont"]],
              @"buttonColor": [RCTConvert  UIColor: attributes[@"buttonColor"]],
              @"buttonTitleColor": [RCTConvert  UIColor: attributes[@"buttonTitleColor"]],
              @"buttonTitleFont": [UIFont fontWithName:@"Helvetica" size:17.0], //[RCTConvert UIFont: attributes[@"buttonTitleFont"]],
              @"buttonBorderColor": [RCTConvert  UIColor: attributes[@"buttonBorderColor"]],
              @"autoplayEnabled": attributes[@"autoplayEnabled"],
        };
    } else if(![_attributes isEqualToDictionary: attributes]){
        NSLog(@"You cant re-set a placementID");
    }

}


- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd
{
    FBNativeAdViewAttributes *attributes = [[FBNativeAdViewAttributes alloc] initWithDictionary: _attributes];
    NSLog(@"Setting FBNativeAdViewAttributes: ", _attributes);
    
    FBNativeAdView *adView = [FBNativeAdView nativeAdViewWithNativeAd:nativeAd
                                                             withType:FBNativeAdViewTypeGenericHeight300 withAttributes:attributes];
    
    [self addSubview:adView];

    RCTLogInfo(@"Facebook Native Ad loaded! => %@", _attributes);
    
    CGSize size = self.bounds.size;
    adView.frame = CGRectMake(0, 0, size.width, size.height);
    
    // Register the native ad view and its view controller with the native ad instance
    [nativeAd registerViewForInteraction:adView withViewController:[NSNull null]];
}

- (void)nativeAdWillLogImpression:(FBNativeAd *)nativeAd
{
    RCTLogInfo(@"Native ad was impressive :)");
    
}

- (void)nativeAdDidClick:(FBNativeAd *)nativeAd
{
    RCTLogInfo(@"Native ad was clicked");
}

- (void)nativeAdDidFinishHandlingClick:(FBNativeAd *)nativeAd
{
    RCTLogInfo(@"Finished with ad");
}

-(void)nativeAd:	(FBNativeAd *)nativeAd didFailWithError:	(NSError *)error
{
    RCTLogError(@"%@", error);
}

- (void)insertReactSubview:(UIView *)view atIndex:(NSInteger)atIndex
{
    RCTLogError(@"Facebook Native Ads cannot have sub-views");
    return;
}

- (void)removeReactSubview:(UIView *)subview
{
    RCTLogError(@"Facebook Native Ads cannot have sub-views");
    return;
}

@end