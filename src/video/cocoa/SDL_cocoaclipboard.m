/*
  Simple DirectMedia Layer
  Copyright (C) 1997-2017 Sam Lantinga <slouken@libsdl.org>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
*/
#include "../../SDL_internal.h"

#if SDL_VIDEO_DRIVER_COCOA

#include "SDL_cocoavideo.h"
#include "../../events/SDL_clipboardevents_c.h"

static NSString *
GetTextFormat(_THIS)
{
#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1060
    if (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_5) {
        return NSPasteboardTypeString;
    } else {
#endif
        return NSStringPboardType;
#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1060
    }
#endif
}

int
Cocoa_SetClipboardText(_THIS, const char *text)
#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
{ @autoreleasepool
{
#else
{   NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
#endif
    SDL_VideoData *data = (SDL_VideoData *) _this->driverdata;
    NSPasteboard *pasteboard;
#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1060
    NSString *format = NSPasteboardTypeString;
#else
    NSString *format = GetTextFormat(_this);
#endif

    pasteboard = [NSPasteboard generalPasteboard];
    data->clipboard_count = [pasteboard declareTypes:[NSArray arrayWithObject:format] owner:nil];
    [pasteboard setString:[NSString stringWithUTF8String:text] forType:format];

#if MAC_OS_X_VERSION_MIN_REQUIRED < 1070
    [pool release];
#endif
    return 0;
#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
}}
#else
}
#endif

char *
Cocoa_GetClipboardText(_THIS)
#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
{ @autoreleasepool
{
#else
{   NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
#endif
    NSPasteboard *pasteboard;
#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1060
    NSString *format = NSPasteboardTypeString;
#else
    NSString *format = GetTextFormat(_this);
#endif
    NSString *available;
    char *text;

    pasteboard = [NSPasteboard generalPasteboard];
    available = [pasteboard availableTypeFromArray:[NSArray arrayWithObject:format]];
    if ([available isEqualToString:format]) {
        NSString* string;
        const char *utf8;

        string = [pasteboard stringForType:format];
        if (string == nil) {
            utf8 = "";
        } else {
            utf8 = [string UTF8String];
        }
        text = SDL_strdup(utf8);
    } else {
        text = SDL_strdup("");
    }

#if MAC_OS_X_VERSION_MIN_REQUIRED < 1070
    [pool release];
#endif
    return text;
#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
}}
#else
}
#endif

SDL_bool
Cocoa_HasClipboardText(_THIS)
{
    SDL_bool result = SDL_FALSE;
    char *text = Cocoa_GetClipboardText(_this);
    if (text) {
        result = text[0] != '\0' ? SDL_TRUE : SDL_FALSE;
        SDL_free(text);
    }
    return result;
}

void
Cocoa_CheckClipboardUpdate(struct SDL_VideoData * data)
#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
{ @autoreleasepool
{
#else
{   NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
#endif
    NSPasteboard *pasteboard;
    NSInteger count;

    pasteboard = [NSPasteboard generalPasteboard];
    count = [pasteboard changeCount];
    if (count != data->clipboard_count) {
        if (data->clipboard_count) {
            SDL_SendClipboardUpdate();
        }
        data->clipboard_count = count;
    }
#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
}}
#else
    [pool release];
}
#endif

#endif /* SDL_VIDEO_DRIVER_COCOA */

/* vi: set ts=4 sw=4 expandtab: */
