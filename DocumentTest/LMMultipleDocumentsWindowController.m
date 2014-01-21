//
//  LMMultipleDocumentsWindowController.m
//  DocumentTest
//
//  Created by Felix Deimel on 07/11/13.
//  Copyright (c) 2013 Felix Deimel. All rights reserved.
//

#import "LMMultipleDocumentsWindowController.h"
#import "LMDocument.h"

static id aInstance;

@interface LMMultipleDocumentsWindowController ()
@end

@implementation LMMultipleDocumentsWindowController {
    LMDocument *m_doc1;
    LMDocument *m_doc2;
    BOOL m_closeCalledInternally;
}

-(void)awakeFromNib
{
    aInstance = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(documentNeedsWindow:) name:LMDocumentNeedWindowNotification object:nil];
    [self setActiveDocument];
    
    m_closeCalledInternally = NO;
}

+(id)instance
{
    return aInstance;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void)dealloc
{
    if (m_doc1) {
        [m_doc1 release];
        m_doc1 = nil;
    }
    
    if (m_doc2) {
        [m_doc2 release];
        m_doc2 = nil;
    }
    
    [super dealloc];
}

- (IBAction)closeDocument:(id)sender
{
    [self removeDocument:[self document]];
}

-(void)documentNeedsWindow:(NSNotification*)aNotification
{
    LMDocument* doc = [aNotification object];
    
    [self addDocument:doc];
}

/* -(void)setDocument:(NSDocument*)document
{
    // nothing to do here
} */

-(NSDocument*)document
{
    // TODO: Return current active document
    NSDocument *doc = nil;
    
    NSTextField *tv = [self activeTextField];
    
    if (tv == self.textFieldDocument1) {
        doc = m_doc1;
    } else if (tv == self.textFieldDocument2) {
        doc = m_doc2;
    }
    
    return doc;
}

-(NSTextField*)activeTextField
{
    NSResponder *firstResponder = [[NSApp keyWindow] firstResponder];
    
    if ([firstResponder isKindOfClass:[NSText class]]) {
        if ([(NSText *)firstResponder delegate] == self.textFieldDocument1) {
            return self.textFieldDocument1;
        } else if ([(NSText *)firstResponder delegate] == self.textFieldDocument2) {
            return self.textFieldDocument2;
        }
    }
    
    return nil;
}

-(void)setActiveDocument
{
    [self performSelector:@selector(setActiveDocumentReal) withObject:nil afterDelay:0];
}

-(void)setActiveDocumentReal
{
    LMDocument* doc = [self document];
    
    if (doc) {
        [self setDocument:doc];
    } else {
        [self setDocument:nil];
        [self.window setTitle:@"NO DOCUMENT"];
    }
}

-(void)addDocument:(LMDocument*)docToAdd
{
    NSTextField *tv = [self activeTextField];
    
    LMDocument *closeDoc = nil;
    
    if (!tv) {
        closeDoc = m_doc1;
        tv = self.textFieldDocument1;
    } else {
        closeDoc = [self document];
    }
    
    if (closeDoc) {
        [self closeDocument:closeDoc];
    }
    
    // !!!  It's very important to do this before adding the document to the NSArray because Cocoa calls document on NSWindowController to see if there has been a document assigned to this window controller already. if so, it doesn't add the window controller to the NSDocument  !!!
    [docToAdd addWindowController:self];
    
    if (tv == self.textFieldDocument1) {
        m_doc1 = [docToAdd retain];
    } else if (tv == self.textFieldDocument2) {
        m_doc2 = [docToAdd retain];
    }
    
    [tv setStringValue:docToAdd.dataInMemory];
    [self setActiveDocument];

    //[lmDoc setWindow:self.window];
    //[lmDoc setDisplayName:@"MY DOC DISPLAY NAME"];
    
    //[self setDocument:docToAdd];
}

-(void)removeDocument:(LMDocument*)docToRemove
{
    // ... remove the document's view controller and view ...
    
    // finally detach the document from the window controller
    // TODO: Remove any views related to the doc
    
    if (!docToRemove) {
        m_closeCalledInternally = YES;
        [self close];
    }
    
    NSTextField *tv = nil;
    
    if (m_doc1 == docToRemove) {
        tv = self.textFieldDocument1;
        
        if (m_doc1) {
            [m_doc1 release];
            m_doc1 = nil;
        }
    } else if (m_doc2 == docToRemove) {
        tv = self.textFieldDocument2;
        
        if (m_doc2) {
            [m_doc2 release];
            m_doc2 = nil;
        }
    }
    
    [tv setStringValue:@""];
    
    [self setActiveDocument];
    
    [docToRemove close];
}

-(void)windowWillClose:(NSNotification*) notification
{
    NSWindow * window = self.window;
    if (notification.object != window) {
        return;
    }
    
    // TODO: Clean up any views related to documents
    
    // disassociate this window controller from the document
    if (m_doc1) {
        [m_doc1 removeWindowController:self];
    }
    
    if (m_doc2) {
        [m_doc2 removeWindowController:self];
    }
    // then any content view
    [window setContentView:nil];
}

- (void)controlTextDidChange:(NSNotification *)notification
{
    NSTextField *textField = [notification object];
    
    LMDocument *doc = nil;
    
    if (textField == self.textFieldDocument1) {
        doc = m_doc1;
    } else if (textField == self.textFieldDocument2) {
        doc = m_doc2;
    }
    
    if (doc) {
        doc.dataInMemory = [textField stringValue];
        
        BOOL hasChanges = [doc hasChanges];
        
        if (hasChanges) {
            [doc updateChangeCount:NSChangeDone];
        } else {
            [doc updateChangeCount:NSChangeCleared];
        }
    }
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
    [self setActiveDocument];
}

- (void)close
{
    if (m_closeCalledInternally) {
        m_closeCalledInternally = NO;
        [super close];
    }
}

@end
