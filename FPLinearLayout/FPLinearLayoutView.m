//
//  FPLinearLayoutView.m
//
//  FPLinearLayout is a view container that automatically handles children
//  positions for you in a linear fashion.
//
//  Created by FingertiP on 7/3/13.
//  Copyright (c) 2013, FingertiP. All rights reserved.
//
//  http://www.fingertip.in.th
//
/*
  Copyright (c) 2013, FingertiP

  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.

  * Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.

  * Neither the name of FingertiP nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY FINGERTIP AND CONTRIBUTORS
  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


#import "FPLinearLayoutView.h"

const int kDefaultItemMargin = 5;

@interface FPLinearLayoutView ()

@property (strong, nonatomic) NSMutableArray* items;
@property (strong, nonatomic) NSMutableArray* itemsMargins;
@property (assign, nonatomic) LinearDirection direction;
@property (assign, nonatomic) CGFloat defaultItemMargin;
@property (assign, nonatomic) CGSize boundSize;

@end

@implementation FPLinearLayoutView

/**
 * Return a fresh linear uiview for a specific direction.
 */
+(FPLinearLayoutView *)layoutForDirection:(LinearDirection)direction {
  FPLinearLayoutView* view = [[FPLinearLayoutView alloc]
    initWithFrame:CGRectMake(0, 0, 10, 10)];
  view.boundSize = view.bounds.size;
  view.direction = direction;
  return view;
}

/**
 * Return a fresh horizontal layout.
 */
+ (FPLinearLayoutView *)horizontalLayout {
  return [self layoutForDirection:kLinearHorizontal];
}

/**
 * Return a fresh vertical layout.
 */
+ (FPLinearLayoutView *)verticalLayout {
  return [self layoutForDirection:kLinearVertical];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

/**
 * Append a view with to current view with default margin.
 */
- (void)appendView:(UIView*)view {
  [self appendView:view marginLeft:kDefaultItemMargin marginTop:kDefaultItemMargin];
}

/**
 * Append a view with a space equal to supplied padding to the previous item.
 */
- (void)appendView:(UIView*)view marginLeft:(CGFloat)left marginTop:(CGFloat)top {
  // Init items if it's nil.
  if(!self.items){
    self.items = [[NSMutableArray alloc] initWithCapacity:3];
  }

  // Init itemMargins if it's nill.
  if(!self.itemsMargins) {
    self.itemsMargins = [[NSMutableArray alloc] initWithCapacity:3];
  }

  // Append item to a right direction.
  if(self.items.count !=0){
    UIView* lastItem = [self.items lastObject];
    CGRect lastItemFrame  = lastItem.frame;
    CGRect frame = view.frame;
    switch (self.direction) {
      case kLinearHorizontal:
        view.frame = CGRectMake(
          lastItemFrame.origin.x + lastItemFrame.size.width + left,
          top,
          frame.size.width,
          frame.size.height);
        break;
      case kLinearVertical:
        view.frame = CGRectMake(
            left,
            lastItemFrame.origin.y + lastItemFrame.size.height + top,
            frame.size.width,
            frame.size.height);
        break;
    }
  }
  else {
    CGRect frame = view.frame;
    view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
  }

  [self.items addObject:view];
  NSValue* margins = [NSValue valueWithCGPoint:CGPointMake(left, top)];
  [self.itemsMargins addObject:margins];
  [self addSubview:view];
  [self updateBound];
}

/**
 * Flush all view's children and re-adding them from items array.
 */
- (void)reset {
    // TODO: Implement.
}

/**
 * Update view's frame, basically change view's bound.
 */
- (void)updateBound {
  UIView* lastItem = [self.items lastObject];
  if(lastItem) {
    CGRect lastItemFrame = lastItem.frame;
    CGFloat newWidth = 0;
    CGFloat newHeight = 0;
    switch (self.direction) {
      case kLinearHorizontal:
        newWidth = lastItemFrame.origin.x + lastItemFrame.size.width;
        if(lastItemFrame.size.height > self.boundSize.height) {
          newHeight = lastItemFrame.size.height;
        }
        else {
          newHeight = self.boundSize.height;
        }
        self.boundSize = CGSizeMake(newWidth, newHeight);
        break;

      case kLinearVertical:
        newHeight = lastItemFrame.origin.y + lastItemFrame.size.height;
        if(lastItemFrame.size.width > self.boundSize.width) {
          newWidth = lastItemFrame.size.width;
        }
        else {
          newWidth = self.boundSize.width;
        }
        self.boundSize = CGSizeMake(newWidth, newHeight);
        break;
    }
    self.frame = CGRectMake(
      self.frame.origin.x,
      self.frame.origin.y,
      self.boundSize.width,
      self.boundSize.height);
  }
}

@end
