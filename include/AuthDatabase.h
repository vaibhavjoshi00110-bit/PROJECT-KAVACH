#ifndef AUTHDATABASE_H
#define AUTHDATABASE_H

#include <QObject>
#include <QString>
#include <QSqlDatabase>

class AuthDatabase : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString currentAgencyName READ currentAgencyName NOTIFY userChanged)
    Q_PROPERTY(QString currentLogoPath READ currentLogoPath NOTIFY userChanged)

public:
    explicit AuthDatabase(QObject *parent = nullptr);
    ~AuthDatabase();

    void initDatabase();
    Q_INVOKABLE bool authenticate(const QString &email, const QString &password);

    QString currentAgencyName() const { return m_agencyName; }
    QString currentLogoPath() const { return m_logoPath; }

signals:
    void userChanged();

private:
    QSqlDatabase db;
    QString m_agencyName;
    QString m_logoPath;
};

#endif // AUTHDATABASE_H
