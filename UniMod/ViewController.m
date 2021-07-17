//
//  ViewController.m
//  UniMod
//
//  Created by yangying on 2021/7/14.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "UniMod-Bridging-Header.h"
@import MoPubSDK;
@import MoPub_UnityAds_Adapters;

static const NSString *kIntersitialAdID = @"42952260fbfb4d1bb8c92da82f9747d7";
static const NSString *kRewardedAdID = @"069afeae9ecd40828898bfa763726327";
static const NSString *kGameID = @"4221286";

@interface ViewController ()<MPRewardedAdsDelegate, MPInterstitialAdControllerDelegate>

@property (nonatomic, strong) MPInterstitialAdController *interstitial;

@property (nonatomic, assign) NSInteger rewardCount;
@property (nonatomic, strong) UILabel *rewardCountLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [MPRewardedAds setDelegate:self forAdUnitId:kRewardedAdID];
    
    self.interstitial = [MPInterstitialAdController
             interstitialAdControllerForAdUnitId:kIntersitialAdID];
    self.interstitial.delegate = self;
    
    UIButton *initBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [initBtn setTitle:@"init MoPub" forState:UIControlStateNormal];
    [self.view addSubview:initBtn];
    [initBtn addTarget:self action:@selector(initMopub) forControlEvents:UIControlEventTouchUpInside];
    
    [initBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@200);
        make.width.equalTo(@150);
        make.height.equalTo(@50);
    }];
    
    UIButton *loadInterstitialBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [loadInterstitialBtn setTitle:@"load interstitial ad" forState:UIControlStateNormal];
    [loadInterstitialBtn addTarget:self action:@selector(loadInterstitial) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadInterstitialBtn];
    
    [loadInterstitialBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@300);
        make.width.equalTo(@150);
        make.height.equalTo(@50);
    }];
    
    UIButton *loadRewardBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [loadRewardBtn setTitle:@"load rewarded video ad" forState:UIControlStateNormal];
    [self.view addSubview:loadRewardBtn];
    [loadRewardBtn addTarget:self action:@selector(loadReward) forControlEvents:UIControlEventTouchUpInside];
    
    [loadRewardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@400);
        make.width.equalTo(@150);
        make.height.equalTo(@50);
    }];
    
    UIButton *showInterstitialBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [showInterstitialBtn setTitle:@"show interstitial ad" forState:UIControlStateNormal];
    [self.view addSubview:showInterstitialBtn];
    [showInterstitialBtn addTarget:self action:@selector(showInterstitial) forControlEvents:UIControlEventTouchUpInside];
    
    [showInterstitialBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@500);
        make.width.equalTo(@150);
        make.height.equalTo(@50);
    }];
    
    UIButton *showRewardBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [showRewardBtn setTitle:@"show rewarded video ad" forState:UIControlStateNormal];
    [self.view addSubview:showRewardBtn];
    [showRewardBtn addTarget:self action:@selector(showReward) forControlEvents:UIControlEventTouchUpInside];
    [showRewardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@600);
        make.width.equalTo(@150);
        make.height.equalTo(@50);
    }];
    
    self.rewardCountLabel = [[UILabel alloc] init];
    self.rewardCountLabel.textColor = UIColor.blackColor;
    [self.view addSubview:self.rewardCountLabel];
    self.rewardCountLabel.text = @"0 times";
    [self.rewardCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(showRewardBtn.mas_bottom).offset(3);
    }];
}

- (void)initMopub
{
    [[UnityAdsAdapterConfiguration alloc] initializeNetworkWithConfiguration:@{@"gameId" : kGameID} complete:^(NSError * _Nullable) {
        NSLog(@"unity adapter initialization complete");
    }];
    
    MPMoPubConfiguration *sdkConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization:kIntersitialAdID];

    sdkConfig.globalMediationSettings = @[];
    sdkConfig.loggingLevel = MPBLogLevelInfo;
    sdkConfig.allowLegitimateInterest = YES;
    sdkConfig.additionalNetworks = @[UnityAdsAdapterConfiguration.class];
    sdkConfig.mediatedNetworkConfigurations = @{NSStringFromClass(UnityAdsAdapterConfiguration.class) : @{@"gameId" : kGameID}}.mutableCopy;

    [[MoPub sharedInstance] initializeSdkWithConfiguration:sdkConfig completion:^{
            NSLog(@"SDK initialization complete");
    }];
}

- (void)loadInterstitial
{
    [self.interstitial loadAd];
}

- (void)showInterstitial
{
    if (self.interstitial.ready) [self.interstitial showFromViewController:self];
}

- (void)loadReward
{
    [MPRewardedAds loadRewardedAdWithAdUnitID:kRewardedAdID withMediationSettings:nil];
}

- (void)showReward
{
    NSArray<MPReward *> *reward = [MPRewardedAds availableRewardsForAdUnitID:kRewardedAdID];
    [MPRewardedAds presentRewardedAdForAdUnitID:kRewardedAdID fromViewController:self withReward:reward.firstObject];
}

#pragma mark - MPInterstitialAdControllerDelegate

- (void)interstitialDidPresent:(MPInterstitialAdController *)interstitial
{
    
}

#pragma mark - MPRewardedAdsDelegate

- (void)rewardedAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPReward *)reward
{
    self.rewardCount++;
    self.rewardCountLabel.text = [NSString stringWithFormat:@"%@ times", @(self.rewardCount)];
}

@end
