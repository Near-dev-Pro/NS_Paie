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
    // methodes
    static Backend *instance();
    Q_INVOKABLE bool startPreviewDoc(QVariant);
    Q_INVOKABLE bool startPrintDoc(QPrinter *);
    Q_INVOKABLE QSqlQueryModel *getListSectNoms();
    Q_INVOKABLE QSqlQueryModel *getListTypEmpNoms();
    Q_INVOKABLE QString getSecNomForShowBull(const QString &);
    Q_INVOKABLE QSqlRelationalTableModel *getListEmp();
    Q_INVOKABLE QSqlRelationalTableModel *getOneEmp(const QString &);
    Q_INVOKABLE QSqlRelationalTableModel *getGroupOfEmp(const QString &);
    Q_INVOKABLE void sendWarning(QString);
    Q_INVOKABLE bool submitNewEmp(const QString &);

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
    int getSecIdByName(const QString &);
    int getTypEmpIdByName(const QString &);
    bool executeQuery(QSqlQuery &);

    // proprietes
    QSqlDatabase db;
    QVariant currentTargetPrint;
    QSqlRelationalTableModel *listEmp, *oneEmp, *groupOfEmp;
    QSqlQueryModel *listSectNom, *listTypEmpNom;
};

#endif // BACKEND_H
