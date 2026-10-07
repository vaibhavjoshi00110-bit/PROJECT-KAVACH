#ifndef SCANNERENGINE_H
#define SCANNERENGINE_H

#include <QObject>
#include <QString>
#include <QVariantMap>
#include <QNetworkAccessManager>
#include <QJsonArray>

class ScannerEngine : public QObject {
    Q_OBJECT
public:
    explicit ScannerEngine(QObject *parent = nullptr);
    
    Q_INVOKABLE void startScan(const QString &domain);
    Q_INVOKABLE void askGemini(const QString &userMessage);

signals:
    void scanProgress(int percent, const QString &status);
    void scanComplete(QVariantMap results);
    void chatMessageReceived(const QString &sender, const QString &message);

private:
    QNetworkAccessManager *networkManager;
    QString lastScanContext;
};

#endif // SCANNERENGINE_H
