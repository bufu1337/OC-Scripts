//var fs = require('fs');
var dataAdapter = null;
var MC = {
	Items: {},
	Mods: {},
	Mod: {},
	Traders: {},
	viewing: {
		Mod: "",
		Item: ""
	},
	editing: {
		Mod: "",
		Item: "",
		Receipt: ""
	},
	createModList: function(){
		$.each(MC.Mods, function (index, value) {
			MC.Mod[value.name] = {idname:index, crafter:value.crafter, items:{}}
			$.each(MC.Items[value.crafter], function (index2, value2) {
				if ( index2.startsWith(index) ) {
					MC.Mod[value.name].items[index2] = MC.Items[value.crafter][index2]
				}
			});
		});
	},
	hide: function(div_name){
		$("#" + div_name).css({visibility: "hidden", display: "none"});
	},
	show: function(div_name){
		$("#" + div_name).css({visibility: "visible", display: "block"});
	},
	go:{
		Mod: function(modname){
			if ( modname.isEmpty() || modname == null) {
				MC.hide("btnEditMod");
				MC.hide("noitems");
				MC.hide("itemListBox");
				MC.hide("additem_button");
				MC.hide("addreceipt_button");
				MC.hide("btnEditItem");
				MC.show("nomod");
				$('#contentSplitter').jqxSplitter('collapse');
			}
			else {
				MC.hide("noitems");
				MC.hide("itemListBox");
				MC.hide("btnEditItem");
				MC.show("additem_button");
				MC.show("btnEditMod");
				MC.hide("addreceipt_button");
				MC.hide("nomod");
				MC.viewing.Mod = modname;
				$('#itemHeader').html("<b class='headerstyle'>Mod-Name: </b>" + modname + " <b class='headerstyle'>Item-Count:</b> " + Object.keys(MC.Mod[modname].items).length);
				if ( Object.keys(MC.Mod[modname].items).length == 0) {
					MC.show("noitems");
				}
				else{
					MC.show("itemListBox");
					var itemssource = [];
					$.each(Object.keys(MC.Mod[modname].items), function (index, item) {
						//var pricecaption = MC.Mod[modname].items[item].count + " St. => " + MC.Mod[modname].items[item].price;
						var pricecaption = 0;
						if ( MC.Mod[modname].items[item].price.includes("/") ) {
							if ( MC.Mod[modname].items[item].price.endsWith("b") ){
								pricecaption = parseInt(MC.Mod[modname].items[item].price.split("b")[0].split("/")[0]);
								pricecaption = MC.Mod[modname].items[item].count + " St. => " + pricecaption + "b";
							}
							else{
								pricecaption = parseInt(MC.Mod[modname].items[item].price.split("b")[0].split("/")[0]);
								pricecaption = MC.Mod[modname].items[item].count + " St. => " + pricecaption;
							}
						}
						else{
							pricecaption = MC.Mod[modname].items[item].count + " St. => " + MC.Mod[modname].items[item].price
						}
							
						if ( MC.Mod[modname].items[item].price.equals("0") ) {
							pricecaption = "price not defined or calculated";
						}
						itemssource.push({html: "<b class='itemstyle'>Name:</b> " + item + " <b class='itemstyle2'>Costs:</b> " + pricecaption, label: item, value: item, group: MC.Mod[modname].items[item].group});
					});
					$('#itemListBox').jqxListBox('source', itemssource);
					$('#itemListBox').jqxListBox('refresh');
				}
			}
		},
		Item: function(itemname){
			console.log("Item Page - Mod ID: " + MC.viewing.Mod + " Item: " + itemname);	
			$('#contentSplitter').jqxSplitter('expand');
			MC.show("btnEditMod");
			MC.show("btnEditItem");
			MC.show("addreceipt_button");
			MC.viewing.Item = itemname;
			for (var i = 1; i < MC.detailtabcount; i++){
				$('#itemDetailTabs').jqxTabs('removeAt', i);
			}			
			if ( Object.keys(MC.Mod[MC.viewing.Mod].items[itemname].receipt).length > 0 ) {
				$('#itemDetailTabs').jqxTabs('setTitleAt', i, Object.keys(MC.Mod[MC.viewing.Mod].items[itemname].receipt)[i]); 
				$('#itemDetailTabs').jqxTabs('setContentAt', i, "<div style='margin: 10px; color: red;font-size: 20px;font-weight: 900;'>No receipt!</div>");
			}
			else{
				$('#itemDetailTabs').jqxTabs('setTitleAt', 0, "No receipt!"); 
				$('#itemDetailTabs').jqxTabs('setContentAt', 0, "<div style='margin: 10px; color: red;font-size: 20px;font-weight: 900;'>No receipt!</div>"); 
			}
		},
		RefreshNameArrays: function(){
			MC.ItemNames = [];
			MC.ResourceGroups = [];
			$.each(Object.keys(MC.Mod), function (index, mod) {
				if ( MC.Mod[mod].groups == null ) {
					MC.Mod[mod].groups = new Array();
				}
				$.each(Object.keys(MC.Mod[mod].items), function (index2, item) {
					if ( $.inArray( item, MC.ItemNames) == -1 ) {
						MC.ItemNames.push(item);
					}
					if ( $.inArray( MC.Mod[mod].items[item].resource_group, MC.ResourceGroups ) == -1 && !MC.Mod[mod].items[item].resource_group.isEmpty() ) {
						MC.ResourceGroups.push(MC.Mod[mod].items[item].resource_group);
					}
					if ( $.inArray( MC.Mod[mod].items[item].group, MC.Mod[mod].groups) == -1 && !MC.Mod[mod].items[item].group.isEmpty() ) {
						MC.Mod[mod].groups.push(MC.Mod[mod].items[item].group);
					}
				});
			});
		},
		ModList: function(){
			MC.sort.Mod();
			MC.sort.Items();
			MC.CalculateCosts();
			MC.go.RefreshNameArrays();
			$('#modListBox').jqxListBox('source', Object.keys(MC.Mod));
			$('#modListBox').jqxListBox('refresh');
		},
		Add:{
			Mod: function(){
				MC.mode.Mod = "add";
				$('#modwindow').jqxWindow('open');
			},
			Item: function(){	
				MC.mode.Item = "add";
				MC.editing.Mod = MC.viewing.Mod;
				$('#itemwindow').jqxWindow('open');
			},
			Receipt: function(){
				MC.mode.Receipt = "add";
				MC.editing.Mod = MC.viewing.Mod;
				MC.editing.Item = MC.viewing.Item;
				$('#receiptwindow').jqxWindow('open');
			}
		},
		Edit:{
			Mod: function(){	
				MC.mode.Mod = "edit";
				MC.editing.Mod = MC.viewing.Mod;
				$('#modwindow').jqxWindow('open');
			},
			Item: function(){		
				MC.mode.Item = "edit";
				MC.editing.Mod = MC.viewing.Mod;
				MC.editing.Item = MC.viewing.Item;
				$('#itemwindow').jqxWindow('open');
			},
			Receipt: function(){		
				MC.mode.Receipt = "edit";
				MC.editing.Mod = MC.viewing.Mod;
				MC.editing.Item = MC.viewing.Item;
				$('#receiptwindow').jqxWindow('open');
			}
		}
	}
}

$(document).ready(function () {
	MC.createModList();
	dataAdapter = new $.jqx.dataAdapter({localdata: MC.Items, datatype: "array"});
	console.log(dataAdapter)
	$("#btnSave").jqxButton({ width: 48, height: 48, imgWidth: 48, imgHeight: 48, imgPosition: "center", textPosition: "center", imgSrc: "save.png", textImageRelation: "imageAboveText" });
	$('#btnSave').on('click', function () {
		if ('Blob' in window) {
			var fileName = 'MC-ItemsTO.js';
			var JStextToWrite = "MC.Items = {\n"
			var objKeys = {}
			objKeys.main = Object.keys(MC.Items)
			for(var i = 0; i < objKeys.main.length; i++) {
				JStextToWrite += "  " + JSON.stringify(objKeys.main[i]) + ":{\n";
				objKeys[objKeys.main[i]] = Object.keys(MC.Items[objKeys.main[i]]);
				for(var j = 0; j < objKeys[objKeys.main[i]].length; j++) {
					JStextToWrite += "    " + JSON.stringify(objKeys[objKeys.main[i]][j]) + ":" + JSON.stringify(MC.Items[objKeys.main[i]][objKeys[objKeys.main[i]][j]])
					if (j == objKeys[objKeys.main[i]].length - 1){
						JStextToWrite += "\n";
						if (i == objKeys.main.length - 1){
							JStextToWrite += "  }\n}";
						}
						else{
							JStextToWrite += "  },\n";
						}
					}
					else{
						JStextToWrite += ",\n";
					}
				}
			}
			var textFileAsBlob = new Blob([JStextToWrite], { type: 'application/javascript' });
	
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
		else {
			alert('Your browser does not support the HTML5 Blob.');
		}
	});
	$("#btnSaveLUA").jqxButton({ width: 48, height: 48, imgWidth: 48, imgHeight: 48, imgPosition: "center", textPosition: "center", imgSrc: "save.png", textImageRelation: "imageAboveText" });
	$('#btnSaveLUA').on('click', function () {
		if ('Blob' in window) {
			var fileName2 = 'All-Items.lua';
			var LUAtextToWrite = "return {\n"
			var objKeys = {}
			objKeys.main = Object.keys(MC.Items)
			for(var i = 0; i < objKeys.main.length; i++) {
				LUAtextToWrite += "  " + objKeys.main[i] + "={\n";
				objKeys[objKeys.main[i]] = Object.keys(MC.Items[objKeys.main[i]]);
				for(var j = 0; j < objKeys[objKeys.main[i]].length; j++) {
					LUAtextToWrite += "    " + objKeys[objKeys.main[i]][j] + "={"
					var templuakeys = Object.keys(MC.Items[objKeys.main[i]][objKeys[objKeys.main[i]][j]])
					for(var g = 0; g < templuakeys.length; g++) {
						//console.log(typeof MC.Items[objKeys.main[i]][objKeys[objKeys.main[i]][j]][templuakeys[g]])
						if((typeof MC.Items[objKeys.main[i]][objKeys[objKeys.main[i]][j]][templuakeys[g]]) == "object"){
							var templen = LUAtextToWrite.length
							LUAtextToWrite += templuakeys[g] + "={";
							var templuaobjkeys = Object.keys(MC.Items[objKeys.main[i]][objKeys[objKeys.main[i]][j]][templuakeys[g]]);
							for(var b = 0; b < templuaobjkeys.length; b++) {
								LUAtextToWrite += templuaobjkeys[b] + "={";
								var templuaobjkeys2 = Object.keys(MC.Items[objKeys.main[i]][objKeys[objKeys.main[i]][j]][templuakeys[g]][templuaobjkeys[b]])
								for(var c = 0; c < templuaobjkeys2.length; c++) {
									LUAtextToWrite += templuaobjkeys2[c] + "=" + JSON.stringify(MC.Items[objKeys.main[i]][objKeys[objKeys.main[i]][j]][templuakeys[g]][templuaobjkeys[b]][templuaobjkeys2[c]]) + ","
								}
								LUAtextToWrite = LUAtextToWrite.substring(0, LUAtextToWrite.length - 1) + "},";
							}
							if(templuaobjkeys.length == 0){
								LUAtextToWrite += "},";
							}
							else{
								LUAtextToWrite = LUAtextToWrite.substring(0, LUAtextToWrite.length - 1) + "},";
							}
							//console.log(LUAtextToWrite.substring(templen, LUAtextToWrite.length));
						}
						else{
							LUAtextToWrite += templuakeys[g] + "=" + JSON.stringify(MC.Items[objKeys.main[i]][objKeys[objKeys.main[i]][j]][templuakeys[g]]) + ",";
						}
					}
					LUAtextToWrite = LUAtextToWrite.substring(0, LUAtextToWrite.length - 1);
					if (j == objKeys[objKeys.main[i]].length - 1){
						LUAtextToWrite += "}\n";
						if (i == objKeys.main.length - 1){
							LUAtextToWrite += "  }\n}";
						}
						else{
							LUAtextToWrite += "  },\n";
						}
					}
					else{
						LUAtextToWrite += "},\n";
					}
				}
			}
			var textFileAsBlob = new Blob([LUAtextToWrite], { type: 'application/lua' });
			
			if ('msSaveOrOpenBlob' in navigator) {
				navigator.msSaveOrOpenBlob(textFileAsBlob, fileName2);
			} 
			else {
				var downloadLink = document.createElement('a');
				downloadLink.download = fileName2;
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
		else {
			alert('Your browser does not support the HTML5 Blob.');
		}
	});
	$("#btnEditMod").jqxButton({imgWidth: 24, imgHeight: 24, width: 100, height: 34, imgPosition: "center", textPosition: "center", imgSrc: "edit.png", textImageRelation: "imageBeforeText" });
	$('#btnEditMod').on('click', function () {
		MC.go.Edit.Mod();
	});	
	$("#btnEditItem").jqxButton({imgWidth: 24, imgHeight: 24, width: 100, height: 34, imgPosition: "center", textPosition: "center", imgSrc: "edit.png", textImageRelation: "imageBeforeText" });
	$('#btnEditItem').on('click', function () {
		MC.go.Edit.Item();	
	});
	
	$('#mainSplitter').jqxSplitter({  width: 1918, height: 930, panels: [{ size: 280, min: 100 }, {min: 200, size: 500}] });
	$('#contentSplitter').jqxSplitter({ width: '100%', height: '100%', panels: [{ size: 500, min: 100, collapsible: false }, { min: 100, collapsible: true}] });
	
	$("#modExpander").jqxExpander({toggleMode: 'none', showArrow: false, width: "100%", height: "100%", 
		initContent: function () {
			var temp = Object.keys(MC.Mod).sort()
			$('#modListBox').jqxListBox({ filterable: true, searchMode: 'contains', filterPlaceHolder: "Suche...", selectedIndex: 0,  source: temp, displayMember: "name", valueMember: "notes", itemHeight: 32, height: '100%', width: '100%',
				renderer: function (index, label, value) {
					return '<table style="min-width: 130px;"><tr><td style="width: 40px;" rowspan="2"><img height="32" width="32" src="images/' + label + '.png"/></td><td>' + label + " (" + Object.keys(MC.Mod[label].items).length + ')</td></tr></table>';
				}
			});
		}
	});
	$("#itemListExpander").jqxExpander({toggleMode: 'none', showArrow: false, width: "100%", height: "100%",
		initContent: function () {
			$('#itemListBox').jqxListBox({ filterable: true, searchMode: 'contains', filterPlaceHolder: "Suche...", source: ['No mod selected! Please Select a mod first!'], width: '100%', height: '100%' });
		}
	});
	$("#itemDetailExpander").jqxExpander({ toggleMode: 'none', showArrow: false, width: "100%", height: "100%", 
		initContent: function () {
			$('#itemDetailTabs').jqxTabs({  width: '100%', height: '100%', position: 'top' });
		}
	});
	
	$('#modListBox').on('select', function (event) {
		MC.go.Mod($('#modListBox').jqxListBox('getSelectedItem').label);
	});
	$('#itemListBox').on('select', function (event) {
		MC.go.Item($('#itemListBox').jqxListBox('getSelectedItem').label);
	});
	MC.go.Mod("");
});

