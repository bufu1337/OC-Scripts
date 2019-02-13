//var fs = require('fs');
var dataAdapter = null;
var MC = {
	Items: {},
	Mods: {},
	Mod: {},
	Traders: [],
	Suggest: {
		groups: [],
		comment1: [],
		comment2: [],
		comment3: [],
		modid: [],
		itemid: {},
		itemlabel: []
	},
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
		MC.Suggest.modid = Object.keys(MC.Mods);
	},
	createItemSource: function(){
		MC.Suggest.groups = [];
		MC.Suggest.comment1 = [];
		MC.Suggest.comment2 = [];
		MC.Suggest.comment3 = [];
		$.each(MC.Items, function (crafter, itemarr) {
			$.each(itemarr, function (name, item) {
				if ( item.group != "" && item.group.equals(MC.Suggest.groups) == false ) {
					MC.Suggest.groups.push(item.group);
				}
				if ( item.c1 != "" && item.c1.equals(MC.Suggest.comment1) == false ) {
					MC.Suggest.comment1.push(item.c1);	
				}
				if ( item.c2 != "" && item.c2.equals(MC.Suggest.comment2) == false ) {
					MC.Suggest.comment2.push(item.c2);	
				}
				if ( item.c3 != "" && item.c3.equals(MC.Suggest.comment3) == false ) {
					MC.Suggest.comment3.push(item.c3);				
				}
			});
		});
	},
	createRecipeSource: function(modid){
		MC.Suggest.itemid = {};
		MC.Suggest.itemlabel = [];
		if ( modid.equals(MC.Suggest.modid) ) {
			$.each(MC.Items[MC.Mods[modid].crafter], function (name, item) {
				if ( name.startsWith(modid) ) {
					if ( item.label != "" ) {
						MC.Suggest.itemlabel.push(item.label);
					}
					var tempname = name.split("_b_")[0];
					var tempid = tempname.split("_jj_")[1];
					var temp_itemdmg = "0";
					if(tempname.split("_jj_")[2] != null){temp_itemdmg = tempname.split("_jj_")[2]}
					var temp_itemvariant = "0";
					if(name.split("_b_")[1] != null){temp_itemvariant = name.split("_b_")[1]}
					if ( MC.Suggest.itemid[tempid] == null) {
						MC.Suggest.itemid[tempid] = {damage:temp_itemdmg, variant:temp_itemvariant};
					}
					else{
						if ( parseInt(temp_itemdmg) > parseInt(MC.Suggest.itemid[tempid].damage) ) {
							MC.Suggest.itemid[tempid].damage = temp_itemdmg;
						}
						if ( parseInt(temp_itemvariant) > parseInt(MC.Suggest.itemid[tempid].variant) ) {
							MC.Suggest.itemid[tempid].variant = temp_itemvariant;
						}
					}				
				}
			});
		}
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
				MC.hide("noitems");
				MC.show("nomod");
				MC.hide("itemListBox");
				$('#contentSplitter').jqxSplitter('collapse');
			}
			else {
				MC.hide("noitems");
				MC.hide("nomod");
				MC.hide("itemListBox");
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
			if(MC.viewing.Item.split("_b_")[1] != null){temp_itemvariant = MC.viewing.Item.split("_b_")[1]}
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
			$.each($("#itemtrader_drop").jqxDropDownList('getItems'), function (index, item) {
				if ( MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].trader == item.value ) {
					$("#itemtrader_drop").jqxDropDownList('selectItem', item ); 
				}
			});
			$("#itemselling_check").jqxCheckBox({checked: MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].selling});
			$("#itembuying_check").jqxCheckBox({checked: MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].buying});
			$("#itemfixedprice_check").jqxCheckBox({checked: MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].fixedprice});
			$('#itemprice_input').jqxNumberInput('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].price);
			$("#itemchisel_check").jqxCheckBox('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].chisel);
			$("#itembit_check").jqxCheckBox('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].bit);
			$("#itempattern_check").jqxCheckBox('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].hasPattern);
		}
	}
}

$(document).ready(function () {
	MC.createModList();
	MC.createItemSource();
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
	
	$('#mainSplitter').jqxSplitter({  width: 1278, height: 900, panels: [{ size: 300, min: 100 }, {min: 200, size: 300}] });
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
	$("#itemgroup_input").jqxInput({source: MC.Suggest.groups, placeHolder: "Enter a group...", height: 25, width: 300, minLength: 1, items: 20});
	$('#itemcomment1_input').jqxInput({source: MC.Suggest.comment1, placeHolder: "Enter a comment...", height: 25, width: 300, minLength: 1, items: 20 });
	$('#itemcomment2_input').jqxInput({source: MC.Suggest.comment2, placeHolder: "Enter a comment...", height: 25, width: 300, minLength: 1, items: 20 });
	$('#itemcomment3_input').jqxInput({source: MC.Suggest.comment3, placeHolder: "Enter a comment...", height: 25, width: 300, minLength: 1, items: 20 });
	$("#itemtrader_drop").jqxDropDownList({source: MC.Traders, placeHolder: "Enter a trader...", height: 25, width: 307});
	$("#itemselling_check").jqxCheckBox({height: 25, width: 50, checked: true});
	$("#itembuying_check").jqxCheckBox({height: 25, width: 50, checked: true});
	$("#itemchisel_check").jqxCheckBox({height: 25, width: 70, checked: true});
	$("#itembit_check").jqxCheckBox({height: 25, width: 50, checked: true});
	$("#itempattern_check").jqxCheckBox({height: 25, width: 100, checked: true});
	$("#itemfixedprice_check").jqxCheckBox({height: 25, width: 100, checked: false});
	$("#itemfixedprice_check").on('change', function (event) {
		if (event.args.checked) {
			$("#itemprice_input").jqxNumberInput({disabled: false});									
		}
		else {
			$("#itemprice_input").jqxNumberInput({disabled: true});									
		}
	});
	$("#itemprice_input").jqxNumberInput({height: 25, width: 100, disabled: true, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 0});
	$('#itemwindow_okButton').jqxButton({ width: '180px', disabled: false });
	$('#itemwindow_okButton').on('click', function () {
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].buying = $("#itembuying_check").jqxCheckBox('checked'),
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].bit = $("#itembit_check").jqxCheckBox('checked');
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].c1 = $('#itemcomment1_input').jqxInput('val');
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].c2 = $('#itemcomment2_input').jqxInput('val');
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].c3 = $('#itemcomment3_input').jqxInput('val');
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].chisel = $("#itemchisel_check").jqxCheckBox('checked');
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].fixedprice = $("#itemfixedprice_check").jqxCheckBox('checked');
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].group = $('#itemgroup_input').jqxInput('val');
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].price = parseInt($('#itemprice_input').jqxNumberInput('val'));
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].selling = $("#itemselling_check").jqxCheckBox('checked');
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].trader = $("#itemtrader_drop").jqxDropDownList('getSelectedItem').value;
		//MC.go.ModList();
		var temp_item = $("#itemListBox").jqxListBox('getSelectedItem');
		$.each($("#modListBox").jqxListBox('getItems'), function (index, value) {
			if ( MC.viewing.Mod.equals(value.label) ) {
				$("#modListBox").jqxListBox('unselectIndex', value.index);
				$("#modListBox").jqxListBox('selectIndex', value.index);
			}
		});
		MC.createItemSource();
		$('#itemgroup_input').jqxInput('source', MC.Suggest.groups);
		$('#itemcomment1_input').jqxInput('source', MC.Suggest.comment1);
		$('#itemcomment2_input').jqxInput('source', MC.Suggest.comment2);
		$('#itemcomment3_input').jqxInput('source', MC.Suggest.comment3);
		$("#itemListBox").jqxListBox('selectItem', temp_item);
	});
	$("#rc_craftcount").jqxNumberInput({height: 25, width: 63, disabled: false, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 1, max: 64});
	for (var h = 0; h < 9; h++){
		$("#rc" + h + "_count").jqxNumberInput({height: 25, width: 63, disabled: true, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 1, max: 9});
		$("#rc" + h + "_dmg").jqxNumberInput({height: 25, width: 63, disabled: true, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 0});
		$("#rc" + h + "_variant").jqxNumberInput({height: 25, width: 63, disabled: true, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 0});
		$("#rc" + h + "_modbox").jqxInput({placeHolder: "Enter Mod id...", height: 25, width: 210, minLength: 1, items: 30, searchMode: 'contains', source: MC.Suggest.modid});
		$("#rc" + h + "_itembox").jqxInput({placeHolder: "Enter Item id...", height: 25, width: 220, minLength: 1, items: 30, searchMode: 'contains', source: Object.keys(MC.Suggest.itemid)});
		$("#rc" + h + "_itemboxlbl").jqxInput({placeHolder: "Enter Item name...", height: 25, width: 210, minLength: 1, items: 30, searchMode: 'contains', source: MC.Suggest.itemlabel});
		$("#rc" + h + "_modbox").on('change', function (event) {
			/*var id = event.target.id.split("_modbox")[0].split("rc")[1];
			var value = $("#rc" + id + "_modbox0").val();
			if ( value.isEmpty() ) {$("#rc" + id + "_itembox0").jqxInput({source: MC.ItemNames});}
			else if ( MC.Mod[value] != null ) {$("#rc" + id + "_itembox0").jqxInput({source: Object.keys(MC.Mod[value].items)});}
			else{$("#rc" + id + "_itembox0").jqxInput({source: []});}*/
		});
	}

	$('#receiptwindow_okButton').jqxButton({ width: '180px', disabled: false });
		
	MC.go.Mod("");
});

