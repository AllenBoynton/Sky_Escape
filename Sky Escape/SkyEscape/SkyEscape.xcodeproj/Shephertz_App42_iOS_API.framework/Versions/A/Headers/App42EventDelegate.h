//
//  App42EventDelegate.h
//  App42IAMSample
//
//  Created by Rajeev Ranjan on 05/01/15.
//  Copyright (c) 2015 Rajeev Ranjan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol App42EventDelegate <NSObject>

-(void)eventDidCompleteWithName:(NSString*)eventName;
-(void)onEventEnabled;
@end
