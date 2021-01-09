This is SDL2 2.0.6, patched with Thomas Bernard's SDL2-2.0.6_OSX_104.patch. Additionally, the file 'src/video/cocoa/SDL_cocoakeyboard.m' has been reverted to how it was in SDL2 2.0.3 to fix keyboard letter keys. 

This will not likely be merged with https://github.com/alex-free/panther_sdl2 since some of the audio APIs are truely Leopard+ only.
To build:

./configure --disable-joystick --disable-haptic --without-x
sudo make install
