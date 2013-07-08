//
//  IPGenerateVideoThumbOperation.m
//  iPresenter
//
//  Created by Marcin Kuptel on 12/04/13.
//  Copyright (c) 2013 InSilico. All rights reserved.
//

#import "MKGenerateVideoThumbOperation.h"
#import "MKGenerateThumbnailOperation_Protected.h"
#import <AVFoundation/AVFoundation.h>

@implementation MKGenerateVideoThumbOperation

- (UIImage*) generateThumbnailForFileAtPath:(NSString *)path size:(CGSize)thumbnailSize
{
    //http://pulkitgoyal.in/2013/04/12/creating-video-thumbnails-using-the-ios-sdk/
    
    NSURL *url = [NSURL fileURLWithPath:path];
    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform=TRUE;
    CMTime thumbTime = CMTimeMakeWithSeconds(5,1);
    
    CGSize maxSize = CGSizeMake(1000, 1000);
    generator.maximumSize = maxSize;
    
    
    CGImageRef thumb = [generator copyCGImageAtTime:thumbTime actualTime:NULL error:NULL];
    if (thumb != NULL) {
        UIImage *image = [UIImage imageWithCGImage:thumb];
        if (image) {
            CGFloat scale = thumbnailSize.width / image.size.width;
            UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scale, image.size.height * scale));
            [image drawInRect:CGRectMake(0, 0, image.size.width * scale, image.size.height * scale)];
            UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            CGImageRelease(thumb);
            return result;
        }
        CGImageRelease(thumb);
    }
    
    return nil;
}

@end
