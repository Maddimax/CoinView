#ifndef SYSTEMTRAYICON_H
#define SYSTEMTRAYICON_H

#include <QSystemTrayIcon>


class SystemTrayIcon : public QSystemTrayIcon
{
	Q_OBJECT
	Q_PROPERTY(int x READ x NOTIFY xChanged)
	Q_PROPERTY(int y READ y NOTIFY yChanged)
	
	Q_PROPERTY(int width READ width NOTIFY widthChanged)
	Q_PROPERTY(int height READ height NOTIFY heightChanged)
	
	int m_x;
	int m_y;
	
	int m_width;
	int m_height;
	
public:
	SystemTrayIcon();
	
	int x() const
	{
		return this->geometry().x();
	}
	int y() const
	{
		return this->geometry().y();
	}
	
	int width() const
	{
		return this->geometry().width();
	}
	
	int height() const
	{
		return this->geometry().height();
	}
	
signals:
	void xChanged(int x);
	void yChanged(int y);
	void widthChanged(int width);
	void heightChanged(int height);
};

#endif // SYSTEMTRAYICON_H
