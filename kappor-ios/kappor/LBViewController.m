//
//  LBViewController.m
//  kappor
//
//  Created by saifuddin on 7/12/13.
//  Copyright (c) 2013 saifuddin. All rights reserved.
//

#import "LBViewController.h"
#import "SRWebSocket.h"

@interface TCMessage : NSObject
- (id)initWithMessage:(NSString *)message fromMe:(BOOL)fromMe;
@property (nonatomic, retain, readonly) NSString *message;
@property (nonatomic, readonly)  BOOL fromMe;
@end

@implementation TCMessage
@synthesize message = _message;
@synthesize fromMe = _fromMe;
- (id)initWithMessage:(NSString *)message fromMe:(BOOL)fromMe;
{
    self = [super init];
    if (self) {
        _fromMe = fromMe;
        _message = message;
    }
    return self;
}
@end

@interface LBViewController () <SRWebSocketDelegate>
{
    SRWebSocket *_webSocket;
    NSMutableArray *_messages;
}
@end

@implementation LBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.drawingPad.delegate = self;
    
    UIView *redBG = [[UIView alloc] initWithFrame:self.view.frame];
    redBG.tag = 22;
    redBG.backgroundColor = [UIColor clearColor];
    [self.view addSubview:redBG];
    [UIView animateWithDuration:1
                     animations:^{
                         redBG.backgroundColor = [UIColor redColor];
                     }
                     completion:nil];
    
    [[[UIAlertView alloc] initWithTitle:@"Whoa!" message:@"U should wait until saifuddin tell u to press ok, and then you can press ok." delegate:nil cancelButtonTitle:@"I will press this only when saifuddin tells me to do so" otherButtonTitles:nil] show];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reconnect];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
    _webSocket.delegate = nil;
    [_webSocket close];
    _webSocket = nil;
}

- (void)reconnect;
{
    _webSocket.delegate = nil;
    [_webSocket close];
    
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://54.251.108.159:8000/chat"]]];
    _webSocket.delegate = self;
    
    self.title = @"Opening Connection...";
    [_webSocket open];
    
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected!");
    UIView *v = [self.view viewWithTag:22];
    [UIView animateWithDuration:1
                     animations:^{
                         v.backgroundColor = [UIColor clearColor];
                     }
                     completion:^(BOOL f){
                         [v removeFromSuperview];
                     }];
    self.title = @"Connected!";
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    self.title = @"Connection Failed! (see logs)";
    _webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"Received \"%@\"", message);
//    [_messages addObject:[[TCMessage alloc] initWithMessage:message fromMe:NO]];
    NSArray *msgComp = [(NSString *)message componentsSeparatedByString:@","];
    CGPoint point = CGPointMake([msgComp[0] floatValue], [msgComp[1] floatValue]);
    int addLine = [msgComp[2] intValue];
    
    if (addLine == 0)
    {
        [self.drawingPad addLineToPoint:point];
    }
    else // addLine == 1
    {
        [self.drawingPad moveToPoint:point];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    self.title = @"Connection Closed! (see logs)";
    _webSocket = nil;
}

- (void)addLineToPoint:(CGPoint)point
{
    NSString *fullMessage = [NSString stringWithFormat:@"%f,%f,0",point.x,point.y];
    [_webSocket send:fullMessage];
}

- (void)moveToPoint:(CGPoint)point
{
    point = CGPointMake(point.x + 10, point.y + 10);
    NSString *fullMessage = [NSString stringWithFormat:@"%f,%f,1",point.x,point.y];
    [_webSocket send:fullMessage];
}

- (IBAction)clear:(id)sender
{
    [self.drawingPad removeAllPoints];
}
@end
