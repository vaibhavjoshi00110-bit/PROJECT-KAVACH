#ifndef AUTHDATABASE_H
#define AUTHDATABASE_H

#include <QObject>
#include <QtSql/QSqlDatabase>
#include <QString>

class AuthDatabase : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString currentAgencyName READ agencyName NOTIFY userChanged)
    Q_PROPERTY(QString currentLogoPath READ logoPath NOTIFY userChanged)
public:
    explicit AuthDatabase(QObject *parent = nullptr);
    ~AuthDatabase();
    Q_INVOKABLE bool authenticate(const QString &email, const QString &password);
    QString agencyName() const { return m_agencyName; }
    QString logoPath() const { return m_logoPath; }
signals:
    void userChanged();
private:
    void initDatabase();
    QSqlDatabase db;
    QString m_agencyName;
    QString m_logoPath;
};

#endif
