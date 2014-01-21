//
//  LMMultipleDocumentsWindowController.h
//  DocumentTest
//
//  Created by Felix Deimel on 07/11/13.
//  Copyright (c) 2013 Felix Deimel. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LMMultipleDocumentsWindowController : NSWindowController

+(id)instance;
- (IBAction)closeDocument:(id)sender;

@property (assign) IBOutlet NSTextField *textFieldDocument1;
@property (assign) IBOutlet NSTextField *textFieldDocument2;

@end
