#!/bin/sh

BUILTBINARY=./build/ytreceiver

set -e

rm -R /tmp/YTReceiver-AppDir || true
mkdir /tmp/YTReceiver-AppDir

# This is gross:
BORKED=/tmp/linuxdeploy-x86_64.AppImage
if [ ! -f linuxdeploy-x86_64.AppImage ]; then
	wget -O ${BORKED} https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
	chmod +x ${BORKED}
	
	#${BORKED} --appimage-extract
	#rm squashfs-root/usr/bin/strip
	#squashfs-root/plugins/linuxdeploy-plugin-appimage/appimagetool-prefix/usr/bin/appimagetool -gn squashfs-root/
	#rm -r squashfs-root
	cp ${BORKED} .
fi

if [ ! -f linuxdeploy-plugin-qt-x86_64.AppImage ]; then
	wget -O linuxdeploy-plugin-qt-x86_64.AppImage "https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage"
	chmod +x linuxdeploy-plugin-qt-x86_64.AppImage
fi

if [ ! -f appimagetool-x86_64.AppImage ]; then
	wget -O appimagetool-x86_64.AppImage "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"
	chmod +x appimagetool-x86_64.AppImage
fi

# This is b0rxed at the moment:
#linuxdeploy-x86_64.AppImage --appdir /tmp/YTReceiver-AppDir --executable ${BUILTBINARY} --plugin qt --output appimage

cp -Rad appimage-data/* /tmp/YTReceiver-AppDir/
ln -s usr/bin/ytreceiver /tmp/YTReceiver-AppDir/AppRun

# Hack to force linuxdeploy-plugin-qt to include webenginequick:
cp Main.qml /tmp/YTReceiver-AppDir/

EXTRA_PLATFORM_PLUGINS="libqwayland-egl.so;libqwayland-generic.so" \
NO_STRIP=true \
EXTRA_QT_MODULES="webenginecore;waylandcompositor;webenginequick;webenginequickdelegatesqml" \
	./linuxdeploy-x86_64.AppImage --appdir /tmp/YTReceiver-AppDir --executable ${BUILTBINARY} --plugin qt --output appimage
#rm ./linuxdeploy-x86_64.AppImage

rm /tmp/YTReceiver-AppDir/Main.qml

appimagetool-x86_64.AppImage /tmp/YTReceiver-AppDir
rm -R /tmp/YTReceiver-AppDir
