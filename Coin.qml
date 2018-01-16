import QtQuick 2.0
import QtCharts 2.0

Item {
	property string symbolId
	property string dataSource
	
	property alias _name: nameLabel.text;
	property alias _euro: valueEURO.text;
	
	property real _percentage: 0.0
	height: chart.height
		
	signal doUpdate();
	
	onDoUpdate: {
		var doc = new XMLHttpRequest();
		doc.onreadystatechange = function() {
			if (doc.readyState == XMLHttpRequest.DONE) {
				var value = 0;
				if(dataSource == "coinmarketcap")
				{
					var a = doc.responseText;
					var jsonObject = eval('(' + a + ')');
					_name = jsonObject[0]["name"]
					value = parseFloat(jsonObject[0]["price_eur"])
					_euro = Math.round(value*100)/100 + "€"
					_percentage = jsonObject[0]["percent_change_24h"]
				}
				else if(dataSource == "googlestock")
				{
					var a = doc.responseText;
					a = a.substring(3)
					var jsonObject = eval('(' + a + ')');
					
					_name = jsonObject[0]["name"]
					
					value = parseFloat(jsonObject[0]["l"]);
					value = value * appWindow.exchangeRates.usdToEuro
					
					_euro = Math.round(value*100)/100 + "€"
					_percentage = jsonObject[0]["c"]
				}
				
				historySeries.update(value)
				
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
		anchors.verticalCenter: parent.verticalCenter
	}
	Row {
		anchors.right: chart.left
		spacing: 2
		id: data
		anchors.verticalCenter: parent.verticalCenter
		
		Text {
			id: valueEURO;
		}
		
		Text {
			id: percent;
			text: "(%1%)".arg(_percentage)
			color: _percentage < 0 ? "red" : "green"
		}
	}
	
	
	Item {
		id:chart
		width: 40
		height: data.height
		anchors.right: parent.right
		
		ChartView {
			x: -10
			y: -10
			width: parent.width+20
			height: parent.height+20

			antialiasing: true
			backgroundRoundness: 0.0
			backgroundColor: "transparent"
			legend.visible: false
			margins {
				bottom: 0
				top: 0
				right: 0
				left: 0
			}
			
			ValueAxis {
				id: axisX
				visible: false
			}
			
			ValueAxis {
				id: axisY
				visible: false
			}
			
			LineSeries {
				id: historySeries
				axisX: axisX
				axisY: axisY
				pointLabelsVisible: false
				property int i : 0;
				property int maxPoints: chart.width/2
				
				function update(value) {
					if(i > maxPoints)
					{
						historySeries.remove(0)
					}
					
					historySeries.append(i, value)
					i=i+1
					
					axisX.min = historySeries.at(0).x
					
					axisY.min = historySeries.at(0).y
					axisY.max = axisY.min
					
					for(var pi=0;pi<historySeries.count;pi++) {
						axisY.min = Math.min(axisY.min, historySeries.at(pi).y)
						axisY.max = Math.max(axisY.max, historySeries.at(pi).y)
						axisX.max = historySeries.at(pi).x
					}
					
					axisY.min -= 5
					axisY.max += 5
				}
			}
		}
	}
}
