/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2014 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiProxy.h"
#import "TiUtils.h"
#import "TiColor.h"
#import "TiApp.h"
#import <MessageUI/MessageUI.h>


@interface ComLimechalkTimessageMessageDialogProxy : TiProxy<MFMessageComposeViewControllerDelegate> {

}

// check if this module will be supported
- (id)isSupported:(id)args;

// check if attachment is supported
- (id)isAttachmentSupported:(id)args;

// open the dialog
- (void)openDialog:(id)args;


@end
