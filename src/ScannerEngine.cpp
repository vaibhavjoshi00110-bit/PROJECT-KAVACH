#include "../include/ScannerEngine.h"
#include <thread>
#include <array>
#include <memory>
#include <algorithm>
#include <iostream>
#include <sstream>
using namespace std;
ScannerEngine::ScannerEngine(QObject *parent) : QObject(parent){
head = nullptr;
}
ScannerEngine::~ScannerEngine(){
clearRam();
}
void ScannerEngine::wipeMemory(){
clearRam();
}
QVariantList ScannerEngine::getHistoryList(){
QVariantList list;
for(const string& s : searchHistory){
list.append(QString::fromStdString(s));
}
return list;
}
void ScannerEngine::removeHistoryItem(int index){
if(index >= 0 && index < searchHistory.size()){
auto it = searchHistory.begin() + index;
fill(it->begin(), it->end(), '*');
searchHistory.erase(it);
}
}
void ScannerEngine::clearRam(){
DataNode* temp = head;
while(temp != nullptr){
DataNode* n = temp->next;
fill(temp->toolName.begin(), temp->toolName.end(), '0');
fill(temp->toolResult.begin(), temp->toolResult.end(), 'X');
delete temp;
temp = n;
}
head = nullptr;
for(auto& s : searchHistory){
fill(s.begin(), s.end(), '*');
}
searchHistory.clear();
}
void ScannerEngine::addData(string name, string res){
DataNode* nn = new DataNode{name, res, nullptr};
if(!head) head = nn;
else{
DataNode* t = head;
while(t->next) t = t->next;
t->next = nn;
}
}
string ScannerEngine::execCmd(string cmd){
array<char, 256> buf;
string out = "";
unique_ptr<FILE, decltype(&pclose)> pipe(popen(cmd.c_str(), "r"), pclose);
if(!pipe) return "Error";
while(fgets(buf.data(), buf.size(), pipe.get()) != nullptr){
out += buf.data();
}
if(!out.empty() && out.back() == '\n') out.pop_back();
return out.empty() ? "NOT FOUND" : out;
}
void ScannerEngine::startScan(const QString &domain){
string target = domain.toStdString();
searchHistory.push_front(target);
std::thread([this, target](){
emit scanProgress(10, "RESOLVING IP, ISP & SUBDOMAINS...");
string ip = execCmd("timeout 3 dig @8.8.8.8 +short " + target + " A | grep -E '^[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+$' | head -n 1");
if(ip == "NOT FOUND" || ip == ""){
QVariantMap errMap;
errMap["overall_score"] = 0; errMap["crypto_score"] = "0 / 25"; errMap["auth_score"] = "0 / 20";
errMap["ip_asn"] = "DOMAIN DEAD"; errMap["waf"] = "FAIL"; errMap["spf"] = "FAIL";
errMap["mx"] = "FAIL"; errMap["dmarc"] = "FAIL"; errMap["dnssec"] = "FAIL"; 
errMap["tls"] = "FAIL"; errMap["cipher"] = "FAIL"; errMap["cert_issuer"] = "FAIL"; 
errMap["cert_expiry"] = "FAIL"; errMap["server_banner"] = "FAIL"; errMap["hsts"] = "FAIL"; 
errMap["xframe"] = "FAIL"; errMap["xcto"] = "FAIL"; errMap["csp"] = "FAIL"; 
errMap["sec_txt"] = "FAIL"; errMap["robots"] = "FAIL"; errMap["subdomains"] = "FAIL";
emit scanProgress(100, "TARGET UNREACHABLE.");
emit scanComplete(errMap);
return;
}
addData("IP", ip);
string asn = execCmd("timeout 3 curl -s ipinfo.io/" + ip + "/org");
if(asn.empty() || asn.find("html") != string::npos) asn = "UNKNOWN ISP";
string ip_asn = ip + " (" + asn + ")";
string subs = execCmd("timeout 5 curl -s 'https://crt.sh/?q=%25." + target + "&output=json' | grep -o '\"name_value\":\"[^\"]*\"' | cut -d'\"' -f4 | sort -u | head -n 2");
if(subs.empty() || subs == "NOT FOUND") subs = "NONE DETECTED";
else{ replace(subs.begin(), subs.end(), '\n', ' '); }
emit scanProgress(30, "EXTRACTING DNS AUTH & WAF RECORDS...");
string mxRaw = execCmd("timeout 4 dig @8.8.8.8 +short " + target + " MX | head -n 1");
string mx = mxRaw.empty() ? "NOT CONFIGURED" : mxRaw;
string spfRaw = execCmd("timeout 4 dig @8.8.8.8 +short " + target + " TXT | grep -i 'v=spf1' | head -n 1");
string dmarcRaw = execCmd("timeout 4 dig @8.8.8.8 +short _dmarc." + target + " TXT | grep -i 'v=DMARC1' | head -n 1");
string ds = execCmd("timeout 4 dig @8.8.8.8 +short " + target + " DS | head -n 1");
string spf = spfRaw.empty() ? "NOT CONFIGURED" : "CONFIGURED (SECURE)";
string dmarc = dmarcRaw.empty() ? "NOT CONFIGURED" : "CONFIGURED (SECURE)";
string dnssecStatus = (ds == "NOT FOUND" || ds.empty()) ? "NOT CONFIGURED" : "VERIFIED (DS SECURED)";
emit scanProgress(50, "AUDITING HEADERS & POLICIES...");
string hdrRaw = execCmd("curl -k -s -L -D - -o /dev/null -A 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)' --max-time 7 https://" + target);
string hsts = "NOT CONFIGURED", xframe = "NOT CONFIGURED", xcto = "NOT CONFIGURED", csp = "NOT CONFIGURED", server = "UNKNOWN";
stringstream ssHdr(hdrRaw); string hLine;
while(getline(ssHdr, hLine)){
string lowerLine = hLine;
transform(lowerLine.begin(), lowerLine.end(), lowerLine.begin(), ::tolower);
if(lowerLine.find("strict-transport-security:") != string::npos) hsts = "ENFORCED (SECURE)";
if(lowerLine.find("x-frame-options:") != string::npos) xframe = "CONFIGURED (SECURE)";
if(lowerLine.find("x-content-type-options:") != string::npos) xcto = "CONFIGURED (SECURE)";
if(lowerLine.find("content-security-policy:") != string::npos) csp = "CONFIGURED (SECURE)";
if(lowerLine.find("server:") != string::npos){
server = hLine.substr(hLine.find(":")+1);
server.erase(0, server.find_first_not_of(" \t\r\n")); server.erase(server.find_last_not_of(" \t\r\n")+1);
}
}
string secTxtRaw = execCmd("curl -k -s -I -m 3 https://" + target + "/.well-known/security.txt | grep -i 'HTTP/.* 200'");
string secTxt = secTxtRaw.empty() ? "NOT FOUND (MISSING VDP)" : "CONFIGURED (SECURE)";
string robotsRaw = execCmd("curl -k -s -I -m 3 https://" + target + "/robots.txt | grep -i 'HTTP/.* 200'");
string robots = robotsRaw.empty() ? "NOT FOUND" : "EXPOSED (VERIFY PATHS)";
string waf = "NOT DETECTED / NATIVE";
string srvLow = server;
transform(srvLow.begin(), srvLow.end(), srvLow.begin(), ::tolower);
if(srvLow.find("cloudflare") != string::npos) waf = "CLOUDFLARE WAF ENFORCED";
else if(srvLow.find("akamai") != string::npos) waf = "AKAMAI EDGE NODE";
else if(srvLow.find("sucuri") != string::npos) waf = "SUCURI FIREWALL";
else if(srvLow.find("imperva") != string::npos) waf = "IMPERVA INCAPSULA";
emit scanProgress(75, "EXTRACTING TLS, CIPHER & CERTIFICATES...");
string tlsCmd = "echo 'Q' | timeout 5 openssl s_client -connect " + target + ":443 -servername " + target + " 2>/dev/null";
string tlsRaw = execCmd(tlsCmd);
string tls = "NOT FOUND", cipher = "NOT FOUND";
stringstream ssTls(tlsRaw); string tLine;
while(getline(ssTls, tLine)){
if(tLine.find("Protocol  :") != string::npos) tls = tLine.substr(tLine.find(":")+1);
else if(tLine.find("Cipher    :") != string::npos) cipher = tLine.substr(tLine.find(":")+1);
else if(tLine.find("Cipher is ") != string::npos) cipher = tLine.substr(tLine.find("Cipher is ")+10);
else if(tLine.find("New, ") != string::npos && tLine.find(", Cipher is ") != string::npos){
cipher = tLine.substr(tLine.find("Cipher is ") + 10);
}
}
auto cleanStr = [](string &s){
if(s == "NOT FOUND") return;
s.erase(0, s.find_first_not_of(" \t\r\n")); s.erase(s.find_last_not_of(" \t\r\n")+1);
if(s == "0000" || s.find("NONE") != string::npos) s = "NOT FOUND";
};
cleanStr(tls); cleanStr(cipher);
string certCmd = "timeout 5 openssl s_client -showcerts -connect " + target + ":443 -servername " + target + " < /dev/null 2>/dev/null | openssl x509 -noout -issuer -dates 2>/dev/null";
string certRaw = execCmd(certCmd);
string certIssuer = "NOT FOUND", certExpiry = "NOT FOUND";
stringstream ssCert(certRaw); string cLine;
while(getline(ssCert, cLine)){
if(cLine.find("issuer=") != string::npos){
if(cLine.find("O = ") != string::npos){ int pos = cLine.find("O = ") + 4; certIssuer = cLine.substr(pos, cLine.find(",", pos) - pos); }
else if(cLine.find("O=") != string::npos){ int pos = cLine.find("O=") + 2; certIssuer = cLine.substr(pos, cLine.find(",", pos) - pos); }
else if(cLine.find("CN = ") != string::npos){ int pos = cLine.find("CN = ") + 5; certIssuer = cLine.substr(pos, cLine.find(",", pos) - pos); }
else if(cLine.find("CN=") != string::npos){ int pos = cLine.find("CN=") + 3; certIssuer = cLine.substr(pos, cLine.find(",", pos) - pos); }
else { certIssuer = cLine.substr(7); }
}
if(cLine.find("notAfter=") != string::npos) certExpiry = cLine.substr(9);
}
emit scanProgress(90, "CALCULATING THREAT SCORES...");
int total = 100, crypto = 25, auth = 20;
if(spf == "NOT CONFIGURED"){ total -= 10; auth -= 5; }
if(dmarc == "NOT CONFIGURED"){ total -= 10; auth -= 5; }
if(tls == "NOT FOUND" || tls.find("TLSv1.0") != string::npos || tls.find("TLSv1.1") != string::npos){ total -= 20; crypto -= 15; }
if(dnssecStatus == "NOT CONFIGURED"){ total -= 5; auth -= 5; }
if(hsts == "NOT CONFIGURED") total -= 5;
if(csp == "NOT CONFIGURED") total -= 5;
if(secTxt == "NOT FOUND (MISSING VDP)") total -= 2;
QVariantMap results;
results["overall_score"] = total; results["crypto_score"] = QString::number(crypto) + " / 25";
results["auth_score"] = QString::number(auth) + " / 20"; results["ip_asn"] = QString::fromStdString(ip_asn);
results["waf"] = QString::fromStdString(waf); results["mx"] = QString::fromStdString(mx);
results["spf"] = QString::fromStdString(spf); results["dmarc"] = QString::fromStdString(dmarc); 
results["dnssec"] = QString::fromStdString(dnssecStatus); results["tls"] = QString::fromStdString(tls); 
results["cipher"] = QString::fromStdString(cipher); results["cert_issuer"] = QString::fromStdString(certIssuer); 
results["cert_expiry"] = QString::fromStdString(certExpiry); results["server_banner"] = QString::fromStdString(server); 
results["hsts"] = QString::fromStdString(hsts); results["xframe"] = QString::fromStdString(xframe); 
results["xcto"] = QString::fromStdString(xcto); results["csp"] = QString::fromStdString(csp); 
results["sec_txt"] = QString::fromStdString(secTxt); results["robots"] = QString::fromStdString(robots); 
results["subdomains"] = QString::fromStdString(subs);
emit scanProgress(100, "POSTURE EVALUATED.");
emit scanComplete(results);
}).detach();
}
