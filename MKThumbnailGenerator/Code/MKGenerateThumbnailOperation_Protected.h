//
//  IPGenerateThumbnailOperation_Protected.h
//  iPresenter
//
//  Created by Marcin Kuptel on 12/04/13.
//  Copyright (c) 2013 InSilico. All rights reserved.
//

#import "MKGenerateThumbnailOperation.h"

@interface MKGenerateThumbnailOperation ()

- (UIImage*) generateThumbnailForFileAtPath: (NSString*) path size: (CGSize) thumbnailSize;
- (CGSize) size: (CGSize) originalSize constrainedToSize: (CGSize) constraint;

@end
