#include "../include/AuthDatabase.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QVariant>
#include <QDir>
#include <QDebug>

AuthDatabase::AuthDatabase(QObject *parent) : QObject(parent) { 
    initDatabase(); 
}

AuthDatabase::~AuthDatabase() { 
    if (db.isOpen()) db.close(); 
}

void AuthDatabase::initDatabase() {
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("kavach_vault.db");
    if (!db.open()) return;

    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT UNIQUE, password TEXT, agency TEXT, logo_path TEXT)");
    
    query.exec("SELECT COUNT(*) FROM users");
    if (query.next() && query.value(0).toInt() == 0) {
        QString currentPath = QDir::currentPath() + "/assets/";
        QList<QStringList> initialData = {
            {"drdo.chief@gov.in", "Kavach@2026", "DEFENCE RESEARCH & DEVELOPMENT ORGANISATION", "file://" + currentPath + "drdo_logo.png"},
            {"ntro.apex@gov.in", "Kavach@2026", "NATIONAL TECHNICAL RESEARCH ORGANISATION", "file://" + currentPath + "ntro_logo.png"},
            {"raw.ops@gov.in", "Kavach@2026", "RESEARCH AND ANALYSIS WING", "file://" + currentPath + "raw_logo.png"}
        };
        query.prepare("INSERT INTO users (email, password, agency, logo_path) VALUES (?, ?, ?, ?)");
        for (const auto &user : initialData) {
            query.addBindValue(user[0]); query.addBindValue(user[1]);
            query.addBindValue(user[2]); query.addBindValue(user[3]);
            query.exec();
        }
    }
}

bool AuthDatabase::authenticate(const QString &email, const QString &password) {
    QSqlQuery query;
    query.prepare("SELECT password, agency, logo_path FROM users WHERE email = ?");
    query.addBindValue(email);
    
    if (query.exec() && query.next()) {
        if(query.value(0).toString() == password) {
            m_agencyName = query.value(1).toString();
            m_logoPath = query.value(2).toString();
            emit userChanged();
            return true;
        }
    }
    return false;
}
