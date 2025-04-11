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
import QtQuick.Layouts

import pyobjects

import "../header"


Page {
    id: root

    required property var appWindow

    anchors {
        fill: root
    }

    header: SpotFetchHeader {
        appWindow: root.appWindow
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        Label {
            text: Qt.application.name + ' (' + Qt.application.version + ')'
            font {
                bold: true
                pixelSize: Qt.application.font.pixelSize * 1.2
            }
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10
        }

        TabBar {
            id: tabBar
            Layout.fillWidth: true
            
            TabButton {
                text: qsTr("Download")
            }
            TabButton {
                text: qsTr("Active Downloads")
            }
            TabButton {
                text: qsTr("History")
            }
        }

        StackLayout {
            currentIndex: tabBar.currentIndex
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            // Download Tab
            SpotFetchDownloadTab {
                id: downloadTab
            }
            
            // Active Downloads Tab
            SpotFetchActiveDownloadsTab {
                id: activeDownloadsTab
            }
            
            // History Tab
            SpotFetchHistoryTab {
                id: historyTab
            }
        }
    }
}
