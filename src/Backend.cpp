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
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("db_save/ns_paie.db");

    // Delais pour que les signaux et les slots se connectent
    // avant d'emettre
    QTimer::singleShot(0, this, &Backend::initialize);
}

Backend::~Backend()
{
    delete listSectNom;
    delete listTypEmpNom;
    delete listEmp;
    delete oneEmp;
    delete groupOfEmp;

    //Fermeture de la connexion a la bd
    db.close();
}

void Backend::initialize()
{
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());
    }
}

bool Backend::startPreviewDoc(QVariant data)
{
    currentTargetPrint = data; // On fixe globalement le contenu
    QPrinter printer(QPrinter::HighResolution);
    QPrintPreviewDialog preview(&printer, 0);
    connect(&preview,
            SIGNAL(paintRequested(QPrinter*)),
            this,
            SLOT(startPrintDoc(QPrinter*)));
    preview.exec();
    return true;
}

bool Backend::startPrintDoc(QPrinter *thePrinter)
{
    QImage contentImage = qvariant_cast<QImage>(
        currentTargetPrint); // On recupere le contenu du screenshot de l'ecran
    if (contentImage.isNull()) {
        emit errorOccurred("Impossible d'imprimer le contenu!");
        return false;
    }

    if (!thePrinter) {
        emit errorOccurred("Impriment invalide!");
        return false;
    }

    QPainter painter(thePrinter);
    // Obtenir la taille de la page en millimètres
    QRectF printerRectMM = thePrinter->pageLayout().paintRect(QPageLayout::Millimeter);
    QSizeF printerSizeMM = printerRectMM.size();
    // Convertir la taille en millimètres en pixels
    int dpiX = thePrinter->logicalDpiX();
    int dpiY = thePrinter->logicalDpiY();
    int widthPixels = static_cast<int>(printerSizeMM.width() * dpiX / 25.4); // 1 pouce = 25.4 mm
    int heightPixels = static_cast<int>(printerSizeMM.height() * dpiY / 25.4);
    // Redimensionner l'image pour qu'elle s'adapte à la page
    QImage scaledImage = contentImage.scaled(widthPixels,
                                             heightPixels,
                                             Qt::KeepAspectRatio,
                                             Qt::SmoothTransformation);
    // Dessiner l'image redimensionnée
    painter.drawImage(QRect(0, 0, widthPixels, heightPixels), scaledImage);
    painter.end();
    return true;
}

QSqlQueryModel *Backend::getListSectNoms()
{
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());
    }

    listSectNom = new QSqlQueryModel(this);
    QSqlQuery query = QSqlQuery(db);

    query.prepare("select libSec from secteur");

    if (!query.exec()) {
        emit errorOccurred("Echec de la lecture des données:" + db.lastError().text());
    }

    listSectNom->setQuery(std::move(query));
    //Definition des titre personnalises
    listSectNom->setHeaderData(0, Qt::Horizontal, QObject::tr("SECTEURS"));

    return (listSectNom->rowCount() > 0)? listSectNom: nullptr;
}

QSqlQueryModel *Backend::getListTypEmpNoms()
{
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());
    }

    listTypEmpNom = new QSqlQueryModel(this);
    QSqlQuery query = QSqlQuery(db);

    query.prepare("select libTypEmp from typeEmp");

    if (!query.exec()) {
        emit errorOccurred("Echec de la lecture des données:" + db.lastError().text());
    }

    listTypEmpNom->setQuery(std::move(query));
    //Definition des titre personnalises
    listTypEmpNom->setHeaderData(0, Qt::Horizontal, QObject::tr("TYPE D'EMPLOI"));

    return (listTypEmpNom->rowCount() > 0)? listTypEmpNom: nullptr;
}

QString Backend::getSecNomForShowBull(const QString &theEmpName)
{
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());
    }

    QSqlQueryModel nomPourBull(this);
    QSqlQuery query = QSqlQuery(db);

    query.prepare("select libSec from employe join secteur on employe.idSec=secteur.idSec where libEmp=:libEmp");
    query.bindValue(":libEmp", theEmpName);

    if (!query.exec()) {
        emit errorOccurred("Echec de la lecture des données:" + db.lastError().text());
    }

    return (query.next()) ? query.value(0).toString() : "";
}

QSqlRelationalTableModel *Backend::getListEmp()
{
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());
    }

    //Assignantion du pointeur de la liste des employes
    listEmp = new QSqlRelationalTableModel(this, db);
    //Recupere la table permanent
    QString tabProName("permanent");
    listEmp->setTable(tabProName);
    listEmp->setEditStrategy(QSqlRelationalTableModel::OnManualSubmit);
    listEmp->setRelation(0, QSqlRelation("employe", "idEmp", "libEmp"));
    listEmp->setRelation(3, QSqlRelation("typeEmp", "idTypEmp", "libTypEmp"));
    listEmp->sort(0, Qt::AscendingOrder);
    listEmp->select();

    return (listEmp->rowCount() > 0)? listEmp: nullptr;
}

QSqlRelationalTableModel *Backend::getOneEmp(const QString &theName)
{
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());
    }

    //Recherche d'un employe
    oneEmp = new QSqlRelationalTableModel(this, db);
    QString myFilter = "libEmp LIKE '%"+theName+"%'";

    //Recupere la table permanent
    QString tabProName("permanent");
    oneEmp->setTable(tabProName);
    oneEmp->setEditStrategy(QSqlRelationalTableModel::OnManualSubmit);
    oneEmp->setRelation(0, QSqlRelation("employe", "idEmp", "libEmp"));
    oneEmp->setRelation(3, QSqlRelation("typeEmp", "idTypEmp", "libTypEmp"));
    oneEmp->setFilter(myFilter);
    oneEmp->sort(0, Qt::AscendingOrder);
    oneEmp->select();

    return (oneEmp->rowCount() > 0)? oneEmp: nullptr;
}

QVariantList Backend::getOneEmpForBull(const QString &theName)
{
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());
    }

    QSqlQueryModel getAllOfEmp(this);
    QSqlQuery query = QSqlQuery(db);

    query.prepare("SELECT sec.*, emp.*, per.*, pri.*, typ.* FROM employe AS emp JOIN secteur AS sec ON emp.idSec = sec.idSec JOIN permanent AS per ON emp.idEmp = per.idEmp JOIN prime AS pri ON emp.idEmp = pri.idEmp JOIN typeEmp AS typ ON per.typEmp = typ.idTypEmp WHERE emp.libEmp = :libEmp");
    query.bindValue(":libEmp", theName);

    if (!query.exec()) {
        emit errorOccurred("Echec de la lecture des données:" + db.lastError().text());
    }

    getAllOfEmp.setQuery(std::move(query));

    QVariantList list;

    if (getAllOfEmp.rowCount() <= 0) {
        emit errorOccurred("Echec de la lecture des données de l'employé(e)!");
        return list;
    }

    for (int row = 0; row < getAllOfEmp.rowCount(); ++row) {
        QVariantMap rowData;

        for (int col = 0; col < getAllOfEmp.columnCount(); ++col) {
            QString columnName = getAllOfEmp.headerData(col, Qt::Horizontal).toString();
            QVariant value = getAllOfEmp.data(getAllOfEmp.index(row, col));
            rowData[columnName] = value;
        }

        list.append(rowData); // Ajouter chaque ligne sous forme de map dans la liste
    }

    return list;
}

QSqlRelationalTableModel *Backend::getGroupOfEmp(const QString &filterData)
{
    QJsonDocument doc = QJsonDocument::fromJson(filterData.toUtf8());
    QJsonObject myObj = doc.object();

    QString libSec = myObj["sect"].toString();
    int sexIndex = myObj["sex"].toInt();
    QString dateArr = myObj["year"].toString();

    // Par la date
    QString theFilter = "dateEmp LIKE '%"+dateArr+"%'";

    // Par le sexe
    if (sexIndex >= 0) {
        theFilter.append(" OR sexEmp="+QString::number(sexIndex));
    }

    // Par secteur
    if (libSec.length() > 0) {
        theFilter.append(" OR idSec="+QString::number(getSecIdByName(libSec)));
    }

    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());
    }

    //Recherche du groupe
    groupOfEmp = new QSqlRelationalTableModel(this, db);

    //Recupere la table permanent
    QString tabProName("permanent");
    groupOfEmp->setTable(tabProName);
    groupOfEmp->setEditStrategy(QSqlRelationalTableModel::OnManualSubmit);
    groupOfEmp->setRelation(0, QSqlRelation("employe", "idEmp", "libEmp"));
    groupOfEmp->setRelation(3, QSqlRelation("typeEmp", "idTypEmp", "libTypEmp"));
    groupOfEmp->setFilter(theFilter);
    groupOfEmp->sort(0, Qt::AscendingOrder);
    groupOfEmp->select();

    return (groupOfEmp->rowCount() > 0)? groupOfEmp: nullptr;
}

void Backend::sendWarning(QString msg)
{
    emit warningOccurred("Attention: " + msg);
}

bool Backend::submitNewEmp(const QString &empData)
{
    QJsonDocument doc = QJsonDocument::fromJson(empData.toUtf8());
    QJsonObject myObj = doc.object();

    QString libSec = myObj["sect"].toString();
    QString libTypEmp = myObj["typEmp"].toString();
    int idSec = getSecIdByName(libSec);
    int idTypEmp = getTypEmpIdByName(libTypEmp);
    int lastEmpId = 0;

    //Verification du secteur
    if (idSec == 0) {
        emit errorOccurred("Secteur inconnu ou erreur interne!");

        return false;
    }

    //Debut de la logique d'insertion d'un nouvel employe...
    // Ouverture de la bd
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());

        return false;
    }

    QSqlQuery query;

    //Debut de la transaction
    query.prepare("BEGIN TRANSACTION"); // Et non 'START TRANSACTION' comme dans MySQL
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de l'ouverture de la transaction:" + query.lastError().text());

        return false;
    }

    //Insertion dans employe
    query.prepare(
        "insert into `employe` (idSec, libEmp, sexEmp, numCni, contact, dateEmp) values (:idSec, :libEmp, :sexEmp, :numCni, :contact, :dateEmp)"
    );
    query.bindValue(":idSec", idSec);
    query.bindValue(":libEmp", myObj["empName"].toString());
    query.bindValue(":sexEmp", myObj["sex"].toInt());
    query.bindValue(":numCni", myObj["numCni"].toString());
    query.bindValue(":contact", myObj["contact"].toString());
    query.bindValue(":dateEmp", myObj["year"].toString());

    if (!executeQuery(query)) {
        query.exec("ROLLBACK");

        return false;
    }
    lastEmpId = query.lastInsertId().toInt();

    // Insertion dans prime
    query.prepare(
        "insert into 'prime' (idEmp, libPri, montPri) values (:idEmp, :libPri, :montPri)"
    );
    query.bindValue(":idEmp", lastEmpId);
    query.bindValue(":libPri", "TRANSPORT");
    query.bindValue(":montPri", myObj["prime"].toInt());

    if (!executeQuery(query)) {
        query.exec("ROLLBACK");

        return false;
    }

    //Insertion dans permanent
    query.prepare(
        "insert into `permanent` (idEmp, numCnps, niu, typEmp, cate, salBase, salCot, salTax, salBrute, irpp, tc, cf, cac, rav) values "
        "(:lastEmpId, :numCnps, :niu, :typEmp, :cate, :salBase, :salCot, :salTax, :salBrute, :irpp, :tc, :cf, :cac, :rav)"
    );
    query.bindValue(":lastEmpId", lastEmpId);
    query.bindValue(":numCnps", myObj["numCnps"].toString());
    query.bindValue(":niu", myObj["niu"].toString());
    query.bindValue(":typEmp", idTypEmp);
    query.bindValue(":cate", myObj["cat"].toString());
    query.bindValue(":salBase", myObj["salBase"].toInt());
    query.bindValue(":salCot", myObj["salCot"].toInt());
    query.bindValue(":salTax", myObj["salTax"].toInt());
    query.bindValue(":salBrute", myObj["salBrute"].toInt());
    query.bindValue(":irpp", myObj["irpp"].toInt());
    query.bindValue(":tc", myObj["tc"].toInt());
    query.bindValue(":cf", myObj["cf"].toInt());
    query.bindValue(":cac", myObj["cac"].toInt());
    query.bindValue(":rav", myObj["rav"].toInt());

    if (!executeQuery(query)) {
        query.exec("ROLLBACK");

        return false;
    }

    //Fin de la transaction
    query.prepare("COMMIT");
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de sauvegarde de la transaction:" + query.lastError().text());

        return false;
    }
    emit successOperation("Effectué avec succès!");

    return true;
}

bool Backend::updateEmpNom(const QString &data)
{
    QJsonDocument doc = QJsonDocument::fromJson(data.toUtf8());
    QJsonObject myObj = doc.object();

    QString curLibEmp = myObj["currentName"].toString();
    QString newLibEmp = myObj["newName"].toString();

    // Ouverture de la bd
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());

        return false;
    }

    QSqlQuery query;

    //Debut de la transaction
    query.prepare("BEGIN TRANSACTION"); // Et non 'START TRANSACTION' comme dans MySQL
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de l'ouverture de la transaction:" + query.lastError().text());

        return false;
    }

    //Insertion dans employe
    query.prepare("update employe set libEmp=:newLib where libEmp=:curLib");
    query.bindValue(":newLib", newLibEmp);
    query.bindValue(":curLib", curLibEmp);

    if (!executeQuery(query)) {
        query.exec("ROLLBACK");

        return false;
    }

    //Fin de la transaction
    query.prepare("COMMIT");
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de sauvegarde de la transaction:" + query.lastError().text());

        return false;
    }
    emit successOperation("Effectué avec succès!");

    return true;
}

bool Backend::updateEmpNumCni(const QString &data)
{
    QJsonDocument doc = QJsonDocument::fromJson(data.toUtf8());
    QJsonObject myObj = doc.object();

    QString curLibEmp = myObj["currentName"].toString();
    QString newCni = myObj["newNumCni"].toString();

    // Ouverture de la bd
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());

        return false;
    }

    QSqlQuery query;

    //Debut de la transaction
    query.prepare("BEGIN TRANSACTION"); // Et non 'START TRANSACTION' comme dans MySQL
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de l'ouverture de la transaction:" + query.lastError().text());

        return false;
    }

    //Insertion dans employe
    query.prepare("update employe set numCni=:newCni where libEmp=:curLib");
    query.bindValue(":newCni", newCni);
    query.bindValue(":curLib", curLibEmp);

    if (!executeQuery(query)) {
        query.exec("ROLLBACK");

        return false;
    }

    //Fin de la transaction
    query.prepare("COMMIT");
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de sauvegarde de la transaction:" + query.lastError().text());

        return false;
    }
    emit successOperation("Effectué avec succès!");

    return true;
}

bool Backend::updateEmpContact(const QString &data)
{
    QJsonDocument doc = QJsonDocument::fromJson(data.toUtf8());
    QJsonObject myObj = doc.object();

    QString curLibEmp = myObj["currentName"].toString();
    QString newContact = myObj["newContact"].toString();

    // Ouverture de la bd
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());

        return false;
    }

    QSqlQuery query;

    //Debut de la transaction
    query.prepare("BEGIN TRANSACTION"); // Et non 'START TRANSACTION' comme dans MySQL
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de l'ouverture de la transaction:" + query.lastError().text());

        return false;
    }

    //Insertion dans employe
    query.prepare("update employe set contact=:newContact where libEmp=:curLib");
    query.bindValue(":newContact", newContact);
    query.bindValue(":curLib", curLibEmp);

    if (!executeQuery(query)) {
        query.exec("ROLLBACK");

        return false;
    }

    //Fin de la transaction
    query.prepare("COMMIT");
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de sauvegarde de la transaction:" + query.lastError().text());

        return false;
    }
    emit successOperation("Effectué avec succès!");

    return true;
}

bool Backend::updateEmpTypEmp(const QString &data)
{
    QJsonDocument doc = QJsonDocument::fromJson(data.toUtf8());
    QJsonObject myObj = doc.object();

    QString curLibEmp = myObj["currentName"].toString();
    QString newTypEmp = myObj["newTypEmp"].toString();
    int idOfTypEmp = getTypEmpIdByName(newTypEmp);
    int idOfEmp = getEmpIdByName(curLibEmp);

    // Ouverture de la bd
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());

        return false;
    }

    QSqlQuery query;

    //Debut de la transaction
    query.prepare("BEGIN TRANSACTION"); // Et non 'START TRANSACTION' comme dans MySQL
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de l'ouverture de la transaction:" + query.lastError().text());

        return false;
    }

    //Insertion dans permanent
    query.prepare("update permanent set typEmp=:newTyp where idEmp=:curId");
    query.bindValue(":newTyp", idOfTypEmp);
    query.bindValue(":curId", idOfEmp);

    if (!executeQuery(query)) {
        qDebug() << "BP: "<< query.lastError().text();
        query.exec("ROLLBACK");

        return false;
    }

    //Fin de la transaction
    query.prepare("COMMIT");
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de sauvegarde de la transaction:" + query.lastError().text());

        return false;
    }
    emit successOperation("Effectué avec succès!");

    return true;
}

bool Backend::updateEmpSalBase(const QString &data)
{
    QJsonDocument doc = QJsonDocument::fromJson(data.toUtf8());
    QJsonObject myObj = doc.object();

    QString curLibEmp = myObj["currentName"].toString();
    int newMont = myObj["newSalBase"].toInt();
    int idOfEmp = getEmpIdByName(curLibEmp);

    // Ouverture de la bd
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());

        return false;
    }

    QSqlQuery query;

    //Debut de la transaction
    query.prepare("BEGIN TRANSACTION"); // Et non 'START TRANSACTION' comme dans MySQL
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de l'ouverture de la transaction:" + query.lastError().text());

        return false;
    }

    //Insertion dans permanent
    query.prepare("update permanent set salBase=:newMont where idEmp=:curId");
    query.bindValue(":newMont", newMont);
    query.bindValue(":curId", idOfEmp);

    if (!executeQuery(query)) {
        query.exec("ROLLBACK");

        return false;
    }

    //Fin de la transaction
    query.prepare("COMMIT");
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de sauvegarde de la transaction:" + query.lastError().text());

        return false;
    }
    emit successOperation("Effectué avec succès!");

    return true;
}

bool Backend::updateEmpPrime(const QString &data)
{
    QJsonDocument doc = QJsonDocument::fromJson(data.toUtf8());
    QJsonObject myObj = doc.object();

    QString curLibEmp = myObj["currentName"].toString();
    int newMont = myObj["newPri"].toInt();
    int idOfEmp = getEmpIdByName(curLibEmp);

    // Ouverture de la bd
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());

        return false;
    }

    QSqlQuery query;

    //Debut de la transaction
    query.prepare("BEGIN TRANSACTION"); // Et non 'START TRANSACTION' comme dans MySQL
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de l'ouverture de la transaction:" + query.lastError().text());

        return false;
    }

    //Insertion dans permanent
    query.prepare("update prime set montPri=:newMont where idEmp=:curId");
    query.bindValue(":newMont", newMont);
    query.bindValue(":curId", idOfEmp);

    if (!executeQuery(query)) {
        query.exec("ROLLBACK");

        return false;
    }

    //Fin de la transaction
    query.prepare("COMMIT");
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de sauvegarde de la transaction:" + query.lastError().text());

        return false;
    }
    emit successOperation("Effectué avec succès!");

    return true;
}

bool Backend::updateEmpSalCot(const QString &data)
{
    QJsonDocument doc = QJsonDocument::fromJson(data.toUtf8());
    QJsonObject myObj = doc.object();

    QString curLibEmp = myObj["currentName"].toString();
    int newMont = myObj["newSalCot"].toInt();
    int idOfEmp = getEmpIdByName(curLibEmp);

    // Ouverture de la bd
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());

        return false;
    }

    QSqlQuery query;

    //Debut de la transaction
    query.prepare("BEGIN TRANSACTION"); // Et non 'START TRANSACTION' comme dans MySQL
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de l'ouverture de la transaction:" + query.lastError().text());

        return false;
    }

    //Insertion dans permanent
    query.prepare("update permanent set salCot=:newMont where idEmp=:curId");
    query.bindValue(":newMont", newMont);
    query.bindValue(":curId", idOfEmp);

    if (!executeQuery(query)) {
        query.exec("ROLLBACK");

        return false;
    }

    //Fin de la transaction
    query.prepare("COMMIT");
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de sauvegarde de la transaction:" + query.lastError().text());

        return false;
    }
    emit successOperation("Effectué avec succès!");

    return true;
}

bool Backend::updateEmpSalTax(const QString &data)
{
    QJsonDocument doc = QJsonDocument::fromJson(data.toUtf8());
    QJsonObject myObj = doc.object();

    QString curLibEmp = myObj["currentName"].toString();
    int newMont = myObj["newSalTax"].toInt();
    int idOfEmp = getEmpIdByName(curLibEmp);

    // Ouverture de la bd
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());

        return false;
    }

    QSqlQuery query;

    //Debut de la transaction
    query.prepare("BEGIN TRANSACTION"); // Et non 'START TRANSACTION' comme dans MySQL
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de l'ouverture de la transaction:" + query.lastError().text());

        return false;
    }

    //Insertion dans permanent
    query.prepare("update permanent set salTax=:newMont where idEmp=:curId");
    query.bindValue(":newMont", newMont);
    query.bindValue(":curId", idOfEmp);

    if (!executeQuery(query)) {
        query.exec("ROLLBACK");

        return false;
    }

    //Fin de la transaction
    query.prepare("COMMIT");
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de sauvegarde de la transaction:" + query.lastError().text());

        return false;
    }
    emit successOperation("Effectué avec succès!");

    return true;
}

bool Backend::updateEmpSalBrute(const QString &data)
{
    QJsonDocument doc = QJsonDocument::fromJson(data.toUtf8());
    QJsonObject myObj = doc.object();

    QString curLibEmp = myObj["currentName"].toString();
    int newMont = myObj["newSalBrute"].toInt();
    int idOfEmp = getEmpIdByName(curLibEmp);

    // Ouverture de la bd
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());

        return false;
    }

    QSqlQuery query;

    //Debut de la transaction
    query.prepare("BEGIN TRANSACTION"); // Et non 'START TRANSACTION' comme dans MySQL
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de l'ouverture de la transaction:" + query.lastError().text());

        return false;
    }

    //Insertion dans permanent
    query.prepare("update permanent set salBrute=:newMont where idEmp=:curId");
    query.bindValue(":newMont", newMont);
    query.bindValue(":curId", idOfEmp);

    if (!executeQuery(query)) {
        query.exec("ROLLBACK");

        return false;
    }

    //Fin de la transaction
    query.prepare("COMMIT");
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de sauvegarde de la transaction:" + query.lastError().text());

        return false;
    }
    emit successOperation("Effectué avec succès!");

    return true;
}

bool Backend::updateEmpIrpp(const QString &data)
{
    QJsonDocument doc = QJsonDocument::fromJson(data.toUtf8());
    QJsonObject myObj = doc.object();

    QString curLibEmp = myObj["currentName"].toString();
    int newMont = myObj["newIrpp"].toInt();
    int idOfEmp = getEmpIdByName(curLibEmp);

    // Ouverture de la bd
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());

        return false;
    }

    QSqlQuery query;

    //Debut de la transaction
    query.prepare("BEGIN TRANSACTION"); // Et non 'START TRANSACTION' comme dans MySQL
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de l'ouverture de la transaction:" + query.lastError().text());

        return false;
    }

    //Insertion dans permanent
    query.prepare("update permanent set irpp=:newMont where idEmp=:curId");
    query.bindValue(":newMont", newMont);
    query.bindValue(":curId", idOfEmp);

    if (!executeQuery(query)) {
        query.exec("ROLLBACK");

        return false;
    }

    //Fin de la transaction
    query.prepare("COMMIT");
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de sauvegarde de la transaction:" + query.lastError().text());

        return false;
    }
    emit successOperation("Effectué avec succès!");

    return true;
}

bool Backend::updateEmpTc(const QString &data)
{
    QJsonDocument doc = QJsonDocument::fromJson(data.toUtf8());
    QJsonObject myObj = doc.object();

    QString curLibEmp = myObj["currentName"].toString();
    int newMont = myObj["newTc"].toInt();
    int idOfEmp = getEmpIdByName(curLibEmp);

    // Ouverture de la bd
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());

        return false;
    }

    QSqlQuery query;

    //Debut de la transaction
    query.prepare("BEGIN TRANSACTION"); // Et non 'START TRANSACTION' comme dans MySQL
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de l'ouverture de la transaction:" + query.lastError().text());

        return false;
    }

    //Insertion dans permanent
    query.prepare("update permanent set tc=:newMont where idEmp=:curId");
    query.bindValue(":newMont", newMont);
    query.bindValue(":curId", idOfEmp);

    if (!executeQuery(query)) {
        query.exec("ROLLBACK");

        return false;
    }

    //Fin de la transaction
    query.prepare("COMMIT");
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de sauvegarde de la transaction:" + query.lastError().text());

        return false;
    }
    emit successOperation("Effectué avec succès!");

    return true;
}

bool Backend::updateEmpCf(const QString &data)
{
    QJsonDocument doc = QJsonDocument::fromJson(data.toUtf8());
    QJsonObject myObj = doc.object();

    QString curLibEmp = myObj["currentName"].toString();
    int newMont = myObj["newCf"].toInt();
    int idOfEmp = getEmpIdByName(curLibEmp);

    // Ouverture de la bd
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());

        return false;
    }

    QSqlQuery query;

    //Debut de la transaction
    query.prepare("BEGIN TRANSACTION"); // Et non 'START TRANSACTION' comme dans MySQL
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de l'ouverture de la transaction:" + query.lastError().text());

        return false;
    }

    //Insertion dans permanent
    query.prepare("update permanent set cf=:newMont where idEmp=:curId");
    query.bindValue(":newMont", newMont);
    query.bindValue(":curId", idOfEmp);

    if (!executeQuery(query)) {
        query.exec("ROLLBACK");

        return false;
    }

    //Fin de la transaction
    query.prepare("COMMIT");
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de sauvegarde de la transaction:" + query.lastError().text());

        return false;
    }
    emit successOperation("Effectué avec succès!");

    return true;
}

bool Backend::updateEmpCac(const QString &data)
{
    QJsonDocument doc = QJsonDocument::fromJson(data.toUtf8());
    QJsonObject myObj = doc.object();

    QString curLibEmp = myObj["currentName"].toString();
    int newMont = myObj["newCac"].toInt();
    int idOfEmp = getEmpIdByName(curLibEmp);

    // Ouverture de la bd
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());

        return false;
    }

    QSqlQuery query;

    //Debut de la transaction
    query.prepare("BEGIN TRANSACTION"); // Et non 'START TRANSACTION' comme dans MySQL
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de l'ouverture de la transaction:" + query.lastError().text());

        return false;
    }

    //Insertion dans permanent
    query.prepare("update permanent set cac=:newMont where idEmp=:curId");
    query.bindValue(":newMont", newMont);
    query.bindValue(":curId", idOfEmp);

    if (!executeQuery(query)) {
        query.exec("ROLLBACK");

        return false;
    }

    //Fin de la transaction
    query.prepare("COMMIT");
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de sauvegarde de la transaction:" + query.lastError().text());

        return false;
    }
    emit successOperation("Effectué avec succès!");

    return true;
}

bool Backend::updateEmpRav(const QString &data)
{
    QJsonDocument doc = QJsonDocument::fromJson(data.toUtf8());
    QJsonObject myObj = doc.object();

    QString curLibEmp = myObj["currentName"].toString();
    int newMont = myObj["newRav"].toInt();
    int idOfEmp = getEmpIdByName(curLibEmp);

    // Ouverture de la bd
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());

        return false;
    }

    QSqlQuery query;

    //Debut de la transaction
    query.prepare("BEGIN TRANSACTION"); // Et non 'START TRANSACTION' comme dans MySQL
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de l'ouverture de la transaction:" + query.lastError().text());

        return false;
    }

    //Insertion dans permanent
    query.prepare("update permanent set rav=:newMont where idEmp=:curId");
    query.bindValue(":newMont", newMont);
    query.bindValue(":curId", idOfEmp);

    if (!executeQuery(query)) {
        query.exec("ROLLBACK");

        return false;
    }

    //Fin de la transaction
    query.prepare("COMMIT");
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de sauvegarde de la transaction:" + query.lastError().text());

        return false;
    }
    emit successOperation("Effectué avec succès!");

    return true;
}

int Backend::getEmpIdByName(const QString &libEmp)
{
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());
        return 0;
    }

    QSqlQuery query;
    query.prepare("select idEmp from `employe` where libEmp=:libEmp");
    query.bindValue(":libEmp", libEmp);

    if (!query.exec()) {
        return 0;
    }
    return (query.next()) ? query.value(0).toInt() : 0;
}

int Backend::getSecIdByName(const QString &libSec)
{
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());
        return 0;
    }

    QSqlQuery query;
    query.prepare("select idSec from `secteur` where libSec=:libSec");
    query.bindValue(":libSec", libSec);

    if (!query.exec()) {
        return 0;
    }
    return (query.next()) ? query.value(0).toInt() : 0;
}

int Backend::getTypEmpIdByName(const QString &libTypEmp)
{
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());
        return 0;
    }

    QSqlQuery query;
    query.prepare("select idTypEmp from `typeEmp` where libTypEmp=:libTypEmp");
    query.bindValue(":libTypEmp", libTypEmp);

    if (!query.exec()) {
        return 0;
    }
    return (query.next()) ? query.value(0).toInt() : 0;
}

bool Backend::executeQuery(QSqlQuery &query)
{
    if (!query.exec()) {
        return false;
    }
    return true;
}
