#include <QApplication>
#include <QQmlApplicationEngine>
#include <QSystemTrayIcon>
#include <QPainter>
#include <QQuickWindow>
#include <QQmlContext>
#include <QMenu>

#include "systemtrayicon.h"

QSystemTrayIcon* createSystemTray(QAction*& showAction)
{
	QPixmap px(64,64);
	px.fill(Qt::transparent);
	
	QPainter p(&px);	
	p.setPen(QPen(Qt::black, 4.0));
	
	p.drawLine(0, 50, 16, 30);
	p.drawLine(16, 30, 32, 20);
	p.drawLine(32, 20, 48, 40);
	p.drawLine(48, 40, 64, 10);
	
	QIcon icon(px);
	
	QSystemTrayIcon* systemTrayIcon = new SystemTrayIcon();
	systemTrayIcon->setIcon(icon);

	QMenu* systemTrayContextMenu = new QMenu();
	
	showAction = systemTrayContextMenu->addAction("Show");
	QAction* quitAction = systemTrayContextMenu->addAction("Quit");
	
	QObject::connect(quitAction, &QAction::triggered, qApp, &QCoreApplication::quit);
	
	systemTrayIcon->setContextMenu(systemTrayContextMenu);
	systemTrayIcon->show();
	
	return systemTrayIcon;
}

int main(int argc, char *argv[])
{
	QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
	QApplication app(argc, argv);
	
	qRegisterMetaType<QSystemTrayIcon::ActivationReason>("QSystemTrayIcon::ActivationReason");
	
	QAction* showAction;
	QSystemTrayIcon* systemTrayIcon = createSystemTray(showAction);
	
	QQmlApplicationEngine engine;
	engine.rootContext()->setContextProperty("ShowAction", showAction);
	engine.rootContext()->setContextProperty("SystemTray", systemTrayIcon);

	engine.load(QUrl(QLatin1String("qrc:/main.qml")));
	if (engine.rootObjects().isEmpty())
		return -1;
	
	QQuickWindow* appWindow = qobject_cast<QQuickWindow*>(engine.rootObjects().first());
	
	if(!appWindow)
		return -1;

	return app.exec();
}
