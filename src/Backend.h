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
#include <QVariantMap>
#include <QVariantList>
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
    Q_INVOKABLE QVariantList getOneEmpForBull(const QString &);
    Q_INVOKABLE QSqlRelationalTableModel *getGroupOfEmp(const QString &);
    Q_INVOKABLE void sendWarning(QString);
    Q_INVOKABLE bool submitNewEmp(const QString &);
    Q_INVOKABLE bool updateEmpNom(const QString &);
    Q_INVOKABLE bool updateEmpNumCni(const QString &);
    Q_INVOKABLE bool updateEmpContact(const QString &);
    Q_INVOKABLE bool updateEmpTypEmp(const QString &);
    Q_INVOKABLE bool updateEmpSalBase(const QString &);
    Q_INVOKABLE bool updateEmpPrime(const QString &);
    Q_INVOKABLE bool updateEmpSalCot(const QString &);
    Q_INVOKABLE bool updateEmpSalTax(const QString &);
    Q_INVOKABLE bool updateEmpSalBrute(const QString &);
    Q_INVOKABLE bool updateEmpIrpp(const QString &);
    Q_INVOKABLE bool updateEmpTc(const QString &);
    Q_INVOKABLE bool updateEmpCf(const QString &);
    Q_INVOKABLE bool updateEmpCac(const QString &);
    Q_INVOKABLE bool updateEmpRav(const QString &);

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
    int getEmpIdByName(const QString &);
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
