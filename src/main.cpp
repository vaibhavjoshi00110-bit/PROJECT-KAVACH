#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include <QCoreApplication>
#include "../include/AuthDatabase.h"
#include "../include/ScannerEngine.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    AuthDatabase authDb;
    ScannerEngine scanner;
    QQmlApplicationEngine engine;
    
    // Project ke main folder ka path nikal rahe hain (build ke ek level upar)
    QString projectRoot = QCoreApplication::applicationDirPath() + "/..";
    
    engine.rootContext()->setContextProperty("applicationDirPath", projectRoot);
    engine.rootContext()->setContextProperty("AuthDB", &authDb);
    engine.rootContext()->setContextProperty("Scanner", &scanner);

    // Ab file seedha main folder wale 'ui' se load hogi, build folder ke andar se nahi
    const QUrl url(QStringLiteral("file://") + projectRoot + "/ui/Login.qml");
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
