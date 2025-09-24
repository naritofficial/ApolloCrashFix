#import <mach-o/dyld.h>

#import <Foundation/Foundation.h>
#import "substrate.h"

%ctor
{
	char execPath[PATH_MAX];
	uint32_t execPathSize = PATH_MAX;
	_NSGetExecutablePath(execPath, &execPathSize);

	uint64_t mainExecSlide = 0;
	for (int i = 0; i < _dyld_image_count(); i++) {
		if (!strcmp(_dyld_get_image_name(i), execPath)) {
			mainExecSlide = _dyld_get_image_vmaddr_slide(i);
			break;
		}
	}

	void *textPtr1 = (void *)(mainExecSlide + 0x1001e3040);
	void *textPtr2 = (void *)(mainExecSlide + 0x1001e3048);
	void *textPtr3 = (void *)(mainExecSlide + 0x1001de6f8);

	void *textPtr4 = (void *)(mainExecSlide + 0x1001de478);
	
	// IMPORTANT NOTE:
	// Do NOT try to investigate why these patches work
	// Even I have no clue, because Swift is horrible
	// Honestly, fuck Swift
	// I blindly debugged the binary and determined what branches lead to the crash
	// Then I randomly nopped out shit and changed branches until it didn't crash anymore
	// (I legitimately cannot tell if the binary is heavily obfuscated or it's just Swift being Swift, lol...)

	uint32_t nopInsn = 0xd503201f;

	MSHookMemory(textPtr1, &nopInsn, sizeof(nopInsn));
	MSHookMemory(textPtr2, &nopInsn, sizeof(nopInsn));
	MSHookMemory(textPtr3, &nopInsn, sizeof(nopInsn));

	uint32_t replInsn = 0x14000071;
	MSHookMemory(textPtr4, &replInsn, sizeof(replInsn));
}


%hook NSUserDefaults

- (NSString *)stringForKey:(NSString *)key
{
	// Yeah, this one is even weirder, I told you to not investigate further :P
	if ([key isEqualToString:@"awesome_notifications"]) {
		return @"wtf";
	}
	return %orig;
}

%end