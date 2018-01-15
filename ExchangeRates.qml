import QtQuick 2.7

Item
{
	property real usdToEuro: 1.0
	
	Timer {
		interval: 1000*60
		repeat: true
		running: true
		triggeredOnStart: true
		
		onTriggered: {
			
			var doc = new XMLHttpRequest();
			doc.onreadystatechange = function() {
				if (doc.readyState == XMLHttpRequest.DONE) {
					var a = doc.responseText;
					var jsonObject = eval('(' + a + ')');
					usdToEuro = jsonObject['rates']['EUR']
				}
			}
			
			doc.open("GET", "https://api.fixer.io/latest?base=USD");
			doc.send();
		}
	}
}
