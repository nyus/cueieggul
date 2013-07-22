//
//  APIHelper.m
//  RoadtripFun
//
//  Created by Jason Huang on 7/21/13.
//  Copyright (c) 2013 Sihang Huang. All rights reserved.
//

#import "APIHelper.h"
#import "NSString+Formatting.h"

@interface APIHelper()<NSURLConnectionDelegate>{
    NSURLConnection *urlConnection;
    NSMutableData *urlResponseData;
    NSURLResponse *urlConnectionResponse;
}
@end

@implementation APIHelper
-(void)launchGoogleMapsRadarSearchWithLocation:(CLLocationCoordinate2D)location radiusInMiles:(CGFloat)radius keyword:(NSString *)keyword name:(NSString *)name{
    
    NSString *urlString = [NSString formatRadarSearchStringWithLocation:location radiusInMiles:radius keyword:keyword name:name];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:8];
    urlConnection =[NSURLConnection connectionWithRequest:request delegate:self];
    urlResponseData = [[NSMutableData alloc] init];
    [urlConnection start];
}

-(void)cancelConnection{
    [urlConnection cancel];
}

#pragma mark - NSURLConnectionDelegate

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"APIHelper: NSURLConection did fail with error %@",error.localizedDescription);
    [self.delegate didFailWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [urlResponseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    urlConnectionResponse = response;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (((NSHTTPURLResponse *)urlConnectionResponse).statusCode != 200) {
        [self connection:connection didFailWithError:nil];
    }else{
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:urlResponseData options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            NSLog(@"Json parsing fail with error %@",error.localizedDescription);
        }else{
            [self.delegate didRecieveJsonOjbectFromURLConnection:jsonObject];
        }
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse{
    return cachedResponse;
}


@end
