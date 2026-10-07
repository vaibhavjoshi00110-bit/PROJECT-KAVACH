#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include "../include/AuthDatabase.h"
#include "../include/ScannerEngine.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    AuthDatabase authDb;
    ScannerEngine scanner;
    QQmlApplicationEngine engine;
    
    engine.rootContext()->setContextProperty("applicationDirPath", QDir::currentPath());
    engine.rootContext()->setContextProperty("AuthDB", &authDb);
    engine.rootContext()->setContextProperty("Scanner", &scanner);

    const QUrl url(QStringLiteral("file://") + QDir::currentPath() + "/ui/Login.qml");
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
