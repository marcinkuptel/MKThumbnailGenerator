//
//  IPThumbnailGenerator.h
//  iPresenter
//
//  Created by Marcin Kuptel on 12/04/13.
//  Copyright (c) 2013 InSilico. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IPMedium;

typedef void(^MKThumbnailGeneratorCompletion)(UIImage *thumbnail, NSError *error);

@interface MKThumbnailGenerator : NSObject

+ (MKThumbnailGenerator*) sharedGenerator;

- (void) generateThumbnailForFile: (NSString*) path completion: (MKThumbnailGeneratorCompletion) completion;
- (void) cancelAllOperations;

@end
