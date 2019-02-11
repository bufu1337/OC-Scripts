//var fs = require('fs');
var dataAdapter = null;
var MC = {
	Mod: [],
	Trader: [],
	ModNames: [],
	ItemNames: {
		ALL: []
	},
	loadJSONFile: function (callback) {
		$.ajax({
			'dataType': 'json',
			'url': 'Minecraft.json',
			success: function (data) {
				MC.Mod = data;
				MC.go.ModList();
			}
		});
	},
	mode: {Mod: "", Item: "", Receipt: ""},
	detailtabcount: 1,
	rc_inputcount: [],
	itemreceipts_temp: {},
	Definitions: {
		receipt_io_count: 12
	},
	crafting_items: ["Werkbank"],
	pages: ["selectmod", "itemlist", "addmod"],//, "additem"
	getPos:{
		Mod: function(mod_id_or_name){
			var searching = "name";
			if ( parseInt(mod_id_or_name) >= 0) {
				searching = "id";
			}
			for (var i = 0; i < MC.Mod.length; i++){
				if ( searching.equals("id") ) {
					if ( MC.Mod[i][searching] == mod_id_or_name ) { 
						return i;
					}
				}
				else{
					if ( MC.Mod[i][searching].equals(mod_id_or_name) ) {
						return i;
					}
				}
			}
			return -1;
		},
		Item: function(mod_id, item_id){
			var modpos = MC.getPos.Mod(mod_id);
			for (var i = 0; i < MC.Mod[modpos].items.length; i++){
				if (  MC.Mod[modpos].items[i].id == item_id ) { 
					return {mod: modpos, item: i};
				}
			}	
			return {mod: -1, item: -1};			
		},
		Trader: function(trader_id_or_name){
			var searching = "name";
			if ( parseInt(trader_id_or_name) >= 0) {
				searching = "id";
			}
			if ( MC.Trader.length == 0 ) {
				return -1;
			}
			for (var i = 0; i < MC.Trader.length; i++){
				if ( searching.equals("id") ) {
					if (  MC.Trader[i][searching] == trader_id_or_name ) { 
						return i;
					}
				}
				else{
					if ( MC.Trader[i][searching].equals(trader_id_or_name) ) {
						return i;
					}
				}
			}	
			return -1;			
		}
	},
	viewing: {
		Mod: -1,
		Item: -1
	},
	editing: {
		Mod: -1,
		Item: -1,
		Receipt: -1
	},
	hideall: function(){
		/*for (var i = 0; i < MC.pages.length; i++){
			document.getElementById(MC.pages[i]).style.visibility = "hidden";
			document.getElementById(MC.pages[i]).style.display = "none";
		}*/
	},
	hide: function(div_name){
		$("#" + div_name).css({visibility: "hidden", display: "none"});
	},
	show: function(div_name){
		$("#" + div_name).css({visibility: "visible", display: "block"});
	},
	go:{
		Mod: function(mod_id){
			if ( mod_id < 0 ) {
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
				var pos = MC.getPos.Mod(mod_id);
				$('#itemHeader').html("<b class='headerstyle'>Mod-Name: </b>" + MC.Mod[pos].name + " <b class='headerstyle'>ID:</b> " + MC.Mod[pos].id + " <b class='headerstyle'>ISO:</b> " + MC.Mod[pos].iso + " <b class='headerstyle'>Item-Count:</b> " + MC.Mod[pos].items.length);
				if ( MC.Mod[pos].items.length == 0) {
					MC.show("noitems");
				}
				else{
					MC.viewing.Mod = MC.Mod[pos].id;
					MC.show("itemListBox");
					MC.Mod[pos].items.sortBy('group', 'name');
					var items = [];
					for (var i = 0; i < MC.Mod[pos].items.length; i++){
						items.push({html: "<b class='itemstyle'>Name:</b> " + MC.Mod[pos].items[i].name + " <b class='itemstyle2'>Costs:</b> " + MC.Mod[pos].items[i].price, label: MC.Mod[pos].items[i].name, value: MC.Mod[pos].items[i].id, group: MC.Mod[pos].items[i].group});
					}
					$('#itemListBox').jqxListBox('source', items);
					$('#itemListBox').jqxListBox('refresh');
				}
			}
		},
		Item: function(item_id){
			console.log("Item Page - Mod ID: " + MC.viewing.Mod + " Item-ID: " + item_id);	
			$('#contentSplitter').jqxSplitter('expand');
			MC.show("btnEditMod");
			MC.show("btnEditItem");
			MC.show("addreceipt_button");
			MC.viewing.Item = item_id;
			var pos = MC.getPos.Item(MC.viewing.Mod, item_id);
			for (var i = 1; i < MC.detailtabcount; i++){
				$('#itemDetailTabs').jqxTabs('removeAt', i);
			}			
			if ( Object.keys(MC.Mod[pos.mod].items[pos.item].receipt).length > 0 ) {
				$('#itemDetailTabs').jqxTabs('setTitleAt', 0, Object.keys(MC.Mod[pos.mod].items[pos.item].receipt)[i]); 
				$('#itemDetailTabs').jqxTabs('setContentAt', 0, "<div style='margin: 10px; color: red;font-size: 20px;font-weight: 900;'>No receipt!</div>"); 
				/*if ( Object.keys(MC.Mod[pos.mod].items[pos.item].receipt).length > 1 ) {
					for (var i = 1; i < Object.keys(MC.Mod[pos.mod].items[pos.item].receipt).length; i++){
						tabs = "<li>" + Object.keys(MC.Mod[pos.mod].items[pos.item].receipt)[i] + "</li>";	
					}						
				}
				else{
					
				}*/
			}
			else{
				$('#itemDetailTabs').jqxTabs('setTitleAt', 0, "No receipt!"); 
				$('#itemDetailTabs').jqxTabs('setContentAt', 0, "<div style='margin: 10px; color: red;font-size: 20px;font-weight: 900;'>No receipt!</div>"); 
			}
		},
		RefreshNameArrays: function(){
			MC.ModNames = new Array();
			MC.ItemNames = {ALL: []};
			for (var i = 0; i < MC.Mod.length; i += 1) {
				MC.ModNames.push(MC.Mod[i].name);
				for (var j = 0; j < MC.Mod[i].items.length; j++){
					MC.ItemNames.ALL.push(MC.Mod[i].items[j].name);
					if ( MC.ItemNames[MC.Mod[i].name] == null ) {
						MC.ItemNames[MC.Mod[i].name] = new Array();
					}
					MC.ItemNames[MC.Mod[i].name].push(MC.Mod[i].items[j].name);
				}
			}
		},
		ModList: function(){
			MC.go.RefreshNameArrays();
			var names = [];
			for (var i = 0; i < MC.Mod.length; i += 1) {
				names.push({
					label: MC.Mod[i].name,
					value: MC.Mod[i].id
				});
			}
			$('#modListBox').jqxListBox('source', names);
			$('#modListBox').jqxListBox('refresh');
		},
		Add:{
			Mod: function(){
				console.log("Add mod");
				MC.mode.Mod = "add";
				$('#modwindow').jqxWindow('open');
			},
			Item: function(){
				console.log("Add item");	
				MC.mode.Item = "add";
				MC.editing.Mod = MC.viewing.Mod;
				$('#itemwindow').jqxWindow('open');
			},
			Receipt: function(){
				console.log("Add receipt");
				MC.mode.Receipt = "add";
				MC.editing.Mod = MC.viewing.Mod;
				MC.editing.Item = MC.viewing.Item;
				$('#receiptwindow').jqxWindow('open');
			}
		},
		Edit:{
			Mod: function(){
				console.log("Edit mod: " + MC.viewing.Mod);	
				MC.mode.Mod = "edit";
				MC.editing.Mod = MC.viewing.Mod;
				$('#modwindow').jqxWindow('open');
			},
			Item: function(){
				console.log("Edit item: " + JSON.stringify(MC.viewing));		
				MC.mode.Item = "edit";
				MC.editing.Mod = MC.viewing.Mod;
				MC.editing.Item = MC.viewing.Item;
				$('#itemwindow').jqxWindow('open');
			},
			Receipt: function(){
				console.log("Edit receipt" + JSON.stringify(MC.viewing));		
				MC.mode.Receipt = "edit";
				MC.editing.Mod = MC.viewing.Mod;
				MC.editing.Item = MC.viewing.Item;
				$('#receiptwindow').jqxWindow('open');
			}
		}
	}
}

$(document).ready(function () {
	dataAdapter = new $.jqx.dataAdapter({localdata: MC.Mod, datatype: "array"});
	for (var i = 0; i < MC.Definitions.receipt_io_count; i++){
		MC.rc_inputcount[i] = 1;
	}

	$("#btnSave").jqxButton({ width: 48, height: 48, imgWidth: 48, imgHeight: 48, imgPosition: "center", textPosition: "center", imgSrc: "save.png", textImageRelation: "imageAboveText" });
	$('#btnSave').on('click', function () {
		if ('Blob' in window) {
			var fileName = prompt('Please enter file name to save', 'Minecraft.json');
			if (fileName) {
				var textToWrite = JSON.stringify(MC.Mod);
				var textFileAsBlob = new Blob([textToWrite], { type: 'application/json' });
		
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
			$('#modListBox').jqxListBox({ filterable: true, searchMode: 'contains', filterPlaceHolder: "Suche...", selectedIndex: 0,  source: dataAdapter, displayMember: "name", valueMember: "notes", itemHeight: 32, height: '100%', width: '100%',
				renderer: function (index, label, value) {
					var mod = MC.Mod[MC.getPos.Mod(value)];
					var imgurl = 'images/' + label + '.png';
					var img = '<td style="width: 40px;" rowspan="2"><img height="32" width="32" src="' + imgurl + '"/></td>';
					var table = '<table style="min-width: 130px;"><tr>' + img + '<td>' + mod.name + " (" + mod.items.length + ')</td></tr></table>';
					//$("#btnEditMod").jqxButton({ width: 120, height: 48, imgPosition: "center", textPosition: "center", imgSrc: "edit.png", textImageRelation: "imageAboveText" });
					return table;
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
		MC.go.Mod($('#modListBox').jqxListBox('getSelectedItem').value);
	});
	$('#itemListBox').on('select', function (event) {
		MC.go.Item($('#itemListBox').jqxListBox('getSelectedItem').value);
	});
	
	$('#modwindow').jqxWindow({
		cancelButton: $('#modwindow_cancelButton'),	//Object …Sets or gets cancel button. When a cancel button is specified you can use this button to interact with the user. When any user press the cacel button window is going to be closed and the dialog result will be in the following format: { OK: false, Cancel: true, None: false }.
		draggable: false,	//Boolean …Sets or gets whether the window is draggable.
		height: 270,	//Number/String …Sets or gets the window's height.
		initContent: function() {
			$("#modname_input").jqxInput({placeHolder: "Enter a Mod name...", height: 25, width: 300, minLength: 1});
			$("#modiso_input").jqxInput({placeHolder: "Enter a Mod iso...", height: 25, width: 300, minLength: 1});
			$('#moddescription_area').jqxTextArea({ placeHolder: 'Enter a Mod description...', height: 90, width: 307, minLength: 1 });
			$('#modwindow_okButton').jqxButton({ width: '100px', disabled: false });
			$('#modwindow_cancelButton').jqxButton({ width: '100px', disabled: false });
		},	//Method …Initializes the jqxWindow's content.
		isModal: true,	//Boolean …Sets or gets whether the window is displayed as a modal dialog. If the jqxWindow's mode is set to modal, the window blocks user interaction with the underlying user interface.
		keyboardNavigation: false,	//Boolean …Determines whether the keyboard navigation is enabled or disabled.
		minHeight: 50,	//Number/String …Sets or gets window's minimum height.
		maxHeight: 1000,	//Number/String …Sets or gets window's maximum height.
		minWidth: 50,	//Number/String …Sets or gets window's minimum width.
		maxWidth: 1260,	//Number/String …Sets or gets window's maximum width.
		modalOpacity: 0.3,	//Number …Sets or gets the jqxWindow's background displayed over the underlying user interface when the window is in modal dialog mode.
		modalZIndex: 18000,	//Number …Sets or gets the jqxWindow's z-index when it is displayed as a modal dialog.
		modalBackgroundZIndex: 12990,	//Number …Sets or gets the jqxWindow overlay's z-index when it is displayed as a modal dialog.
		okButton: $('#modwindow_okButton'),	//Object …Sets or gets submit button. When a ok/submit button is specified you can use this button to interact with the user. When any user press the submit button window is going to be closed and the dialog result will be in the following format: { OK: true, Cancel: false, None: false }.
		resizable: false,	//Boolean …Enables or disables whether the end-user can resize the window.
		showCloseButton: false,	//Boolean …Sets or gets whether a close button will be visible.
		title: '',	//String …Sets or gets window's title content.
		width: 420,	//Number/String …Sets or gets the window's width.
		zIndex: 9001 //Number …Sets or gets the jqxWindow z-index.
	});
	$('#itemwindow').jqxWindow({
		cancelButton: $('#itemwindow_cancelButton'),	//Object …Sets or gets cancel button. When a cancel button is specified you can use this button to interact with the user. When any user press the cacel button window is going to be closed and the dialog result will be in the following format: { OK: false, Cancel: true, None: false }.
		draggable: false,	//Boolean …Sets or gets whether the window is draggable.
		height: 405,	//Number/String …Sets or gets the window's height.
		initContent: function() {
			$("#itemname_input").jqxInput({placeHolder: "Enter an Item name...", height: 25, width: 300, minLength: 1});
			$("#itemgroup_input").jqxInput({placeHolder: "Enter an Item group...", height: 25, width: 300, minLength: 1});
			$('#itemdescription_area').jqxTextArea({ placeHolder: 'Enter an Item description...', height: 90, width: 307, minLength: 1 });
			$("#itemtrader_input").jqxInput({placeHolder: "Enter a Trader...", height: 25, width: 300});
			$("#itemselling_check").jqxCheckBox({height: 25, width: 80, checked: true});
			$("#itembuying_check").jqxCheckBox({height: 25, width: 80, checked: true});
			$("#itemfixedprice_check").jqxCheckBox({height: 25, width: 100, checked: false});
			$("#itemfixedprice_check").on('change', function (event) {
				if (event.args.checked) {
					$("#itemprice_input").jqxInput({disabled: false});									
				}
				else {
					$("#itemprice_input").jqxInput({disabled: true});									
				}
			});
			$("#itemprice_input").jqxInput({placeHolder: "Enter a Price...", height: 25, width: 300, disabled: true});
			$('#itemaddreceipt_button').jqxButton({ width: '180px', disabled: false });
			$('#itemaddreceipt_button').on('click', function () {
				MC.go.Add.Receipt();	
			});
			$('#itemwindow_okButton').jqxButton({ width: '180px', disabled: false });
			$('#itemwindow_cancelButton').jqxButton({ width: '180px', disabled: false });	
		},	//Method …Initializes the jqxWindow's content.
		isModal: true,	//Boolean …Sets or gets whether the window is displayed as a modal dialog. If the jqxWindow's mode is set to modal, the window blocks user interaction with the underlying user interface.
		keyboardNavigation: false,	//Boolean …Determines whether the keyboard navigation is enabled or disabled.
		minHeight: 50,	//Number/String …Sets or gets window's minimum height.
		maxHeight: 1000,	//Number/String …Sets or gets window's maximum height.
		minWidth: 50,	//Number/String …Sets or gets window's minimum width.
		maxWidth: 1260,	//Number/String …Sets or gets window's maximum width.
		modalOpacity: 0.3,	//Number …Sets or gets the jqxWindow's background displayed over the underlying user interface when the window is in modal dialog mode.
		modalZIndex: 18001,	//Number …Sets or gets the jqxWindow's z-index when it is displayed as a modal dialog.
		modalBackgroundZIndex: 12991,	//Number …Sets or gets the jqxWindow overlay's z-index when it is displayed as a modal dialog.
		okButton: $('#itemwindow_okButton'),	//Object …Sets or gets submit button. When a ok/submit button is specified you can use this button to interact with the user. When any user press the submit button window is going to be closed and the dialog result will be in the following format: { OK: true, Cancel: false, None: false }.
		resizable: true,	//Boolean …Enables or disables whether the end-user can resize the window.
		showCloseButton: false,	//Boolean …Sets or gets whether a close button will be visible.
		title: '',	//String …Sets or gets window's title content.
		width: 450,	//Number/String …Sets or gets the window's width.
		zIndex: 9002 //Number …Sets or gets the jqxWindow z-index.
	});
	$('#receiptwindow').jqxWindow({
		cancelButton: $('#receiptwindow_cancelButton'),	//Object …Sets or gets cancel button. When a cancel button is specified you can use this button to interact with the user. When any user press the cacel button window is going to be closed and the dialog result will be in the following format: { OK: false, Cancel: true, None: false }.
		draggable: false,	//Boolean …Sets or gets whether the window is draggable.
		height: 630,	//Number/String …Sets or gets the window's height.
		initContent: function() {
			$("#crafting_item").jqxDropDownList({
				autoDropDownHeight: true,	//Boolean  … Sets or gets whether the height of the jqxDropDownList's ListBox displayed in the widget's DropDown is calculated as a sum of the items heights.
				source: MC.crafting_items,	//Array  … Sets or gets the items source.
				selectedIndex: 0,	//Number  … Sets or gets the selected index.
				width: 200 	//Number/String  … Sets or gets the jqxDropDownList's width.
			});

			for (var h = 0; h < MC.Definitions.receipt_io_count; h++){
				$("#rc" + h + "_count").jqxInput({placeHolder: "How Many?...", height: 25, width: 90, minLength: 1});
				$("#rc" + h + "_count").jqxInput('val', "1");
				$("#rc" + h + "_modbox0").jqxInput({placeHolder: "Enter Mod name...", height: 25, width: 130, minLength: 1, items: 30, searchMode: 'contains', source: MC.ModNames});
				$("#rc" + h + "_itembox0").jqxInput({placeHolder: "Enter Item name...", height: 25, width: 200, minLength: 1, items: 30, searchMode: 'contains', source: MC.ItemNames.ALL});
				$("#rc" + h + "_modbox0").on('change', function (event) {
 					var id = event.target.id.split("_modbox")[0].split("rc")[1];
					var value = $("#rc" + id + "_modbox0").val();
					if ( value.isEmpty() ) {$("#rc" + id + "_itembox0").jqxInput({source: MC.ItemNames.ALL});}
					else if ( MC.ItemNames[value] != null ) {$("#rc" + id + "_itembox0").jqxInput({source: MC.ItemNames[value]});}
					else{$("#rc" + id + "_itembox0").jqxInput({source: []});}
				});
				$("#addButton" + h).jqxButton({width: 30, height: 23, imgSrc: "plus.png", imgWidth: 20, imgHeight: 20, imgPosition: "center", textPosition: "center", textImageRelation: "imageAboveText"});
				$("#removeButton" + h).jqxButton({width: 30, height: 23, imgSrc: "minus.png", imgWidth: 20, imgHeight: 20, imgPosition: "center", textPosition: "center", textImageRelation: "imageAboveText"});
				$("#addButton" + h).click(function (event) {
					var addid = parseInt(event.target.id.split("addButton")[1]);
					if(MC.rc_inputcount[addid] > 20){
						alert("Only 20 textboxes allow");
						return false;
					}
					var newTextBoxDiv = $(document.createElement('div')).attr("id", "rc" + addid + "_div" + MC.rc_inputcount[addid]);
					newTextBoxDiv.after().html("<input type='textbox' id='rc" + addid + "_modbox" + MC.rc_inputcount[addid] + "' autocomplete='off' style='float:left; margin: 3px 5px;'/><input type='textbox' id='rc" + addid + "_itembox" + MC.rc_inputcount[addid] + "' style='margin: 3px 5px;' autocomplete='off'/>");
					newTextBoxDiv.appendTo("#rc" + addid + "_group");
					$("#rc" + addid + "_modbox" + MC.rc_inputcount[addid]).jqxInput({placeHolder: "Enter a Mod name...", height: 25, width: 130, minLength: 1, items: 30, searchMode: 'contains', source: MC.ModNames});
					$("#rc" + addid + "_itembox" + MC.rc_inputcount[addid]).jqxInput({placeHolder: "Enter Item name...", height: 25, width: 200, minLength: 1, items: 30, searchMode: 'contains', source: MC.ItemNames.ALL});
					$("#rc" + addid + "_modbox" + MC.rc_inputcount[addid]).on('change', function (event) { 
						var id = event.target.id.split("modbox")[1];
						var value = $("#rc" + 0 + "_modbox" + id).val();
						if ( value.isEmpty() ) {$("#rc" + 0 + "_itembox" + id).jqxInput({source: MC.ItemNames.ALL});}
						else if ( MC.ItemNames[value] != null ) {$("#rc" + 0 + "_itembox" + id).jqxInput({source: MC.ItemNames[value]});}
						else{$("#rc" + 0 + "_itembox" + id).jqxInput({source: []});}
					});
					MC.rc_inputcount[0]++;
				});
				$("#removeButton" + 0).click(function () {
					if(MC.rc_inputcount[0]==1){
						alert("No more textbox to remove");
						return false;
					}
					MC.rc_inputcount[0]--;
					$("#rc" + 0 + "_div" + MC.rc_inputcount[0]).remove();
				});
			}					
			$('#receiptwindow_okButton').jqxButton({ width: '180px', disabled: false });
			$('#receiptwindow_cancelButton').jqxButton({ width: '180px', disabled: false });
		},	//Method …Initializes the jqxWindow's content.
		isModal: true,	//Boolean …Sets or gets whether the window is displayed as a modal dialog. If the jqxWindow's mode is set to modal, the window blocks user interaction with the underlying user interface.
		keyboardNavigation: false,	//Boolean …Determines whether the keyboard navigation is enabled or disabled.
		minHeight: 50,	//Number/String …Sets or gets window's minimum height.
		maxHeight: 1000,	//Number/String …Sets or gets window's maximum height.
		minWidth: 50,	//Number/String …Sets or gets window's minimum width.
		maxWidth: 1260,	//Number/String …Sets or gets window's maximum width.
		modalOpacity: 0.3,	//Number …Sets or gets the jqxWindow's background displayed over the underlying user interface when the window is in modal dialog mode.
		modalZIndex: 18002,	//Number …Sets or gets the jqxWindow's z-index when it is displayed as a modal dialog.
		modalBackgroundZIndex: 12992,	//Number …Sets or gets the jqxWindow overlay's z-index when it is displayed as a modal dialog.
		okButton: $('#receiptwindow_okButton'),	//Object …Sets or gets submit button. When a ok/submit button is specified you can use this button to interact with the user. When any user press the submit button window is going to be closed and the dialog result will be in the following format: { OK: true, Cancel: false, None: false }.
		resizable: true,	//Boolean …Enables or disables whether the end-user can resize the window.
		showCloseButton: false,	//Boolean …Sets or gets whether a close button will be visible.
		title: '',	//String …Sets or gets window's title content.
		width: 1096,	//Number/String …Sets or gets the window's width.
		zIndex: 9003 //Number …Sets or gets the jqxWindow z-index.
	});
	
	$('#modwindow').on('open', function(event) { //This event is triggered when the window is displayed.
		if(MC.editing.Mod >= 0 && MC.mode.Mod.equals("edit")){
			var pos = MC.getPos.Mod(MC.editing.Mod);
			$('#modname_input').jqxInput('val', MC.Mod[pos].name);
			$('#modiso_input').jqxInput('val', MC.Mod[pos].iso);
			$('#moddescription_area').jqxTextArea('val', MC.Mod[pos].description);
			$('#modwindow').jqxWindow('setTitle', 'Edit Mod: ' + MC.Mod[pos].name);
		}
		else if(MC.mode.Mod.equals("add")){
			$('#modname_input').jqxInput('val', "");
			$('#modiso_input').jqxInput('val', "");
			$('#moddescription_area').jqxTextArea('val', "");
			$('#modwindow').jqxWindow('setTitle', 'Add Mod');
		}
		else{
			$('#modwindow').jqxWindow('close')
		}
	});
	$('#modwindow').on('close', function(event) {//This event is triggered when the window is closed.
		var result = event.args.dialogResult;
		if(result.OK && result.Cancel == false){
			if(MC.editing.Mod >= 0 && MC.mode.Mod.equals("edit")){
				var pos = MC.getPos.Mod(MC.editing.Mod);
				MC.Mod[pos].name = $('#modname_input').jqxInput('val');
				MC.Mod[pos].iso = $('#modiso_input').jqxInput('val');
				MC.Mod[pos].description = $('#moddescription_area').jqxTextArea('val');
				MC.go.ModList();

				var mods = $("#modListBox").jqxListBox('getItems');
				for (var i = 0; i < mods.length; i++){
					if ( mods[i].value == MC.editing.Mod ){
						$("#modListBox").jqxListBox('unselectIndex', i);
						$("#modListBox").jqxListBox('selectIndex', i);
					}
				}
				if ( MC.viewing.Item > 0 ){
					var items = $("#itemListBox").jqxListBox('getItems');
					for (var i = 0; i < items.length; i++){
						if ( items[i].value == MC.viewing.Item ){
							$("#itemListBox").jqxListBox('selectIndex', i);
						}
					}
				}
			}
			else if(MC.mode.Mod.equals("add")){
				MC.Mod.push({
					id: MC.Mod.length,
					name: $('#modname_input').jqxInput('val'),
					iso: $('#modiso_input').jqxInput('val'),
					description: $('#moddescription_area').jqxTextArea('val'),
					items: new Array()
				});
				MC.go.ModList();
				$("#modListBox").jqxListBox('selectIndex', MC.Mod.length - 1);
			}
			
		}
		MC.editing.Mod = -1;
		MC.mode.Mod = "";
	});
	
	$('#itemwindow').on('open', function(event) { //This event is triggered when the window is displayed.
		if(MC.editing.Item >= 0 && MC.mode.Item.equals("edit")){
			var pos = MC.getPos.Item(MC.editing.Mod, MC.editing.Item);
			$("#itemname_input").jqxInput('val', MC.Mod[pos.mod].items[pos.item].name);
			$("#itemgroup_input").jqxInput('val', MC.Mod[pos.mod].items[pos.item].group);
			$('#itemdescription_area').jqxTextArea('val', MC.Mod[pos.mod].items[pos.item].description);
			var traderpos = MC.getPos.Trader(MC.Mod[pos.mod].items[pos.item].trader_id);
			console.log(pos);
			console.log(traderpos);
			if ( traderpos < 0 ) {
				$("#itemtrader_input").jqxInput('val', "");
			}
			else{
				$("#itemtrader_input").jqxInput('val', MC.Trader[traderpos].name);
			}
			$("#itemselling_check").jqxCheckBox({checked: MC.Mod[pos.mod].items[pos.item].selling});
			$("#itembuying_check").jqxCheckBox({checked: MC.Mod[pos.mod].items[pos.item].buying});
			$("#itemfixedprice_check").jqxCheckBox({checked: MC.Mod[pos.mod].items[pos.item].fixedprice});
			$('#itemprice_input').jqxInput('val', MC.Mod[pos.mod].items[pos.item].price);
			var rcount = 0;
			var receipttables = Object.keys(MC.Mod[pos.mod].items[pos.item].receipt);
			for (var i = 0; i < receipttables.length; i++){
				rcount += MC.Mod[pos.mod].items[pos.item].receipt[receipttables[i]].length;
			}
			$('#itemreceiptcount').html('Receipts: ' + rcount);
			$('#itemwindow').jqxWindow('setTitle', 'Edit Item: ' + MC.Mod[pos.mod].items[pos.item].name + ' -------- Mod: ' +  MC.Mod[pos.mod].name);	
		}
		else if(MC.mode.Item.equals("add")){
			$("#itemname_input").jqxInput('val', "");
			$("#itemgroup_input").jqxInput('val', "");
			$('#itemdescription_area').jqxTextArea('val', "");
			$("#itemtrader_input").jqxInput('val', "");
			$("#itemselling_check").jqxCheckBox({checked: true});
			$("#itembuying_check").jqxCheckBox({checked: true});
			$("#itemfixedprice_check").jqxCheckBox({checked: false});
			$("#itemprice_input").jqxInput({disabled: true});
			$('#itemprice_input').jqxInput('val', "");
			$('#itemreceiptcount').html('Receipts: 0');
			$('#itemwindow').jqxWindow('setTitle', 'Add Item to Mod: ' +  MC.Mod[MC.getPos.Mod(MC.editing.Mod)].name);		
		}
		else{
			$('#itemwindow').jqxWindow('close')
		}
	});
	$('#itemwindow').on('close', function(event) {//This event is triggered when the window is closed.
		var result = event.args.dialogResult;
		if(result.OK && result.Cancel == false){
			var tempgroup = $("#itemgroup_input").jqxInput('val');
			if ( tempgroup.isEmpty() ){
				tempgroup = "- No Group -";
			}
			if(MC.editing.Item >= 0 && MC.mode.Item.equals("edit")){	
				var pos = MC.getPos.Item(MC.editing.Mod, MC.editing.Item);
				MC.Mod[pos.mod].items[pos.item].name = $('#itemname_input').jqxInput('val');
				MC.Mod[pos.mod].items[pos.item].description = $('#itemdescription_area').jqxTextArea('val');
				MC.Mod[pos.mod].items[pos.item].selling = $("#itemselling_check").jqxCheckBox('checked');
				MC.Mod[pos.mod].items[pos.item].buying = $("#itembuying_check").jqxCheckBox('checked');
				MC.Mod[pos.mod].items[pos.item].fixedprice = $("#itemfixedprice_check").jqxCheckBox('checked');
				MC.Mod[pos.mod].items[pos.item].price = $('#itemprice_input').jqxInput('val');
				MC.Mod[pos.mod].items[pos.item].count = 1;
				MC.Mod[pos.mod].items[pos.item].trader_id = 1;
				MC.Mod[pos.mod].items[pos.item].group = tempgroup;
				MC.Mod[pos.mod].items[pos.item].receipt = {};
				var mods = $("#modListBox").jqxListBox('getItems');
				for (var i = 0; i < mods.length; i++){
					if ( mods[i].value == MC.editing.Mod ){
						$("#modListBox").jqxListBox('unselectIndex', i);
						$("#modListBox").jqxListBox('selectIndex', i);
					}
				}
				var items = $("#itemListBox").jqxListBox('getItems');
				for (var i = 0; i < mods.length; i++){
					if ( items[i].value == MC.editing.Item ){
						$("#itemListBox").jqxListBox('selectIndex', i);
					}
				}
			}
			else if(MC.mode.Item.equals("add")){
				var pos = MC.getPos.Mod(MC.editing.Mod);
				MC.Mod[pos].items.push({
					id: MC.Mod[pos].items.length,
					name: $('#itemname_input').jqxInput('val'),
					description: $('#itemdescription_area').jqxTextArea('val'),
					selling: $("#itemselling_check").jqxCheckBox('checked'),
					buying: $("#itembuying_check").jqxCheckBox('checked'),
					fixedprice: $("#itemfixedprice_check").jqxCheckBox('checked'),
					price: $('#itemprice_input').jqxInput('val'),
					count: 1,
					trader_id: 1,
					group: tempgroup,
					receipt: {}
				});
				var mods = $("#modListBox").jqxListBox('getItems');
				for (var i = 0; i < mods.length; i++){
					if ( mods[i].value == MC.editing.Mod ){
						console.log("reload");
						$("#modListBox").jqxListBox('unselectIndex', i);
						$("#modListBox").jqxListBox('selectIndex', i);
					}
				}
				var items = $("#itemListBox").jqxListBox('getItems');
				for (var i = 0; i < mods.length; i++){
					if ( items[i].value == MC.Mod[pos].items.length ){
						$("#modListBox").jqxListBox('selectIndex', i);
					}
				}
			}
			MC.go.RefreshNameArrays();
		}
		MC.editing.Mod = -1;
		MC.editing.Item = -1;
		MC.mode.Item = "";
	});
	
	$('#receiptwindow').on('open', function(event) { //This event is triggered when the window is displayed.
		$("#crafting_item").jqxDropDownList('selectIndex', 0 ); 
		for (var i = 0; i < MC.Definitions.receipt_io_count; i++){
			$("#rc" + i + "_count").jqxInput('val', "1");
			$("#rc" + i + "_modbox0").jqxInput('val', "");
			$("#rc" + i + "_itembox0").jqxInput('val', "");
			$("#rc" + i + "_modbox0").jqxInput({source: MC.ModNames});
			$("#rc" + i + "_itembox0").jqxInput({source: MC.ItemNames.ALL});
			while ( MC.rc_inputcount[i] != 1 ) {
				$("#removeButton" + i).click();
			}
		}
		if(MC.editing.Receipt >= 0 && MC.mode.Receipt.equals("edit")){
			
		}
		else if(MC.mode.Receipt.equals("add")){
			var pos = MC.getPos.Item(MC.editing.Mod, MC.editing.Item);
			$("#rc10_modbox0").jqxInput('val', MC.Mod[pos.mod].name);
			$("#rc10_itembox0").jqxInput('val', MC.Mod[pos.mod].items[pos.item].name);		
		}
		else{
			$('#receiptwindow').jqxWindow('close')
		}
	});
	$('#receiptwindow').on('close', function(event) {//This event is triggered when the window is closed.
		var result = event.args.dialogResult;
		if(result.OK && result.Cancel == false){
			var ci = $("#crafting_item").jqxDropDownList('getSelectedItem').label
			var entered = {IN: {}, OUT: {}};
			var pe = {IN: 0, OUT: 0};
			var io = "IN";
			if(MC.mode.Receipt.equals("add") && MC.mode.Item.equals("edit")){
				var pos = MC.getPos.Item(MC.editing.Mod, MC.editing.Item);
				if ( MC.Mod[pos.mod].items[pos.item].receipt[ci] == null ) {
					MC.Mod[pos.mod].items[pos.item].receipt[ci] = new Array();
				}
				for (var i = 0; i < MC.Definitions.receipt_io_count; i++){
					if ( i > MC.Definitions.receipt_io_count - 4 ) {
						io = "OUT";
					}
					if ( $("#rc" + i + "_itembox0").jqxInput('val').isEmpty() == false && $("#rc" + i + "_modbox0").jqxInput('val').isEmpty() == false ) {
						entered[io]["item" + pe[io]] = {count: $("#rc" + i + "_count").jqxInput('val'), things: new Array()};
						for (var j = 0; j < MC.rc_inputcount[i]; j++){
							entered[io]["item" + pe[io]].things.push({
								modname: $("#rc" + i + "_modbox" + j).jqxInput('val'),
								itemname: $("#rc" + i + "_itembox" + j).jqxInput('val')
							});
							pe[io]++;
						}
					}
					pe[io] = 0;
				}
				console.log(ci);
				console.log(entered);
				var rcount = 0;
				var receipttables = Object.keys(MC.Mod[pos.mod].items[pos.item].receipt);
				for (var i = 0; i < receipttables.length; i++){
					rcount += MC.Mod[pos.mod].items[pos.item].receipt[receipttables[i]].length;
				}
				$('#itemreceiptcount').html('Receipts: ' + rcount);
				MC.Mod[pos.mod].items[pos.item].receipt[ci].push(entered);
			}
		}
		MC.editing.Mod = -1;
		MC.editing.Item = -1;
		MC.editing.Receipt = -1;
		MC.mode.Receipt = "";
	});
	
	$('#modwindow').jqxWindow({
		closeAnimationDuration : 0,
		showAnimationDuration : 0
	});
	$('#modwindow').jqxWindow('open');
	$('#modwindow').jqxWindow('close');
	$('#modwindow').jqxWindow({
		closeAnimationDuration : 350,
		showAnimationDuration : 350
	});
	$('#itemwindow').jqxWindow({
		closeAnimationDuration : 0,
		showAnimationDuration : 0
	});
	$('#itemwindow').jqxWindow('open');
	$('#itemwindow').jqxWindow('close');
	$('#itemwindow').jqxWindow({
		closeAnimationDuration : 350,
		showAnimationDuration : 350
	});
	$('#receiptwindow').jqxWindow({
		closeAnimationDuration : 0,
		showAnimationDuration : 0
	});
	$('#receiptwindow').jqxWindow('open');
	$('#receiptwindow').jqxWindow('close');
	$('#receiptwindow').jqxWindow({
		closeAnimationDuration : 350,
		showAnimationDuration : 350
	});

	MC.loadJSONFile();
	MC.go.Mod(-1);
	

	var rss = (function ($) {
		var selectFirst = function () {
			$('#itemListBox').jqxListBox('selectIndex', 0);
			loadContent(0);
		};
		var displayModHeader = function (header) {
			$("#itemListExpander").jqxExpander('setHeaderContent', header);
		};
		var loadContent = function (index) {
			var item = config.currentFeedContent[index];
			if (item != null) {
				config.itemDetailTabs.jqxPanel('clearcontent');
				config.itemDetailTabs.jqxPanel('prepend', '<div style="padding: 1px;"><span>' + item.description + '</span></div>');
				addContentHeaderData(item);
				config.selectedIndex = index;
			}
		};
		var addContentHeaderData = function (item) {
			var link = $('<a style="white-space: nowrap; margin-left: 15px;" target="_blank">Source</a>'),
				date = $('<div style="white-space: nowrap; margin-left: 30px;">' + item.pubDate + '</div>');
			container = $('<table height="100%"><tr><td></td><td></td></tr></table>');
			link[0].href = item.link;
			config.detailHeader.empty();
			config.detailHeader.append(container);
			container.find('td:first').append(link);
			container.find('td:last').append(date);
			$("#itemDetailExpander").jqxExpander('setHeaderContent', container[0].outerHTML);
		};
		var config = {
			feeds: { 'CNN.com': 'cnn', 'Geek.com': 'geek', 'ScienceDaily': 'sciencedaily' },
			format: 'txt',
			modlist: $('#modListBox'),
			itemListBox: $('#itemListBox'),
			itemDetailTabs: $('#itemDetailTabs'),
			detailHeader: $('#detailHeader'),
			itemUpperPanel: $('#itemUpperPanel'),
			itemHeader: $('#itemHeader'),
			feedContentArea: $('#feedContentArea'),
			selectedIndex: -1,
			currentFeed: '',
			currentFeedContent: {}
		};
		return 0;
	} (jQuery));
});

