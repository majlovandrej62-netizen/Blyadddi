#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/sysctl.h>
#import <sys/ptrace.h>
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <string.h>

%hookf(void, exit, int status) {
    NSLog(@"[Bypass] Blocked exit call with status: %d", status);
}

%hookf(void, _exit, int status) {
    NSLog(@"[Bypass] Blocked _exit call with status: %d", status);
}

%hookf(int, ptrace, int request, pid_t pid, caddr_t addr, int data) {
    if (request == 31) { 
        return 0;
    }
    return %orig;
}

%hookf(const char*, _dyld_get_image_name, uint32_t image_index) {
    const char* name = %orig;
    if (name && (strstr(name, "Bypass") || strstr(name, "Cheat") || strstr(name, "H5GG") || strstr(name, "substrate"))) {
        return "/usr/lib/libSystem.B.dylib"; 
    }
    return name;
}
