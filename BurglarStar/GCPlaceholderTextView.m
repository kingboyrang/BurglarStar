//
//  GCPlaceholderTextView.m
//  GCLibrary
//
//  Created by Guillaume Campagna on 10-11-16.
//  Copyright 2010 LittleKiwi. All rights reserved.
//

#import "GCPlaceholderTextView.h"
#import <QuartzCore/QuartzCore.h>
#define toolBarH 44

@interface GCPlaceholderTextView ()
//toobar handler
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, retain) UIView *fullView;

@property (nonatomic, retain) UIColor* realTextColor;
@property (nonatomic, readonly) NSString* realText;

- (void) beginEditing:(NSNotification*) notification;
- (void) endEditing:(NSNotification*) notification;

@end

@implementation GCPlaceholderTextView

@synthesize realTextColor;
@synthesize placeholder;

@synthesize toolBar;
@synthesize fullView;
#pragma mark -
#pragma mark Initialisation

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    //键盘处理
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing:) name:UITextViewTextDidEndEditingNotification object:self];
    
    self.realTextColor = [UIColor blackColor];
}
- (void)done {
    [self resignFirstResponder];
}
#pragma mark -
#pragma mark keyboard with toolbar
- (void)keyboardWillShow:(NSNotification *)notification{
    
	if (![self isFirstResponder]) return;
	
	NSDictionary *info = [notification userInfo];
	
	if (!fullView) {
		self.fullView = self.superview;
		while (![fullView.superview isKindOfClass:[UIWindow class]]) {
			self.fullView = fullView.superview;
		}
	}
	
	CGRect fieldFrame = self.frame;
	fieldFrame = [fullView convertRect:fieldFrame fromView:self.superview];
	//int fieldBottom = fieldFrame.origin.y + fieldFrame.size.height;
    //取得键盘的大小
	CGRect kbFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	kbFrame = [fullView convertRect:kbFrame fromView:self.window];
	int kbTop = kbFrame.origin.y;
	int kbWidth = kbFrame.size.width;
	
	//if (fieldBottom < kbTop) return;
	
	CGRect fullFrame = fullView.frame;
	if (!toolBar) {
		NSString *title = @"Done";

		UIBarButtonItem *spacer =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:NULL action:NULL];
		UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
		
		self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, fullFrame.size.height, kbWidth, toolBarH)];
		toolBar.barStyle = UIBarStyleBlack;
		toolBar.translucent = TRUE;
		toolBar.items = @[spacer, doneButton];
		toolBar.alpha = 0.0;
		
				
		[fullView addSubview:toolBar];
		
	}
    
	// Reset values in case device has rotated
	toolBar.frame = CGRectMake(0, fullFrame.size.height, kbWidth, toolBarH);
	CGRect toolFrame = toolBar.frame;
	toolFrame.origin.x = 0;    
	toolFrame.origin.y = kbTop - toolFrame.size.height;
	
	[UIView animateWithDuration:[[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] delay:0 options:[[info valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue] animations:^{
		toolBar.frame = toolFrame;
		toolBar.alpha = 1.0;
	} completion:^(BOOL finished){
	}];


}
- (void)keyboardWillHide:(NSNotification *)notification{
    if (![self isFirstResponder]) return;
	CGRect toolBarFrame = toolBar.frame;
	toolBarFrame.origin.y = fullView.frame.size.height;
	NSDictionary *info = [notification userInfo];
	[UIView animateWithDuration:[[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] delay:0 options:[[info valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue] animations:^{
		toolBar.frame = toolBarFrame;
		toolBar.alpha = 0.0;
	} completion:^(BOOL finished){
	}];
}
#pragma mark -
#pragma mark Setter/Getters

- (void) setPlaceholder:(NSString *)aPlaceholder {
    if ([self.realText isEqualToString:placeholder]) {
        self.text = aPlaceholder;
    }
    
    [placeholder release];
    placeholder = [aPlaceholder retain];
    
    [self endEditing:nil];
}

- (NSString *) text {
    NSString* text = [super text];
    if ([text isEqualToString:self.placeholder]) return @"";
    return text;
}

- (void) setText:(NSString *)text {
    if ([text isEqualToString:@""] || text == nil) {
        super.text = self.placeholder;
    }
    else {
        super.text = text;
    }
    
    if ([text isEqualToString:self.placeholder]) {
        self.textColor = [UIColor lightGrayColor];
    }
    else {
        self.textColor = self.realTextColor;
    }
}

- (NSString *) realText {
    return [super text];
}

- (void) beginEditing:(NSNotification*) notification {
    if ([self.realText isEqualToString:self.placeholder]) {
        super.text = nil;
        self.textColor = self.realTextColor;
    }
}

- (void) endEditing:(NSNotification*) notification {
    if ([self.realText isEqualToString:@""] || self.realText == nil) {
        super.text = self.placeholder;
        self.textColor = [UIColor lightGrayColor];
    }
}

- (void) setTextColor:(UIColor *)textColor {
    if ([self.realText isEqualToString:self.placeholder]) {
        if ([textColor isEqual:[UIColor lightGrayColor]]) [super setTextColor:textColor];
        else self.realTextColor = textColor;
    }
    else {
        self.realTextColor = textColor;
        [super setTextColor:textColor];
    }
}
- (void)shake {
    CAKeyframeAnimation *animationKey = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animationKey setDuration:0.5f];
    
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      nil];
    [animationKey setValues:array];
    [array release];
    
    NSArray *times = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithFloat:0.1f],
                      [NSNumber numberWithFloat:0.2f],
                      [NSNumber numberWithFloat:0.3f],
                      [NSNumber numberWithFloat:0.4f],
                      [NSNumber numberWithFloat:0.5f],
                      [NSNumber numberWithFloat:0.6f],
                      [NSNumber numberWithFloat:0.7f],
                      [NSNumber numberWithFloat:0.8f],
                      [NSNumber numberWithFloat:0.9f],
                      [NSNumber numberWithFloat:1.0f],
                      nil];
    [animationKey setKeyTimes:times];
    [times release];
    [self.layer addAnimation:animationKey forKey:@"TextViewShake"];
}
#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    [realTextColor release];
    [placeholder release];
    [fullView release];
    [toolBar release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

@end
