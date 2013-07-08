//
//  IPThumbnailGenerator.m
//  iPresenter
//
//  Created by Marcin Kuptel on 12/04/13.
//  Copyright (c) 2013 InSilico. All rights reserved.
//

#import "MKThumbnailGenerator.h"
#import "MKGeneratePDFThumbOperation.h"
#import "MKGenerateVideoThumbOperation.h"
#import "MKGenerateImageThumbOperation.h"


typedef NS_ENUM(NSUInteger, MKFileType)
{
    MKFileTypeUnknown = 0,
    MKFileTypePDF,
    MKFileTypeVideo,
    MKFileTypeImage
};

static NSDictionary * fileTypesDictionary(){
    static NSDictionary *fileTypes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileTypes = @{
            @"pdf":@(MKFileTypePDF),
            @"mov":@(MKFileTypeVideo),
            @"m4v":@(MKFileTypeVideo),
            @"3gp":@(MKFileTypeVideo),
            @"png":@(MKFileTypeImage),
            @"jpg":@(MKFileTypeImage)
        };
    });
    return fileTypes;
}

@interface MKThumbnailGenerator	()

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation MKThumbnailGenerator

+ (MKThumbnailGenerator*) sharedGenerator
{
	static MKThumbnailGenerator *generator;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		generator = [[self alloc] init];
	});
	return generator;
}


- (id) init
{
	self = [super init];
	if (self) {
		self.operationQueue = [[NSOperationQueue alloc] init];
	}
	return self;
}


#pragma mark - Private methods


- (MKGenerateThumbnailOperation*) operationForFile: (NSString*) path completion: (MKThumbnailGeneratorCompletion) completion
{
	MKGenerateThumbnailOperation *operation = nil;

	IPGenerateThumbnailOperationCompletionBlock operationCompletion = ^(UIImage *thumbnail, NSError *error)
	{
		if (error) {
			DLog(@"%@", error);
			if (completion) {
				completion(nil, error);
			}
		}else{
			if (completion) {
				completion(thumbnail, nil);
			}
		}
	};
    
    MKFileType type = [self fileTypeForPath: path];

	switch (type) {
		case MKFileTypePDF:{
			operation = [[MKGeneratePDFThumbOperation alloc] initWithFilePath: path
																   completion: operationCompletion];
			break;
		}
		case MKFileTypeVideo:{
			operation = [[MKGenerateVideoThumbOperation alloc] initWithFilePath: path
																	 completion: operationCompletion];
			break;
		}
		case MKFileTypeImage:{
			operation = [[MKGenerateImageThumbOperation alloc] initWithFilePath: path
																	 completion: operationCompletion];
			break;
		}

		default:{
			NSAssert(NO, @"Invalid file type");
			return nil;
		}
	}

	NSAssert(operation, @"Operation not created");

	return operation;
}


- (MKFileType) fileTypeForPath: (NSString*) path
{
    NSDictionary *fileTypes = fileTypesDictionary();
    NSString *extension = [path pathExtension];
    NSNumber *fileType = fileTypes[extension];
    
    if (!fileTypes) return MKFileTypeUnknown;
    else return [fileType intValue];
}


#pragma mark - Public methods

- (void) generateThumbnailForFile:(NSString*)path completion:(MKThumbnailGeneratorCompletion)completion
{
	MKGenerateThumbnailOperation *operation = [self operationForFile: path completion: completion];
	[self.operationQueue addOperation: operation];
}


- (void) cancelAllOperations
{
	[self.operationQueue cancelAllOperations];
}

@end
