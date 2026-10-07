import QtQuick 6.0
import QtQuick.Controls 6.0
import QtQuick.Layouts 6.0

Rectangle {
    anchors.fill: parent
    color: "#030811"
    property int currentTab: 0

    property string safeAgencyName: typeof AuthDB !== "undefined" ? AuthDB.currentAgencyName : "DRDO"
    property string safeLogoPath: typeof AuthDB !== "undefined" ? AuthDB.currentLogoPath : "file:///home/vaibhav/PROJECT_KAVACH_CPP/assets/drdo_logo.png"

    function getMinistry(agency) {
        if (!agency) return "MINISTRY OF DEFENCE\nGOVERNMENT OF INDIA";
        var upperAgency = agency.toUpperCase();
        if (upperAgency.indexOf("RAW") !== -1 || upperAgency.indexOf("R&AW") !== -1) return "CABINET SECRETARIAT\nGOVERNMENT OF INDIA";
        if (upperAgency.indexOf("IB") !== -1 || upperAgency.indexOf("INTELLIGENCE") !== -1) return "MINISTRY OF HOME AFFAIRS\nGOVERNMENT OF INDIA";
        if (upperAgency.indexOf("NTRO") !== -1) return "NATIONAL SECURITY ADVISOR\nGOVERNMENT OF INDIA";
        return "MINISTRY OF DEFENCE\nGOVERNMENT OF INDIA"; 
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // TOP BANNER
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            color: "#1a0202"
            border.color: "#ef4444"
            border.width: 1
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                Text {
                    text: "CLASSIFICATION: TOP SECRET | CRYPTOGRAPHIC POSTURE ASSESSMENT"
                    color: "#ef4444"
                    font.pixelSize: 12
                    font.bold: true
                    font.letterSpacing: 1
                }
                Item { Layout.fillWidth: true }
                Text {
                    text: "SYSTEM STATUS: SECURE"
                    color: "#10b981"
                    font.pixelSize: 12
                    font.bold: true
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // LEFT SIDEBAR
            Rectangle {
                Layout.preferredWidth: 260
                Layout.fillHeight: true
                color: "#060e1a"
                border.color: "#1e293b"
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 12

                    Image {
                        source: "file:///home/vaibhav/PROJECT_KAVACH_CPP/assets/golden_ashok_stambh.png"
                        Layout.preferredHeight: 90
                        Layout.fillWidth: true
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                        smooth: true
                    }
                    Text {
                        text: getMinistry(safeAgencyName)
                        color: "#fbbf24"
                        font.pixelSize: 11
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: -5
                    }
                    Image {
                        source: safeLogoPath 
                        Layout.preferredHeight: 110
                        Layout.fillWidth: true
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                        smooth: true
                        Layout.topMargin: 5
                    }
                    Text {
                        text: safeAgencyName + "\nCYBER COMMAND"
                        color: "#38bdf8"
                        font.pixelSize: 18
                        font.weight: Font.Black
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        color: "#1e293b"
                        Layout.topMargin: 10
                        Layout.bottomMargin: 10
                    }
                    Button {
                        text: "POSTURE DASHBOARD"
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        background: Rectangle { 
                            color: currentTab === 0 ? "#0ea5e9" : "transparent"
                            radius: 4 
                        }
                        contentItem: Text { 
                            text: parent.text
                            color: currentTab === 0 ? "white" : "#94a3b8"
                            font.bold: true
                            font.pixelSize: 13
                            horizontalAlignment: Text.AlignLeft
                            leftPadding: 15
                            verticalAlignment: Text.AlignVCenter 
                        }
                        onClicked: { currentTab = 0 }
                    }
                    Button {
                        text: "AI SECURITY ASSISTANT"
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        background: Rectangle { 
                            color: currentTab === 1 ? "#ef4444" : "transparent"
                            radius: 4 
                        }
                        contentItem: Text { 
                            text: parent.text
                            color: currentTab === 1 ? "white" : "#94a3b8"
                            font.bold: true
                            font.pixelSize: 13
                            horizontalAlignment: Text.AlignLeft
                            leftPadding: 15
                            verticalAlignment: Text.AlignVCenter 
                        }
                        onClicked: { currentTab = 1 }
                    }
                    Item { Layout.fillHeight: true }
                    Button {
                        text: "LOGOUT SECURELY"
                        Layout.fillWidth: true
                        Layout.preferredHeight: 45
                        background: Rectangle { 
                            color: "#1a0202"
                            border.color: "#ef4444"
                            radius: 4 
                        }
                        contentItem: Text { 
                            text: parent.text
                            color: "#ef4444"
                            font.bold: true
                            font.pixelSize: 13
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter 
                        }
                        onClicked: { Qt.quit() }
                    }
                }
            }

            // RIGHT CONTENT
            StackLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: currentTab

                // TAB 0: DASHBOARD
                Rectangle {
                    color: "transparent"
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 15

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 15
                            TextField { 
                                id: searchInput
                                placeholderText: "Enter Target Domain..."
                                Layout.fillWidth: true
                                Layout.preferredHeight: 45
                                color: "white"
                                font.pixelSize: 15
                                background: Rectangle { 
                                    color: "#0a1324"
                                    border.color: "#1e293b"
                                    radius: 4 
                                }
                                leftPadding: 20 
                            }
                            Button { 
                                text: "EVALUATE POSTURE"
                                Layout.preferredHeight: 45
                                Layout.preferredWidth: 240
                                background: Rectangle { 
                                    color: "#0ea5e9"
                                    radius: 4 
                                }
                                contentItem: Text { 
                                    text: parent.text
                                    color: "white"
                                    font.bold: true
                                    font.pixelSize: 13
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter 
                                }
                                onClicked: { 
                                    scanStatus.text = "[*] INITIALIZING ENGINE..."
                                    scanStatus.color = "#f59e0b"
                                    Scanner.startScan(searchInput.text.trim()) 
                                } 
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Text { 
                                id: scanStatus
                                text: "SYSTEM STANDBY."
                                color: "#38bdf8"
                                font.pixelSize: 13
                                font.bold: true
                                font.family: "Courier New" 
                            }
                            Item { Layout.fillWidth: true }
                            Text { 
                                text: "TOTAL SECURITY SCORE: "
                                color: "#94a3b8"
                                font.pixelSize: 14
                                font.bold: true 
                            }
                            Text { 
                                id: valScore
                                text: "--/100"
                                color: "#10b981"
                                font.pixelSize: 24
                                font.bold: true 
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 180
                            spacing: 15
                            Rectangle { 
                                Layout.preferredWidth: 300
                                Layout.fillHeight: true
                                color: "#060e1a"
                                border.color: "#1e293b"
                                radius: 6
                                ColumnLayout { 
                                    anchors.fill: parent
                                    anchors.margins: 15
                                    spacing: 8
                                    Text { text: "MODULE SCORES"; color: "#38bdf8"; font.pixelSize: 13; font.bold: true }
                                    Text { text: "CRYPTOGRAPHY:"; color: "#64748b"; font.pixelSize: 11; font.bold: true; Layout.topMargin: 10 }
                                    Text { id: valCryptoScore; text: "-- / 25"; color: "#e2e8f0"; font.pixelSize: 18; font.weight: Font.Black }
                                    Text { text: "AUTHENTICATION:"; color: "#64748b"; font.pixelSize: 11; font.bold: true; Layout.topMargin: 10 }
                                    Text { id: valAuthScore; text: "-- / 20"; color: "#e2e8f0"; font.pixelSize: 18; font.weight: Font.Black }
                                    Item { Layout.fillHeight: true } 
                                } 
                            }
                            Rectangle { 
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: "#1a0202"
                                border.color: "#ef4444"
                                radius: 6
                                ColumnLayout { 
                                    anchors.fill: parent
                                    anchors.margins: 15
                                    spacing: 8
                                    Text { text: "POST-QUANTUM READINESS (PQC)"; color: "#ef4444"; font.pixelSize: 13; font.bold: true }
                                    Text { text: "NIST Crypto-Agility Capability Assessment"; color: "#94a3b8"; font.pixelSize: 11; font.italic: true }
                                    Text { id: valPqc; text: "Awaiting Assessment..."; color: "#f59e0b"; font.pixelSize: 14; wrapMode: Text.WrapAnywhere; Layout.fillWidth: true; Layout.topMargin: 10 }
                                    Item { Layout.fillHeight: true } 
                                } 
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 250
                            spacing: 15
                            Rectangle { 
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: "#060e1a"
                                border.color: "#1e293b"
                                radius: 6
                                ColumnLayout { 
                                    anchors.fill: parent
                                    anchors.margins: 15
                                    spacing: 8
                                    Text { text: "IDENTITY & DNSSEC"; color: "#38bdf8"; font.pixelSize: 13; font.bold: true }
                                    Text { text: "MX MAIL SERVERS:"; color: "#64748b"; font.pixelSize: 11; font.bold: true; Layout.topMargin: 5 }
                                    Text { id: valMx; text: "--"; color: "#e2e8f0"; font.pixelSize: 12; wrapMode: Text.WrapAnywhere; Layout.fillWidth: true }
                                    Text { text: "SPF POLICY:"; color: "#64748b"; font.pixelSize: 11; font.bold: true; Layout.topMargin: 5 }
                                    Text { id: valSpf; text: "--"; color: "#10b981"; font.pixelSize: 14 }
                                    Text { text: "DMARC POLICY:"; color: "#64748b"; font.pixelSize: 11; font.bold: true; Layout.topMargin: 5 }
                                    Text { id: valDmarc; text: "--"; color: "#10b981"; font.pixelSize: 14 }
                                    Text { text: "DNSSEC INTEGRITY:"; color: "#64748b"; font.pixelSize: 11; font.bold: true; Layout.topMargin: 5 }
                                    Text { id: valDnssec; text: "--"; color: "#e2e8f0"; font.pixelSize: 14 }
                                    Item { Layout.fillHeight: true } 
                                } 
                            }
                            Rectangle { 
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                color: "#060e1a"
                                border.color: "#1e293b"
                                radius: 6
                                ColumnLayout { 
                                    anchors.fill: parent
                                    anchors.margins: 15
                                    spacing: 8
                                    Text { text: "TRANSPORT CRYPTO & WAF"; color: "#10b981"; font.pixelSize: 13; font.bold: true }
                                    Text { text: "TLS HANDSHAKE (PORT 443):"; color: "#64748b"; font.pixelSize: 11; font.bold: true; Layout.topMargin: 5 }
                                    Text { id: valTls; text: "--"; color: "#e2e8f0"; font.pixelSize: 18; font.weight: Font.Black }
                                    Text { text: "CIPHER SUITE:"; color: "#64748b"; font.pixelSize: 11; font.bold: true; Layout.topMargin: 5 }
                                    Text { id: valCipher; text: "--"; color: "#e2e8f0"; font.pixelSize: 12; wrapMode: Text.WrapAnywhere; Layout.fillWidth: true }
                                    Text { text: "DNS CRYPTO (CAA / MTA-STS / TLSA):"; color: "#64748b"; font.pixelSize: 11; font.bold: true; Layout.topMargin: 5 }
                                    Text { id: valDnsCrypto; text: "--"; color: "#10b981"; font.pixelSize: 12; wrapMode: Text.WrapAnywhere; Layout.fillWidth: true }
                                    Item { Layout.fillHeight: true } 
                                } 
                            }
                        }
                        Item { Layout.fillHeight: true }
                    }
                }

                // TAB 1: AI CHATBOT
                Rectangle {
                    color: "transparent"
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 25
                        spacing: 20
                        Text {
                            text: "AI CONFIGURATION AUDIT INTERFACE"
                            color: "#ef4444"
                            font.pixelSize: 18
                            font.weight: Font.Black
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "#060e1a"
                            border.color: "#1e293b"
                            radius: 6
                            ScrollView {
                                anchors.fill: parent
                                anchors.margins: 15
                                TextArea {
                                    id: chatLog
                                    textFormat: TextEdit.RichText
                                    text: "<font color='#10b981'>--- SECURE CHANNEL ESTABLISHED ---</font><br><br>"
                                    color: "#e2e8f0"
                                    font.pixelSize: 15
                                    readOnly: true
                                    wrapMode: Text.WordWrap
                                    background: Rectangle { color: "transparent" }
                                }
                            }
                        }

                        Button {
                            id: autoGenerateBtn
                            text: "GENERATE DETAILED REPORT" // Pure text, no emojis
                            Layout.fillWidth: true
                            Layout.preferredHeight: 45
                            background: Rectangle { 
                                color: "#10b981" 
                                radius: 4 
                            }
                            contentItem: Text { 
                                text: parent.text
                                color: "white"
                                font.bold: true
                                font.pixelSize: 14
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter 
                            }
                            onClicked: {
                                var query = "Provide a highly detailed security assessment. Include the HTML table, exact reasons for point deductions, and step-by-step remediation recommendations."
                                chatLog.append("<font color='#38bdf8'><b>[ANALYST]</b></font> INITIATING DETAILED SCAN REPORT...")
                                chatLog.append("<font color='#f59e0b'><b>[SYSTEM]</b></font> Generating Comprehensive Report via Secure Uplink. Please wait...")
                                Scanner.askGemini(query)
                                visible = false 
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 15
                            TextField {
                                id: chatInput
                                placeholderText: "Ask Kavach AI for details..."
                                Layout.fillWidth: true
                                Layout.preferredHeight: 50
                                color: "white"
                                font.pixelSize: 15
                                background: Rectangle { 
                                    color: "#0a1324"
                                    border.color: "#1e293b"
                                    radius: 4 
                                }
                                leftPadding: 20
                                onAccepted: sendChatBtn.clicked()
                            }
                            Button {
                                id: sendChatBtn
                                text: "TRANSMIT"
                                Layout.preferredHeight: 50
                                Layout.preferredWidth: 150
                                background: Rectangle { 
                                    color: "#ef4444"
                                    radius: 4 
                                }
                                contentItem: Text { 
                                    text: parent.text
                                    color: "white"
                                    font.bold: true
                                    font.pixelSize: 13
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter 
                                }
                                onClicked: {
                                    if(chatInput.text.trim() === "") return;
                                    chatLog.append("<font color='#38bdf8'><b>[ANALYST]</b></font> " + chatInput.text)
                                    chatLog.append("<font color='#f59e0b'><b>[SYSTEM]</b></font> Secure Query Transmitted. Analyzing...")
                                    Scanner.askGemini(chatInput.text.trim())
                                    chatInput.text = ""
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    Connections {
        target: Scanner
        function onScanProgress(percent, status) { 
            scanStatus.text = "[*] " + status 
        }
        function onScanComplete(results) {
            scanStatus.text = "[✓] POSTURE EVALUATED."
            scanStatus.color = "#10b981"
            valScore.text = results.overall_score + "/100"
            valCryptoScore.text = results.crypto_score
            valAuthScore.text = results.auth_score
            valMx.text = results.mx
            valSpf.text = results.spf
            valDmarc.text = results.dmarc
            valDnssec.text = results.dnssec
            valTls.text = results.tls
            valCipher.text = results.cipher
            valPqc.text = results.pqc
            valDnsCrypto.text = "CAA: " + results.caa + " | MTA-STS: " + results.mta_sts + " | TLSA: " + results.tlsa
        }
        function onChatMessageReceived(sender, message) {
            // 🔥 FIX: <hr> removed entirely. Using <br><br> for clean spacing between messages.
            if(sender === "GEMINI") {
                chatLog.append("<br><font color='#10b981'><b>[KAVACH AI]</b></font><br>" + message + "<br><br>")
            } else if (sender === "SYSTEM") {
                chatLog.append("<font color='#f59e0b'><b>[ALERT]</b></font> " + message)
            }
        }
    }
}
