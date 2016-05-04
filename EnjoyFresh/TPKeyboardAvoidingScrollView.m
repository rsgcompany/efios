//
//  TPKeyboardAvoidingScrollView.m
//
//  Created by Michael Tyson on 30/09/2013.
//  Copyright 2013 A Tasty Pixel. All rights reserved.
//

#import "TPKeyboardAvoidingScrollView.h"

@interface TPKeyboardAvoidingScrollView () <UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, strong) UIImageView *vertical_indicator_view;
@end
enum {
    k_scroll_indicator_vertical,
};
static const CGFloat scroll_indicator_margin_exclude = 6.5;
static const CGFloat scroll_indicator_min            = 7;
static const CGFloat scroll_indicator_factor         = 0.25;

static inline
CGFloat scroll_indicator_size(UIScrollViewIndicatorStyle indicatorStyle)
{
    return indicatorStyle == UIScrollViewIndicatorStyleDefault ? 3.5 : 2.5;
}

static inline
CGFloat scroll_indicator_margin(UIScrollViewIndicatorStyle indicatorStyle)
{
    return indicatorStyle == UIScrollViewIndicatorStyleDefault ? 2 : 2.5;
}

static
CGFloat scroll_indicator_round(CGFloat valf)
{
    static NSDecimalNumberHandler *handler;
    
    if (handler == nil) {
        handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                         scale:1
                                                              raiseOnExactness:NO
                                                               raiseOnOverflow:NO
                                                              raiseOnUnderflow:NO
                                                           raiseOnDivideByZero:NO];
    }
    
    NSDecimalNumber *decimal = [[NSDecimalNumber alloc] initWithDouble:(double)valf];
    
    decimal = [decimal decimalNumberByRoundingAccordingToBehavior:handler];
    
    valf = [decimal doubleValue];
    
    CGFloat diff = valf - ((long)valf + 0.5);
    
    if (diff > scroll_indicator_factor) {
        valf = (long)valf + 1;
    } else if (diff < -scroll_indicator_factor) {
        valf = (long)valf;
    } else {
        valf = (long)valf + 0.5;
    }
    
    return valf;
}

static
void scroll_indicator_position(TPKeyboardAvoidingScrollView *scrollView, int indicatorType)
{
    CGFloat contentsz = indicatorType == k_scroll_indicator_vertical ? scrollView.contentSize.height : scrollView.contentSize.width;
    CGFloat boundsz = indicatorType == k_scroll_indicator_vertical ? scrollView.bounds.size.height : scrollView.bounds.size.width;
    CGFloat offset = indicatorType == k_scroll_indicator_vertical ? scrollView.contentOffset.y : scrollView.contentOffset.x;
    CGFloat maxOffset = contentsz - boundsz;
    CGFloat indicatorMargin = scroll_indicator_margin(scrollView.indicatorStyle);
    CGFloat indicatorsz = scroll_indicator_round((boundsz - indicatorMargin) / contentsz * (boundsz - indicatorMargin));
    CGFloat indicatorScrollsz = boundsz - indicatorsz - indicatorMargin * 2;
    CGFloat indicator;
    
    if (offset < 0) {
        indicator = offset + indicatorMargin;
        indicatorsz += offset;
        
        if (indicatorsz < scroll_indicator_min) {
            indicatorsz = scroll_indicator_min;
        }
        
    } else if (offset > maxOffset) {
        CGFloat indicator_sz = indicatorsz;
        
        indicatorsz -= offset - maxOffset;
        
        if (indicatorsz < scroll_indicator_min) {
            indicatorsz = scroll_indicator_min;
        }
        
        indicator = indicator_sz - indicatorsz + offset + indicatorScrollsz + indicatorMargin;
        
    } else {
        indicator = offset / maxOffset * indicatorScrollsz + offset + indicatorMargin;
        indicator = scroll_indicator_round(indicator);
    }
    
    BOOL moreExclude = NO;
    
    if (indicatorType == k_scroll_indicator_vertical) {
        moreExclude = scrollView.contentSize.width > CGRectGetWidth(scrollView.bounds);
    } else {
        moreExclude = scrollView.contentSize.height > CGRectGetHeight(scrollView.bounds);
    }
    
    if (moreExclude) {
        if (offset + boundsz - indicator - indicatorsz - scroll_indicator_margin_exclude < 0) {
            indicator = offset + boundsz - indicatorsz - scroll_indicator_margin_exclude;
        }
    }
    
    CGFloat sizemetric = indicatorType == k_scroll_indicator_vertical ? CGRectGetMaxX(scrollView.bounds) : CGRectGetMaxY(scrollView.bounds);
    CGFloat indicatorSize = scroll_indicator_size(scrollView.indicatorStyle);
    
    if (indicatorType == k_scroll_indicator_vertical) {
        scrollView.vertical_indicator_view.frame = CGRectMake(sizemetric - indicatorMargin - indicatorSize, indicator, indicatorSize, indicatorsz);
    }
}

static
UIImage *scroll_indicator_default_image(UIScrollView *scrollView, int indicatorType)
{
    NSUInteger index =
    [scrollView.subviews indexOfObjectPassingTest:^BOOL(UIView *view, NSUInteger idx, BOOL *stop) {
        return [view isMemberOfClass:[UIImageView class]] &&
        (CGRectGetWidth(view.bounds) < CGRectGetHeight(view.bounds) || indicatorType);
    }];
    
    if (index != NSNotFound) {
        return [(UIImageView *)scrollView.subviews[index] image];
    }
    
    static
    char defaultPNGData[] = {
        0x89,0x50,0x4e,0x47,0x0d,0x0a,0x1a,0x0a,0x00,0x00,0x00,0x0d,0x49,0x48,0x44,0x52,
        0x00,0x00,0x00,0x07,0x00,0x00,0x00,0x07,0x08,0x06,0x00,0x00,0x00,0xc4,0x52,0x57,
        0xd3,0x00,0x00,0x00,0x09,0x70,0x48,0x59,0x73,0x00,0x00,0x16,0x25,0x00,0x00,0x16,
        0x25,0x01,0x49,0x52,0x24,0xf0,0x00,0x00,0x00,0x1c,0x69,0x44,0x4f,0x54,0x00,0x00,
        0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x04,0x00,0x00,0x00,0x28,0x00,0x00,
        0x00,0x04,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x7a,0xe2,0x99,0x23,0x24,0x00,0x00,
        0x00,0x46,0x49,0x44,0x41,0x54,0x08,0x1d,0x62,0x60,0x00,0x82,0xff,0xff,0xff,0x73,
        0x03,0xb1,0x38,0x10,0x4b,0x43,0x69,0x6e,0x90,0x38,0x58,0x62,0xea,0xd4,0xa9,0x9a,
        0x56,0x56,0x56,0x76,0xec,0xec,0xec,0x5e,0x20,0x1a,0xc4,0x07,0x69,0x00,0x49,0x8a,
        0x83,0x04,0x80,0xea,0x7c,0x61,0x18,0xc4,0x07,0x89,0x83,0x24,0xa5,0x41,0x3a,0x60,
        0x12,0x20,0x1a,0xc4,0x07,0x89,0x03,0x00,0x00,0x00,0xff,0xff,0x7d,0xb1,0x9c,0x8b,
        0x00,0x00,0x00,0x38,0x49,0x44,0x41,0x54,0x63,0xf8,0xff,0xff,0xbf,0xb8,0x95,0x95,
        0x95,0x1d,0x03,0x03,0x83,0x2f,0x0c,0x83,0xf8,0x20,0x71,0x06,0x20,0xc1,0x3d,0x75,
        0xea,0x54,0x4d,0x90,0x00,0x3b,0x3b,0xbb,0x17,0x88,0x06,0xf1,0x41,0xe2,0x40,0xc5,
        0x0c,0x60,0x05,0x20,0x95,0x40,0x2c,0x0d,0xa5,0xc1,0x12,0x00,0xff,0xc8,0x50,0x72,
        0x5e,0x2d,0x72,0x4e,0x00,0x00,0x00,0x00,0x49,0x45,0x4e,0x44,0xae,0x42,0x60,0x82
    };
    
    static
    char blackPNGData[] = {
        0x89,0x50,0x4e,0x47,0x0d,0x0a,0x1a,0x0a,0x00,0x00,0x00,0x0d,0x49,0x48,0x44,0x52,
        0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x05,0x08,0x06,0x00,0x00,0x00,0x8d,0x6f,0x26,
        0xe5,0x00,0x00,0x00,0x09,0x70,0x48,0x59,0x73,0x00,0x00,0x16,0x25,0x00,0x00,0x16,
        0x25,0x01,0x49,0x52,0x24,0xf0,0x00,0x00,0x00,0x1c,0x69,0x44,0x4f,0x54,0x00,0x00,
        0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x28,0x00,0x00,
        0x00,0x03,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x58,0x4e,0x6a,0x5a,0xf2,0x00,0x00,
        0x00,0x24,0x49,0x44,0x41,0x54,0x08,0x1d,0x62,0x60,0x60,0x60,0x10,0x04,0x62,0x03,
        0x20,0xf6,0x80,0xd2,0x20,0x3e,0x58,0xc0,0x17,0x48,0xc3,0x30,0x48,0x01,0x58,0x05,
        0x4c,0x00,0x44,0x7b,0x00,0x00,0x00,0x00,0xff,0xff,0xd8,0xa3,0x9d,0x20,0x00,0x00,
        0x00,0x19,0x49,0x44,0x41,0x54,0x63,0x60,0x60,0x60,0x30,0x00,0x62,0x5f,0x24,0x0c,
        0xe2,0x33,0x08,0x02,0x31,0x88,0xe1,0x01,0xa5,0x05,0x01,0x1d,0xf3,0x05,0x9a,0x93,
        0x70,0x80,0xc6,0x00,0x00,0x00,0x00,0x49,0x45,0x4e,0x44,0xae,0x42,0x60,0x82
    };
    
    static
    char whitePNGData[] = {
        0x89,0x50,0x4e,0x47,0x0d,0x0a,0x1a,0x0a,0x00,0x00,0x00,0x0d,0x49,0x48,0x44,0x52,
        0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x05,0x08,0x06,0x00,0x00,0x00,0x8d,0x6f,0x26,
        0xe5,0x00,0x00,0x00,0x09,0x70,0x48,0x59,0x73,0x00,0x00,0x16,0x25,0x00,0x00,0x16,
        0x25,0x01,0x49,0x52,0x24,0xf0,0x00,0x00,0x00,0x1c,0x69,0x44,0x4f,0x54,0x00,0x00,
        0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x28,0x00,0x00,
        0x00,0x03,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x59,0x39,0x6d,0x6a,0x64,0x00,0x00,
        0x00,0x25,0x49,0x44,0x41,0x54,0x08,0x1d,0x62,0xf8,0xff,0xff,0xbf,0x20,0x10,0x1b,
        0x00,0xb1,0x07,0x94,0x16,0x64,0x80,0x32,0x7c,0x81,0x34,0x0c,0x1b,0x80,0x04,0x41,
        0x2a,0x60,0x02,0x20,0xda,0x03,0x00,0x00,0x00,0xff,0xff,0x7f,0xbd,0x30,0x04,0x00,
        0x00,0x00,0x19,0x49,0x44,0x41,0x54,0x63,0xf8,0xff,0xff,0xbf,0x01,0x10,0xfb,0x22,
        0x61,0x03,0x06,0x20,0x47,0x10,0x2a,0xe1,0x01,0xa5,0x05,0x01,0x96,0x4d,0x50,0x4f,
        0xb8,0x10,0xce,0xa8,0x00,0x00,0x00,0x00,0x49,0x45,0x4e,0x44,0xae,0x42,0x60,0x82
    };
    
#define ARRAY_SIZE(x) sizeof(x)/sizeof(x[0])
    
    UIImage *image = nil;
    
    switch (scrollView.indicatorStyle) {
        case UIScrollViewIndicatorStyleDefault:
            image = [UIImage imageWithData:[NSData dataWithBytesNoCopy:defaultPNGData length:ARRAY_SIZE(defaultPNGData)] scale:2];
            break;
        case UIScrollViewIndicatorStyleBlack:
            image = [UIImage imageWithData:[NSData dataWithBytesNoCopy:blackPNGData length:ARRAY_SIZE(blackPNGData)] scale:2];
            break;
        case UIScrollViewIndicatorStyleWhite:
            image = [UIImage imageWithData:[NSData dataWithBytesNoCopy:whitePNGData length:ARRAY_SIZE(whitePNGData)] scale:2];
            break;
    }
    
    CGFloat top = 0., left = 0.;
    
    if (indicatorType == k_scroll_indicator_vertical) {
        top = image.size.height / 2;
    } else {
        left = image.size.width / 2;
    }
    
    if (image != nil) {
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, top, left)];
    }
    
    return image;
}
@implementation TPKeyboardAvoidingScrollView

#pragma mark - Setup/Teardown

- (void)setup {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TPKeyboardAvoiding_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TPKeyboardAvoiding_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToActiveTextField) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToActiveTextField) name:UITextFieldTextDidBeginEditingNotification object:nil];
}

-(id)initWithFrame:(CGRect)frame {
    if ( !(self = [super initWithFrame:frame]) ) return nil;
    [self setup];
    return self;
}

-(void)awakeFromNib {
    [self setup];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self TPKeyboardAvoiding_updateContentInset];
}

-(void)setContentSize:(CGSize)contentSize {
    [super setContentSize:contentSize];
    [self TPKeyboardAvoiding_updateFromContentSizeChange];
}

- (void)contentSizeToFit {
    self.contentSize = [self TPKeyboardAvoiding_calculatedContentSizeFromSubviewFrames];
}

- (BOOL)focusNextTextField {
    return [self TPKeyboardAvoiding_focusNextTextField];
    
}
- (void)scrollToActiveTextField {
    return [self TPKeyboardAvoiding_scrollToActiveTextField];
}

#pragma mark - Responders, events

-(void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if ( !newSuperview ) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView:) object:self];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self TPKeyboardAvoiding_findFirstResponderBeneathView:self] resignFirstResponder];
    [super touchesEnded:touches withEvent:event];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ( ![self focusNextTextField] ) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    if (self.showsVerticalScrollIndicatorAlways) {
        scroll_indicator_position(self, k_scroll_indicator_vertical);
    }

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView:) object:self];
    [self performSelector:@selector(TPKeyboardAvoiding_assignTextDelegateForViewsBeneathView:) withObject:self afterDelay:0.1];
}
- (void)setShowsVerticalScrollIndicatorAlways:(BOOL)showsVerticalScrollIndicatorAlways
{
    if (_showsVerticalScrollIndicatorAlways != showsVerticalScrollIndicatorAlways) {
        _showsVerticalScrollIndicatorAlways = showsVerticalScrollIndicatorAlways;
        
        if (showsVerticalScrollIndicatorAlways) {
            UIImage *image = scroll_indicator_default_image(self, k_scroll_indicator_vertical);
            
            NSAssert(image, @"defalut indicator image not found");
            
            if (image != nil) {
                self.vertical_indicator_view = [[UIImageView alloc] initWithImage:image];
                [self addSubview:self.vertical_indicator_view];
                self.showsVerticalScrollIndicator = NO;
            }
            
        } else {
            [self.vertical_indicator_view removeFromSuperview];
            self.vertical_indicator_view = nil;
        }
    }
}
- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    
    if (self.showsVerticalScrollIndicatorAlways) {
        [self bringSubviewToFront:self.vertical_indicator_view];
    }
    
}


@end
