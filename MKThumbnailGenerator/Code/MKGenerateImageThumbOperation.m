//
//  IPGenerateImageThumbOperation.m
//  iPresenter
//
//  Created by Marcin Kuptel on 12/04/13.
//  Copyright (c) 2013 InSilico. All rights reserved.
//

#import "MKGenerateImageThumbOperation.h"
#import "MKGenerateThumbnailOperation_Protected.h"

@implementation MKGenerateImageThumbOperation

#pragma mark - Overriden methods

- (UIImage*) generateThumbnailForFileAtPath:(NSString *)path size:(CGSize)thumbnailSize
{
	NSData *imageData = [NSData dataWithContentsOfURL: [NSURL fileURLWithPath: path]];
	UIImage *image = [UIImage imageWithData:imageData];
	CGSize scaledSize = [self size: image.size constrainedToSize: thumbnailSize];

	UIGraphicsBeginImageContext(scaledSize);

		CGRect imageRect = {CGPointZero, scaledSize};
		[image drawInRect: imageRect];
		UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();

	return resultingImage;
}

@end
