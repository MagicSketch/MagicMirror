//
//  MMEventHandler.m
//  MagicMirror2
//
//  Created by James Tang on 8/1/2016.
//  Copyright © 2016 James Tang. All rights reserved.
//

#import "MMProxy.h"
#import "MagicMirror.h"
#import "MSShapeEventHandler.h"

@interface MMProxy <ObjectType> ()

//@property (nonatomic, strong) ObjectType target;

@end

@implementation MMProxy

+ (instancetype)proxyWithTarget:(id)target {
    MMProxy  *proxy = [[self alloc] init];
    proxy.target = target;
    return proxy;
}

- (id)init {
    return self;
}

- (NSString *)className {
    NSString *name = NSStringFromClass([self.target class]);
    return name;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    return [self.target methodSignatureForSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:self.target];
}


- (void)drawView:(NSRect)frame {
    [(MSShapeEventHandler *)self.target drawInRect:frame];


    //// Text Drawing
    NSRect textRect = NSMakeRect(NSMinX(frame) + floor((NSWidth(frame) - 149) * 0.53846 + 0.5), NSMinY(frame) + floor((NSHeight(frame) - 68) * 0.36538 + 0.5), 149, 68);
    {
        NSString* textContent = @"Avaliable in Magic Mirror Pro Version";
        NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        textStyle.alignment = NSCenterTextAlignment;

        NSDictionary* textFontAttributes = @{NSFontAttributeName: [NSFont systemFontOfSize: NSFont.systemFontSize], NSForegroundColorAttributeName: NSColor.greenColor, NSParagraphStyleAttributeName: textStyle};

        NSRect textInset = NSInsetRect(textRect, 10, 10);
        CGFloat textTextHeight = NSHeight([textContent boundingRectWithSize: textInset.size options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes]);
        NSRect textTextRect = NSMakeRect(NSMinX(textInset), NSMinY(textInset) + (NSHeight(textInset) - textTextHeight) / 2, NSWidth(textInset), textTextHeight);
        [NSGraphicsContext saveGraphicsState];
        NSRectClip(textInset);
        [textContent drawInRect: NSOffsetRect(textTextRect, 0, 1) withAttributes: textFontAttributes];
        [NSGraphicsContext restoreGraphicsState];
    }

}

@end
