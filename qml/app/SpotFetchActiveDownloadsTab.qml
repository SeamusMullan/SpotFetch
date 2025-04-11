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

Item {
    id: root

    // Property to store active downloads - this would be populated from the backend
    // For now, using a dummy model for display purposes
    property var activeDownloadsModel: ListModel {
        id: dummyDownloadsModel
        
        ListElement {
            title: "Bohemian Rhapsody"
            artist: "Queen"
            progress: 75
            downloadSpeed: "1.2 MB/s"
            timeRemaining: "0:45"
            sourceUrl: "https://open.spotify.com/track/7tFiyTwD0nx5a1eklYtX2J"
            size: "8.5 MB"
            status: "Downloading"
        }
        
        ListElement {
            title: "Hotel California"
            artist: "Eagles"
            progress: 35
            downloadSpeed: "850 KB/s"
            timeRemaining: "1:20"
            sourceUrl: "https://open.spotify.com/track/40riOy7x9W7GXjyGp4pjAv"
            size: "7.8 MB"
            status: "Downloading"
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        
        ColumnLayout {
            anchors {
                fill: parent
                margins: 20
            }
            spacing: 15
            
            // Header
            Label {
                text: qsTr("Active Downloads")
                font.pixelSize: Qt.application.font.pixelSize * 1.5
                font.bold: true
                Layout.fillWidth: true
            }
            
            // Download statistics summary
            RowLayout {
                Layout.fillWidth: true
                spacing: 20
                
                // Total downloads
                ColumnLayout {
                    Layout.fillWidth: true
                    
                    Label {
                        text: qsTr("Active Downloads")
                        font.bold: true
                    }
                    
                    Label {
                        text: activeDownloadsModel.count.toString()
                        font.pixelSize: Qt.application.font.pixelSize * 2
                        color: Material.accent
                    }
                }
                
                // Total download speed
                ColumnLayout {
                    Layout.fillWidth: true
                    
                    Label {
                        text: qsTr("Total Speed")
                        font.bold: true
                    }
                    
                    Label {
                        text: "2.05 MB/s"  // Would be calculated from active downloads
                        font.pixelSize: Qt.application.font.pixelSize * 2
                        color: Material.accent
                    }
                }
                
                // Total data
                ColumnLayout {
                    Layout.fillWidth: true
                    
                    Label {
                        text: qsTr("Total Size")
                        font.bold: true
                    }
                    
                    Label {
                        text: "16.3 MB"  // Would be calculated from active downloads
                        font.pixelSize: Qt.application.font.pixelSize * 2
                        color: Material.accent
                    }
                }
            }
            
            // List of active downloads
            ListView {
                id: activeDownloadsList
                model: activeDownloadsModel
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 10
                
                delegate: Rectangle {
                    width: activeDownloadsList.width
                    height: downloadItemLayout.height + 20
                    radius: 5
                    color: Qt.rgba(0, 0, 0, 0.1)
                    
                    // Download item content
                    ColumnLayout {
                        id: downloadItemLayout
                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                            margins: 10
                        }
                        spacing: 5
                        
                        // Title and controls row
                        RowLayout {
                            Layout.fillWidth: true
                            
                            // Song info
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                
                                Label {
                                    text: title
                                    font.bold: true
                                    font.pixelSize: Qt.application.font.pixelSize * 1.1
                                }
                                
                                Label {
                                    text: artist
                                    opacity: 0.7
                                }
                            }
                            
                            // Control buttons
                            Row {
                                spacing: 10
                                
                                Button {
                                    icon.name: "pause"
                                    ToolTip.text: qsTr("Pause Download")
                                    ToolTip.visible: hovered
                                    ToolTip.delay: 500
                                    
                                    onClicked: {
                                        // Pause download logic would go here
                                    }
                                }
                                
                                Button {
                                    icon.name: "stop"
                                    ToolTip.text: qsTr("Cancel Download")
                                    ToolTip.visible: hovered
                                    ToolTip.delay: 500
                                    
                                    onClicked: {
                                        // Cancel download logic would go here
                                    }
                                }
                            }
                        }
                        
                        // Progress bar and details
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10
                            
                            ProgressBar {
                                from: 0
                                to: 100
                                value: progress
                                Layout.fillWidth: true
                            }
                            
                            Label {
                                text: progress + "%"
                                font.bold: true
                            }
                        }
                        
                        // Download details row
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 20
                            
                            Label {
                                text: qsTr("Speed: ") + downloadSpeed
                            }
                            
                            Label {
                                text: qsTr("Time left: ") + timeRemaining
                            }
                            
                            Label {
                                text: qsTr("Size: ") + size
                            }
                            
                            Label {
                                text: qsTr("Status: ") + status
                                font.italic: true
                            }
                        }
                        
                        // Source URL row
                        Label {
                            text: qsTr("Source: ") + sourceUrl
                            font.pixelSize: Qt.application.font.pixelSize * 0.9
                            opacity: 0.7
                            elide: Text.ElideMiddle
                            Layout.fillWidth: true
                        }
                    }
                }
                
                // Empty state message
                Label {
                    anchors.centerIn: parent
                    text: qsTr("No active downloads. Go to the Download tab to start downloading music.")
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    opacity: 0.7
                    visible: activeDownloadsModel.count === 0
                }
            }
            
            // Global action buttons
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                
                Button {
                    text: qsTr("Pause All")
                    icon.name: "pause"
                    enabled: activeDownloadsModel.count > 0
                    
                    onClicked: {
                        // Pause all downloads logic would go here
                    }
                }
                
                Button {
                    text: qsTr("Resume All")
                    icon.name: "play"
                    enabled: activeDownloadsModel.count > 0
                    
                    onClicked: {
                        // Resume all downloads logic would go here
                    }
                }
                
                Item { Layout.fillWidth: true } // Spacer
                
                Button {
                    text: qsTr("Cancel All")
                    icon.name: "stop"
                    enabled: activeDownloadsModel.count > 0
                    
                    onClicked: {
                        // Cancel all downloads logic would go here
                    }
                }
            }
        }
    }

    // Function to add a new download to the list - would be called from the main component
    function addDownload(url, title, artist) {
        activeDownloadsModel.append({
            "title": title || "Unknown Title",
            "artist": artist || "Unknown Artist",
            "progress": 0,
            "downloadSpeed": "0 KB/s",
            "timeRemaining": "Calculating...",
            "sourceUrl": url,
            "size": "Calculating...",
            "status": "Starting..."
        })
    }
    
    // Function to update download progress - would be called from backend
    function updateDownloadProgress(index, progress, speed, timeRemaining, size, status) {
        if (index >= 0 && index < activeDownloadsModel.count) {
            activeDownloadsModel.setProperty(index, "progress", progress)
            activeDownloadsModel.setProperty(index, "downloadSpeed", speed)
            activeDownloadsModel.setProperty(index, "timeRemaining", timeRemaining)
            activeDownloadsModel.setProperty(index, "size", size)
            activeDownloadsModel.setProperty(index, "status", status)
        }
    }
    
    // Function to remove a completed or cancelled download
    function removeDownload(index) {
        if (index >= 0 && index < activeDownloadsModel.count) {
            activeDownloadsModel.remove(index)
        }
    }
}