//
//  App42IAMService.h
//  PAE_iOS_SDK
//
//  Created by Rajeev Ranjan on 13/01/15.
//  Copyright (c) 2015 ShephertzTechnology PVT LTD. All rights reserved.
//

#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>

@interface App42IAMService : App42Service

- (id) init __attribute__((unavailable));
/**
 * This is a constructor that takes
 *
 * @param apiKey
 * @param secretKey
 * @param baseURL
 *
 */

-(id)initWithAPIKey:(NSString *)apiKey  secretKey:(NSString *)secretKey;

/**
 * Gets the IAM config data
 */
-(void)getConfig:(App42ResponseBlock)completionBlock;

/**
 * Checks for the eligibility of campaigns based install props
 */

-(void)isAvailable:(NSArray*)campaigns completionBlock:(App42ResponseBlock)completionBlock;


-(void)getViralityConfig:(App42ResponseBlock)completionBlock;

-(void)getMyReferral:(App42ResponseBlock)completionBlock;

-(void)earnRewardForUser:(NSString*)userName rewardPoint:(float)rewardPoints inUnit:(NSString*)unit fromCampaign:(NSString*)campName completionBlock:(App42ResponseBlock)completionBlock;

-(void)redeemRewardForUser:(NSString*)userName rewardPoint:(float)rewardPoints inUnit:(NSString*)unit fromCampaign:(NSString*)campName completionBlock:(App42ResponseBlock)completionBlock;

-(void)getRewardOfUser:(NSString*)userName fromCampaign:(NSString*)campName completionBlock:(App42ResponseBlock)completionBlock;

-(void)getCampaignsForUser:(NSString*)userName completionBlock:(App42ResponseBlock)completionBlock;

@end
