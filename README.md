# Info 
This is a single header library that exposes a function to hook a method of a specific instance (as opposed to other hooking functions which hook the class itself)

# Usage

```objc
void hookInstance(id instance, SEL targetSEL, IMP replacementFp, IMP* origFp) 

instance: the instance you want to hook
targetSEL: selector for the method you want to hook
replacementFp: function pointer to the replacement function
origFp: address of a function pointer that will be filled in with a stub which may be used to call the original implementation. This can be NULL if you don't wish to use original implementation
```
Using with the same instance multiple times is supported, you can do this to hook multiple methods.

There is an example for the usage in "example" branch, as a tip; it is designed to be similiar with `MSHookMessageEx` function

# Update: HOOK_INSTANCE macro
I have added a convenient to use c macro that creates the function pointers for you, see below for usage.

```objc

HOOK_INSTANCE(instance, selectorName, retType, argTypes..., block)

instance: the instance you want to hook
selectorName: name of the selector, not a string. mySelector: is correct "mySelector:" is wrong
retType: return type of the method. 
argTypes...: types of arguments, upto 10 arguments are supported
block: c block of the implementation you want to hook with. you can use arguments starting from arg0 going to arg9, you can call the original implementation by calling orig(args);
```

Some examples here:
```objc
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
```


# How it works
It is creating a new class everytime you call the function, replaces the target method of it and uses `object_setClass` on the instance with that class to apply the hook












