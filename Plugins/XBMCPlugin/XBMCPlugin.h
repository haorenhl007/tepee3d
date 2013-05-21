#ifndef XBMCPLUGIN_H
#define XBMCPLUGIN_H

#include <QObject>
#include <QQuickView>
#include <QQuickItem>
#include <QHash>
#include "PluginBase.h"
#include "DatabaseServiceUserInterface.h"
#include "WebServiceUserInterface.h"
#include "IWebRequestDispatcher.h"
#include <Audio/AudioLibrary.h>

#define PLUGIN_ID 12

class XBMCPlugin  : public Plugins::PluginBase
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "com.tepee3d.plugins.xbmcplugin")

    Q_PROPERTY(int xbmcServerPort WRITE setXbmcServerPort READ xbmcServerPort NOTIFY xbmcServerPortChanged)
    Q_PROPERTY(QUrl xbmcServerUrl WRITE setXbmcServerUrl READ xbmcServerUrl NOTIFY xbmcServerUrlChanged)
    Q_PROPERTY(QString xbmcServerUserName WRITE setXbmcServerUserName READ xbmcServerUserName NOTIFY xbmcServerUserNameChanged)
    Q_PROPERTY(QString xbmcServerPassword WRITE setXbmcServerPassword READ xbmcServerPassword NOTIFY xbmcServerPasswordChanged)

public:
    XBMCPlugin();
    int                          getPluginId();
    void                        initPlugin();
    void                        clearPluginBeforeRemoval();

    Q_INVOKABLE QString         getPluginName();

    QString                     getPluginDescription();

    PluginBase*                 getPluginBase();
    PluginBase*                 createNewInstance();

    QString                     getRoomPluginQmlFile() const;
    QString                     getMenuPluginQmlFile() const;

    // FOCUS STATE HANDLERS
    void                onIdleFocusState();
    void                onSelectedFocusState();
    void                onFocusedFocusState();

    // DatabaseServiceUserInterface
    void                        receiveResultFromSQLQuery(QList<QSqlRecord> result, int id, void *data);
    // WebServiceUserInterface
    void                        receiveResultFromHttpRequest(QNetworkReply * reply,int id, void *data);

    void                        setXbmcServerPort(int port);
    void                        setXbmcServerUrl(const QUrl &url);
    void                        setXbmcServerUserName(const QString &username);
    void                        setXbmcServerPassword(const QString &password);

    int                           xbmcServerPort()  const;
    QUrl                       xbmcServerUrl()    const;
    QString                  xbmcServerUserName() const;
    QString                  xbmcServerPassword()   const;

private:
    QHash<int, IWebRequestDispatcher*> networkRequestResultDispatch;

    AudioLibrary    *m_AudioLibrary;

    int      m_xbmcServerPort;
    QUrl  m_xbmcServerUrl;
    QString m_xbmcServerUserName;
    QString m_xbmcServerPassword;

    QUrl               getXbmcServerRequestUrl() const;

private slots:
    void                     performJsonRPCRequest(const QJsonObject& request, int requestId, void *data = NULL);

signals:
    void                    xbmcServerUrlChanged();
    void                    xbmcServerPortChanged();
    void                    xbmcServerUserNameChanged();
    void                    xbmcServerPasswordChanged();
};

#endif // XBMCPLUGIN_H