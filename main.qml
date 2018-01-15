import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
	id: appWindow
	visible: true
	width: 1270/4
	height: coinList.contentHeight + 10
	visibility: ApplicationWindow.Hidden
	flags: Qt.Window | Qt.FramelessWindowHint
	x: 100
	y: 100
	
	signal trayActivation()
	
	onActiveChanged: {
		if(!active)
			hide();
	}
	
	Connections {
		target: ShowAction
		onTriggered: {
			show()
			raise()
			requestActivate()
			
			appWindow.x = SystemTray.x
			appWindow.y = SystemTray.y + SystemTray.height
		}
	}
	
	onClosing: {
		hide()
		close.accepted = false
	}
	
	Item {
		focus: true
		
		Keys.onEscapePressed: {
			hide()
		}
		
		Component.onCompleted: forceActiveFocus()
	}
	
	property ExchangeRates exchangeRates: ExchangeRates { }
	
	ListView {
		id: coinList
		anchors.fill: parent
		anchors.margins: 5
		focus: true
		
		model: ListModel {
			ListElement {
				type: "coinmarketcap"
				symbol: "bitcoin"
			}
			ListElement {
				type: "coinmarketcap"
				symbol: "ethereum"
			}
			ListElement {
				type: "googlestock"
				symbol: "NASDAQ:TSLA"
			}
			ListElement {
				type: "googlestock"
				symbol: "NASDAQ:AMD"
			}
		}
		
		delegate: Coin {
			dataSource: type
			symbolId: symbol
			anchors.left: parent.left
			anchors.right: parent.right
			Component.onCompleted: {
				updateTimer.updateData.connect(doUpdate)
				updateTimer.newView()
				
			}
		}
		
		Timer {
			id: updateTimer
			triggeredOnStart: true
			interval: 1000
			repeat: true
			
			signal updateData()
			
			property int dataUpdateInterval: 30000
			property int remaining: 0
			
			function newView() {
				remaining = 0;
				restart()
			}
			
			onRemainingChanged: {
				appWindow.title = "%1".arg(remaining / 1000)
			}
			
			onTriggered: {
				remaining -= interval
				if(remaining <= 0)
				{
					remaining = dataUpdateInterval
					updateData();
				}
			}
		}
	}
}
