//
//  IPGeneratePDFThumbOperation.m
//  iPresenter
//
//  Created by Marcin Kuptel on 12/04/13.
//  Copyright (c) 2013 InSilico. All rights reserved.
//

#import "MKGeneratePDFThumbOperation.h"
#import "MKGenerateThumbnailOperation_Protected.h"
#import <PSPDFKit/PSPDFKit.h>

#define SHADOW_PADDING		8

@implementation MKGeneratePDFThumbOperation

#pragma mark - Overriden methods

- (UIImage*) generateThumbnailForFileAtPath: (NSString*) path size: (CGSize) thumbnailSize
{
	NSURL *fileURL = [NSURL fileURLWithPath: path];
	PSPDFDocument *document = [[PSPDFDocument alloc] initWithURL:fileURL];
	CGRect pageRect = [document rectBoxForPage: 0];
	CGSize scaledPageSize = [self size: pageRect.size constrainedToSize: thumbnailSize];

	UIImage *thumbnail = [document renderImageForPage: 0
											 withSize: scaledPageSize
										clippedToRect: CGRectZero
									  withAnnotations: nil
											  options: nil];

	CGSize newSize = CGSizeMake(thumbnail.size.width, thumbnail.size.height);
	newSize.width += SHADOW_PADDING;
	newSize.height += SHADOW_PADDING;
	CGRect imageRect = CGRectMake(2, 2, thumbnail.size.width, thumbnail.size.height);

	UIColor * shadowColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha:1.0];

	UIGraphicsBeginImageContext(newSize);

		CGContextRef ctx = UIGraphicsGetCurrentContext();

		CGPathRef drawingPath = CGPathCreateWithRect(imageRect, NULL);
		CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 6.0, shadowColor.CGColor);
		CGContextAddPath(ctx, drawingPath);

		CGContextStrokePath(ctx);
		[thumbnail drawInRect: imageRect];
		UIImage* result = UIGraphicsGetImageFromCurrentImageContext();

		CGPathRelease(drawingPath);
	
	UIGraphicsEndImageContext();

	return result;
}

@end
