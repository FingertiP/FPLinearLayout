FPLinearLayoutView
============

FPLinearLayoutView enables you to add a view as a child without worrying about the position. FPLinearLayoutView will handle every added views and place them at a right place (according to the selected direction). This basically makes UIView behaves like Android's linear layout.

### Feature
* Behaves like normal UIView.
* Automatically handles children view position according to a decided direction.
* The child view can be oriented in horizontal or vertical direction.
* The margin of a to-be-added view can be specified (top-left margin).

### Usage Example
```objective-c
// Horizontal oriented layout.
FPLinearLayoutView *layoutView = [FPLinearLayoutView horizontalLayout];

// Appending view with default margin.
UIView* view = [[UIView alloc] initWithFrame:CGRect(0, 0, 320, 100)];
[layoutView appendView:view]

// Appending view with specific margins.
UIView* view = [[UIView alloc] initWithFrame:CGRect(0, 0, 320, 100)];
[layoutView appendView:view marginLeft:10.0f marginTop:20.0f];
```
