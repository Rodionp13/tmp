//
//  Connectivity.m
//  downloaderGifs
//
//  Created by User on 8/30/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "Connectivity.h"

@implementation Connectivity

+ (BOOL)isNetworkAvailable {
    CFNetDiagnosticRef diagnosticRef;
    diagnosticRef = CFNetDiagnosticCreateWithURL(NULL, (__bridge CFURLRef)[NSURL URLWithString:@"https://www.google.com/"]);
    CFNetDiagnosticStatusValues status;
    status = CFNetDiagnosticCopyNetworkStatusPassively(diagnosticRef, NULL);
    CFRelease(diagnosticRef);
    if(status == kCFNetDiagnosticConnectionUp) {return YES;} else {return NO;}
}

+ (void)networkConditionIsConnected:(NetworkCondition)isConnected isDisconnected:(NetworkCondition)isDisconnected {
    if([Connectivity isNetworkAvailable]) {
        isConnected();
    } else {
        isDisconnected();
    }
}



@end
