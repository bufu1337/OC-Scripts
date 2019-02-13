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
			if(MC.Mod[value.name] != null){
				MC.Mod[value.name].idname.push(index);
			}
			else{
				MC.Mod[value.name] = {idname:[index], crafter:value.crafter, items:{}}
			}
			$.each(MC.Items[value.crafter], function (index2, value2) {
				if ( index2.startsWith((index + "_")) ) {
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
				$('#contentSplitter').jqxSplitter('collapse');
				MC.viewing.Mod = modname;
				MC.viewing.Item = "";
				$('#itemHeader').html("<b class='headerstyle'>Mod-Name: </b>" + modname + " <b class='headerstyle'>Item-Count:</b> " + Object.keys(MC.Mod[modname].items).length);
				if ( Object.keys(MC.Mod[modname].items).length == 0) {
					MC.show("noitems");
				}
				else{
					MC.show("itemListBox");
					var itemssource = [];
					$.each(Object.keys(MC.Mod[modname].items), function (index, item) {
						//var pricecaption = MC.Mod[modname].items[item].count + " St. => " + MC.Mod[modname].items[item].price;
						var pricecaption = MC.Mod[modname].items[item].count + " St. => " + MC.Mod[modname].items[item].price
						if ( MC.Mod[modname].items[item].price == 0 ) {
							pricecaption = "No";
						}
						var itemname = "";
						if (MC.Mod[modname].items[item].label != ""){
							itemname = MC.Mod[modname].items[item].label;
						}
						else{
							itemname = item.replace("_jj_", ":").replaceAll("_xx_", "/").replaceAll("_qq_", "-").replaceAll("_vv_", ".").replace("_b_", " Typ: ")
							if(itemname.contains("_jj_")){
								itemname = itemname.split("_jj_")[0] + " <b class='itemstyle3'>DMG:</b> " + itemname.split("_jj_")[1]
							}
						}
						itemssource.push({html: "<b class='itemstyle'>Name:</b> " + itemname + " <b class='itemstyle2'>Costs:</b> " + pricecaption, label: item, value: item, group: MC.Mod[modname].items[item].group});
					});
					$('#itemListBox').jqxListBox('source', itemssource);
					$('#itemListBox').jqxListBox('refresh');
				}
			}
		},
		Item: function(itemname){
			console.log("Item Page - Mod ID: " + MC.viewing.Mod + " Item: " + itemname);
			MC.viewing.Item = itemname;	
			$('#contentSplitter').jqxSplitter('expand');
			var tempname = MC.viewing.Item.split("_b_")[0]
			var temp_itemdmg = "";
			if(tempname.split("_jj_")[2] != null){temp_itemdmg = tempname.split("_jj_")[2]}
			var temp_itemvariant = "";
			if(MC.viewing.Item .split("_b_")[1] != null){temp_itemvariant = MC.viewing.Item .split("_b_")[1]}
			$("#id_display").text(MC.viewing.Item);
			$("#modid_display").text(tempname.split("_jj_")[0]);
			$("#itemid_display").text(tempname.split("_jj_")[1]);
			$("#itemdmg_display").text(temp_itemdmg);
			if(temp_itemdmg == ""){
				$("#itemdmg_line").css({visibility: "hidden", display: "none"});
			}
			else{
				$("#itemdmg_line").css({visibility: "visible", display: "table-row"});
			}
			$("#itemvariant_display").text(temp_itemvariant);
			if(temp_itemvariant == ""){
				$("#itemvariant_line").css({visibility: "hidden", display: "none"});
			}
			else{
				$("#itemvariant_line").css({visibility: "visible", display: "table-row"});
			}
			$("#itemtag_display").text(MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].tag);
			if(MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].tag == ""){
				$("#itemtag_line").css({visibility: "hidden", display: "none"});
			}
			else{
				$("#itemtag_line").css({visibility: "visible", display: "table-row"});
			}
			
			$("#itemlabel_input").jqxInput('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].label);
			$("#itemgroup_input").jqxInput('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].group);
			$('#itemcomment1_input').jqxInput('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].c1);
			$('#itemcomment2_input').jqxInput('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].c2);
			$('#itemcomment3_input').jqxInput('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].c3);
			$("#itemtrader_drop").jqxInput('val', MC.Traders[MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].trader].label);
			$("#itemselling_check").jqxCheckBox({checked: MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].selling});
			$("#itembuying_check").jqxCheckBox({checked: MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].buying});
			$("#itemfixedprice_check").jqxCheckBox({checked: MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].fixedprice});
			$('#itemprice_input').jqxInput('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].price);
			$("#itemchisel_check").jqxCheckBox('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].chisel);
			$("#itembit_check").jqxCheckBox('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].bit);
			$("#itempattern_check").jqxCheckBox('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].hasPattern);
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
	$('#contentSplitter').on('expanded', function (event) {
		if(MC.viewing.Item == ""){
			$('#contentSplitter').jqxSplitter('collapse');
		}
	});
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
	
	$("#itemlabel_input").jqxInput({placeHolder: "Enter a name...", height: 25, width: 300, minLength: 1});
	$("#itemgroup_input").jqxInput({placeHolder: "Enter a group...", height: 25, width: 300, minLength: 1});
	$('#itemcomment1_input').jqxInput({ placeHolder: "Enter a comment...", height: 25, width: 300, minLength: 1 });
	$('#itemcomment2_input').jqxInput({ placeHolder: "Enter a comment...", height: 25, width: 300, minLength: 1 });
	$('#itemcomment3_input').jqxInput({ placeHolder: "Enter a comment...", height: 25, width: 300, minLength: 1 });
	$("#itemtrader_drop").jqxDropDownList({source: MC.Traders, placeHolder: "Enter a trader...", height: 25, width: 307});
	$("#itemselling_check").jqxCheckBox({height: 25, width: 50, checked: true});
	$("#itembuying_check").jqxCheckBox({height: 25, width: 50, checked: true});
	$("#itemchisel_check").jqxCheckBox({height: 25, width: 70, checked: true});
	$("#itembit_check").jqxCheckBox({height: 25, width: 50, checked: true});
	$("#itempattern_check").jqxCheckBox({height: 25, width: 100, checked: true});
	$("#itemfixedprice_check").jqxCheckBox({height: 25, width: 100, checked: false});
	$("#itemfixedprice_check").on('change', function (event) {
		if (event.args.checked) {
			$("#itemprice_input").jqxInput({disabled: false});									
		}
		else {
			$("#itemprice_input").jqxInput({disabled: true});									
		}
	});
	$("#itemprice_input").jqxInput({placeHolder: "Enter a price...", height: 25, width: 300, disabled: true});
	$('#itemValidator').jqxValidator({
		rules: [
			{ input: '#itemprice_input', message: 'Price must be an Integer!', action: 'valueChanged', rule: function (input, commit) {
					try{
						var g = parseInt($('#itemprice_input').jqxInput('val'));
						return true;
					}
					catch{
						return false;
					}
				}
			}
		]
	});
	$('#itemValidator').on('validationSuccess', function(event) {//This event is triggered when the window is closed.
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].buying = $("#itembuying_check").jqxCheckBox('checked'),
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].bit = $("#itembit_check").jqxCheckBox('checked');
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].c1 = $('#itemcomment1_input').jqxTextArea('val');
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].c2 = $('#itemcomment2_input').jqxTextArea('val');
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].c3 = $('#itemcomment3_input').jqxTextArea('val');
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].chisel = $("#itemchisel_check").jqxCheckBox('checked');
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].fixedprice = $("#itemfixedprice_check").jqxCheckBox('checked');
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].group = $('#itemgroup_input').jqxInput('val');
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].price = parseInt($('#itemprice_input').jqxInput('val'));
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].selling = $("#itemselling_check").jqxCheckBox('checked');
		var temptrader = 0;
		$.each(MC.Traders, function (index, value) {
			if ( value.label == $('#itemtrader_drop').jqxInput('val') ) {
				temptrader = value.value
			}
		});
		
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].trader = temptrader;
		MC.go.ModList();
		$.each($("#modListBox").jqxListBox('getItems'), function (index, value) {
			if ( MC.editing.Mod.equals(value.label) ) {
				$("#modListBox").jqxListBox('unselectIndex', value.index);
				$("#modListBox").jqxListBox('selectIndex', value.index);
			}
		});
		$.each($("#itemListBox").jqxListBox('getItems'), function (index, value) {
			if ( MC.viewing.Item.equals(value.label) ) {
				$("#itemListBox").jqxListBox('selectIndex', value.index);
			}
		});
	});
	$('#itemwindow_okButton').jqxButton({ width: '180px', disabled: false });
	$('#itemwindow_okButton').on('click', function () {
		$('#itemValidator').jqxValidator('validate');
	});
	
	$('#itemwindow_cancelButton').jqxButton({ width: '180px', disabled: false });
	
	MC.go.Mod("");
});

