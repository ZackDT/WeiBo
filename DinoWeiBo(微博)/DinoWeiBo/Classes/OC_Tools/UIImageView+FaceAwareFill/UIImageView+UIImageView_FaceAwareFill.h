//
//  UIImageView+UIImageView_FaceAwareFill.h
//  faceAwarenessClipping
//
//  Created by Julio Andrés Carrettoni on 03/02/13.
//  Copyright (c) 2013 Julio Andrés Carrettoni. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 这个 category 使用了 Aspect Fill 的模式来显示图片并且当人脸被检测到时，它会就以脸部中心替代图片的集合中心。
 */
@interface UIImageView (UIImageView_FaceAwareFill)

//Ask the image to perform an "Aspect Fill" but centering the image to the detected faces
//Not the simple center of the image
- (void) faceAwareFill;

@end
