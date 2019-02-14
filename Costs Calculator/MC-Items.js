var MC = {
	Items: {},
	Mods: {},
	Mod: {},
	Traders: [],
	Suggest: {
		groups: [],
		comment1: [],
		comment2: [],
		comment3: []
	},
	viewing: {
		Mod: "",
		Item: ""
	},
	item_selecting: false,
	createModList: function(){
		$.each(MC.Mods, function (modid, mod) {
			MC.Mods[modid].itemid = [];
			MC.Mods[modid].itemlabel = [];
			if(MC.Mod[mod.name] != null){
				MC.Mod[mod.name].idname.push(modid);
			}
			else{
				MC.Mod[mod.name] = {idname:[modid], crafter:mod.crafter, items:{}}
			}
			$.each(MC.Items[mod.crafter], function (itemid, item) {
				var temp = itemid.split("_b_")[0].split("_jj_")[1];
				if ( itemid.startsWith((modid + "_")) ) {
					MC.Mod[mod.name].items[itemid] = MC.Items[mod.crafter][itemid]
					MC.Mods[modid].itemid.push(temp)
					if(item.label != ""){
						MC.Mods[modid].itemlabel.push(item.label)
					}
				}
			});
		});
	},
	createLabelSource: function(modid){
		MC.Mods[modid].itemlabel = [];
		$.each(MC.Items[MC.Mods[modid].crafter], function (itemid, item) {
			if ( itemid.startsWith((modid + "_")) ) {
				if(item.label != ""){
					MC.Mods[modid].itemlabel.push(item.label)
				}
			}
		});
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
	convertItemID: function(item){
		var tempname = item.split("_b_")[0]
		var citem = {modid: tempname.split("_jj_")[0], itemid: tempname.split("_jj_")[1], dmg: 0, variant: 0, valid: false, crafter: "", tag:"", maxdmg: 0, maxvariant: 0}
		if(tempname.split("_jj_")[2] != null){citem.dmg = parseInt(tempname.split("_jj_")[2])}
		if(item.split("_b_")[1] != null){citem.variant = parseInt(item.split("_b_")[1])}
		if(MC.Mods[citem.modid] != null){
			citem.crafter = MC.Mods[citem.modid].crafter;
			if(MC.Items[citem.crafter][item] != null){
				citem.valid = true;
				$.each(Object.keys(MC.Items[citem.crafter]), function (index, name) {
					if ( name.startsWith(citem.modid + "_jj_" + citem.itemid) ) {
						var tempdmg = name.split("_b_")[0].split("_jj_")[2];
						if(tempdmg != null){
							if(parseInt(tempdmg) > citem.maxdmg){
								citem.maxdmg = parseInt(tempdmg)
							}
						}
						if(name.split("_b_")[1] != null){
							if(parseInt(name.split("_b_")[1]) > citem.maxvariant){
								citem.maxvariant = parseInt(name.split("_b_")[1])
							}
						}					
					}
				});
			}
		}
		return citem
	},
	convertCItemtoID: function(citem){
		var item = citem.modid + "_jj_" + citem.itemid
		if(citem.dmg > 0){item = item + "_jj_" + citem.dmg}
		if(citem.variant > 0){item = item + "_b_" + citem.variant}
		return item
	},
	checkItem: function(citem){
		return MC.convertItemID(MC.convertCItemtoID(citem)).valid
	},
	hide: function(div_name){
		$("#" + div_name).css({visibility: "hidden", display: "none"});
	},
	show: function(div_name, typ){
		if(typ==null){ typ = "block" }
		$("#" + div_name).css({visibility: "visible", display: typ});
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
				MC.hide("itemdmg_line") 
			}
			else{ 
				MC.show("itemdmg_line", "table-row")
			}
			$("#itemvariant_display").text(temp_itemvariant);
			if(temp_itemvariant == ""){ 
				MC.hide("itemvariant_line") 
			}
			else{ 
				MC.show("itemvariant_line", "table-row")
			}
			$("#itemtag_display").text(MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].tag);
			if(MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].tag == ""){ 
				MC.hide("itemtag_line") 
			}
			else{ 
				MC.show("itemtag_line", "table-row")
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
			
			$('#rc_craftcount').jqxNumberInput('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].craftCount);
			var temp_counter = 0;
			$.each(MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].recipe, function (itemid, item) {
				MC.show("rc" + temp_counter + "_group0", "table-row");
				MC.show("rc" + temp_counter + "_group1", "table-row");
				$("#rc" + temp_counter + "_need").jqxNumberInput("val", item.need);
				var temp_citem = MC.convertItemID(itemid);
				$("#rc" + temp_counter + "_dmg").jqxNumberInput({disabled: (!(temp_citem.maxdmg > 0)), max: temp_citem.maxdmg});
				$("#rc" + temp_counter + "_dmg").jqxNumberInput("val", temp_citem.dmg);
				$("#rc" + temp_counter + "_variant").jqxNumberInput({disabled: (!(temp_citem.maxvariant > 0)), max: temp_citem.maxvariant});
				$("#rc" + temp_counter + "_variant").jqxNumberInput("val", temp_citem.variant);
				$("#rc" + temp_counter + "_modbox").jqxInput("val", temp_citem.modid);
				$("#rc" + temp_counter + "_itembox").jqxInput("val", temp_citem.itemid);
				if(temp_citem.valid){
					$("#rc" + temp_counter + "_itembox").jqxInput({source: MC.Mods[temp_citem.modid].itemid});
					$("#rc" + temp_counter + "_itemboxlbl").jqxInput({source: MC.Mods[temp_citem.modid].itemlabel});
					$("#rc" + temp_counter + "_itemboxlbl").jqxInput("val", MC.Items[temp_citem.crafter][itemid].label);
				}
				else{
					$("#rc" + temp_counter + "_itembox").jqxInput({source: []});
					$("#rc" + temp_counter + "_itemboxlbl").jqxInput({source: []});
					$("#rc" + temp_counter + "_itemboxlbl").jqxInput("val", "");
				}
				temp_counter += 1;
			});
			for(var i = temp_counter; i < 9; i++){
				$("#rc" + i + "_dmg").jqxNumberInput({disabled: true});
				$("#rc" + i + "_variant").jqxNumberInput({disabled: true});
				$("#rc" + i + "_dmg").jqxNumberInput("val", "0");
				$("#rc" + i + "_variant").jqxNumberInput("val", "0");
				$("#rc" + i + "_need").jqxNumberInput("val", "1");
				$("#rc" + i + "_modbox").jqxInput("val", "");
				$("#rc" + i + "_itembox").jqxInput("val", "");
				$("#rc" + i + "_itemboxlbl").jqxInput("val", "");
				$("#rc" + i + "_itembox").jqxInput({source: []});
				$("#rc" + i + "_itemboxlbl").jqxInput({source: []});
				MC.hide("rc" + i + "_group0");
				MC.hide("rc" + i + "_group1");
			}
			MC.show("rc" + temp_counter + "_group0", "table-row");
			MC.show("rc" + temp_counter + "_group1", "table-row");
		}
	}
}

$(document).ready(function () {
	MC.createModList();
	MC.createItemSource();
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
		MC.createLabelSource(MC.viewing.Item.split("_jj_")[0])
		$('#itemgroup_input').jqxInput('source', MC.Suggest.groups);
		$('#itemcomment1_input').jqxInput('source', MC.Suggest.comment1);
		$('#itemcomment2_input').jqxInput('source', MC.Suggest.comment2);
		$('#itemcomment3_input').jqxInput('source', MC.Suggest.comment3);
		$("#itemListBox").jqxListBox('selectItem', temp_item);
	});
	$("#rc_craftcount").jqxNumberInput({height: 25, width: 63, disabled: false, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 1, max: 64});
	for (var h = 0; h < 9; h++){
		$("#rc" + h + "_need").jqxNumberInput({height: 25, width: 63, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 1, max: 9});
		$("#rc" + h + "_dmg").jqxNumberInput({height: 25, width: 63, disabled: true, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 0});
		$("#rc" + h + "_variant").jqxNumberInput({height: 25, width: 63, disabled: true, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 0});
		$("#rc" + h + "_modbox").jqxInput({placeHolder: "Enter Mod id...", height: 25, width: 210, minLength: 1, items: 30, searchMode: 'contains', source: Object.keys(MC.Mods)});
		$("#rc" + h + "_itembox").jqxInput({placeHolder: "Enter Item id...", height: 25, width: 220, minLength: 1, items: 30, searchMode: 'contains', source: []});
		$("#rc" + h + "_itemboxlbl").jqxInput({placeHolder: "Enter Item name...", height: 25, width: 210, minLength: 1, items: 30, searchMode: 'contains', source: []});
		$("#rc" + h + "_modbox").on('change', function (event) {
			if(!MC.item_selecting){
				var id = event.target.id.split("_modbox")[0].split("rc")[1];
				var value = $("#rc" + id + "_modbox").val();
				if(value.equals.Object.keys(MC.Mods)){
					$("#rc" + id + "_itembox").jqxInput({source: MC.Mods[value].itemid});
					$("#rc" + id + "_itemboxlbl").jqxInput({source: MC.Mods[value].itemlabel});
				}
				else{
					$("#rc" + id + "_itembox").jqxInput({source: []});
					$("#rc" + id + "_itemboxlbl").jqxInput({source: []});
				}
				
			}
			/*if ( value.isEmpty() ) {$("#rc" + id + "_itembox0").jqxInput({source: MC.ItemNames});}
			else if ( MC.Mod[value] != null ) {$("#rc" + id + "_itembox0").jqxInput({source: Object.keys(MC.Mod[value].items)});}
			else{$("#rc" + id + "_itembox0").jqxInput({source: []});}*/
		});
	}

	$('#receiptwindow_okButton').jqxButton({ width: '180px', disabled: false });
		
	MC.go.Mod("");
});

