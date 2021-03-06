// Copyright 2010 The Omni Group.  All rights reserved.
//
// This software may only be used and reproduced according to the
// terms in the file OmniSourceLicense.html, which should be
// distributed with this project and can also be found at
// <http://www.omnigroup.com/developer/sourcecode/sourcelicense/>.

#import "OUIDocumentImagePreview.h"

RCS_ID("$Id$");

@implementation OUIDocumentImagePreview

- initWithImage:(UIImage *)image;
{
    OBPRECONDITION(image);
    
    if (!(self = [super init]))
        return nil;

    _cachedImage = [image retain];
    
    return self;
}

- (void)dealloc;
{
    [_cachedImage release];
    [super dealloc];
}

- (CGSize)originalViewSize;
{
    return [_cachedImage size];
}

- (CGAffineTransform)transformForTargetRect:(CGRect)targetRect;
{
    return CGAffineTransformIdentity;
}

- (CGRect)untransformedPageRect;
{
    CGSize size = [_cachedImage size];
    return CGRectMake(0, 0, size.width, size.height);
}

@synthesize cachedImage = _cachedImage;

@end
