import QtQuick 6.0
import QtQuick.Controls 6.0
import QtQuick.Layouts 6.0

ApplicationWindow {
    id: appWindow
    visible: true
    width: 1500
    height: 900
    title: "PROJECT KAVACH - SOVEREIGN ACCESS"
    
    background: Rectangle {
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#020815" } 
            GradientStop { position: 1.0; color: "#0a1e3f" } 
        }
    }

    Loader { 
        id: mainLoader
        anchors.fill: parent 
        onStatusChanged: {
            if (mainLoader.status === Loader.Error) {
                console.log("CRITICAL ERROR: UI file load nahi hui!")
            }
        }
    }

    Item {
        id: loginPage
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 75
                color: "#FFFFFF"
                RowLayout {
                    anchors.fill: parent
                    anchors.rightMargin: 40
                    anchors.leftMargin: 30
                    Item { Layout.fillWidth: true } 
                    ColumnLayout {
                        spacing: 2
                        Layout.alignment: Qt.AlignVCenter
                        Text { text: "GOVERNMENT OF INDIA"; color: "#000000"; font.pixelSize: 15; font.weight: Font.Black; Layout.alignment: Qt.AlignRight }
                        Text { text: "सत्यमेव जयते"; color: "#000000"; font.pixelSize: 11; font.bold: true; Layout.alignment: Qt.AlignRight }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true; Layout.fillHeight: true; Layout.margins: 80; spacing: 50
                Item {
                    Layout.fillWidth: true; Layout.fillHeight: true; Layout.preferredWidth: 55
                    ColumnLayout {
                        anchors.centerIn: parent; spacing: 25
                        Image { source: "file://" + applicationDirPath + "/assets/HLO.png"; Layout.preferredHeight: 450; Layout.alignment: Qt.AlignHCenter; fillMode: Image.PreserveAspectFit }
                        Text { text: "GOVERNMENT OF INDIA"; color: "#FFFFFF"; font.pixelSize: 26; font.weight: Font.Black; font.letterSpacing: 2; Layout.alignment: Qt.AlignHCenter }
                    }
                }
                Item {
                    Layout.fillHeight: true; Layout.preferredWidth: 400
                    ColumnLayout {
                        anchors.centerIn: parent; width: parent.width; spacing: 20
                        TextField { id: emailField; placeholderText: "Username / Mail"; Layout.fillWidth: true; Layout.preferredHeight: 50; color: "white"; font.pixelSize: 14; leftPadding: 20; background: Rectangle { color: Qt.rgba(2/255, 10/255, 26/255, 0.7); border.color: "#1E3A5F"; radius: 4 } }
                        TextField { id: passField; placeholderText: "Password"; echoMode: TextInput.Password; Layout.fillWidth: true; Layout.preferredHeight: 50; color: "white"; font.pixelSize: 14; leftPadding: 20; background: Rectangle { color: Qt.rgba(2/255, 10/255, 26/255, 0.7); border.color: "#1E3A5F"; radius: 4 } }
                        Text { id: errorMsg; text: ""; font.pixelSize: 13; font.bold: true; visible: false; Layout.alignment: Qt.AlignHCenter }
                        Button {
                            text: "Connect ➔"
                            Layout.alignment: Qt.AlignRight; Layout.preferredHeight: 45; Layout.preferredWidth: 140
                            background: Rectangle { color: parent.down ? "#0369a1" : "transparent"; border.color: "#38bdf8"; radius: 4; border.width: 1 }
                            contentItem: Text { text: parent.text; color: "white"; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; font.bold: true; font.pixelSize: 14 }
                            onClicked: {
                                var email = emailField.text.trim().toLowerCase()
                                var pwd = passField.text.trim()
                                if(email === "" && pwd === "") { email = "drdo.chief@gov.in"; pwd = "Kavach@2026" }

                                if(AuthDB.authenticate(email, pwd)) {
                                    loginPage.visible = false
                                    // FORCE EXACT PATH
                                    mainLoader.source = "Dashboard.qml" 
                                } else {
                                    errorMsg.text = "ACCESS DENIED"; errorMsg.color = "#ef4444"; errorMsg.visible = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
