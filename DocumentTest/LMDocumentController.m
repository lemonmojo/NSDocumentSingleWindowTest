//
//  LMDocumentController.m
//  DocumentTest
//
//  Created by Felix Deimel on 07/11/13.
//  Copyright (c) 2013 Felix Deimel. All rights reserved.
//

#import "LMDocumentController.h"

@implementation LMDocumentController

#pragma mark NSDocument Delegate

- (void)document:(NSDocument *)doc shouldClose:(BOOL)shouldClose contextInfo:(void*)contextInfo
{
    NSLog(@"document:(NSDocument *)doc shouldClose:(BOOL)shouldClose contextInfo:(void*)contextInfo");
    
    /* if (contextInfo == BSMultiWindowDocumentControllerCloseAllContext) {
        DebugLog(@"in close all. should close: %@",@(shouldClose));
        if (shouldClose) {
            // work on a copy of the window controllers array so that the doc can mutate its own array.
            NSArray* windowCtrls = [doc.windowControllers copy];
            for (NSWindowController* windowCtrl in windowCtrls) {
                if ([windowCtrl respondsToSelector:@selector(removeDocument:)]) {
                    [(id)windowCtrl removeDocument:doc];
                }
            }
            
            [doc close];
            [self removeDocument:doc];
        } else {
            _didCloseAll = NO;
        }
    } */
}


#pragma mark NSDocumentController

- (void)closeAllDocumentsWithDelegate:(id)delegate didCloseAllSelector:(SEL)didCloseAllSelector contextInfo:(void*)contextInfo
{
    NSLog(@"closeAllDocumentsWithDelegate:(id)delegate didCloseAllSelector:(SEL)didCloseAllSelector contextInfo:(void*)contextInfo");
    /* _didCloseAll = YES;
    for (NSDocument* currentDocument in self.documents) {
        [currentDocument canCloseDocumentWithDelegate:self shouldCloseSelector:@selector(document:shouldClose:contextInfo:) contextInfo:(void*)BSMultiWindowDocumentControllerCloseAllContext];
    }
    
    objc_msgSend(delegate,didCloseAllSelector,self,_didCloseAll,contextInfo); */
}

@end
