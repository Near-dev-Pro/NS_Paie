#ifndef BACKEND_H
#define BACKEND_H

#include <QImage>
#include <QJsonDocument>
#include <QJsonObject>
#include <QObject>
#include <QPainter>
#include <QPrintDialog>
#include <QPrintPreviewDialog>
#include <QPrinter>
#include <QSqlDatabase>
#include <QSqlDriver>
#include <QSqlError>
#include <QSqlField>
#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QSqlRecord>
#include <QSqlRelationalTableModel>
#include <QSqlTableModel>
#include <QString>
#include <QTimer>
#include <QVariant>
#include <QDir>

class Backend : public QObject
{
    Q_OBJECT
public:
    static Backend *instance();

    virtual ~Backend();

signals:
    void errorOccurred(const QString &);
    void warningOccurred(const QString &);
    void successOperation(const QString &);

private:
    explicit Backend(QObject *parent = nullptr);
    Q_DISABLE_COPY(Backend)

    // methodes
    void initialize();

    // proprietes
    QDir dbPath;
    QSqlDatabase db;
};

#endif // BACKEND_H
