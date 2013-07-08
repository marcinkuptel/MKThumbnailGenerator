//
//  IPGenerateThumbnailOperation.m
//  iPresenter
//
//  Created by Marcin Kuptel on 12/04/13.
//  Copyright (c) 2013 InSilico. All rights reserved.
//

#import "MKGenerateThumbnailOperation.h"

#define THUMBNAIL_HEIGHT			300.0
#define THUMBNAIL_WIDTH				300.0

NSString * const MKGenerateThumbnailOperationErrorDomain = @"dk.marcinkuptel.MKGenerateThumbanailOperation";


@interface MKGenerateThumbnailOperation ()

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, copy) MKGenerateThumbnailOperationCompletionBlock completion;

@end


@implementation MKGenerateThumbnailOperation{
	BOOL _executing;
	BOOL _finished;
}


- (id) initWithFilePath:(NSString *)path completion:(MKGenerateThumbnailOperationCompletionBlock)completion
{
	self = [super init];
	if (self) {
		self.filePath = path;
		self.completion = completion;
	}
	return self;
}

#pragma mark - Error handling


+ (NSError*) localizedErrorWithErrorCode: (MKGenerateThumbnailOperationErrorCode) code
{
	NSString *string = nil;

	switch (code) {
		case MKGenerateThumbnailOperationErrorCodeFileMissing:		string = NSLocalizedString(@"File missing", @""); break;
		case MKGenerateThumbnailOperationErrorCodeCancelled:		string = NSLocalizedString(@"Operation cancelled", @""); break;
		default:													string = NSLocalizedString(@"Unknown error", @""); break;
	}

	NSDictionary *userInfo = @{NSLocalizedDescriptionKey:string};

	return [NSError errorWithDomain: MKGenerateThumbnailOperationErrorDomain
							   code: code
						   userInfo: userInfo];
}


#pragma mark -


- (void) main
{
	if ([self isCancelled]) {
		[self callCompletionBlockWithErrorCode: MKGenerateThumbnailOperationErrorCodeCancelled];
		[self finishOperation];
		return;
	}

	NSFileManager *manager = [NSFileManager defaultManager];
	BOOL fileExists = [manager fileExistsAtPath: self.filePath];

	if (!fileExists) {
		[self callCompletionBlockWithErrorCode: MKGenerateThumbnailOperationErrorCodeFileMissing];
		[self finishOperation];
		return;
	}

	UIImage * thumb = [self generateThumbnailForFileAtPath: self.filePath size: CGSizeMake(THUMBNAIL_WIDTH, THUMBNAIL_HEIGHT)];

	NSAssert(thumb, @"Thumbnail not created");

	if ([self isCancelled]) {
		[self callCompletionBlockWithErrorCode: MKGenerateThumbnailOperationErrorCodeCancelled];
		[self finishOperation];
		return;
	}

	if (self.completion) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.completion(thumb, nil);
		});
	}

	[self finishOperation];
}


- (void) start
{
	NSAssert(self.filePath, @"File path is not set");
	NSAssert(self.completion, @"Completion block is not set");

	if ([self isCancelled]) {
		[self callCompletionBlockWithErrorCode: MKGenerateThumbnailOperationErrorCodeCancelled];
		[self finishOperation];
		return;
	}

	[self willChangeValueForKey:@"isExecuting"];
	[self main];
	_executing = YES;
	[self didChangeValueForKey:@"isExecuting"];
}


- (BOOL) isConcurrent
{
	return YES;
}


- (BOOL)isExecuting
{
    return _executing;
}


- (BOOL)isFinished
{
    return _finished;
}


- (void) finishOperation
{
	[self willChangeValueForKey:@"isFinished"];
	[self willChangeValueForKey:@"isExecuting"];

	_executing = NO;
	_finished = YES;

	[self didChangeValueForKey:@"isExecuting"];
	[self didChangeValueForKey:@"isFinished"];
}


- (void) callCompletionBlockWithErrorCode: (MKGenerateThumbnailOperationErrorCode) code
{
	if (self.completion) {
		dispatch_async(dispatch_get_main_queue(), ^{
			self.completion(nil, [MKGenerateThumbnailOperation localizedErrorWithErrorCode: code]);
		});
	}
}


#pragma mark - To be overriden

- (UIImage*) generateThumbnailForFileAtPath: (NSString*) path size: (CGSize) thumbnailSize
{
	[NSException raise: @"Subclassing error" format: @"%@ should be overriden", NSStringFromSelector(_cmd)];
	return nil;
}


#pragma mark - Utility methods

- (CGSize) size: (CGSize) originalSize constrainedToSize: (CGSize) constraint
{
	CGFloat ratioOriginal = originalSize.width/originalSize.height;
	CGFloat ratioConstraint = constraint.width/constraint.height;

	CGSize resultingSize = CGSizeZero;

	if (ratioConstraint >= ratioOriginal) {
		resultingSize = CGSizeMake(ratioOriginal*constraint.height, constraint.height);
	}else{
		resultingSize = CGSizeMake(constraint.width, constraint.width/ratioOriginal);
	}

	return resultingSize;
}


@end
