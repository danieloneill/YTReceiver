import QtQuick

import QtWebEngine
import QtQuick.Dialogs

Window {
    id: youtubeThing
    width: 640
    height: 480
    visible: true
    title: qsTr("YTReceiver")

    flags: Qt.Window | Qt.WindowFullscreenButtonHint
    visibility: Window.FullScreen

    WebEngineView {
        id: webview
        anchors.fill: parent

        profile {
            offTheRecord: false
            storageName: 'YTReceiver'
            persistentCookiesPolicy: WebEngineProfile.ForcePersistentCookies
            httpCacheType: WebEngineProfile.DiskHttpCache
            httpUserAgent: "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36; Youtube ; Tizen 4.0"
        }
        settings {
            localStorageEnabled: true
            pluginsEnabled: true
            webGLEnabled: true
            showScrollBars: false
        }
        onFullScreenRequested: function(req) {
            req.accept();
        }
        onFeaturePermissionRequested: function(securityOrigin, feature) {
            let title = 'Feature Request';
            let text = 'Dunnae';

            return grantFeaturePermission(securityOrigin, feature, true);

            switch(feature) {
            case WebEngineView.Geolocation:
                title = qsTr('Geolocation Request');
                text = qsTr('Website wants access to your location. Okae?');
                break;
            case WebEngineView.MediaAudioCapture:
                title = qsTr('Mic Request');
                text = qsTr('Website wants access to your microphone. Okae?');
                break;
            case WebEngineView.MediaVideoCapture:
                title = qsTr('Video Request');
                text = qsTr('Website wants access to your webcam. Okae?');
                break;
            case WebEngineView.MediaAudioVideoCapture:
                title = qsTr('Mic/Video Request');
                text = qsTr('Website wants access to capture audio and video. Okae?');
                break;
            case WebEngineView.DesktopVideoCapture:
                title = qsTr('Desktop Capture Request');
                text = qsTr('Website wants access to capture your desktop video. Okae?');
                break;
            case WebEngineView.DesktopAudioVideoCapture:
                title = qsTr('Desktop A/V Request');
                text = qsTr('Website wants access to capture your desktop audio and video. Okae?');
                break;
            default:
                grantFeaturePermission(securityOrigin, feature, false);
                return;
            }

            youtubeThing.ask(title, text, function(onoff) {
                grantFeaturePermission(securityOrigin, feature, onoff);
            });
        }

        url: 'http://youtube.com/tv'
    }

    function ask(title, text, cb) {
        let w = dialogueComponent.createObject(youtubeThing, { 'title':title, 'text':text } );
        w.yes.connect( function() {
            w.close();
            delete w;
            cb(true);
        } );
        w.no.connect( function() {
            w.close();
            delete w;
            cb(false);
        } );
        w.open();
    }

    Component {
        id: dialogueComponent

        MessageDialog {
            id: askDialogue
            buttons: MessageDialog.Yes | MessageDialog.No
            text: qsTr("Allow?")
        }
    }
}
