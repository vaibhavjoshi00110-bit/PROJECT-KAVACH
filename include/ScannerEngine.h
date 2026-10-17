#ifndef SCANNERENGINE_H
#define SCANNERENGINE_H
#include <QObject>
#include <QString>
#include <QVariantMap>
#include <QVariantList>
#include <string>
#include <deque>
using namespace std;
struct DataNode{
string toolName;
string toolResult;
DataNode* next;
};
class ScannerEngine : public QObject {
Q_OBJECT
public:
explicit ScannerEngine(QObject *parent = nullptr);
~ScannerEngine();
Q_INVOKABLE void startScan(const QString &domain);
Q_INVOKABLE void wipeMemory();
Q_INVOKABLE QVariantList getHistoryList();
Q_INVOKABLE void removeHistoryItem(int index);
signals:
void scanProgress(int percent, const QString &status);
void scanComplete(QVariantMap results);
private:
DataNode* head;
deque<string> searchHistory;
void addData(string name, string res);
string execCmd(string cmd);
void clearRam();
};
#endif
