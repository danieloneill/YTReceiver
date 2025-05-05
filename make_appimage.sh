#!/bin/sh

BUILTBINARY=./build/ytreceiver
HOST_ARCH=x86_64

set -e

rm -R /tmp/YTReceiver-AppDir || true
mkdir /tmp/YTReceiver-AppDir

# This is gross:
BORKED=/tmp/linuxdeploy-${HOST_ARCH}.AppImage
if [ ! -f linuxdeploy-${HOST_ARCH}.AppImage ]; then
	wget -O ${BORKED} https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-${HOST_ARCH}.AppImage
	chmod +x ${BORKED}
	
	#${BORKED} --appimage-extract
	#rm squashfs-root/usr/bin/strip
	#squashfs-root/plugins/linuxdeploy-plugin-appimage/appimagetool-prefix/usr/bin/appimagetool -gn squashfs-root/
	#rm -r squashfs-root
	cp ${BORKED} .
fi

if [ ! -f linuxdeploy-plugin-qt-${HOST_ARCH}.AppImage ]; then
	wget -O linuxdeploy-plugin-qt-${HOST_ARCH}.AppImage "https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-${HOST_ARCH}.AppImage"
	chmod +x linuxdeploy-plugin-qt-${HOST_ARCH}.AppImage
fi

if [ ! -f appimagetool-${HOST_ARCH}.AppImage ]; then
	wget -O appimagetool-${HOST_ARCH}.AppImage "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-${HOST_ARCH}.AppImage"
	chmod +x appimagetool-${HOST_ARCH}.AppImage
fi

# This is b0rxed at the moment:
#linuxdeploy-${HOST_ARCH}.AppImage --appdir /tmp/YTReceiver-AppDir --executable ${BUILTBINARY} --plugin qt --output appimage

cp -Rad appimage-data/* /tmp/YTReceiver-AppDir/
ln -s usr/bin/ytreceiver /tmp/YTReceiver-AppDir/AppRun

# Hack to force linuxdeploy-plugin-qt to include webenginequick:
cp Main.qml /tmp/YTReceiver-AppDir/

EXTRA_PLATFORM_PLUGINS="libqwayland-egl.so;libqwayland-generic.so" \
NO_STRIP=true \
EXTRA_QT_MODULES="webenginecore;waylandcompositor;webenginequick;webenginequickdelegatesqml" \
	./linuxdeploy-${HOST_ARCH}.AppImage --appdir /tmp/YTReceiver-AppDir --executable ${BUILTBINARY} --plugin qt --output appimage
#rm ./linuxdeploy-${HOST_ARCH}.AppImage

rm /tmp/YTReceiver-AppDir/Main.qml

appimagetool-${HOST_ARCH}.AppImage /tmp/YTReceiver-AppDir
rm -R /tmp/YTReceiver-AppDir
