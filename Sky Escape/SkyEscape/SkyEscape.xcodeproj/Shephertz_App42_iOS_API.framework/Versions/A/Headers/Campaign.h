//
//  Campaign.h
//  PAE_iOS_SDK
//
//  Created by Rajeev Ranjan on 07/05/16.
//  Copyright © 2016 ShephertzTechnology PVT LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kApp42Push,
    kApp42InApp,
} CampaignType;


@interface Campaign : NSObject

-(instancetype)initWithCampaignData:(NSDictionary*)campaignData;

/*!
 *set and get the name for the Campaign name.
 */
@property(nonatomic,retain) NSString *name;

/*!
 *set and get the campaign end date.
 */
@property(nonatomic,retain) NSDate *endDate;

/*!
 *set and get the messages.
 */
@property(nonatomic,retain) NSString *message;

/*!
 *set and get the messageData.
 */
@property(nonatomic,retain) NSDictionary *messageData;

/*!
 *set and get the inAppData.
 */
@property(nonatomic,retain) NSDictionary *inAppData;

/*!
 *set and get the campaign type.
 */
@property(nonatomic) CampaignType type;

@end
