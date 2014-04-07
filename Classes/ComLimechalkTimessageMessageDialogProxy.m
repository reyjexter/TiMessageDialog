/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2014 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "ComLimechalkTimessageMessageDialogProxy.h"

@implementation ComLimechalkTimessageMessageDialogProxy

- (id)isSupported:(id)args
{
    if([MFMessageComposeViewController canSendText])
    {
        return NUMBOOL(YES);
    }
    return NUMBOOL(NO);
}


- (id)isAttachmentSupported:(id)args
{
    if([self isSupported:YES] && [MFMessageComposeViewController canSendAttachments])
    {
        return NUMBOOL(YES);
    }
    return NUMBOOL(NO);
}


- (void)openDialog:(id)args
{
    [self rememberSelf];
	ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
    
    NSLog(@"[TiMessageDialog Module] Trying to open dialog");
    
    if(![self isSupported:nil])
    {
        NSLog(@"[TiMessageDialog Module] SMS/MMS not supported");
        
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
                               NUMBOOL(NO), @"success",
							   @"SMS/MMS not supported", @"error",
							   nil];
        
        [self fireEvent:@"error" withObject:event];
        
		return;
    }
    
    // make sure this is running on UI thread
    ENSURE_UI_THREAD(openDialog, args);
    
    NSLog(@"[TiMessageDialog Module] This is supported. Will try to open message dialog now");
    
    // recipients
    NSArray *recipients = [self valueForUndefinedKey:@"recipients"];
    ENSURE_CLASS_OR_NIL(recipients, [NSArray class]);
    
    // message
    NSString *message = [TiUtils stringValue:[self valueForUndefinedKey:@"message"]];
    
    // animated or not
    BOOL animated = [TiUtils boolValue:@"animated" properties:args def:YES];
    
    // attachments
    NSString *attachmentPath = [TiUtils stringValue:[self valueForUndefinedKey:@"attachmentPath"]];
    NSString *attachmentName = [TiUtils stringValue:[self valueForUndefinedKey:@"attachmentName"]];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    
    [messageController setRecipients:recipients];
    [messageController setBody:message];
    [messageController addAttachmentURL: [TiUtils toURL:attachmentPath proxy: self] withAlternateFilename:attachmentName];
    
    NSLog(@"[TiMessageDialog Module] Showing messageController now");
    
    [self retain];
    
    // Present message view controller on screen
    [[TiApp app] showModalController:messageController animated:animated];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)messageController didFinishWithResult:(MessageComposeResult) result
{
    [[TiApp app] hideModalController:messageController animated:YES];
	[messageController autorelease];
	messageController = nil;
    
    switch (result) {
        case MessageComposeResultCancelled:
        {
            NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
                                   NUMBOOL(NO), @"success",
                                   @"Message dialog cancelled", @"message",
                                   nil];
            
            [self fireEvent:@"cancelled" withObject:event];
            break;
        }
            
        case MessageComposeResultFailed:
        {
            NSLog(@"[TiMessageDialog Module] Showing messageController now");
            
            NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
                                   NUMBOOL(NO), @"success",
                                   @"Failed sending SMS/MMS", @"message",
                                   nil];
            
            [self fireEvent:@"error" withObject:event];
            break;
        }
            
        case MessageComposeResultSent:
        {
            NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:
                                   NUMBOOL(YES), @"success",
                                   @"SMS/MMS sent successfully!", @"message",
                                   nil];
            
            [self fireEvent:@"complete" withObject:event];
            
            break;
        }
            
        default:
            break;
    }
    
    [messageController dismissViewControllerAnimated:YES completion:nil];
    
    [self forgetSelf];
    
	[self autorelease];
}

@end