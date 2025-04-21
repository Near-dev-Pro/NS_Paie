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
    //Fermeture de la connexion a la bd
    db.close();
}

void Backend::initialize()
{
    if (!db.open()) {
        emit errorOccurred("Failed to open database:" + db.lastError().text());
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
        emit errorOccurred("Unable to print content!");
        return false;
    }

    if (!thePrinter) {
        emit errorOccurred("Invalid printer!");
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
