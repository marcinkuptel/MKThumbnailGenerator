//
//  IPGenerateThumbnailOperation.h
//  iPresenter
//
//  Created by Marcin Kuptel on 12/04/13.
//  Copyright (c) 2013 InSilico. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MKGenerateThumbnailOperationErrorCode)
{
	MKGenerateThumbnailOperationErrorCodeFileMissing,
	MKGenerateThumbnailOperationErrorCodeFileReadFailed,
	MKGenerateThumbnailOperationErrorCodeCancelled
};

typedef void(^MKGenerateThumbnailOperationCompletionBlock)(UIImage *thumbnail, NSError *error);

@interface MKGenerateThumbnailOperation : NSOperation

- (id) initWithFilePath: (NSString*) path completion: (MKGenerateThumbnailOperationCompletionBlock) completion;

@end
