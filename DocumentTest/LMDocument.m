//
//  LMDocument.m
//  DocumentTest
//
//  Created by Felix Deimel on 07/11/13.
//  Copyright (c) 2013 Felix Deimel. All rights reserved.
//

#import "LMDocument.h"
#import "LMMultipleDocumentsWindowController.h"

@implementation LMDocument {
    NSString* m_dataInMemory;
    NSString* m_dataFromLoad;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.dataInMemory = @"";
        m_dataFromLoad = [self.dataInMemory copy];
    }
    return self;
}

- (void)dealloc
{
    if (m_dataInMemory) {
        [m_dataInMemory release];
        m_dataInMemory = nil;
    }
    
    if (m_dataFromLoad) {
        [m_dataFromLoad release];
        m_dataFromLoad = nil;
    }
    
    [super dealloc];
}

-(void)setDataInMemory:(NSString *)aDataInMemory
{
    m_dataInMemory = [aDataInMemory retain];
}

-(NSString*)dataInMemory
{
    return m_dataInMemory;
}

-(void)makeWindowControllers
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LMDocumentNeedWindowNotification object:self];
    
    /* LMMultipleDocumentsWindowController *wc = [[LMMultipleDocumentsWindowController alloc] initWithWindowNibName:@"LMMultipleDocumentsWindow"];

    //[wc addDocument:self];

    [self addWindowController:wc];

    [wc showWindow:self]; */
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

+ (BOOL)preservesVersions
{
    return YES;
}

/* - (NSString*)displayName
{
    return @"Royal TSX - Filename";
} */

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    
    if (m_dataFromLoad) {
        [m_dataFromLoad release];
        m_dataFromLoad = nil;
    }
    
    m_dataFromLoad = [m_dataInMemory copy];
    
    return [[self dataInMemory] dataUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    
    [self setDataInMemory:[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]];
    m_dataFromLoad = [m_dataInMemory copy];
    
    return YES;
}

- (BOOL)hasChanges
{
    return ![m_dataInMemory isEqualToString:m_dataFromLoad];
}

- (void)close
{
    [super close];
}

@end
