#import <Modulous/Module.h>
#import <dlfcn.h>

@implementation ModulousModule

// 加载模块
- (BOOL)loadModule {
    if(_handle) {
        // already loaded
        return YES;
    }

    // 获取当前模块的可执行文件路径
    NSString* module_executable = [self executablePath];

    if(module_executable) {
        // 在运行时动态加载可执行文件本身
        _handle = dlopen([module_executable fileSystemRepresentation], RTLD_LAZY);

        if(_handle) {
            NSLog(@"[Modulous] module '%@' loaded", [self bundleIdentifier]);
            return YES;
        }
    }

    return NO;
}

// 初始化模块
- (instancetype)init {
    if((self = [super init])) {
        _handle = NULL;
    }

    return self;
}

@end
