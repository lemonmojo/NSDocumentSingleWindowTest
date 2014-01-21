//
//  LMDocument.h
//  DocumentTest
//
//  Created by Felix Deimel on 07/11/13.
//  Copyright (c) 2013 Felix Deimel. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LMDocument : NSDocument {
    
}

@property (nonatomic, retain) NSString* dataInMemory;

- (BOOL)hasChanges;

@end
