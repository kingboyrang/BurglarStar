//
//  ViewController.h
//  PageViewController
//
//  Created by Tom Fewster on 11/01/2012.
//

#import <UIKit/UIKit.h>

@interface PagerViewController : BasicViewController <UIScrollViewDelegate>

@property (nonatomic, strong)  UIScrollView *scrollView;
@property (nonatomic, strong)  UIPageControl *pageControl;

- (IBAction)changePage:(id)sender;

- (void)previousPage;
- (void)nextPage;
- (void)changePageIndex:(int)index;
- (void)handChangePageIndex:(int)index;
@end
