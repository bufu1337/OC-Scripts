var MC = {
	Items: {},
	CItems: {},
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
	rv_rules: [],
	item_selecting: false,
	valid_recipe: false,
	recipe_show: [],
	setChangedRecipes: function(modid){
		console.log("Setting Changed Recipes")
		$.each(Object.keys(MC.Items[MC.Mods[modid].crafter]), function (i, itemid) {
			if ( itemid.startsWith(modid) ) {
				MC.CItems[MC.Mods[modid].name][itemid] = MC.convertItemID(itemid, true, true)
			}
		});
		console.log("Set Changed Recipes finished")
	},
	changeRecipeItem: function(modid, item, newitem){
		$.each(Object.keys(MC.Items[MC.Mods[modid].crafter]), function (i, itemid) {
			if ( itemid.startsWith(modid) ) {
				if ( MC.Items[MC.Mods[modid].crafter][itemid].recipe[item] ) {
					var temp = MC.Items[MC.Mods[modid].crafter][itemid].recipe[item].Copy()
					MC.Items[MC.Mods[modid].crafter][itemid].recipe = MC.Items[MC.Mods[modid].crafter][itemid].recipe.Copy(item)
					MC.Items[MC.Mods[modid].crafter][itemid].recipe[newitem] = temp.Copy()
					MC.CItems[MC.Mods[modid].name][itemid] = MC.convertItemID(itemid, true, true)
					console.log("Changed at item: " + itemid)
				}
			}
		});
	},
	createNewItems: function(items){
		$.each(items, function (i, item) {
			if ( !item.tag ) {
				item.tag = ""
			}
			var citem = MC.convertItemID(item.id)
			if ( citem.crafter == "" ) {
				if ( !item.crafter ) {
					console.log("Cant find crafter for item: " + item.id)
				}
				else{
					citem.crafter = item.crafter
				}
			}
			if ( citem.crafter != "" ) {
				MC.Items[citem.crafter][item.id] = {"bit":false,"buying":false,"c1":"","c2":"","c3":"","chisel":false,"craftCount":0,"fixedprice":false,"group":"","hasPattern":false,"label":"","maxCount":8,"price":0,"recipe":{},"selling":false,"tag":tag,"trader":0}
				MC.Mod[MC.Mods[citem.modid].name].items[item.id] = MC.Items[citem.crafter][item.id]
				MC.CItems[MC.Mods[citem.modid].name][item.id] = MC.convertItemID(itemid, true, true)
				if(!citem.itemid.equals(MC.Mods[modid].itemid)){
					MC.Mods[citem.modid][item.id].push(citem.itemid)
				}
			}
		});
		//{"bit":false,"buying":false,"c1":"","c2":"","c3":"","chisel":false,"craftCount":0,"fixedprice":false,"group":"","hasPattern":false,"label":"","maxCount":8,"price":0,"recipe":{},"selling":false,"tag":tag,"trader":0}
	},
	setForAll: function(what, items, newval){
		
	},
	createModList: function(modid){
		if ( modid != null && MC.Mods[modid] != null ) {
			MC.Mods[modid].itemid = [];
			MC.Mods[modid].itemlabel = [];
			console.log("Analyzing Mod: " + MC.Mods[modid].name)
			if(MC.Mod[MC.Mods[modid].name] != null){
				MC.Mod[MC.Mods[modid].name].idname.push(modid);
			}
			else{
				MC.Mod[MC.Mods[modid].name] = {idname:[modid], crafter:MC.Mods[modid].crafter, items:{}}
			}
			$.each(MC.Items[MC.Mods[modid].crafter], function (itemid, item) {
				var temp = itemid.split("_b_")[0].split("_jj_")[1];
				if ( itemid.startsWith((modid + "_")) ) {
					MC.Mod[MC.Mods[modid].name].items[itemid] = MC.Items[MC.Mods[modid].crafter][itemid]
					//MC.CItems[MC.Mods[modid].name][itemid] = MC.convertItemID(itemid, true, true)
					if ( !temp.equals(MC.Mods[modid].itemid) ) {
						MC.Mods[modid].itemid.push(temp)
					}
					if(item.label != ""){
						MC.Mods[modid].itemlabel.push(item.label)
					}
				}
			});
		}
		else{
			$.each(MC.Mods, function (modid, mod) {
				MC.createModList(modid);
			});
		}
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
	convertCItemtoID: function(citem){
		var item = citem.modid + "_jj_" + citem.itemid
		if(citem["dmg"] != null){if(citem.dmg > 0){item = item + "_jj_" + citem.dmg}}
		if(citem["variant"] != null){if(citem.variant > 0){item = item + "_b_" + citem.variant}}
		return item
	},
	convertItemID: function(item, rcheck, multi){
		var tempname = item.split("_b_")[0]
		var citem = {modid: tempname.split("_jj_")[0], itemid: tempname.split("_jj_")[1], dmg: 0, variant: 0, valid: false, valid_recipe: true, itemfull: "", crafter: "", tag:"", damages: ["0"], variants: ["0"]}
		if(tempname.split("_jj_")[2] != null){citem.dmg = parseInt(tempname.split("_jj_")[2])}
		if(item.split("_b_")[1] != null){citem.variant = parseInt(item.split("_b_")[1])}
		if(MC.Mods[citem.modid] != null){
			citem.crafter = MC.Mods[citem.modid].crafter;
			if(MC.Items[citem.crafter][item] != null){
				citem.valid = true;
				citem.itemfull = item
				if ( rcheck ) {
					$.each(Object.keys(MC.Items[citem.crafter][item].recipe), function (indexr, itemr) {
						if(MC.convertItemID(itemr, false, false).valid == false){
							citem.valid_recipe = false
							return
						}
					});
				}
				if ( multi ) {
					$.each(Object.keys(MC.Items[citem.crafter]), function (index, name) {
						if ( name.startsWith(citem.modid + "_jj_" + citem.itemid) ) {
							var tempdmg = name.split("_b_")[0].split("_jj_")[2];
							if(tempdmg != null){
								if(!tempdmg.equals(citem.damages)){
									citem.damages.push(tempdmg)
								}
							}
							if(name.split("_b_")[1] != null){
								if(!name.split("_b_")[1].equals(citem.variants)){
									citem.variants.push(name.split("_b_")[1])
								}
							}					
						}
					});
				}
			}
		}
		return citem
	},
	checkItem: function(citem){
		return MC.convertItemID(MC.convertCItemtoID(citem), false, true)
	},
	itemfilter: function () {
		var newitems = {}
		var filters = [ "filter_modid_input",
			"filter_itemid_input",
			"filter_dmg_input",
			"filter_tag_input",
			"filter_label_input",
			"filter_group_input",
			"filter_comment1_input",
			"filter_comment2_input",
			"filter_comment3_input",
			"filter_trader_input",
			"filter_fixedprice_check",
			"filter_pricefrom_numinput",
			"filter_validrecipe_check",
			"filter_selling_check",
			"filter_buying_check",
			"filter_chisel_check",
			"filter_bit_check",
			"filter_hasPattern_check"];
		var items = {};
		$.each(Object.keys(MC.Mod[MC.viewing.Mod].items), function (index, item) {
			items[item] = true
		});
		$.each(filters, function(i, filt) {
			var check = false;
			if ( filt.endsWith("_input") ) { check = ( $('#' + filt).val() != "" )}
			else if (filt.endsWith("_check")){ check = ( $('#' + filt).val() != null )}
			else if (filt.endsWith("filter_pricefrom_numinput")){ check = ( $('#' + filt).val() != "0" || $('#filter_priceto_numinput').val() != "0" )}
			if ( check ) {
				var id = filt.split("_")[1]
				$.each(Object.keys(MC.Mod[MC.viewing.Mod].items), function (index, item) {
					if ( items[item] ) {
						if ( id.equals(["modid","itemid","dmg"]) ) {
							if ( !MC.CItems[MC.viewing.Mod][item][id].contains($('#' + filt).val() ) ) {
								items[item] = false
							}
						}
						else if ( id == "validrecipe" ) {
							if ( MC.CItems[MC.viewing.Mod][item]["valid_recipe"] != ($('#' + filt).val())  ) {
								items[item] = false
							}
							if(Object.keys(MC.Mod[MC.viewing.Mod].items[item].recipe).length == 0){
								if ( ($('#' + filt).val() ) ) {
									items[item] = false
								}
								else{
									items[item] = true
								}
							}
						}
						else if( filt.endsWith("_input") ){
							if ( !MC.Mod[MC.viewing.Mod].items[item][id].contains($('#' + filt).val() ) ) {
								items[item] = false
							}
						}
						else if( filt.endsWith("_check") ){
							if ( MC.Mod[MC.viewing.Mod].items[item][id] != ($('#' + filt).val() ) ) {
								items[item] = false
							}
						}
						else if ( id == "pricefrom" ) {
							var tprice = MC.Mod[MC.viewing.Mod].items[item].price
							if ( tprice < (parseInt($('#' + filt).val()) || tprice > parseInt($('#filter_priceto_numinput').val())) ) {
								items[item] = false
							}
						}
					}
				});
			}
		});
		$.each(items, function (itemc, cc) {
			if ( cc ) { newitems[itemc] = MC.Mod[MC.viewing.Mod].items[itemc] }
		});
		MC.show("itemListBox");
		var itemssource = [];
		$.each(Object.keys(newitems), function (index, item) {
			//var pricecaption = newitems[item].count + " St. => " + newitems[item].price;
			//var pricecaption = newitems[item].count + " St. => " + newitems[item].price
			if ( newitems[item].price == 0 ) {
				pricecaption = "No";
			}
			else{
				pricecaption = newitems[item].price.toString()
			}
			var itemname = "";
			if (newitems[item].label != ""){
				itemname = newitems[item].label;
			}
			else{
				itemname = item.replace("_jj_", ":").replaceAll("_xx_", "/").replaceAll("_qq_", "-").replaceAll("_vv_", ".").replace("_b_", " Typ: ")
				if(itemname.contains("_jj_")){
					itemname = itemname.split("_jj_")[0] + " <b class='itemstyle3'>DMG:</b> " + itemname.split("_jj_")[1]
				}
			}
			var valid = ""
			if ( Object.keys(newitems[item].recipe).length == 0) {
				valid = " <b class='itemstyle4'>Recipe: No</b>"
			}
			else if(!MC.CItems[MC.viewing.Mod][item].valid_recipe){
				valid = " <b class='itemstyle4'>Recipe: Not valid</b>"
			}
			itemssource.push({html: "<b class='itemstyle'>Name:</b> " + itemname + valid + " <b class='itemstyle2'>Costs:</b> " + pricecaption, label: item, value: item, group: MC.Mod[MC.viewing.Mod].items[item].group});
		});
		$('#itemListBox').jqxListBox('source', itemssource);
		$('#itemListBox').jqxListBox('refresh');
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
				$('#contentSplitter').jqxSplitter('expand');
				$('#contentSplitter').jqxSplitter('expand');
				$('#itemDetailTabs').jqxTabs('select', 2);
				MC.viewing.Mod = modname;
				MC.viewing.Item = "";
				$('#itemHeader').html("<b class='headerstyle'>Mod-Name: </b>" + modname + " <b class='headerstyle'>Item-Count:</b> " + Object.keys(MC.Mod[modname].items).length);
				if ( Object.keys(MC.Mod[modname].items).length == 0) {
					MC.show("noitems");
				}
				else{
					MC.itemfilter();
				}
			}
		},
		Item: function(itemname){
			MC.item_selecting = true;
			console.log("Item Page - Mod ID: " + MC.viewing.Mod + " Item: " + itemname);
			MC.hide("cr_group");
			$("#cr_modbox").val("");
			$("#cr_itembox").val("");
			$("#cr_dmg").val("0");
			$("#cr_variant").val("0");
			if ( $('#itemDetailTabs').jqxTabs('selectedItem') == 2 ) {
				$('#itemDetailTabs').jqxTabs('select', 0);
			}
			MC.viewing.Item = itemname;	
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
			$("#itemgroup_input").jqxComboBox('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].group);
			$('#itemcomment1_input').jqxComboBox('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].c1);
			$('#itemcomment2_input').jqxComboBox('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].c2);
			$('#itemcomment3_input').jqxComboBox('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].c3);
			$.each($("#itemtrader_drop").jqxComboBox('getItems'), function (index, item) {
				if ( MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].trader == item.value ) {
					$("#itemtrader_drop").jqxComboBox('selectItem', item ); 
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
				MC.show("rc" + temp_counter + "_group", "table");
				$("#rc" + temp_counter + "_need").jqxNumberInput("val", item.need);
				var temp_citem = MC.convertItemID(itemid, false, true);
				if(temp_citem.valid){
					$("#rc" + temp_counter + "_itembox").jqxInput({source: MC.Mods[temp_citem.modid].itemid});
					$("#rc" + temp_counter + "_itemboxlbl").jqxInput({source: MC.Mods[temp_citem.modid].itemlabel});
					$("#rc" + temp_counter + "_itemboxlbl").val(MC.Items[temp_citem.crafter][itemid].label);
				}
				else{
					$("#rc" + temp_counter + "_itembox").jqxInput({source: []});
					$("#rc" + temp_counter + "_itemboxlbl").jqxInput({source: []});
					$("#rc" + temp_counter + "_itemboxlbl").val("");
				}
				console.log("setting 2 " + temp_counter + " to " + (!(temp_citem.damages.length > 1)))
				$("#rc" + temp_counter + "_dmg").jqxInput({disabled: (!(temp_citem.damages.length > 1)), source: temp_citem.damages});
				$("#rc" + temp_counter + "_dmg").val(temp_citem.dmg.toString());
				$("#rc" + temp_counter + "_variant").jqxInput({disabled: (!(temp_citem.variants.length > 1)), source: temp_citem.variants});
				$("#rc" + temp_counter + "_variant").val(temp_citem.variant.toString());
				$("#rc" + temp_counter + "_modbox").val(temp_citem.modid);
				$("#rc" + temp_counter + "_itembox").val(temp_citem.itemid);
				MC.recipe_show[temp_counter] = true
				temp_counter += 1;
			});
			for(var i = temp_counter; i < 9; i++){
				$("#rc" + i + "_dmg").jqxInput({disabled: true});
				$("#rc" + i + "_variant").jqxInput({disabled: true});
				$("#rc" + i + "_dmg").jqxInput("val", "0");
				$("#rc" + i + "_variant").jqxInput("val", "0");
				$("#rc" + i + "_need").jqxNumberInput("val", "1");
				$("#rc" + i + "_modbox").jqxInput("val", "");
				$("#rc" + i + "_itembox").jqxInput({source: []});
				$("#rc" + i + "_itemboxlbl").jqxInput({source: []});
				$("#rc" + i + "_itembox").jqxInput("val", "");
				$("#rc" + i + "_itemboxlbl").jqxInput("val", "");
				MC.hide("rc" + i + "_group");
				MC.recipe_show[i] = false
			}
			MC.show("rc" + temp_counter + "_group", "table");
			MC.recipe_show[temp_counter] = true
			MC.item_selecting = false;
			if($('#itemDetailTabs').jqxTabs('selectedItem') == 1){
				$('#recipeValidator').jqxValidator('validate');
			}
		}
	}
}

$(document).ready(function () {
	MC.createModList();
	MC.createItemSource();
	$("#btnSave").jqxButton({ width: 48, height: 48, imgWidth: 48, imgHeight: 48, imgPosition: "left", textPosition: "center", imgSrc: "save-js.png", textImageRelation: "overlay" });
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
	$("#btnSaveConvert").jqxButton({ width: 48, height: 48, imgWidth: 48, imgHeight: 48, imgPosition: "left", textPosition: "center", imgSrc: "save-convert.png", textImageRelation: "overlay" });
	$('#btnSaveConvert').on('click', function () {
		if ('Blob' in window) {
			var fileName = 'MC-CItems.js';
			var JStextToWrite = "MC.CItems = {\n"
			var objKeys = {}
			objKeys.main = Object.keys(MC.CItems)
			for(var i = 0; i < objKeys.main.length; i++) {
				JStextToWrite += "  " + JSON.stringify(objKeys.main[i]) + ":{\n";
				objKeys[objKeys.main[i]] = Object.keys(MC.CItems[objKeys.main[i]]);
				for(var j = 0; j < objKeys[objKeys.main[i]].length; j++) {
					JStextToWrite += "    " + JSON.stringify(objKeys[objKeys.main[i]][j]) + ":" + JSON.stringify(MC.CItems[objKeys.main[i]][objKeys[objKeys.main[i]][j]])
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
	$("#btnSaveLUA").jqxButton({ width: 48, height: 48, imgWidth: 48, imgHeight: 48, imgPosition: "left", textPosition: "center", imgSrc: "save-lua.png", textImageRelation: "overlay" });
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
		if(MC.viewing.Item == "" && MC.viewing.Mod == ""){
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
			$('#itemListBox').jqxListBox({ filterable: true, searchMode: 'contains', filterPlaceHolder: "Suche...", source: ['No mod selected! Please Select a mod first!'], width: '100%', height: 896 });
		}
	});
	$("#itemDetailExpander").jqxExpander({ toggleMode: 'none', showArrow: false, width: "100%", height: "100%", 
		initContent: function () {
			$('#itemDetailTabs').jqxTabs({  width: '100%', height: '100%', position: 'top', selectedItem: 2 });
		}
	});
	$('#itemDetailTabs').on('selected', function (event) {
		if ( MC.viewing.Item == "" ) {
			$('#itemDetailTabs').jqxTabs('select', 2);
		}
		else{
			if ( event.args.item == 1 ) {
				$('#recipeValidator').jqxValidator('validate');
			}
		}
	}); 
	$('#modListBox').on('select', function (event) {
		MC.go.Mod($('#modListBox').jqxListBox('getSelectedItem').label);
	});
	$('#itemListBox').on('select', function (event) {
		MC.go.Item($('#itemListBox').jqxListBox('getSelectedItem').label);
	});
	
	$("#itemlabel_input").jqxInput({placeHolder: "Enter a name...", height: 25, width: 300, minLength: 1});
	$("#itemgroup_input").jqxComboBox({source: MC.Suggest.groups, placeHolder: "Enter a group...", height: 25, width: 307, minLength: 1, items: 20});
	$('#itemcomment1_input').jqxComboBox({source: MC.Suggest.comment1, placeHolder: "Enter a comment...", height: 25, width: 307, minLength: 1, items: 20 });
	$('#itemcomment2_input').jqxComboBox({source: MC.Suggest.comment2, placeHolder: "Enter a comment...", height: 25, width: 307, minLength: 1, items: 20 });
	$('#itemcomment3_input').jqxComboBox({source: MC.Suggest.comment3, placeHolder: "Enter a comment...", height: 25, width: 307, minLength: 1, items: 20 });
	$("#itemtrader_drop").jqxComboBox({source: MC.Traders, placeHolder: "Enter a trader...", height: 25, width: 307});
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
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].label = $("#itemlabel_input").val();
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].buying = $("#itembuying_check").jqxCheckBox('checked'),
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].bit = $("#itembit_check").jqxCheckBox('checked');
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].c1 = $('#itemcomment1_input').val();
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].c2 = $('#itemcomment2_input').val();
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].c3 = $('#itemcomment3_input').val();
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].chisel = $("#itemchisel_check").jqxCheckBox('checked');
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].fixedprice = $("#itemfixedprice_check").jqxCheckBox('checked');
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].group = $('#itemgroup_input').val();
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].price = parseInt($('#itemprice_input').val());
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].selling = $("#itemselling_check").jqxCheckBox('checked');
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].trader = $("#itemtrader_drop").val();
		//MC.go.ModList();
		MC.item_selecting = true;
		MC.createLabelSource(MC.viewing.Item.split("_jj_")[0]);
		var temp_item = $("#itemListBox").jqxListBox('getSelectedItem');
		$.each($("#modListBox").jqxListBox('getItems'), function (index, value) {
			if ( MC.viewing.Mod.equals(value.label) ) {
				$("#modListBox").jqxListBox('unselectIndex', value.index);
				$("#modListBox").jqxListBox('selectIndex', value.index);
			}
		});
		$('#itemDetailTabs').jqxTabs('select', 0);
		MC.createItemSource();
		$('#itemgroup_input').jqxInput('source', MC.Suggest.groups);
		$('#itemcomment1_input').jqxInput('source', MC.Suggest.comment1);
		$('#itemcomment2_input').jqxInput('source', MC.Suggest.comment2);
		$('#itemcomment3_input').jqxInput('source', MC.Suggest.comment3);
		$("#itemListBox").jqxListBox('selectItem', temp_item);
		MC.item_selecting = false;
	});
	
	
	$("#filter_modid_input").jqxInput({placeHolder: "ModID contains...", height: 25, width: 300, minLength: 1});
	$("#filter_itemid_input").jqxInput({placeHolder: "ItemID contains...", height: 25, width: 300, minLength: 1});
	$("#filter_dmg_input").jqxInput({placeHolder: "Enter a damage...", height: 25, width: 300, minLength: 1});
	$("#filter_tag_input").jqxInput({placeHolder: "Tag contains...", height: 25, width: 300, minLength: 1});
	$("#filter_label_input").jqxInput({placeHolder: "Label contains...", height: 25, width: 300, minLength: 1});
	$("#filter_group_input").jqxComboBox({source: MC.Suggest.groups, placeHolder: "Enter groups...", height: 25, width: 307, minLength: 1, multiSelect: true, searchMode: 'contains'});
	$('#filter_comment1_input').jqxComboBox({source: MC.Suggest.comment1, placeHolder: "Enter comments...", height: 25, width: 307, minLength: 1, multiSelect: true, searchMode: 'contains' });
	$('#filter_comment2_input').jqxComboBox({source: MC.Suggest.comment2, placeHolder: "Enter comments...", height: 25, width: 307, minLength: 1, multiSelect: true, searchMode: 'contains' });
	$('#filter_comment3_input').jqxComboBox({source: MC.Suggest.comment3, placeHolder: "Enter comments...", height: 25, width: 307, minLength: 1, multiSelect: true, searchMode: 'contains' });
	$("#filter_trader_input").jqxComboBox({source: MC.Traders, placeHolder: "Enter traders...", height: 25, width: 307, minLength: 1, multiSelect: true, searchMode: 'contains'});
	$("#filter_selling_check").jqxCheckBox({height: 25, width: 50, hasThreeStates: true, checked: null});
	$("#filter_buying_check").jqxCheckBox({height: 25, width: 50, hasThreeStates: true, checked: null});
	$("#filter_chisel_check").jqxCheckBox({height: 25, width: 70, hasThreeStates: true, checked: null});
	$("#filter_bit_check").jqxCheckBox({height: 25, width: 50, hasThreeStates: true, checked: null});
	$("#filter_hasPattern_check").jqxCheckBox({height: 25, width: 100, hasThreeStates: true, checked: null});
	$("#filter_validrecipe_check").jqxCheckBox({height: 25, width: 100, hasThreeStates: true, checked: null});
	$("#filter_fixedprice_check").jqxCheckBox({height: 25, width: 100, hasThreeStates: true, checked: null});
	$("#filter_pricefrom_numinput").jqxNumberInput({height: 25, width: 60, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 0});
	$("#filter_priceto_numinput").jqxNumberInput({height: 25, width: 60, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 0, max: 6400});
	$('#filter_okButton').jqxButton({ width: '180px', disabled: false });
	$('#filter_okButton').on('click', MC.itemfilter);
	$('#filter_clearButton').jqxButton({ width: '180px', disabled: false });
	$('#filter_clearButton').on('click', function(){
		$("#filter_modid_input").val("");
		$("#filter_itemid_input").val("");
		$("#filter_dmg_input").val("");
		$("#filter_tag_input").val("");
		$("#filter_label_input").val("");
		$("#filter_group_input").val("");
		$('#filter_comment1_input').val("");
		$('#filter_comment2_input').val("");
		$('#filter_comment3_input').val("");
		$("#filter_trader_input").val("");
		$("#filter_selling_check").jqxCheckBox({checked: null});
		$("#filter_buying_check").jqxCheckBox({checked: null});
		$("#filter_chisel_check").jqxCheckBox({checked: null});
		$("#filter_bit_check").jqxCheckBox({checked: null});
		$("#filter_hasPattern_check").jqxCheckBox({checked: null});
		$("#filter_validrecipe_check").jqxCheckBox({checked: null});
		$("#filter_fixedprice_check").jqxCheckBox({checked: null});
		$("#filter_pricefrom_numinput").val("0");
		$("#filter_priceto_numinput").val("0");
			
		MC.itemfilter();
	});
	
	$("#rc_craftcount").jqxNumberInput({height: 25, width: 63, disabled: false, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 1, max: 64});
	for (var h = 0; h < 9; h++){
		$("#rc" + h + "_need").jqxNumberInput({height: 25, width: 63, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 1, max: 9});
		$("#rc" + h + "_dmg").jqxInput({height: 25, width: 63, disabled: true, minLength: 0, items: 30, searchMode: 'contains'});
		$("#rc" + h + "_variant").jqxInput({height: 25, width: 63, disabled: true, minLength: 0, items: 30, searchMode: 'contains'});
		$("#rc" + h + "_modbox").jqxInput({placeHolder: "Enter ModID...", height: 25, width: 210, minLength: 1, items: 30, searchMode: 'contains', source: Object.keys(MC.Mods)});
		$("#rc" + h + "_itembox").jqxInput({placeHolder: "Enter ItemID...", height: 25, width: 220, minLength: 1, items: 30, searchMode: 'contains', source: []});
		$("#rc" + h + "_itemboxlbl").jqxInput({placeHolder: "Enter Item name...", height: 25, width: 210, minLength: 1, items: 30, searchMode: 'contains', source: []});
		$("#rc" + h + "_modbox").on('change', function (event) {
			if(!MC.item_selecting){
				var id = event.target.id.split("_modbox")[0].split("rc")[1];
				var valmod = $("#rc" + id + "_modbox").val();
				var valitem = $("#rc" + id + "_itembox").val();
				if(valmod.equals(Object.keys(MC.Mods))){
					$("#rc" + id + "_itembox").jqxInput({source: MC.Mods[valmod].itemid});
					$("#rc" + id + "_itemboxlbl").jqxInput({source: MC.Mods[valmod].itemlabel});
				}
				else{
					$("#rc" + id + "_itembox").jqxInput({source: []});
					$("#rc" + id + "_itemboxlbl").jqxInput({source: []});
				}
				if(valmod != "" && valitem != ""){
					$('#recipeValidator').jqxValidator('validate');
				}
			}
		});
		$("#rc" + h + "_itembox").on('change', function (event) {
			if(!MC.item_selecting){
				var id = event.target.id.split("_itembox")[0].split("rc")[1];
				console.log("ID: " + id)
				var valmod = $("#rc" + id + "_modbox").val();
				var valitem = $("#rc" + id + "_itembox").val();
				if(valmod != "" && valitem != ""){
					$('#recipeValidator').jqxValidator('validate');
				}
			}
		});
		$("#rc" + h + "_itemboxlbl").on('change', function (event) {
			if(!MC.item_selecting){
				var id = event.target.id.split("_itemboxlbl")[0].split("rc")[1];
				var valmod = $("#rc" + id + "_modbox").val();
				var valitem = $("#rc" + id + "_itembox").val();
				if(valmod != "" && valitem != ""){
					$('#recipeValidator').jqxValidator('validate');
				}
			}
		});
		$("#rc" + h + "_dmg").on('change', function (event) {
			if(!MC.item_selecting){
				$('#recipeValidator').jqxValidator('validate');
			}
		});
		$("#rc" + h + "_variant").on('change', function (event) {
			if(!MC.item_selecting){
				$('#recipeValidator').jqxValidator('validate');
			}
		});
	}
					
	$('#recipeValidator').jqxValidator({
		position: 'topcenter',
		hintType : 'label',
 		rules: [
			{ input: "#rc0_modbox", message: 'mod-id not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; if ( input == "" ) {return true} return input.equals(Object.keys(MC.Mods)) }},
			{ input: "#rc0_itembox", message: 'item not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; var valmod = $("#rc0_modbox").val(); if ( input == "" ) {return true} if ( valmod == "" ) {return false} if ( !valmod.equals(Object.keys(MC.Mods)) ) {return false} return input.equals(MC.Mods[valmod].itemid) }},
			{ input: "#rc0_itemboxlbl", message: 'item label not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; var valmod = $("#rc0_modbox").val(); if ( input == "" ) {return true} if ( valmod == "" ) {return false} if ( !valmod.equals(Object.keys(MC.Mods)) ) {return false} return input.equals(MC.Mods[valmod].itemlabel) }},
			{ input: "#rc1_modbox", message: 'mod-id not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; if ( input == "" ) {return true} return input.equals(Object.keys(MC.Mods)) }},
			{ input: "#rc1_itembox", message: 'item not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; var valmod = $("#rc1_modbox").val(); if ( input == "" ) {return true} if ( valmod == "" ) {return false} if ( !valmod.equals(Object.keys(MC.Mods)) ) {return false} return input.equals(MC.Mods[valmod].itemid) }},
			{ input: "#rc1_itemboxlbl", message: 'item label not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; var valmod = $("#rc1_modbox").val(); if ( input == "" ) {return true} if ( valmod == "" ) {return false} if ( !valmod.equals(Object.keys(MC.Mods)) ) {return false} return input.equals(MC.Mods[valmod].itemlabel) }},
			{ input: "#rc2_modbox", message: 'mod-id not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; if ( input == "" ) {return true} return input.equals(Object.keys(MC.Mods)) }},
			{ input: "#rc2_itembox", message: 'item not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; var valmod = $("#rc2_modbox").val(); if ( input == "" ) {return true} if ( valmod == "" ) {return false} if ( !valmod.equals(Object.keys(MC.Mods)) ) {return false} return input.equals(MC.Mods[valmod].itemid) }},
			{ input: "#rc2_itemboxlbl", message: 'item label not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; var valmod = $("#rc2_modbox").val(); if ( input == "" ) {return true} if ( valmod == "" ) {return false} if ( !valmod.equals(Object.keys(MC.Mods)) ) {return false} return input.equals(MC.Mods[valmod].itemlabel) }},
			{ input: "#rc3_modbox", message: 'mod-id not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; if ( input == "" ) {return true} return input.equals(Object.keys(MC.Mods)) }},
			{ input: "#rc3_itembox", message: 'item not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; var valmod = $("#rc3_modbox").val(); if ( input == "" ) {return true} if ( valmod == "" ) {return false} if ( !valmod.equals(Object.keys(MC.Mods)) ) {return false} return input.equals(MC.Mods[valmod].itemid) }},
			{ input: "#rc3_itemboxlbl", message: 'item label not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; var valmod = $("#rc3_modbox").val(); if ( input == "" ) {return true} if ( valmod == "" ) {return false} if ( !valmod.equals(Object.keys(MC.Mods)) ) {return false} return input.equals(MC.Mods[valmod].itemlabel) }},
			{ input: "#rc4_modbox", message: 'mod-id not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; if ( input == "" ) {return true} return input.equals(Object.keys(MC.Mods)) }},
			{ input: "#rc4_itembox", message: 'item not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; var valmod = $("#rc4_modbox").val(); if ( input == "" ) {return true} if ( valmod == "" ) {return false} if ( !valmod.equals(Object.keys(MC.Mods)) ) {return false} return input.equals(MC.Mods[valmod].itemid) }},
			{ input: "#rc4_itemboxlbl", message: 'item label not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; var valmod = $("#rc4_modbox").val(); if ( input == "" ) {return true} if ( valmod == "" ) {return false} if ( !valmod.equals(Object.keys(MC.Mods)) ) {return false} return input.equals(MC.Mods[valmod].itemlabel) }},
			{ input: "#rc5_modbox", message: 'mod-id not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; if ( input == "" ) {return true} return input.equals(Object.keys(MC.Mods)) }},
			{ input: "#rc5_itembox", message: 'item not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; var valmod = $("#rc5_modbox").val(); if ( input == "" ) {return true} if ( valmod == "" ) {return false} if ( !valmod.equals(Object.keys(MC.Mods)) ) {return false} return input.equals(MC.Mods[valmod].itemid) }},
			{ input: "#rc5_itemboxlbl", message: 'item label not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; var valmod = $("#rc5_modbox").val(); if ( input == "" ) {return true} if ( valmod == "" ) {return false} if ( !valmod.equals(Object.keys(MC.Mods)) ) {return false} return input.equals(MC.Mods[valmod].itemlabel) }},
			{ input: "#rc6_modbox", message: 'mod-id not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; if ( input == "" ) {return true} return input.equals(Object.keys(MC.Mods)) }},
			{ input: "#rc6_itembox", message: 'item not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; var valmod = $("#rc6_modbox").val(); if ( input == "" ) {return true} if ( valmod == "" ) {return false} if ( !valmod.equals(Object.keys(MC.Mods)) ) {return false} return input.equals(MC.Mods[valmod].itemid) }},
			{ input: "#rc6_itemboxlbl", message: 'item label not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; var valmod = $("#rc6_modbox").val(); if ( input == "" ) {return true} if ( valmod == "" ) {return false} if ( !valmod.equals(Object.keys(MC.Mods)) ) {return false} return input.equals(MC.Mods[valmod].itemlabel) }},
			{ input: "#rc7_modbox", message: 'mod-id not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; if ( input == "" ) {return true} return input.equals(Object.keys(MC.Mods)) }},
			{ input: "#rc7_itembox", message: 'item not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; var valmod = $("#rc7_modbox").val(); if ( input == "" ) {return true} if ( valmod == "" ) {return false} if ( !valmod.equals(Object.keys(MC.Mods)) ) {return false} return input.equals(MC.Mods[valmod].itemid) }},
			{ input: "#rc7_itemboxlbl", message: 'item label not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; var valmod = $("#rc7_modbox").val(); if ( input == "" ) {return true} if ( valmod == "" ) {return false} if ( !valmod.equals(Object.keys(MC.Mods)) ) {return false} return input.equals(MC.Mods[valmod].itemlabel) }},
			{ input: "#rc8_modbox", message: 'mod-id not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; if ( input == "" ) {return true} return input.equals(Object.keys(MC.Mods)) }},
			{ input: "#rc8_itembox", message: 'item not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; var valmod = $("#rc8_modbox").val(); if ( input == "" ) {return true} if ( valmod == "" ) {return false} if ( !valmod.equals(Object.keys(MC.Mods)) ) {return false} return input.equals(MC.Mods[valmod].itemid) }},
			{ input: "#rc8_itemboxlbl", message: 'item label not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; var valmod = $("#rc8_modbox").val(); if ( input == "" ) {return true} if ( valmod == "" ) {return false} if ( !valmod.equals(Object.keys(MC.Mods)) ) {return false} return input.equals(MC.Mods[valmod].itemlabel) }}
		]
	});
	$('#recipeValidator').on('validationSuccess', function(event) { 
		var boollist_valid = [];
		var boollist_show = [];
		for (var i = 0; i < 9; i++){
			if ( MC.recipe_show[i] ) {
				boollist_show.push(true)
				var valmod = $("#rc" + i + "_modbox").val();
				var valitem = $("#rc" + i + "_itembox").val();
				if(valmod != "" && valitem != ""){
					var temp_item = MC.checkItem({modid:valmod, itemid:valitem, dmg: $("#rc" + i + "_dmg").val(), variant: $("#rc" + i + "_variant").val()})
					if ( temp_item.valid ) {
						boollist_valid.push(true)
						MC.item_selecting = true
						$("#rc" + i + "_itemboxlbl").val(MC.Items[temp_item.crafter][temp_item.itemfull].label);
						$("#rc" + i + "_dmg").jqxInput({disabled: (!(temp_item.damages.length > 1)), source: temp_item.damages});
						//console.log("setting " + i + " to " + (!(temp_item.damages.length > 1)))
						$("#rc" + i + "_variant").jqxInput({disabled: (!(temp_item.variants.length > 1)), source: temp_item.variants});
						$("#rc" + i + "_dmg").val(temp_item.dmg.toString());
						$("#rc" + i + "_variant").val(temp_item.variant.toString());
						MC.item_selecting = false
					}
					else{
						boollist_valid.push(false)
					}
				}
			}
		}
		MC.valid_recipe = boollist_valid.isBoolListTrue();
		if ( MC.valid_recipe && boollist_show.length == boollist_valid.length ) {
			MC.show("rc" + boollist_show.length + "_group", "table");
			MC.recipe_show[boollist_show.length] = true
		}
	});
	$('#recipeValidator').on('validationError', function(event) { MC.valid_recipe = false; });
	$('#recipe_okButton').jqxButton({ width: '180px', disabled: false });
	$('#recipe_okButton').on('click', function () {
		$('#recipeValidator').jqxValidator('validate');
		if(MC.valid_recipe){
			MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].craftCount = parseInt($("#rc_craftcount").val())
			MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].recipe = {}
			MC.CItems[MC.viewing.Mod][MC.viewing.Item].valid_recipe = true
			for (var i = 0; i < 9; i++){
				if ( MC.recipe_show[i] ) {
					var valmod = $("#rc" + i + "_modbox").val();
					var valitem = $("#rc" + i + "_itembox").val();
					if(valmod != "" && valitem != ""){
						var temp_item = MC.checkItem({modid:valmod, itemid:valitem, dmg: $("#rc" + i + "_dmg").val(), variant: $("#rc" + i + "_variant").val()})
						MC.Items[temp_item.crafter][temp_item.itemfull].label = $("#rc" + i + "_itemboxlbl").val()
						MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].recipe[temp_item.itemfull] = {need: parseInt($("#rc" + i + "_need").val()), tag: MC.Items[temp_item.crafter][temp_item.itemfull].tag}
					}
				}
			}
			$("#recipe_message")[0].style.color = "green"
			$("#recipe_message")[0].innerHTML = "Recipe written successfully!!!"
			MC.show("recipe_message");
			setInterval(function(){ MC.hide("recipe_message") }, 10000);
		}
		else{
			var boollist_valid = [];
			for (var i = 0; i < 9; i++){
				if ( MC.recipe_show[i] ) {
					var valmod = $("#rc" + i + "_modbox").val();
					var valitem = $("#rc" + i + "_itembox").val();
					if(valmod != "" && valitem != ""){
						var temp_item = MC.convertItemID(MC.convertCItemtoID({modid:valmod, itemid:valitem, dmg: $("#rc" + i + "_dmg").val(), variant: $("#rc" + i + "_variant").val()}), false, false)
						if ( temp_item.valid ) {
							boollist_valid.push(true)
						}
						else{
							boollist_valid.push(false)
						}
					}
				}
			}
			var returning = ""; 
			$.each(Object.keys(boollist_valid), function (index, value) {
				returning = returning + value + ", "
			})
			$("#recipe_message")[0].style.color = "red"
			$("#recipe_message")[0].innerHTML = "Recipe not valid, check: " + returning.substring(0, returning.length - 2)
			MC.show("recipe_message");
			setInterval(function(){ MC.hide("recipe_message") }, 10000);
		}
	});
	
	$("#cr_dmg").jqxInput({height: 25, width: 63, disabled: true, minLength: 0, items: 30, searchMode: 'contains'});
	$("#cr_variant").jqxInput({height: 25, width: 63, disabled: true, minLength: 0, items: 30, searchMode: 'contains'});
	$("#cr_modbox").jqxInput({placeHolder: "Enter ModID...", height: 25, width: 210, minLength: 1, items: 30, searchMode: 'contains', source: Object.keys(MC.Mods)});
	$("#cr_itembox").jqxInput({placeHolder: "Enter ItemID...", height: 25, width: 220, minLength: 1, items: 30, searchMode: 'contains', source: []});
	$("#cr_modbox").on('change', function (event) {
		if(!MC.item_selecting){
			var valmod = $("#cr_modbox").val();
			var valitem = $("#cr_itembox").val();
			if(valmod.equals(Object.keys(MC.Mods))){
				$("#cr_itembox").jqxInput({source: MC.Mods[valmod].itemid});
			}
			else{
				$("#cr_itembox").jqxInput({source: []});
			}
			if(valmod != "" && valitem != ""){
				$('#copyrecipeValidator').jqxValidator('validate');
			}
		}
	});
	$("#cr_itembox").on('change', function (event) {
		if(!MC.item_selecting){
			if($("#cr_modbox").val() != "" && $("#cr_itembox").val() != ""){
				$('#copyrecipeValidator').jqxValidator('validate');
			}
		}
	});
	$("#cr_dmg").on('change', function (event) {
		if(!MC.item_selecting){
			$('#copyrecipeValidator').jqxValidator('validate');
		}
	});
	$("#cr_variant").on('change', function (event) {
		if(!MC.item_selecting){
			$('#copyrecipeValidator').jqxValidator('validate');
		}
	});
	$('#copyrecipeValidator').jqxValidator({
		position: 'topcenter',
		hintType : 'label',
		rules: [
			{ input: "#cr_modbox", message: 'mod-id not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; if ( input == "" ) {return true} return input.equals(Object.keys(MC.Mods)) }},
			{ input: "#cr_itembox", message: 'item not found!', action: 'keyup, blur', rule: function (input) { input = input[0].value; var valmod = $("#cr_modbox").val(); if ( input == "" ) {return true} if ( valmod == "" ) {return false} if ( !valmod.equals(Object.keys(MC.Mods)) ) {return false} return input.equals(MC.Mods[valmod].itemid) }},
		]
	});
	$('#copyrecipeValidator').on('validationSuccess', function(event) { 
		if ( $('#cr_group')[0].style.visibility != "hidden" ) {
			var valmod = $("#cr_modbox").val();
			var valitem = $("#cr_itembox").val();
			if(valmod != "" && valitem != ""){
				var temp_item = MC.checkItem({modid:valmod, itemid:valitem, dmg: $("#cr_dmg").val(), variant: $("#cr_variant").val()})
				if ( temp_item.valid ) {
					MC.item_selecting = true
					$("#cr_dmg").jqxInput({disabled: (!(temp_item.damages.length > 1)), source: temp_item.damages});
					$("#cr_variant").jqxInput({disabled: (!(temp_item.variants.length > 1)), source: temp_item.variants});
					$("#cr_dmg").val(temp_item.dmg.toString());
					$("#cr_variant").val(temp_item.variant.toString());
					MC.item_selecting = false
				}
			}
		}
	});
		
	$('#recipe_copyButton').jqxButton({ width: '180px', disabled: false });
	$('#recipe_copyButton').on('click', function () {
		if($('#cr_group')[0].style.visibility == "hidden"){
			MC.show("cr_group")
		}
		else{
			$('#copyrecipeValidator').jqxValidator('validate');
			var itemid = MC.convertCItemtoID({modid:$("#cr_modbox").val(), itemid:$("#cr_itembox").val(), dmg: $("#cr_dmg").val(), variant: $("#cr_variant").val()})
			var citem = MC.convertItemID(itemid, false, false)
			if(citem.valid){
				MC.Items[MC.Mod[MC.viewing.Mod].crafter][MC.viewing.Item].craftCount = MC.Items[citem.crafter][itemid].craftCount
				MC.Items[MC.Mod[MC.viewing.Mod].crafter][MC.viewing.Item].recipe = MC.Items[citem.crafter][itemid].recipe.Copy()
				MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].craftCount = MC.Items[citem.crafter][itemid].craftCount
				MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].recipe = MC.Items[citem.crafter][itemid].recipe.Copy()
				MC.CItems[MC.viewing.Mod][MC.viewing.Item].valid_recipe = MC.CItems[MC.Mods[citem.modid].name][itemid].valid_recipe
				$("#recipe_message")[0].style.color = "green"
				$("#recipe_message")[0].innerHTML = "Recipe copied successfully from: " + itemid
				MC.hide("cr_group");
				$("#cr_modbox").val("");
				$("#cr_itembox").val("");
				$("#cr_dmg").val("0");
				$("#cr_variant").val("0");
				MC.show("recipe_message");
				setInterval(function(){ MC.hide("recipe_message") }, 10000);
			}
			else{
				$("#recipe_message")[0].style.color = "red"
				$("#recipe_message")[0].innerHTML = "Cant copy recipe, item not valid: " + itemid
				MC.show("recipe_message");
				setInterval(function(){ MC.hide("recipe_message") }, 10000);
			}
		}
	});
			
	MC.go.Mod("");
});

/*OTHER
MC.changeRecipeItem("atlcraft", "ore_jj_materialPressedwax", "atlcraft_jj_atlcraft_wax")
MC.changeRecipeItem("atlcraft", "ore_jj_wick", "minecraft_jj_string")
MC.changeRecipeItem("atlcraft", "ore_jj_glassclear", "minecraft_jj_glass_pane")
MC.changeRecipeItem("atlcraft", "ore_jj_coalpiece", "minecraft_jj_coal")

MC.changeRecipeItem("atlcraft", "ore_jj_paneGlassBlack", "minecraft_jj_stained_glass_pane_jj_")
MC.changeRecipeItem("atlcraft", "ore_jj_paneGlassBlue", "minecraft_jj_stained_glass_pane_jj_")
MC.changeRecipeItem("atlcraft", "ore_jj_paneGlassBrown", "minecraft_jj_stained_glass_pane_jj_")
MC.changeRecipeItem("atlcraft", "ore_jj_paneGlassCyan", "minecraft_jj_stained_glass_pane_jj_")
MC.changeRecipeItem("atlcraft", "ore_jj_paneGlassGreen", "minecraft_jj_stained_glass_pane_jj_")
MC.changeRecipeItem("atlcraft", "ore_jj_paneGlassGray", "minecraft_jj_stained_glass_pane_jj_")
MC.changeRecipeItem("atlcraft", "ore_jj_paneGlassLightBlue", "minecraft_jj_stained_glass_pane_jj_")
MC.changeRecipeItem("atlcraft", "ore_jj_paneGlassLightGray", "minecraft_jj_stained_glass_pane_jj_")
MC.changeRecipeItem("atlcraft", "ore_jj_paneGlassLime", "minecraft_jj_stained_glass_pane_jj_")
MC.changeRecipeItem("atlcraft", "ore_jj_paneGlassMagenta", "minecraft_jj_stained_glass_pane_jj_")
MC.changeRecipeItem("atlcraft", "ore_jj_paneGlassOrange", "minecraft_jj_stained_glass_pane_jj_")
MC.changeRecipeItem("atlcraft", "ore_jj_paneGlassPink", "minecraft_jj_stained_glass_pane_jj_")
MC.changeRecipeItem("atlcraft", "ore_jj_paneGlassPurple", "minecraft_jj_stained_glass_pane_jj_")
MC.changeRecipeItem("atlcraft", "ore_jj_paneGlassRed", "minecraft_jj_stained_glass_pane_jj_")
MC.changeRecipeItem("atlcraft", "ore_jj_paneGlassYellow", "minecraft_jj_stained_glass_pane_jj_")
*/