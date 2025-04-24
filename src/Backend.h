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
    Q_INVOKABLE QSqlQueryModel *getListEmp();
    Q_INVOKABLE QSqlQueryModel *getOneEmp(const QString &);
    Q_INVOKABLE QSqlQueryModel *getFullHis(int start = 0, int year = QDate().year());
    Q_INVOKABLE QSqlQueryModel *getHisOfEmp(const QString &);
    Q_INVOKABLE QSqlQueryModel *getGroupOfEmp(const QString &, bool isHis = false);
    Q_INVOKABLE QVariantList getOneEmpForBull(const QString &);
    Q_INVOKABLE void insertInHis(QVariantList &);
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
    QSqlQueryModel *listSectNom, *listTypEmpNom, *listEmp, *oneEmp, *groupOfEmp, *getAllOfEmp, *histOfEmp, *fullHis;
};

#endif // BACKEND_H
