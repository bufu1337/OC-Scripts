//var fs = require('fs');
var dataAdapter = null;
var MC = {
	Items: {},
	Mods: {},
	loadJSONFile: function (callback) {
		$.ajax({
			'dataType': 'json',
			'url': 'MC-Items.json',
			success: function (data) {
				MC.Items = data;
			}
		});
	},
	loadModFile: function (callback) {
		$.ajax({
			'dataType': 'json',
			'url': 'MC-Mods.json',
			success: function (data) {
				MC.Mods = data;
			}
		});
	}
}

$(document).ready(function () {
	$("#btnSave").jqxButton({ width: 48, height: 48, imgWidth: 48, imgHeight: 48, imgPosition: "center", textPosition: "center", imgSrc: "save.png", textImageRelation: "imageAboveText" });
	$('#btnSave').on('click', function () {
		if ('Blob' in window) {
			var fileName = 'MC-ItemsTW.js';
			if (fileName) {
				//var textToWrite = "MC.Items = " + JSON.stringify(MC.Items.minecraft) + "\nbla";
				var JStextToWrite = ""
				var LUAtextToWrite = ""
				var objectKeys = {}
				objectKeys.main = Object.keys(MC.Items)
				for(var i = 0; i < objectKeys.main.length; i++) {
					objectKeys[objectKeys.main[i]] = Object.keys(MC.Items[objectKeys.main[i]])
				)
				var textFileAsBlob = new Blob([textToWrite], { type: 'application/javascript' });
		
				if ('msSaveOrOpenBlob' in navigator) {
					navigator.msSaveOrOpenBlob(textFileAsBlob, fileName);
				} 
				else {
					var downloadLink = document.createElement('a');
					downloadLink.download = fileName;
					downloadLink.innerHTML = 'Download File';
					if ('webkitURL' in window) {
						// Chrome allows the link to be clicked without actually adding it to the DOM.
						downloadLink.href = window.webkitURL.createObjectURL(textFileAsBlob);
					}
					else {
						// Firefox requires the link to be added to the DOM before it can be clicked.
						downloadLink.href = window.URL.createObjectURL(textFileAsBlob);
						downloadLink.onclick = function (event) {document.body.removeChild(event.target);};
						downloadLink.style.display = 'none';
						document.body.appendChild(downloadLink);
					}
					downloadLink.click();
				}
			}
		}
		else {
			alert('Your browser does not support the HTML5 Blob.');
		}
	});
	/* MC.loadJSONFile();
	MC.loadModFile(); */
});

