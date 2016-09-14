//
//  RewardsPoint.h
//  PAE_iOS_SDK
//
//  Created by Rajeev Ranjan on 10/12/15.
//  Copyright © 2015 ShephertzTechnology PVT LTD. All rights reserved.
//

#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>

@interface RewardsPoint : App42Response

/*!
 *set and get the name for the Campaign.
 */
@property(nonatomic,retain) NSString *campaignName;

/*!
 *set and get the reward point.
 */
@property(nonatomic) float points;

/*!
 *set and get the reward unit.
 */
@property(nonatomic,retain) NSString *rewardUnit;

/*!
 *set and get the user name.
 */
@property(nonatomic,retain) NSString *userName;

@end
