This is SDL2 2.0.6, patched with Thomas Bernard's SDL2-2.0.6_OSX_104.patch. Additionally, the file 'src/video/cocoa/SDL_cocoakeyboard.m' has been reverted to how it was in SDL2 2.0.3 to fix keyboard letter keys. 

This will most likely be merged with https://github.com/alex-free/panther_sdl2 once full screen works correctly. SDL2 apps linked against this that go full screen will only maximize the window, not hide the menu bar and actually go full screen like SDL2 2.0.3.

To build:

./configure --disable-joystick --disable-haptic --without-x
sudo make install
