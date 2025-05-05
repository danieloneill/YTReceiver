# YTReceiver

A dead simple QML app for receiving "Cast to TV" from an Android/iOS device

Based on the concept of [Youtube Cast Receiver (YCR)](https://github.com/marcomow/youtube-cast-receiver), and snaking the user-agent value (and these docs/screenshots) from that project too.

## Linking your device

### 1: Open the application and click the settings icon

![step1](https://i.imgur.com/WLl57WN.png)

### 2: Click "LINK WITH TV CODE"

![step2](https://i.imgur.com/J0Awy33.png)

### 3: Note the TV code on your screen

![step3](https://i.imgur.com/bhmCurr.png)

### 4: Open the Youtube app on your smartphone and click your photo in the top right

<img src="https://i.imgur.com/wcA32XI.png" height="500px">

### 5: Tap "Settings"

<img src="https://i.imgur.com/wcA32XI.png" height="500px">

### 6: Tap "Watch on TV"

<img src="https://i.imgur.com/TrBpOjk.png" height="500px">

### 7: Tap "Enter TV code"

<img src="https://i.imgur.com/2kEBacS.png" height="500px">

### 8: Enter the code on your computer screen in the box and press "Link"

<img src="https://i.imgur.com/gCKYXlz.png" height="500px">

## Building

Clone this repository, then do something like this:

```bash
$ cd YTReceiver
$ mkdir build
$ cd build
$ qmake6 ..
$ make -j12
$ ./ytreceiver
```

There's no magic in it. This can be run directly inside qml6 without having to compile diddly-squat:
```bash
$ cd YTReceiver
$ qml6 Main.qml
```

## AppImage

To make an AppImage, a bash script is provided called `make_appimage.sh` which makes several assumptions:

* You built it using the instructions above, specifically in the `build` directory.
* You are on a BSD/Linux system with access to create/delete stuff in /tmp
* You have squashfs tools installed
* You have wget
* You are building on x86_64<sup>1</sup>
* You want Wayland support<sup>2</sup>

<sup>1</sup> If you aren't on x86_64 change `HOST_ARCH` to your arch at the top of the script. Check which architectures are available at the [linuxdeploy-plugin-qt releases page](https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/tag/continuous).

<sup>2</sup> Wayland support (as I understand it) may not work on all distros at the moment. Just edit those environment variables and remove those if you want to stick with only xcb.

This script also instructs linuxdeploy to not strip binaries/libraries, because (on my system) it is currently (2025-05-05) broken.

This script is also clearly my first attempt at using AppImage. We're learnding.
