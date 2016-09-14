//
//  App42API_Protected.h
//  PAE_iOS_SDK
//
//  Created by Rajeev Ranjan on 15/01/15.
//  Copyright (c) 2015 ShephertzTechnology PVT LTD. All rights reserved.
//

#import <Shephertz_App42_iOS_API/Shephertz_App42_iOS_API.h>

@interface App42API ()

+(void)setApp42EventDelegate:(id)l_delegate;
+(id)getApp42EventDelegate;
+(void)enableApp42Campaign:(BOOL)isEnable;
+(BOOL)isApp42CampaignEnabled;
+(NSString*)apiKey;

@end
