import QtQuick 2.0

Item {
	property string symbolId
	property string dataSource
	
	property alias _name: nameLabel.text;
	property alias _euro: valueEURO.text;
	
	property real _percentage: 0.0
	height: data.height

	signal doUpdate();
	
	onDoUpdate: {
		var doc = new XMLHttpRequest();
		doc.onreadystatechange = function() {
			if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {
				
			} else if (doc.readyState == XMLHttpRequest.DONE) {
				if(dataSource == "coinmarketcap")
				{
					var a = doc.responseText;
					var jsonObject = eval('(' + a + ')');
					_name = jsonObject[0]["name"]
					_euro = Math.round(jsonObject[0]["price_eur"]*100)/100 + "€"
					_percentage = jsonObject[0]["percent_change_24h"]
				}
				else if(dataSource == "googlestock")
				{
					var a = doc.responseText;
					a = a.substring(3)
					var jsonObject = eval('(' + a + ')');
					
					_name = jsonObject[0]["name"]
					
					var value = jsonObject[0]["l"];
					value = value * appWindow.exchangeRates.usdToEuro
					
					_euro = Math.round(value*100)/100 + "€"
					_percentage = jsonObject[0]["c"]
				}
			}
		}
		if(dataSource == 'coinmarketcap')
		{
			doc.open("GET", "https://api.coinmarketcap.com/v1/ticker/%1/?convert=EUR".arg(symbolId));
		}
		else if(dataSource == 'googlestock')
		{
			doc.open("GET", "https://finance.google.com/finance?q=%1&output=json".arg(symbolId));
		}

		doc.send();
	}
	
	Text {
		id: nameLabel
		anchors.left: parent.left
	}
	Row {
		anchors.right: parent.right
		spacing: 2
		id: data
		
		Text {
			id: valueEURO;
		}
		
		Text {
			id: percent;
			text: "(%1%)".arg(_percentage)
			color: _percentage < 0 ? "red" : "green"
		}
	}
	
}
