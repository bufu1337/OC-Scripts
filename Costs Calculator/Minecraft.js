//var fs = require('fs');
var MC = {
	Mod: [],
	Trader: [],
	getPos:{
		Mod: function(mod_id_name){
			var searching = "name";
			if ( parseInt(mod_id_name) >= 0) {
				searching = "id";
			}
			console.log(searching);
			var result = -1;
			for (var i = 0; i < MC.Mod.length; i++){
				if ( searching.equals("id") ) {
					if ( MC.Mod[i][searching] == mod_id_name ) { 
						return i;
					}
				}
				else{
					if ( MC.Mod[i][searching].localeCompare(mod_id_name) == 0 ) {
						return i;
					}
				}
			}
			return 0;
		},
		Item: function(mod_id, item_id){
														
		}
	},
	Add:{
		Mod: function(){
			console.log("Adding Mod");
			MC.Mod.push({id: MC.Mod.length, name: document.getElementsByName('addModname')[0].value, iso: document.getElementsByName('addModiso')[0].value, items: []});
			MC.go.Mod(MC.Mod.length - 1);
		},
		Item: function(){
			console.log("Adding Item - Mod ID: " + MC.viewing.Mod);			
		}
	},
	pages: ["selectmod", "itemlist", "addmod"],//, "additem"
	viewing: {
		Mod: -1,
		Item: -1
	},
	editing: {
		Mod: -1,
		Item: -1
	},
	hideall: function(){
		/*for (var i = 0; i < MC.pages.length; i++){
			document.getElementById(MC.pages[i]).style.visibility = "hidden";
			document.getElementById(MC.pages[i]).style.display = "none";
		}*/
	},
	hide: function(div_name){
		/*document.getElementById(div_name).style.visibility = "hidden";
		document.getElementById(div_name).style.display = "none";*/
	},
	show: function(div_name, hide_all){
		var hide=true;
		if ( hide_all != null ) {
			hide = hide_all;
		}
		if ( hide ) {
			MC.hideall();
		}
		/*document.getElementById(div_name).style.visibility = "visible";
		document.getElementById(div_name).style.display = "block";*/
	},
	go:{
		Mod: function(mod_id){
			if ( mod_id < 0 ) {
				MC.show("selectmod");
			}
			else {
				var pos = MC.getPos.Mod(mod_id);
				console.log(MC.Mod[pos].name + " (ID: " + MC.Mod[pos].id + ") - Mod Page ");
				MC.viewing.Mod = MC.Mod[pos].id;
				MC.show("itemlist");
				MC.show("additem_button", false);
				document.getElementById("modinfo").innerHTML = "<tr><td style='font-size:19px;font-weight:900;width: 70px;'>ID:</td><td>" + MC.Mod[pos].id + "</td></tr><tr><td style='font-size:19px;font-weight:900;'>Name:</td><td>" + MC.Mod[pos].name + "</td></tr><tr><td style='font-size:19px;font-weight:900;'>ISO:</td><td>" + MC.Mod[pos].iso + "</td></tr><tr><td style='font-size:19px;font-weight:900;'>Items:</td><td>" + MC.Mod[pos].items.length + "</td></tr>";			
				if ( MC.Mod[pos].items.length == 0 ) {
					document.getElementById("itemsHeader").innerHTML = "No Items defined, please hit \"Add Item\" - button!";
					MC.hide("itemslisting");
				}
				else{
					document.getElementById("itemsHeader").innerHTML = "Items:";
					MC.show("itemslisting", false);
				}
				var listofitems = "";
				for (var i = 0; i < MC.Mod[pos].items.length; i++){
					listofitems += "<tr><td><a class='itemlisting' onclick='MC.go.Mod(" + MC.Mod[pos].items[i].id + ")' style='padding: 3px;'>" + MC.Mod[pos].items[i].name + "</a></td><td style='width: 70px;'>Costs:</td><td style='width: 40px;'>" + MC.Mod[pos].items[i].costs + "</td></tr>";
				}
			}
		},
		Item: function(item_id){
												
		},
		ModList: function(){
			console.log("Listing Mods");
			dataAdapter = new $.jqx.dataAdapter({localdata: MC.Mod, datatype: "array"});
			/*var modlisting = "";
			for (var i = 0; i < MC.Mod.length; i++){
				modlisting += "<div><a onclick='MC.go.Mod(" + MC.Mod[i].id + ")' style='padding: 3px;'>" + MC.Mod[i].name + "</a></div>";
			}
			console.log(modlisting);
			document.getElementById('modlist').innerHTML= modlisting;*/
			dataAdapter = new $.jqx.dataAdapter({localdata: MC.Mod, datatype: "array"});
		},
		Add:{
			Mod: function(){
				console.log("Add Mod Page");
				MC.show("addmod");
			},
			Item: function(){
				console.log("Add Item Page - Mod ID: " + MC.viewing.Mod);			
			}
		}
	}
}
$(document).ready(function (){
	var dataAdapter = new $.jqx.dataAdapter({localdata: MC.Mod, datatype: "array"});	
	$("#btnOpen").jqxButton({ width: 50, height: 50, imgWidth: 48, imgHeight: 48, imgPosition: "center", textPosition: "center", imgSrc: "open.png", textImageRelation: "imageAboveText" });
	$("#btnSave").jqxButton({ width: 50, height: 50, imgWidth: 48, imgHeight: 48, imgPosition: "center", textPosition: "center", imgSrc: "save.png", textImageRelation: "imageAboveText" });
	$('#btnSave').onclick = function() {
	  if ('Blob' in window) {
		var fileName = prompt('Please enter file name to save', 'Minecraft.json');
		if (fileName) {
		  var textToWrite = JSON.stringify(MC.Mod);
		  var textFileAsBlob = new Blob([textToWrite], { type: 'application/json' });
	
		  if ('msSaveOrOpenBlob' in navigator) {
			navigator.msSaveOrOpenBlob(textFileAsBlob, fileName);
		  } else {
			var downloadLink = document.createElement('a');
			downloadLink.download = fileName;
			downloadLink.innerHTML = 'Download File';
			if ('webkitURL' in window) {
			  // Chrome allows the link to be clicked without actually adding it to the DOM.
			  downloadLink.href = window.webkitURL.createObjectURL(textFileAsBlob);
			} else {
			  // Firefox requires the link to be added to the DOM before it can be clicked.
			  downloadLink.href = window.URL.createObjectURL(textFileAsBlob);
			  downloadLink.onclick = destroyClickedElement;
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
	};
	$('#btnOpen').onclick = function() {
	  if ('FileReader' in window) {
		document.getElementById('exampleInputFile').click();
	  }
	  else {
		alert('Your browser does not support the HTML5 FileReader.');
	  }
	};
	function destroyClickedElement(event) {
	  document.body.removeChild(event.target);
	}
	$('#InputFile').onchange = function(event) {
	  var fileToLoad = event.target.files[0];
	  console.log(fileToLoad);
	
	  if (fileToLoad) {
		var reader = new FileReader();
		reader.onload = function(fileLoadedEvent) {
		  var textFromFileLoaded = fileLoadedEvent.target.result;
		  MC.Mod = JSON.parse(textFromFileLoaded);
		  console.log("MC.Mod");
		  console.log(MC.Mod);
		  MC.go.ModList();
		};
		reader.readAsText(fileToLoad, 'UTF-8');
	  }
	};
	$('#btnOpen').click();	
	$("#splitter").jqxSplitter({  width: 600, height: 600, panels: [{ size: '40%'}] });
	var updatePanel = function (index) {
		/*var container = $('<div style="margin: 5px;"></div>')
		var leftcolumn = $('<div style="float: left; width: 45%;"></div>');
		var rightcolumn = $('<div style="float: left; width: 40%;"></div>');
		container.append(leftcolumn);
		container.append(rightcolumn);
		var datarecord = MC.Mod[index];
		var firstname = "<div style='margin: 10px;'><b>First Name:</b> " + datarecord.firstname + "</div>";
		var lastname = "<div style='margin: 10px;'><b>Last Name:</b> " + datarecord.lastname + "</div>";
		var title = "<div style='margin: 10px;'><b>Title:</b> " + datarecord.title + "</div>";
		var address = "<div style='margin: 10px;'><b>Address:</b> " + datarecord.address + "</div>";
		$(leftcolumn).append(firstname);
		$(leftcolumn).append(lastname);
		$(leftcolumn).append(title);
		$(leftcolumn).append(address);
		var postalcode = "<div style='margin: 10px;'><b>Postal Code:</b> " + datarecord.postalcode + "</div>";
		var city = "<div style='margin: 10px;'><b>City:</b> " + datarecord.city + "</div>";
		var phone = "<div style='margin: 10px;'><b>Phone:</b> " + datarecord.homephone + "</div>";
		var hiredate = "<div style='margin: 10px;'><b>Hire Date:</b> " + datarecord.hiredate + "</div>";
		$(rightcolumn).append(postalcode);
		$(rightcolumn).append(city);
		$(rightcolumn).append(phone);
		$(rightcolumn).append(hiredate);
		var education = "<div style='clear: both; margin: 10px;'><div><b>Education</b></div><div>" +  $('#listbox').jqxListBox('getItem', index).value + "</div></div>";
		container.append(education);
		$("#ContentPanel").html(container.html());*/
	}
	$('#modlist').on('select', function (event) {
		MC.go.Mod(MC.Mod[event.args.index].id);
	});
	  
	// Create jqxListBox
	$('#modlist').jqxListBox({ selectedIndex: 0,  source: dataAdapter, displayMember: "name", valueMember: "notes", itemHeight: 32, height: '100%', width: '100%',
		renderer: function (index, label, value) {
			var mod = MC.Mod[index];
			var imgurl = 'images/' + label + '.png';
			var img = '<td style="width: 40px;" rowspan="2"><img height="32" width="32" src="' + imgurl + '"/></td>';
			var table = '<table style="min-width: 130px;"><tr>' + img + '<td>' + mod.name + " (" + mod.id + ')</td></tr><tr><td>' + mod.iso + '</td></tr></table>';
			return table;
		}
	});
	updatePanel(0);
});
