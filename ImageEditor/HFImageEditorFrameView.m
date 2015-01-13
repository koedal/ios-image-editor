#import "HFImageEditorFrameView.h"
#import "QuartzCore/QuartzCore.h"

const CGFloat HFRoundedImageCropInsetPercent = 0.05f;

@interface HFImageEditorFrameView ()
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation HFImageEditorFrameView

@synthesize cropRect = _cropRect;
@synthesize imageView  = _imageView;


- (void) initialize
{
    self.opaque = NO;
    self.layer.opacity = 0.7;
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:imageView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(imageView);
    NSMutableArray *constraints = [[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[imageView]-0-|" options:0 metrics:nil views:views] mutableCopy];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]-0-|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[constraints copy]];
    self.imageView = imageView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self initialize];
    }
    return self;
}

- (void)setCropRect:(CGRect)cropRect
{
    if(!CGRectEqualToRect(_cropRect,cropRect)){
        _cropRect = CGRectOffset(cropRect, self.frame.origin.x, self.frame.origin.y);
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.f);
        
        CGFloat circleInset = MIN(self.frame.size.width, self.frame.size.height) * HFRoundedImageCropInsetPercent;
        UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:CGRectInfinite];
        CGRect circleRect = CGRectInset(_cropRect, circleInset, circleInset);
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:circleRect];
        [clipPath appendPath:circlePath];
        clipPath.usesEvenOddFillRule = YES;
        [clipPath addClip];
        
        [[UIColor blackColor] setFill];
        UIRectFill(self.bounds);
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();
    }
}

/*
- (void)drawRect:(CGRect)rect
{
   CGContextRef context = UIGraphicsGetCurrentContext();

    [[UIColor blackColor] setFill];
    UIRectFill(rect);
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor);
    CGContextStrokeRect(context, self.cropRect);
    [[UIColor clearColor] setFill];
    UIRectFill(CGRectInset(self.cropRect, 1, 1));

}
*/

@end
