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

    // Property to store download history - this would be populated from the backend
    // For now, using a dummy model for display purposes
    property var downloadHistoryModel: ListModel {
        id: dummyHistoryModel
        
        ListElement {
            title: "Stairway to Heaven"
            artist: "Led Zeppelin"
            albumName: "Led Zeppelin IV"
            downloadDate: "2025-04-09 15:30"
            filePath: "/Users/Music/Led Zeppelin - Stairway to Heaven.mp3"
            fileSize: "12.4 MB"
            sourceUrl: "https://open.spotify.com/track/5CQ30WqJwcep0pYcV4AMNc"
            quality: "High (320kbps)"
            format: "MP3"
        }
        
        ListElement {
            title: "Yesterday"
            artist: "The Beatles"
            albumName: "Help!"
            downloadDate: "2025-04-08 10:15"
            filePath: "/Users/Music/The Beatles - Yesterday.mp3"
            fileSize: "7.2 MB"
            sourceUrl: "https://open.spotify.com/track/3BQHpFgAp4l80e1XslIjNI"
            quality: "High (320kbps)"
            format: "MP3"
        }
        
        ListElement {
            title: "Imagine"
            artist: "John Lennon"
            albumName: "Imagine"
            downloadDate: "2025-04-07 22:45"
            filePath: "/Users/Music/John Lennon - Imagine.mp3"
            fileSize: "8.5 MB"
            sourceUrl: "https://open.spotify.com/track/7pKfPomDEeI4TPT6EOYjn9"
            quality: "High (320kbps)"
            format: "MP3"
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
            
            // Header with search and filter
            RowLayout {
                Layout.fillWidth: true
                
                Label {
                    text: qsTr("Download History")
                    font.pixelSize: Qt.application.font.pixelSize * 1.5
                    font.bold: true
                    Layout.fillWidth: true
                }
                
                TextField {
                    id: searchField
                    placeholderText: qsTr("Search history...")
                    Layout.preferredWidth: 250
                    
                    onTextChanged: {
                        // Would filter the history list based on search text
                    }
                }
            }
            
            // History statistics
            RowLayout {
                Layout.fillWidth: true
                spacing: 20
                
                // Total downloads
                ColumnLayout {
                    Layout.fillWidth: true
                    
                    Label {
                        text: qsTr("Total Downloads")
                        font.bold: true
                    }
                    
                    Label {
                        text: downloadHistoryModel.count.toString()
                        font.pixelSize: Qt.application.font.pixelSize * 2
                        color: Material.accent
                    }
                }
                
                // Total data downloaded
                ColumnLayout {
                    Layout.fillWidth: true
                    
                    Label {
                        text: qsTr("Total Data")
                        font.bold: true
                    }
                    
                    Label {
                        text: "28.1 MB"  // Would be calculated from history
                        font.pixelSize: Qt.application.font.pixelSize * 2
                        color: Material.accent
                    }
                }
                
                // Last download
                ColumnLayout {
                    Layout.fillWidth: true
                    
                    Label {
                        text: qsTr("Last Download")
                        font.bold: true
                    }
                    
                    Label {
                        text: downloadHistoryModel.count > 0 ? downloadHistoryModel.get(0).downloadDate : "-"
                        font.pixelSize: Qt.application.font.pixelSize * 1.2
                        color: Material.accent
                    }
                }
            }
            
            // List of download history
            ListView {
                id: historyList
                model: downloadHistoryModel
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 10
                
                // History item delegate
                delegate: Rectangle {
                    width: historyList.width
                    height: historyItemLayout.height + 20
                    radius: 5
                    color: Qt.rgba(0, 0, 0, 0.1)
                    
                    ColumnLayout {
                        id: historyItemLayout
                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                            margins: 10
                        }
                        spacing: 5
                        
                        // Song title and actions row
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
                                    text: artist + (albumName ? " - " + albumName : "")
                                    opacity: 0.7
                                }
                            }
                            
                            // Actions for the downloaded file
                            Row {
                                spacing: 10
                                
                                Button {
                                    text: qsTr("Play")
                                    icon.name: "play"
                                    
                                    onClicked: {
                                        // Open file in default player logic
                                    }
                                }
                                
                                Button {
                                    text: qsTr("Open Location")
                                    icon.name: "folder"
                                    
                                    onClicked: {
                                        // Open containing folder logic
                                    }
                                }
                            }
                        }
                        
                        // File details
                        GridLayout {
                            columns: 2
                            Layout.fillWidth: true
                            columnSpacing: 10
                            rowSpacing: 5
                            
                            Label { 
                                text: qsTr("File:") 
                                font.bold: true
                            }
                            Label { 
                                text: filePath 
                                elide: Text.ElideMiddle
                                Layout.fillWidth: true
                            }
                            
                            Label { 
                                text: qsTr("Downloaded:") 
                                font.bold: true
                            }
                            Label { text: downloadDate }
                            
                            Label { 
                                text: qsTr("Size:") 
                                font.bold: true
                            }
                            Label { text: fileSize }
                            
                            Label { 
                                text: qsTr("Quality:") 
                                font.bold: true
                            }
                            Label { text: quality + " - " + format }
                            
                            Label { 
                                text: qsTr("Source:") 
                                font.bold: true
                            }
                            Label { 
                                text: sourceUrl 
                                elide: Text.ElideMiddle
                                Layout.fillWidth: true
                            }
                        }
                    }
                }
                
                // Empty state message
                Label {
                    anchors.centerIn: parent
                    text: qsTr("No download history yet. Downloaded songs will appear here.")
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    opacity: 0.7
                    visible: downloadHistoryModel.count === 0
                }
            }
            
            // Action buttons for history management
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                
                Button {
                    text: qsTr("Export History")
                    icon.name: "save"
                    enabled: downloadHistoryModel.count > 0
                    
                    onClicked: {
                        // Export history logic would go here
                    }
                }
                
                Item { Layout.fillWidth: true } // Spacer
                
                Button {
                    text: qsTr("Clear History")
                    icon.name: "delete"
                    enabled: downloadHistoryModel.count > 0
                    
                    onClicked: {
                        // Clear history confirmation dialog would appear
                        confirmDeleteDialog.open()
                    }
                }
            }
        }
    }
    
    // Confirmation dialog for clearing history
    Dialog {
        id: confirmDeleteDialog
        title: qsTr("Confirm Clear History")
        standardButtons: Dialog.Yes | Dialog.No
        modal: true
        anchors.centerIn: parent
        
        Label {
            text: qsTr("Are you sure you want to clear your download history? This action cannot be undone.")
            wrapMode: Text.WordWrap
            width: parent.width
        }
        
        onAccepted: {
            // Clear the history model
            downloadHistoryModel.clear()
        }
    }
    
    // Function to add a completed download to history
    function addToHistory(downloadInfo) {
        // This would be called when a download completes
        downloadHistoryModel.insert(0, downloadInfo)
    }
}