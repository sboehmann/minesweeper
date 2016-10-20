#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>

int main(int argc, char *argv[])
{
    QCoreApplication::setApplicationName(QStringLiteral("Minesweeper"));
    QCoreApplication::setApplicationVersion("1.0.0");
    QGuiApplication::setApplicationDisplayName(QObject::tr("Minesweeper"));

    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(QStringLiteral(":/minesweeper.png")));

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
