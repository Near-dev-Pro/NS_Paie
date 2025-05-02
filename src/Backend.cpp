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
    delete getAllOfEmp;
    delete histOfEmp;
    delete fullHis;

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

QSqlQueryModel *Backend::getListEmp()
{
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());
    }

    //Assignantion du pointeur de la liste des employes
    listEmp = new QSqlQueryModel(this);

    //Recupere la table employe
    QSqlQuery query;
    query.prepare("SELECT emp.*, sec.*, pri.*, typ.* FROM employe AS emp JOIN secteur AS sec ON emp.idSec = sec.idSec JOIN prime AS pri ON emp.idEmp = pri.idEmp JOIN typeEmp AS typ ON emp.idTypEmp = typ.idTypEmp ORDER BY emp.libEmp ASC");

    if (!executeQuery(query)) {
        emit errorOccurred("Echec de la lecture des données:" + query.lastError().text());
    }

    listEmp->setQuery(std::move(query));

    return (listEmp->rowCount() > 0)? listEmp: nullptr;
}

QSqlQueryModel *Backend::getOneEmp(const QString &theName)
{
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());
    }

    //Recherche d'un employe
    oneEmp = new QSqlQueryModel(this);
    QSqlQuery query;
    query.prepare("SELECT emp.*, sec.*, pri.*, typ.* FROM employe AS emp JOIN secteur AS sec ON emp.idSec = sec.idSec JOIN prime AS pri ON emp.idEmp = pri.idEmp JOIN typeEmp AS typ ON emp.idTypEmp = typ.idTypEmp WHERE emp.libEmp LIKE '%"+theName+"%'");

    if (!query.exec()) {
        emit errorOccurred("Echec de la lecture des données:" + query.lastError().text());
    }

    oneEmp->setQuery(std::move(query));

    return (oneEmp->rowCount() > 0)? oneEmp: nullptr;
}

QSqlQueryModel *Backend::getFullHis(int start, int year)
{
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());
    }

    //Recherche d'un history
    fullHis = new QSqlQueryModel(this);
    QSqlQuery query;
    query.prepare("SELECT his.dateHis, his.salBase, his.salTaxCot, his.prime, his.salBrute, his.impot, his.montCnps, his.totRet, his.nap, emp.libEmp FROM history AS his JOIN employe AS emp ON his.idEmp = emp.idEmp WHERE his.dateHis LIKE '%"+QString::number(year)+"%' ORDER BY his.idHis DESC LIMIT "+QString::number(start)+", 100");

    if (!query.exec()) {
        emit errorOccurred("Echec de la lecture des données:" + query.lastError().text());
    }

    fullHis->setQuery(std::move(query));

    return (fullHis->rowCount() > 0)? fullHis: nullptr;
}

QSqlQueryModel *Backend::getHisOfEmp(const QString &theName)
{
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());
    }

    //Recherche d'un history
    histOfEmp = new QSqlQueryModel(this);
    QSqlQuery query;
    query.prepare("SELECT his.dateHis, his.salBase, his.salTaxCot, his.prime, his.salBrute, his.impot, his.montCnps, his.totRet, his.nap FROM history AS his JOIN employe AS emp ON his.idEmp = emp.idEmp WHERE emp.libEmp = :libEmp");
    query.bindValue(":libEmp", theName);

    if (!query.exec()) {
        emit errorOccurred("Echec de la lecture des données:" + query.lastError().text());
    }

    histOfEmp->setQuery(std::move(query));

    return (histOfEmp->rowCount() > 0)? histOfEmp: nullptr;
}

QVariantList Backend::getOneEmpForBull(const QString &data)
{
    QJsonDocument doc = QJsonDocument::fromJson(data.toUtf8());
    QJsonObject myObj = doc.object();

    QString theName = myObj["empName"].toString();
    bool isOverview = myObj["isOverview"].toBool();

    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());
    }

    getAllOfEmp = new QSqlQueryModel(this);
    QSqlQuery query(db);

    query.prepare("SELECT emp.*, sec.*, pri.*, typ.* FROM employe AS emp JOIN secteur AS sec ON emp.idSec = sec.idSec JOIN prime AS pri ON emp.idEmp = pri.idEmp JOIN typeEmp AS typ ON emp.idTypEmp = typ.idTypEmp WHERE emp.libEmp = :libEmp");
    query.bindValue(":libEmp", theName);

    if (!query.exec()) {
        emit errorOccurred("Echec de la lecture des données:" + query.lastError().text());
    }

    getAllOfEmp->setQuery(std::move(query));

    QVariantList list;

    if (getAllOfEmp->rowCount() <= 0) {
        emit errorOccurred("Echec de la lecture des données de l'employé(e)!");
        return list;
    }

    for (int row = 0; row < getAllOfEmp->rowCount(); ++row) {
        QVariantMap rowData;

        for (int col = 0; col < getAllOfEmp->columnCount(); ++col) {
            QString columnName = getAllOfEmp->headerData(col, Qt::Horizontal).toString();
            QVariant value = getAllOfEmp->data(getAllOfEmp->index(row, col));
            rowData[columnName] = value;
        }

        list.append(rowData); // Ajouter chaque ligne sous forme de map dans la liste
    }

    if (!isOverview) {
        insertInHis(list);
    }

    return list;
}

void Backend::insertInHis(QVariantList &list)
{
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());
        return;
    }

    QSqlQuery query(db);

    //Debut de la transaction
    query.prepare("BEGIN TRANSACTION"); // Et non 'START TRANSACTION' comme dans MySQL
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de l'ouverture de la transaction:" + query.lastError().text());
        return;
    }

    //Insertion dans historique
    int lastHis = 0;

    QVariantMap rowData = list[0].toMap();

    int salBru = rowData["salBase"].toInt() + rowData["montPri"].toInt();
    int impot = rowData["irpp"].toInt() + rowData["tc"].toInt() + rowData["cf"].toInt() + rowData["cac"].toInt() + rowData["rav"].toInt();
    int cnps = rowData["salCot"].toInt() * 0.042;
    int totRet = impot + cnps;
    int nap = salBru - totRet;

    query.prepare(
        "insert into history (idEmp, dateHis, salBase, salTaxCot, prime, salBrute, impot, montCnps, totRet, nap) values "
        "(:idEmp, :dateHis, :salBase, :salTaxCot, :prime, :salBrute, :impot, :montCnps, :totRet, :nap)"
        );
    query.bindValue(":idEmp", rowData["idEmp"].toInt());
    query.bindValue(":dateHis", QDateTime::currentDateTime());
    query.bindValue(":salBase", rowData["salBase"].toInt());
    query.bindValue(":salTaxCot", rowData["salCot"].toInt());
    query.bindValue(":prime", rowData["montPri"].toInt());
    query.bindValue(":salBrute", salBru);
    query.bindValue(":impot", impot);
    query.bindValue(":montCnps", cnps);
    query.bindValue(":totRet", totRet);
    query.bindValue(":nap", nap);

    if (!executeQuery(query)) {
        query.exec("ROLLBACK");
        return;
    }
    lastHis = query.lastInsertId().toInt();

    //Fin de la transaction
    query.prepare("COMMIT");
    if (!executeQuery(query)) {
        emit errorOccurred("Echec de sauvegarde de la transaction:" + query.lastError().text());
        return;
    }

    rowData["lastHisId"] = QVariant(lastHis);
    list[0] = rowData;
}

QSqlQueryModel *Backend::getGroupOfEmp(const QString &filterData, bool isHis)
{
    QJsonDocument doc = QJsonDocument::fromJson(filterData.toUtf8());
    QJsonObject myObj = doc.object();

    QString libSec = myObj["sect"].toString();
    int sexIndex = myObj["sex"].toInt();
    QString anArriv = myObj["anArriv"].toString();

    // la requete avant les filtres
    QString theQuery("SELECT emp.*, sec.*, pri.*, typ.* FROM employe AS emp JOIN secteur AS sec ON emp.idSec = sec.idSec JOIN prime AS pri ON emp.idEmp = pri.idEmp JOIN typeEmp AS typ ON emp.idTypEmp = typ.idTypEmp WHERE ");

    if (isHis) {
        // Par secteur
        theQuery.append("sec.idSec="+QString::number(getSecIdByName(libSec)));
    }
    else {
        // Par la date
        theQuery.append("emp.anArriv LIKE '%"+anArriv+"%'");

        // Par le sexe
        if (sexIndex >= 0) {
            theQuery.append(" OR emp.sexEmp="+QString::number(sexIndex));
        }

        // Par secteur
        if (libSec.length() > 0) {
            theQuery.append(" OR sec.idSec="+QString::number(getSecIdByName(libSec)));
        }
    }

    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());
    }

    //Recherche du groupe
    groupOfEmp = new QSqlQueryModel(this);

    //Recupere la table employe
    if (!db.open()) {
        emit errorOccurred("Echec de l'ouverture de la base de données:" + db.lastError().text());
    }

    QSqlQuery query(db);

    query.prepare(theQuery);

    if (!query.exec()) {
        emit errorOccurred("Echec de la lecture des données:" + query.lastError().text());
    }

    groupOfEmp->setQuery(std::move(query));

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
    QString libNewTypEmp = myObj["newTypEmp"].toString();
    int idSec = getSecIdByName(libSec);
    int idTypEmp = 0;
    int lastEmpId = 0;

    // S'il n'y a pas un nouveau type d'emploi
    if (libNewTypEmp.isEmpty()) {
        idTypEmp = getTypEmpIdByName(libTypEmp);
    }

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

    // S'il y a un nouveau type d'emploi
    if (!libNewTypEmp.isEmpty()) {
        //Insertion dans typeEmp
        query.prepare(
            "insert into `typeEmp` "
            "(libTypEmp) values "
            "(:libTypEmp)"
            );
        query.bindValue(":libTypEmp", libNewTypEmp);

        if (!executeQuery(query)) {
            query.exec("ROLLBACK");
            emit errorOccurred("Echec de l'insertion en base de données du nouveau type d'emploi:" + query.lastError().text());

            return false;
        }
        idTypEmp = query.lastInsertId().toInt();
    }

    //Insertion dans employe
    query.prepare(
        "insert into `employe` "
        "(idSec, libEmp, sexEmp, numCni, contact, dateEmp, numCnps, niu, idTypEmp, cate, salBase, salCot, salTax, irpp, tc, cf, cac, rav, anArriv) values "
        "(:idSec, :libEmp, :sexEmp, :numCni, :contact, :dateEmp, :numCnps, :niu, :idTypEmp, :cate, :salBase, :salCot, :salTax, :irpp, :tc, :cf, :cac, :rav, :anArriv)"
    );
    query.bindValue(":idSec", idSec);
    query.bindValue(":libEmp", myObj["empName"].toString());
    query.bindValue(":sexEmp", myObj["sex"].toInt());
    query.bindValue(":numCni", myObj["numCni"].toString());
    query.bindValue(":contact", myObj["contact"].toString());
    query.bindValue(":dateEmp", QDateTime::currentDateTime());
    query.bindValue(":numCnps", myObj["numCnps"].toString());
    query.bindValue(":niu", myObj["niu"].toString());
    query.bindValue(":idTypEmp", idTypEmp);
    query.bindValue(":cate", myObj["cat"].toString());
    query.bindValue(":salBase", myObj["salBase"].toInt());
    query.bindValue(":salCot", myObj["salCot"].toInt());
    query.bindValue(":salTax", myObj["salTax"].toInt());
    query.bindValue(":irpp", myObj["irpp"].toInt());
    query.bindValue(":tc", myObj["tc"].toInt());
    query.bindValue(":cf", myObj["cf"].toInt());
    query.bindValue(":cac", myObj["cac"].toInt());
    query.bindValue(":rav", myObj["rav"].toInt());
    query.bindValue(":anArriv", myObj["anArriv"].toString());

    if (!executeQuery(query)) {
        query.exec("ROLLBACK");
        emit errorOccurred("Echec de l'insertion en base de données:" + query.lastError().text());

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
        emit errorOccurred("Echec de l'insertion en base de données:" + query.lastError().text());

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

    //Insertion dans employe
    query.prepare("update employe set idTypEmp=:newTyp where idEmp=:curId");
    query.bindValue(":newTyp", idOfTypEmp);
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

    //Insertion dans employe
    query.prepare("update employe set salBase=:newMont where idEmp=:curId");
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

    //Insertion dans prime
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

    //Insertion dans employe
    query.prepare("update employe set salCot=:newMont where idEmp=:curId");
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

    //Insertion dans employe
    query.prepare("update employe set salTax=:newMont where idEmp=:curId");
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

    //Insertion dans employe
    query.prepare("update employe set irpp=:newMont where idEmp=:curId");
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

    //Insertion dans employe
    query.prepare("update employe set tc=:newMont where idEmp=:curId");
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

    //Insertion dans employe
    query.prepare("update employe set cf=:newMont where idEmp=:curId");
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

    //Insertion dans employe
    query.prepare("update employe set cac=:newMont where idEmp=:curId");
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

    //Insertion dans employe
    query.prepare("update employe set rav=:newMont where idEmp=:curId");
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
