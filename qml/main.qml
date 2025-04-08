/*
Copyright

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick
import QtQuick.Controls

import "app"


ApplicationWindow {
    id: root

    width: 1280
    height: 720
    // Use platform detection to set appropriate flags
    flags: (Qt.platform.os === "osx" || Qt.platform.os === "macos") 
           ? Qt.Window  // On macOS, let native code handle window decoration
           : Qt.FramelessWindowHint | Qt.Window  // Standard frameless for other platforms
    visible: true
    
    // Property to detect macOS platform
    readonly property bool isMacOS: Qt.platform.os === "osx" || Qt.platform.os === "macos"

    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    SpotFetchMainPage {
        id: mainPage
        appWindow: _shared

        anchors {
            fill: root.contentItem
            // No top margin on macOS to eliminate the gap under the header
            topMargin: isMacOS ? 0 : _private.windowBorder
            leftMargin: _private.windowBorder
            rightMargin: _private.windowBorder
            bottomMargin: _private.windowBorder
        }
    }

    Component.onCompleted: {
        // load language from settings
        // Qt.uiLanguage = ...
    }

    QtObject {
        id: _private  // Implementation details not exposed to child items

        readonly property bool maximized: root.visibility === Window.Maximized
        readonly property bool fullscreen: root.visibility === Window.FullScreen
        readonly property int windowBorder: fullscreen || maximized ? 0 : 1
    }

    QtObject {
        id: _shared  // Properties and functions exposed to child items

        readonly property var visibility: root.visibility

        function startSystemMove() {
            root.startSystemMove()
        }

        function showMinimized() {
            root.showMinimized()
        }

        function showMaximized() {
            root.showMaximized()
        }

        function showNormal() {
            root.showNormal()
        }

        function close() {
            root.close()
        }
    }
}
