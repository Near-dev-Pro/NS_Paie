#include <QApplication>
#include <QIcon>
#include <QLocale>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTranslator>
#include <QFontDatabase>
#include "Backend.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    // Settint default font
    qint32 fontId = QFontDatabase::addApplicationFont(":/assets/fonts/roboto.ttf");
    QStringList fontList = QFontDatabase::applicationFontFamilies(fontId);
    QString family = fontList.first();
    app.setFont(QFont(family));

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = "translations/NS_Paie_" + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }

    QQmlApplicationEngine engine;

    // Exposer l'instance singleton à QML
    engine.rootContext()->setContextProperty("MyApi", Backend::instance());
    // Définir l'icône de la fenêtre
    app.setWindowIcon(QIcon("qrc:/assets/images/myIco.ico"));

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
