#include "Backend.h"

Backend *Backend::instance()
{
    static Backend instance;
    return &instance;
}

Backend::Backend(QObject *parent)
    : QObject(parent)
{
    //Connexion unique a la base de donnees
    QString path = dbPath.currentPath() + "/database/ns_paie.db";
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(path);

    // Delais pour que les signaux et les slots se connectent
    // avant d'emettre
    QTimer::singleShot(0, this, &Backend::initialize);
}

Backend::~Backend()
{
    //Fermeture de la connexion a la bd
    db.close();
}

void Backend::initialize()
{
    if (!db.open()) {
        emit errorOccurred("Failed to open database:" + db.lastError().text());
    }
}
