import QtQuick 6.0
import QtQuick.Controls 6.0
import QtQuick.Layouts 6.0

Rectangle {
id: appWindow
width: 1500
height: 900
color: "#0a1e3f"

property string safeAgencyName: typeof AuthDB !== "undefined" ? AuthDB.currentAgencyName : "DRDO"
property string safeLogoPath: "file://" + applicationDirPath + "/assets/drdo_logo.png"

function getMinistry(agency) {
if (!agency) return "MINISTRY OF DEFENCE\nGOVERNMENT OF INDIA"
var upperAgency = agency.toUpperCase()
if (upperAgency.indexOf("RAW") !== -1 || upperAgency.indexOf("R&AW") !== -1) return "CABINET SECRETARIAT\nGOVERNMENT OF INDIA"
if (upperAgency.indexOf("IB") !== -1 || upperAgency.indexOf("INTELLIGENCE") !== -1) return "MINISTRY OF HOME AFFAIRS\nGOVERNMENT OF INDIA"
if (upperAgency.indexOf("NTRO") !== -1) return "NATIONAL SECURITY ADVISOR\nGOVERNMENT OF INDIA"
return "MINISTRY OF DEFENCE\nGOVERNMENT OF INDIA"
}

ColumnLayout {
anchors.fill: parent
spacing: 0

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

Item {
Layout.fillWidth: true
}

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
source: "file://" + applicationDirPath + "/assets/golden_ashok_stambh.png"
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
color: "#0ea5e9"
radius: 4
}
contentItem: Text {
text: parent.text
color: "white"
font.bold: true
font.pixelSize: 13
horizontalAlignment: Text.AlignLeft
leftPadding: 15
verticalAlignment: Text.AlignVCenter
}
}

Button {
text: "WIPE RAM & LOGS"
Layout.fillWidth: true
Layout.preferredHeight: 40
background: Rectangle {
color: "#550000"
border.color: "#ef4444"
radius: 4
}
contentItem: Text {
text: parent.text
color: "#ef4444"
font.bold: true
font.pixelSize: 13
horizontalAlignment: Text.AlignLeft
leftPadding: 15
verticalAlignment: Text.AlignVCenter
}
onClicked: {
Scanner.wipeMemory()
scanStatus.text = "[!] ANTI-FORENSICS: MEMORY & HISTORY WIPED."
scanStatus.color = "#ef4444"
valScore.text = "--/100"
valCryptoScore.text = "-- / 25"
valAuthScore.text = "-- / 20"
valIpAsn.text = "--"
valWaf.text = "--"
valSecTxt.text = "--"
valRobots.text = "--"
valSubdomains.text = "--"
valMx.text = "--"
valSpf.text = "--"
valDmarc.text = "--"
valDnssec.text = "--"
valTls.text = "--"
valCipher.text = "--"
valCertIssuer.text = "--"
valCertExpiry.text = "--"
valServer.text = "--"
valHsts.text = "--"
valXFrame.text = "--"
valXcto.text = "--"
valCsp.text = "--"
historyList.model = Scanner.getHistoryList()
}
}

Item {
Layout.fillHeight: true
}

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
onClicked: Qt.quit()
}
}
}

Rectangle {
Layout.fillWidth: true
Layout.fillHeight: true
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

Item {
Layout.fillWidth: true
}

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
Layout.preferredHeight: 200
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

Text {
text: "MODULE SCORES"
color: "#38bdf8"
font.pixelSize: 13
font.bold: true
}

Text {
text: "CRYPTOGRAPHY:"
color: "#64748b"
font.pixelSize: 11
font.bold: true
Layout.topMargin: 10
}

Text {
id: valCryptoScore
text: "-- / 25"
color: "#e2e8f0"
font.pixelSize: 18
font.weight: Font.Black
}

Text {
text: "AUTHENTICATION:"
color: "#64748b"
font.pixelSize: 11
font.bold: true
Layout.topMargin: 10
}

Text {
id: valAuthScore
text: "-- / 20"
color: "#e2e8f0"
font.pixelSize: 18
font.weight: Font.Black
}

Item {
Layout.fillHeight: true
}
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
spacing: 5

Text {
text: "HTTP SECURITY HEADERS (POSTURE)"
color: "#ef4444"
font.pixelSize: 13
font.bold: true
}

Text {
text: "HSTS POLICY:"
color: "#64748b"
font.pixelSize: 11
font.bold: true
Layout.topMargin: 5
}

Text {
id: valHsts
text: "--"
color: "#f59e0b"
font.pixelSize: 14
}

Text {
text: "X-FRAME-OPTIONS:"
color: "#64748b"
font.pixelSize: 11
font.bold: true
Layout.topMargin: 5
}

Text {
id: valXFrame
text: "--"
color: "#f59e0b"
font.pixelSize: 14
}

Text {
text: "X-CONTENT-TYPE-OPTIONS:"
color: "#64748b"
font.pixelSize: 11
font.bold: true
Layout.topMargin: 5
}

Text {
id: valXcto
text: "--"
color: "#f59e0b"
font.pixelSize: 14
}

Text {
text: "CONTENT-SECURITY-POLICY (CSP):"
color: "#64748b"
font.pixelSize: 11
font.bold: true
Layout.topMargin: 5
}

Text {
id: valCsp
text: "--"
color: "#10b981"
font.pixelSize: 14
}

Item {
Layout.fillHeight: true
}
}
}

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

Text {
text: "SESSION HISTORY (DEQUE)"
color: "#38bdf8"
font.pixelSize: 13
font.bold: true
}

ListView {
id: historyList
Layout.fillWidth: true
Layout.fillHeight: true
clip: true
model: []
spacing: 5
delegate: RowLayout {
width: ListView.view.width
Text {
text: modelData
color: "#94a3b8"
font.pixelSize: 11
Layout.fillWidth: true
elide: Text.ElideRight
}
Button {
text: "X"
Layout.preferredWidth: 18
Layout.preferredHeight: 18
background: Rectangle { color: "#550000"; radius: 2; border.color: "#ef4444" }
contentItem: Text { text: "X"; color: "#ef4444"; font.pixelSize: 9; font.bold: true; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
onClicked: {
Scanner.removeHistoryItem(index)
historyList.model = Scanner.getHistoryList()
}
}
}
}
}
}
}

RowLayout {
Layout.fillWidth: true
Layout.preferredHeight: 280
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

Text {
text: "HOSTING & PASSIVE OSINT"
color: "#38bdf8"
font.pixelSize: 13
font.bold: true
}

Text {
text: "TARGET IP & ASN (ISP):"
color: "#64748b"
font.pixelSize: 11
font.bold: true
Layout.topMargin: 5
}

Text {
id: valIpAsn
text: "--"
color: "#e2e8f0"
font.pixelSize: 12
}

Text {
text: "WEB APPLICATION FIREWALL (WAF):"
color: "#64748b"
font.pixelSize: 11
font.bold: true
Layout.topMargin: 5
}

Text {
id: valWaf
text: "--"
color: "#10b981"
font.pixelSize: 12
}

Text {
text: "SECURITY.TXT (VULN DISCLOSURE):"
color: "#64748b"
font.pixelSize: 11
font.bold: true
Layout.topMargin: 5
}

Text {
id: valSecTxt
text: "--"
color: "#e2e8f0"
font.pixelSize: 12
}

Text {
text: "ROBOTS.TXT (EXPOSED RULES):"
color: "#64748b"
font.pixelSize: 11
font.bold: true
Layout.topMargin: 5
}

Text {
id: valRobots
text: "--"
color: "#e2e8f0"
font.pixelSize: 12
}

Text {
text: "SUBDOMAINS ENUMERATED:"
color: "#64748b"
font.pixelSize: 11
font.bold: true
Layout.topMargin: 5
}

Text {
id: valSubdomains
text: "--"
color: "#e2e8f0"
font.pixelSize: 11
wrapMode: Text.WrapAnywhere
Layout.fillWidth: true
}

Item {
Layout.fillHeight: true
}
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

Text {
text: "IDENTITY & DNSSEC"
color: "#38bdf8"
font.pixelSize: 13
font.bold: true
}

Text {
text: "MX MAIL SERVERS:"
color: "#64748b"
font.pixelSize: 11
font.bold: true
Layout.topMargin: 5
}

Text {
id: valMx
text: "--"
color: "#e2e8f0"
font.pixelSize: 11
wrapMode: Text.WrapAnywhere
Layout.fillWidth: true
}

Text {
text: "SPF POLICY:"
color: "#64748b"
font.pixelSize: 11
font.bold: true
Layout.topMargin: 5
}

Text {
id: valSpf
text: "--"
color: "#10b981"
font.pixelSize: 12
}

Text {
text: "DMARC POLICY:"
color: "#64748b"
font.pixelSize: 11
font.bold: true
Layout.topMargin: 5
}

Text {
id: valDmarc
text: "--"
color: "#10b981"
font.pixelSize: 12
}

Text {
text: "DNSSEC INTEGRITY (DS RECORD):"
color: "#64748b"
font.pixelSize: 11
font.bold: true
Layout.topMargin: 5
}

Text {
id: valDnssec
text: "--"
color: "#e2e8f0"
font.pixelSize: 12
}

Item {
Layout.fillHeight: true
}
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

Text {
text: "TRANSPORT CRYPTO & CERTIFICATE"
color: "#10b981"
font.pixelSize: 13
font.bold: true
}

Text {
text: "TLS HANDSHAKE (PORT 443):"
color: "#64748b"
font.pixelSize: 11
font.bold: true
Layout.topMargin: 5
}

Text {
id: valTls
text: "--"
color: "#e2e8f0"
font.pixelSize: 18
font.weight: Font.Black
}

Text {
text: "CIPHER SUITE:"
color: "#64748b"
font.pixelSize: 11
font.bold: true
Layout.topMargin: 5
}

Text {
id: valCipher
text: "--"
color: "#e2e8f0"
font.pixelSize: 12
wrapMode: Text.WrapAnywhere
Layout.fillWidth: true
}

Text {
text: "CERTIFICATE ISSUER (CA):"
color: "#64748b"
font.pixelSize: 11
font.bold: true
Layout.topMargin: 5
}

Text {
id: valCertIssuer
text: "--"
color: "#e2e8f0"
font.pixelSize: 12
}

Text {
text: "CERTIFICATE EXPIRY:"
color: "#64748b"
font.pixelSize: 11
font.bold: true
Layout.topMargin: 5
}

Text {
id: valCertExpiry
text: "--"
color: "#e2e8f0"
font.pixelSize: 12
}

Text {
text: "SERVER BANNER:"
color: "#64748b"
font.pixelSize: 11
font.bold: true
Layout.topMargin: 5
}

Text {
id: valServer
text: "--"
color: "#10b981"
font.pixelSize: 12
}

Item {
Layout.fillHeight: true
}
}
}
}

Item {
Layout.fillHeight: true
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
historyList.model = Scanner.getHistoryList()
scanStatus.text = results.overall_score === 0 ? "[!] SCAN FAILED. INVALID DOMAIN." : "[✓] POSTURE EVALUATED."
scanStatus.color = results.overall_score === 0 ? "#ef4444" : "#10b981"
valScore.text = results.overall_score + "/100"
valScore.color = results.overall_score >= 80 ? "#10b981" : (results.overall_score >= 50 ? "#f59e0b" : "#ef4444")
valCryptoScore.text = results.crypto_score
valAuthScore.text = results.auth_score
valIpAsn.text = results.ip_asn
valWaf.text = results.waf
valSecTxt.text = results.sec_txt
valRobots.text = results.robots
valSubdomains.text = results.subdomains
valMx.text = results.mx
valSpf.text = results.spf
valDmarc.text = results.dmarc
valDnssec.text = results.dnssec
valTls.text = results.tls
valCipher.text = results.cipher
valCertIssuer.text = results.cert_issuer
valCertExpiry.text = results.cert_expiry
valServer.text = results.server_banner
valHsts.text = results.hsts
valXFrame.text = results.xframe
valXcto.text = results.xcto
valCsp.text = results.csp
}
}
}
