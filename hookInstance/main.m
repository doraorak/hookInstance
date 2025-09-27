//
//  main.m
//  hookInstance
//
//  Created by Dora Orak on 22.01.2025.
//
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <AppKit/AppKit.h>
#import <CoreGraphics/CoreGraphics.h>

#define ARG0(type) type arg0
#define ARG1(type) type arg1
#define ARG2(type) type arg2
#define ARG3(type) type arg3
#define ARG4(type) type arg4
#define ARG5(type) type arg5
#define ARG6(type) type arg6
#define ARG7(type) type arg7
#define ARG8(type) type arg8
#define ARG9(type) type arg9

// SIGNATURE macro for cleaner syntax
#define SIGNATURE(returnType, ...) returnType __VA_OPT__(,) __VA_ARGS__

// Build declaration list from up to 10 types
#define GET_DISPATCH_MACRO(shift, shift2, _1,_2,_3,_4,_5,_6,_7,_8,_9,_10,NAME,...) NAME

#define GET_ARGS_MACRO(_1,_2,_3,_4,_5,_6,_7,_8,_9,_10,NAME,...) NAME
#define DECL_ARGS(...) GET_ARGS_MACRO(__VA_ARGS__, DECL10, DECL9, DECL8, DECL7, DECL6, DECL5, DECL4, DECL3, DECL2, DECL1, DECL0)(__VA_ARGS__)

#define DECL0()
#define DECL1(t0) ARG0(t0)
#define DECL2(t0,t1) ARG0(t0), ARG1(t1)
#define DECL3(t0,t1,t2) ARG0(t0), ARG1(t1), ARG2(t2)
#define DECL4(t0,t1,t2,t3) ARG0(t0), ARG1(t1), ARG2(t2), ARG3(t3)
#define DECL5(t0,t1,t2,t3,t4) ARG0(t0), ARG1(t1), ARG2(t2), ARG3(t3), ARG4(t4)
#define DECL6(t0,t1,t2,t3,t4,t5) ARG0(t0), ARG1(t1), ARG2(t2), ARG3(t3), ARG4(t4), ARG5(t5)
#define DECL7(t0,t1,t2,t3,t4,t5,t6) ARG0(t0), ARG1(t1), ARG2(t2), ARG3(t3), ARG4(t4), ARG5(t5), ARG6(t6)
#define DECL8(t0,t1,t2,t3,t4,t5,t6,t7) ARG0(t0), ARG1(t1), ARG2(t2), ARG3(t3), ARG4(t4), ARG5(t5), ARG6(t6), ARG7(t7)
#define DECL9(t0,t1,t2,t3,t4,t5,t6,t7,t8) ARG0(t0), ARG1(t1), ARG2(t2), ARG3(t3), ARG4(t4), ARG5(t5), ARG6(t6), ARG7(t7), ARG8(t8)
#define DECL10(t0,t1,t2,t3,t4,t5,t6,t7,t8,t9) ARG0(t0), ARG1(t1), ARG2(t2), ARG3(t3), ARG4(t4), ARG5(t5), ARG6(t6), ARG7(t7), ARG8(t8), ARG9(t9)

// Main HOOK_INSTANCE macro - now properly dispatches based on argument count
#define HOOK_INSTANCE(instance, selectorName, ...) \
    HOOK_INSTANCE_DISPATCH(instance, selectorName, __VA_ARGS__ )

// Dispatch based on the full signature
#define HOOK_INSTANCE_DISPATCH(instance, selectorName, ...) \
    GET_DISPATCH_MACRO(__VA_ARGS__, \
        HOOK_INSTANCE_10, HOOK_INSTANCE_9, HOOK_INSTANCE_8, HOOK_INSTANCE_7, \
        HOOK_INSTANCE_6, HOOK_INSTANCE_5, HOOK_INSTANCE_4, HOOK_INSTANCE_3, \
        HOOK_INSTANCE_2, HOOK_INSTANCE_1, HOOK_INSTANCE_0)(instance, selectorName, __VA_ARGS__)

// Hook instance with no arguments
#define HOOK_INSTANCE_0(instance, selectorName, returnType, block) \
do { \
    __block SEL _cmd = NSSelectorFromString(@#selectorName); \
    __block returnType (*originalImpl)(id, SEL) = NULL; \
    __auto_type replacement = ^(id self) { \
        returnType (^orig)(void) = ^returnType(void) { \
            return originalImpl(self, _cmd); \
        }; \
        block \
    }; \
    IMP newImplementation = imp_implementationWithBlock(replacement); \
    hookInstance(instance, _cmd, newImplementation, (IMP *)&originalImpl); \
} while (0)

// Hook instance with 1 argument
#define HOOK_INSTANCE_1(instance, selectorName, returnType, t0, block) \
do { \
    __block SEL _cmd = NSSelectorFromString(@#selectorName); \
    __block returnType (*originalImpl)(id, SEL, t0) = NULL; \
    __auto_type replacement = ^(id self, DECL_ARGS(t0)) { \
        returnType (^orig)(t0) = ^returnType(t0 a0) { \
            return originalImpl(self, _cmd, a0); \
        }; \
        block; \
    }; \
    IMP newImplementation = imp_implementationWithBlock(replacement); \
    hookInstance(instance, _cmd, newImplementation, (IMP *)&originalImpl); \
} while (0)

// Hook instance with 2 arguments
#define HOOK_INSTANCE_2(instance, selectorName, returnType, t0, t1, block) \
do { \
    __block SEL _cmd = NSSelectorFromString(@#selectorName); \
    __block returnType (*originalImpl)(id, SEL, t0, t1) = NULL; \
    __auto_type replacement = ^(id self, DECL_ARGS(t0, t1)) { \
        returnType (^orig)(t0, t1) = ^returnType(t0 a0, t1 a1) { \
            return originalImpl(self, _cmd, a0, a1); \
        }; \
        block \
    }; \
    IMP newImplementation = imp_implementationWithBlock(replacement); \
    hookInstance(instance, _cmd, newImplementation, (IMP *)&originalImpl); \
} while (0)

// Hook instance with 3 arguments
#define HOOK_INSTANCE_3(instance, selectorName, returnType, t0, t1, t2, block) \
do { \
    __block SEL _cmd = NSSelectorFromString(@#selectorName); \
    __block returnType (*originalImpl)(id, SEL, t0, t1, t2) = NULL; \
    __auto_type replacement = ^(id self, DECL_ARGS(t0, t1, t2)) { \
        returnType (^orig)(t0, t1, t2) = ^returnType(t0 a0, t1 a1, t2 a2) { \
            return originalImpl(self, _cmd, a0, a1, a2); \
        }; \
        block \
    }; \
    IMP newImplementation = imp_implementationWithBlock(replacement); \
    hookInstance(instance, _cmd, newImplementation, (IMP *)&originalImpl); \
} while (0)

// Hook instance with 4 arguments
#define HOOK_INSTANCE_4(instance, selectorName, returnType, t0, t1, t2, t3, block) \
do { \
    __block SEL _cmd = NSSelectorFromString(@#selectorName); \
    __block returnType (*originalImpl)(id, SEL, t0, t1, t2, t3) = NULL; \
    __auto_type replacement = ^(id self, DECL_ARGS(t0, t1, t2, t3)) { \
        returnType (^orig)(t0, t1, t2, t3) = ^returnType(t0 a0, t1 a1, t2 a2, t3 a3) { \
            return originalImpl(self, _cmd, a0, a1, a2, a3); \
        }; \
        block \
    }; \
    IMP newImplementation = imp_implementationWithBlock(replacement); \
    hookInstance(instance, _cmd, newImplementation, (IMP *)&originalImpl); \
} while (0)

// Hook instance with 5 arguments
#define HOOK_INSTANCE_5(instance, selectorName, returnType, t0, t1, t2, t3, t4, block) \
do { \
    __block SEL _cmd = NSSelectorFromString(@#selectorName); \
    __block returnType (*originalImpl)(id, SEL, t0, t1, t2, t3, t4) = NULL; \
    __auto_type replacement = ^(id self, DECL_ARGS(t0, t1, t2, t3, t4)) { \
        returnType (^orig)(t0, t1, t2, t3, t4) = ^returnType(t0 a0, t1 a1, t2 a2, t3 a3, t4 a4) { \
            return originalImpl(self, _cmd, a0, a1, a2, a3, a4); \
        }; \
        block \
    }; \
    IMP newImplementation = imp_implementationWithBlock(replacement); \
    hookInstance(instance, _cmd, newImplementation, (IMP *)&originalImpl); \
} while (0)

// Hook instance with 6 arguments
#define HOOK_INSTANCE_6(instance, selectorName, returnType, t0, t1, t2, t3, t4, t5, block) \
do { \
    __block SEL _cmd = NSSelectorFromString(@#selectorName); \
    __block returnType (*originalImpl)(id, SEL, t0, t1, t2, t3, t4, t5) = NULL; \
    __auto_type replacement = ^(id self, DECL_ARGS(t0, t1, t2, t3, t4, t5)) { \
        returnType (^orig)(t0, t1, t2, t3, t4, t5) = ^returnType(t0 a0, t1 a1, t2 a2, t3 a3, t4 a4, t5 a5) { \
            return originalImpl(self, _cmd, a0, a1, a2, a3, a4, a5); \
        }; \
        block \
    }; \
    IMP newImplementation = imp_implementationWithBlock(replacement); \
    hookInstance(instance, _cmd, newImplementation, (IMP *)&originalImpl); \
} while (0)

// Hook instance with 7 arguments
#define HOOK_INSTANCE_7(instance, selectorName, returnType, t0, t1, t2, t3, t4, t5, t6, block) \
do { \
    __block SEL _cmd = NSSelectorFromString(@#selectorName); \
    __block returnType (*originalImpl)(id, SEL, t0, t1, t2, t3, t4, t5, t6) = NULL; \
    __auto_type replacement = ^(id self, DECL_ARGS(t0, t1, t2, t3, t4, t5, t6)) { \
        returnType (^orig)(t0, t1, t2, t3, t4, t5, t6) = ^returnType(t0 a0, t1 a1, t2 a2, t3 a3, t4 a4, t5 a5, t6 a6) { \
            return originalImpl(self, _cmd, a0, a1, a2, a3, a4, a5, a6); \
        }; \
        block \
    }; \
    IMP newImplementation = imp_implementationWithBlock(replacement); \
    hookInstance(instance, _cmd, newImplementation, (IMP *)&originalImpl); \
} while (0)

// Hook instance with 8 arguments
#define HOOK_INSTANCE_8(instance, selectorName, returnType, t0, t1, t2, t3, t4, t5, t6, t7, block) \
do { \
    __block SEL _cmd = NSSelectorFromString(@#selectorName); \
    __block returnType (*originalImpl)(id, SEL, t0, t1, t2, t3, t4, t5, t6, t7) = NULL; \
    __auto_type replacement = ^(id self, DECL_ARGS(t0, t1, t2, t3, t4, t5, t6, t7)) { \
        returnType (^orig)(t0, t1, t2, t3, t4, t5, t6, t7) = ^returnType(t0 a0, t1 a1, t2 a2, t3 a3, t4 a4, t5 a5, t6 a6, t7 a7) { \
            return originalImpl(self, _cmd, a0, a1, a2, a3, a4, a5, a6, a7); \
        }; \
        block \
    }; \
    IMP newImplementation = imp_implementationWithBlock(replacement); \
    hookInstance(instance, _cmd, newImplementation, (IMP *)&originalImpl); \
} while (0)

// Hook instance with 9 arguments
#define HOOK_INSTANCE_9(instance, selectorName, returnType, t0, t1, t2, t3, t4, t5, t6, t7, t8, block) \
do { \
    __block SEL _cmd = NSSelectorFromString(@#selectorName); \
    __block returnType (*originalImpl)(id, SEL, t0, t1, t2, t3, t4, t5, t6, t7, t8) = NULL; \
    __auto_type replacement = ^(id self, DECL_ARGS(t0, t1, t2, t3, t4, t5, t6, t7, t8)) { \
        returnType (^orig)(t0, t1, t2, t3, t4, t5, t6, t7, t8) = ^returnType(t0 a0, t1 a1, t2 a2, t3 a3, t4 a4, t5 a5, t6 a6, t7 a7, t8 a8) { \
            return originalImpl(self, _cmd, a0, a1, a2, a3, a4, a5, a6, a7, a8); \
        }; \
        block \
    }; \
    IMP newImplementation = imp_implementationWithBlock(replacement); \
    hookInstance(instance, _cmd, newImplementation, (IMP *)&originalImpl); \
} while (0)

// Hook instance with 10 arguments
#define HOOK_INSTANCE_10(instance, selectorName, returnType, t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, block) \
do { \
    __block SEL _cmd = NSSelectorFromString(@#selectorName); \
    __block returnType (*originalImpl)(id, SEL, t0, t1, t2, t3, t4, t5, t6, t7, t8, t9) = NULL; \
    __auto_type replacement = ^(id self, DECL_ARGS(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9)) { \
        returnType (^orig)(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9) = ^returnType(t0 a0, t1 a1, t2 a2, t3 a3, t4 a4, t5 a5, t6 a6, t7 a7, t8 a8, t9 a9) { \
            return originalImpl(self, _cmd, a0, a1, a2, a3, a4, a5, a6, a7, a8, a9); \
        }; \
        block \
    }; \
    IMP newImplementation = imp_implementationWithBlock(replacement); \
    hookInstance(instance, _cmd, newImplementation, (IMP *)&originalImpl); \
} while (0)

// Example usage with both styles:
/*
// Traditional style
HOOK_INSTANCE(myObject, setValue:forKey:, void, NSString*, NSString*, {
    NSLog(@"Setting value %@ for key %@", arg0, arg1);
    orig(arg0, arg1);
});

// With SIGNATURE macro for cleaner look
HOOK_INSTANCE(myObject, setValue:forKey:, SIGNATURE(void, NSString*, NSString*), {
    NSLog(@"Setting value %@ for key %@", arg0, arg1);
    orig(arg0, arg1);
});

// No arguments
HOOK_INSTANCE(myObject, doSomething, SIGNATURE(void), {
    NSLog(@"doSomething called");
    orig();
});

// One argument
HOOK_INSTANCE(otherIHview.layer, setBackgroundColor:, SIGNATURE(void, CGColorRef), {
    NSLog(@"otherIHview.layer setBackgroundColor: hooked");
    orig(arg0);
});

// Many arguments
HOOK_INSTANCE(myObject, methodWithManyArgs:arg1:arg2:arg3:arg4:arg5:arg6:arg7:arg8:arg9:,
              SIGNATURE(void, int, float, double, char*, NSString*, NSNumber*, NSArray*, NSDictionary*, id, BOOL), {
    NSLog(@"Called with 10 arguments: %d %f %f %s %@ %@ %@ %@ %@ %d",
          arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
    orig(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
});
*/

Class clsHook(id self, SEL _cmd){

    NSMutableString* className = [NSString stringWithCString:class_getName(object_getClass(self))];
    NSMutableString* baseClassName = className;
    
    if([className containsString:@"_instanceHook_"]){
        baseClassName = [NSMutableString stringWithString:[[className componentsSeparatedByString:@"_instanceHook_"] objectAtIndex:0]];
    }
    
    return objc_getClass(baseClassName.cString);

}

void hookInstance(id instance, SEL targetSEL, IMP replacementFp, IMP* origFp) {
    
    const char* replacementClassName = [[NSString stringWithFormat:@"%@_instanceHook_", object_getClass(instance)] stringByAppendingString:[[NSUUID UUID] UUIDString]].cString;
    
    Class replacementClass = objc_allocateClassPair(object_getClass(instance), replacementClassName, 0);
    objc_registerClassPair(replacementClass);
    
    Method origMethod = class_getInstanceMethod(object_getClass(instance), targetSEL);
    
    if(origFp != NULL)
    *origFp = method_getImplementation(origMethod);
    
    const char* typenc = method_getTypeEncoding(origMethod);
        
    class_replaceMethod(replacementClass, targetSEL, replacementFp, typenc);

    //lie about the class
    class_replaceMethod(replacementClass, @selector(class), (IMP)clsHook, "#16@0:8");
 
    //apply hook
    object_setClass(instance, replacementClass);
}

//------------------TEST BEGIN--------------------------

void (*sbgcOrigOld)(id _self, SEL cmd, struct CGColor* color);
void (*sbcOrigOld)(id _self, SEL cmd, CGColorRef clr);


void sbgcHook(id _self, SEL cmd, struct CGColor* color){
    
    
    sbgcOrigOld(_self, cmd, NSColor.yellowColor.CGColor);

   
}

void sbgcHook2(id _self, SEL cmd, struct CGColor* color){
    
    
    sbgcOrigOld(_self, cmd, NSColor.cyanColor.CGColor);

   
}

void sbcHook(id _self, SEL cmd, CGColorRef clr){
    
    
    sbcOrigOld(_self, cmd, NSColor.greenColor.CGColor);
    
}


int main(int argc, const char * argv[]) {        // Create the NSApplication instance
        NSApplication* app = [NSApplication sharedApplication];

        // Create the window with the specified frame size
        NSWindow* win = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 600, 800)
                                                    styleMask:(NSWindowStyleMaskResizable | NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable)
                                                      backing:NSBackingStoreBuffered
                                                        defer:NO];

        // Make the window the key window
        [win makeKeyAndOrderFront:nil];
        
        NSViewController* vc = [NSViewController new];
        
        win.contentViewController = vc;
        
        NSView* IHview = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 150, 200)];
        IHview.wantsLayer = YES;
        
        NSView* otherIHview = [[NSView alloc] initWithFrame:NSMakeRect(150, 200, 150, 200)];
        otherIHview.wantsLayer = YES;
        
        NSView* otherview = [[NSView alloc] initWithFrame:NSMakeRect(150, 0, 150, 200)];
        otherview.wantsLayer = YES;
        
      //  hookInstance(IHview.layer, @selector(setBorderColor:), (IMP)sbcHook, (IMP*)&sbcOrigOld);

     //   hookInstance(IHview.layer, @selector(setBackgroundColor:), (IMP)sbgcHook, (IMP*)&sbgcOrigOld);
       // hookInstance(IHview.layer, @selector(setBackgroundColor:), (IMP)sbgcHook2, (IMP*)&sbgcOrigOld);

        //hookInstance(otherIHview.layer, @selector(setBackgroundColor:), (IMP)sbgcHook, (IMP*)&sbgcOrigOld);
        
        HOOK_INSTANCE(otherIHview, addToolTipRect:owner:userData:, SIGNATURE(NSToolTipTag, NSRect, id, void*), {
            NSLog(@"otherIHview.layer setBackgroundColor: hooked");
            //arg0 = NSColor.purpleColor.CGColor;
            orig(arg0, arg1, arg2);
        });
        
      //  NSLog(@"cn:%@\n", [IHview.layer class]);
        
        otherIHview.layer.backgroundColor = [NSColor.redColor CGColor];
        otherview.layer.backgroundColor = [NSColor.blueColor CGColor];
        IHview.layer.backgroundColor = [NSColor.blueColor CGColor];

        
        IHview.layer.borderWidth = 10;
        IHview.layer.borderColor = NSColor.magentaColor.CGColor;

        [win.contentView addSubview:IHview];
        [win.contentView addSubview:otherIHview];
        [win.contentView addSubview:otherview];

        // Run the application event loop
        [app run];

    return 0;
}

