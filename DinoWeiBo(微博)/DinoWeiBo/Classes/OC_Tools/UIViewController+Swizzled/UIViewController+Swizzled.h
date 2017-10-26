//
//  UIViewController+Swizzled.h
//
//  Created by Rui Peres on 12/08/2013.
//  Copyright (c) 2013 Rui Peres. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SWIZZ_IT [UIViewController swizzIt];
#define SWIZZ_IT_WITH_TAG(tag) [UIViewController swizzItWithTag:tag];

#define UN_SWIZZ_IT [UIViewController undoSwizz];

/**
 这个能帮你管理你的应用。当你正在做复杂的行为以及刚接手工程的时候这个会变得特别好用。使用这个 category 能看到你现在所在的UIViewController，还有展示你进入的层次
 */
@interface UIViewController (Swizzled)

/**
 It will swizz the methods:
 viewDidLoad
 @return void
 */
+ (void)swizzIt;

/**
 It will swizz the methods:
 viewDidLoad
 and prepend "tag" to each line of log
 @return void
 */
+ (void)swizzItWithTag:(NSString *)tag;

/**
 It will undo what was done with the swizzIt
 @return void
 */
+ (void)undoSwizz;

@end
