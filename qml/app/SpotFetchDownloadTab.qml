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

    // Signal to notify when a new download has started
    signal downloadStarted(string url, string title)

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        
        ColumnLayout {
            anchors {
                fill: parent
                margins: 20
            }
            spacing: 15
            
            // Header for the download section
            Label {
                text: qsTr("Download from Spotify")
                font.pixelSize: Qt.application.font.pixelSize * 1.5
                font.bold: true
                Layout.fillWidth: true
            }
            
            // Spotify URL input
            TextField {
                id: spotifyUrlInput
                placeholderText: qsTr("Paste Spotify URL here (song, album, playlist)")
                Layout.fillWidth: true
                selectByMouse: true
                
                // Support paste operation with keyboard shortcut
                Keys.onPressed: {
                    if ((event.key === Qt.Key_V) && (event.modifiers & Qt.ControlModifier)) {
                        spotifyUrlInput.paste()
                    }
                }
            }
            
            // URL validation message
            Label {
                id: validationMessage
                text: ""
                color: "red"
                visible: text !== ""
                Layout.fillWidth: true
            }
            
            // Download button
            Button {
                id: downloadButton
                text: qsTr("Download")
                icon.name: "download"
                Layout.alignment: Qt.AlignRight
                
                onClicked: {
                    if (validateSpotifyUrl(spotifyUrlInput.text)) {
                        // Here we would start the download process
                        // For now, just emit the signal
                        root.downloadStarted(spotifyUrlInput.text, "Song from Spotify")
                        
                        // Show success message
                        infoMessage.text = qsTr("Download started!")
                        infoMessage.color = Material.accent
                        infoMessage.visible = true
                        infoTimer.start()
                        
                        // Clear the input field
                        spotifyUrlInput.text = ""
                    } else {
                        validationMessage.text = qsTr("Invalid Spotify URL. Please enter a valid Spotify song, album, or playlist URL.")
                    }
                }
            }
            
            // Information message
            Label {
                id: infoMessage
                text: ""
                color: Material.accent
                visible: false
                Layout.fillWidth: true
            }
            
            // Advanced options section
            GroupBox {
                title: qsTr("Download Options")
                Layout.fillWidth: true
                
                GridLayout {
                    columns: 2
                    anchors.fill: parent
                    columnSpacing: 10
                    rowSpacing: 10
                    
                    Label { text: qsTr("Quality:") }
                    ComboBox {
                        id: qualityComboBox
                        model: ["High (320kbps)", "Medium (160kbps)", "Low (96kbps)"]
                        Layout.fillWidth: true
                        currentIndex: 0
                    }
                    
                    Label { text: qsTr("Output Format:") }
                    ComboBox {
                        id: formatComboBox
                        model: ["MP3", "AAC", "FLAC", "WAV"]
                        Layout.fillWidth: true
                        currentIndex: 0
                    }
                    
                    Label { text: qsTr("Save Location:") }
                    RowLayout {
                        Layout.fillWidth: true
                        TextField {
                            id: saveLocationTextField
                            readOnly: true
                            placeholderText: qsTr("Default location")
                            Layout.fillWidth: true
                        }
                        Button {
                            text: qsTr("Browse")
                            onClicked: {
                                // Here we would open a file dialog to select a save location
                                // This would be handled by a Python function
                            }
                        }
                    }
                }
            }
            
            // Spacer
            Item {
                Layout.fillHeight: true
            }
            
            // Instructions
            Label {
                text: qsTr("Instructions: Paste a Spotify URL for a song, album, or playlist, then click Download.")
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                opacity: 0.7
            }
        }
    }
    
    // Timer to hide success message after a delay
    Timer {
        id: infoTimer
        interval: 3000
        onTriggered: {
            infoMessage.visible = false
        }
    }
    
    // Simple validation function - could be enhanced or moved to backend
    function validateSpotifyUrl(url) {
        return url.trim().startsWith("https://open.spotify.com/") || 
               url.trim().startsWith("spotify:track:") ||
               url.trim().startsWith("spotify:album:") ||
               url.trim().startsWith("spotify:playlist:")
    }
}