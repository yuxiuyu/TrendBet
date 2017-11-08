//
//  TBWebService.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/8/6.
//  Copyright © 2017年 yxy. All rights reserved.

#import "TBWebService.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#ifdef DEBUG
#define WBSLog(...) NSLog(__VA_ARGS__)
#else
#define WBSLog(...)
#endif

#define RequestTimeoutInterval 30

@implementation TBWebService

+ (instancetype)sharedInstance {
  static TBWebService *_sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedInstance = [[TBWebService alloc] init];
    //Todo: your init code
  });
  
  return _sharedInstance;
}

- (void)bascRequest:(NSString*)api postData:(id)postData isanimated:(BOOL)isanimated success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString* fullUrl = [NSString stringWithFormat:@"%@%@", SERVER_URL, api];
      

  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  [manager.requestSerializer setTimeoutInterval:RequestTimeoutInterval];
  manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    if (isanimated)
    {
          [SVProgressHUD showWithStatus:@"文件下载中"];
    }

  [manager POST:fullUrl parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    
//      if (responseString.length==6)
//      {
//          success(@{@"msg":@"success"});
//      }
//      else if ([responseString containsString:@"illegal"])
//      {
//          success(@{@"msg":@"illegal"});
//      }
//      else
//      {
//          failure(@"noUser");
//      }
//         success(@{@"msg":responseString});
//
//      NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
      
      NSDictionary* responseDict = [responseString objectFromJSONString];
      if (isanimated) {
          [self hidenProgress];
      }
      
      success(responseDict);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      if (isanimated) {
          [self hidenProgress];
      }
      
    WBSLog(@"Error: %@", error);
    WBSLog(@"Error: %@", [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding]);
    if (failure) {
      failure(error.localizedDescription);
    }
  }];
}

- (void)bascRequestGet:(NSString*)api postData:(id)postData success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
  NSString* postString = [NSString stringWithFormat:@"reqJson=%@",[postData objectFromJSONString]];
  [self bascRequestGet:api postString:postString success:success failure:failure];
}

- (void)bascRequestGet:(NSString*)api postString:(NSString*)postString success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSString* error))failure{
    NSString* fullUrl = [NSString stringWithFormat:@"%@%@", fullUrl, api];

  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
  [manager.requestSerializer setTimeoutInterval:RequestTimeoutInterval];
  manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    if (![fullUrl containsString:@"getInitData"]) {
         [self showProgress:YES];
    }
  
  [manager GET:fullUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       if (![fullUrl containsString:@"getInitData"]) {
        [self hidenProgress];
       }
    NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    
    NSDictionary* responseDict = [responseString objectFromJSONString];
    WBSLog(@"Log: %@", responseString);
    if([responseDict[@"result"] integerValue]!=0){
      WBSLog(@"Log: api = %@\r requestString = %@", api, [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding]);
      if (failure)
      {
        failure(responseDict[@"message"]);
      }
    }else if (success)
    {
      success(responseDict);
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       if (![fullUrl containsString:@"getInitData"]) {
        [self hidenProgress];
       }
    WBSLog(@"Error: %@", error);
    WBSLog(@"Error: %@", [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding]);
    if (failure)
    {
      failure(error.localizedDescription);
    }
  }];
}

- (void) showProgress:(BOOL) show
{
    if (show) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    }
}

- (void) hidenProgress
{
    [SVProgressHUD dismiss];
}

@end
