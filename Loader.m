#import <Modulous/Loader.h>
#import <Modulous/Module.h>

#import <dlfcn.h>

@implementation ModulousLoader
@synthesize _modules;

+ (instancetype)loaderWithURL:(NSURL *)url {
    // 创建新实例
    ModulousLoader* loader = [self new];
    // 初始化实例
    [loader _loadBundlesFromURL:url];
    // 返回实例
    return loader;
}

+ (instancetype)loaderWithPath:(NSString *)path {
    // 将 NSString 路径转换为 NSURL
    NSURL* file_url = [NSURL fileURLWithPath:path isDirectory:YES];
    // 调用 loaderWithURL 方法加载模块
    return [self loaderWithURL:file_url];
}

- (void)_loadBundlesFromURL:(NSURL *)url {
    // 扫描目录获取所有 bundle URL
    NSArray<NSURL *>* bundle_urls = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:url includingPropertiesForKeys:@[] options:0 error:nil];

    // 只有当bundle_urls不为nil时才继续处理
    if(bundle_urls) {
        // 创建可变字典,键是bundleIdentifier,值是ModulousModule对象
        NSMutableDictionary<NSString *, ModulousModule *>* modules = [NSMutableDictionary new];

        for(NSURL* bundle_url in bundle_urls) {
            // 调用 ModulousModule 的创建模块实例
            ModulousModule* module = [ModulousModule bundleWithURL:bundle_url];

            if(module && [module bundleIdentifier]) {
                // 检查重复标识符
                if([modules objectForKey:[module bundleIdentifier]]) {
                    NSLog(@"[ModulousLoader] warning: skipping duplicate bundle identifier %@", [module bundleIdentifier]);
                    continue;
                }

                // if(!dlopen_preflight([[module executablePath] fileSystemRepresentation])) {
                //     NSLog(@"[ModulousLoader] warning: dlopen_preflight failed on bundle identifier %@", [module bundleIdentifier]);
                //     continue;
                // }

                // 存储有效模块
                [modules setObject:module forKey:[module bundleIdentifier]];
            }
        }
        // 将可变字典转为不可变字典
        // 赋值给_modules属性
        _modules = [modules copy];
    }
}

// 获取所有模块信息的方法
- (NSArray<NSDictionary *> *)getModuleInfo {
    // 创建可变数组用于存储结果
    NSMutableArray<NSDictionary *>* infos = [NSMutableArray new];

    // 遍历所有模块
    [_modules enumerateKeysAndObjectsUsingBlock:^(NSString* key, ModulousModule* module, BOOL* stop) {
        // 获取每个模块的信息字典
        NSDictionary* info = [module infoDictionary];

        // 如果信息有效,添加到数组
        if(info) {
            [infos addObject:info];
        }
    }];

    // 返回不可变副本
    return [infos copy];
}

// 获取指定标识符模块信息的方法
- (NSArray<NSDictionary *> *)getModuleInfoWithIdentifers:(NSArray<NSString *> *)identifiers {
    NSMutableArray<NSDictionary *>* infos = [NSMutableArray new];

    for(NSString* identifier in identifiers) {
        ModulousModule* module = [_modules objectForKey:identifier];

        if(module) {
            NSDictionary* info = [module infoDictionary];

            if(info) {
                [infos addObject:info];
            }
        }
    }

    return [infos copy];
}

// 加载所有模块
- (void)loadModules {
    [_modules enumerateKeysAndObjectsUsingBlock:^(NSString* key, ModulousModule* module, BOOL* stop) {
        [module loadModule];
    }];
}

// 加载指定标识符的模块
- (void)loadModulesWithIdentifiers:(NSArray<NSString *> *)identifiers {
    for(NSString* identifier in identifiers) {
        ModulousModule* module = [_modules objectForKey:identifier];

        if(module) {
            [module loadModule];
        }
    }
}

// 初始化方法
- (instancetype)init {
    if((self = [super init])) {
        _modules = @{};
    }

    return self;
}
@end
