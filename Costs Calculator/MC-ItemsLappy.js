var MC = {
	Items: {},
	CItems: {},
	Mods: {},
	Mod: {},
	Traders: [],
	Listing: {itemListBox:[]},
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
	listInvalidRecipeItems: function(modid, counts){
		if ( counts == null ) {
			counts = 1
		}
		var itemlist = {};
		$.each(Object.keys(MC.Items[MC.Mods[modid].crafter]), function (i, itemid) {
			if ( itemid.startsWith(modid) ) {
				$.each(Object.keys(MC.Items[MC.Mods[modid].crafter][itemid].recipe), function (j, ritemid) {
					if(!MC.convertItemID(ritemid, false, false).valid){
						if(itemlist[ritemid] == null){
							itemlist[ritemid] = 1
						}
						else{
							itemlist[ritemid] = itemlist[ritemid] + 1
						}
					}
				});
			}
		});
		var itemlistnew = [];
		$.each(itemlist, function (itemid, count) {
			if ( count > counts ) {
				itemlistnew.push(itemid)
			}
		});
		return itemlistnew
	},
	listItemsWOCraftCount: function(modid){
		var itemlist = [];
		$.each(Object.keys(MC.Items[MC.Mods[modid].crafter]), function (i, itemid) {
			if ( itemid.startsWith(modid) ) {
				if(MC.Items[MC.Mods[modid].crafter][itemid].craftCount == 0 && MC.Items[MC.Mods[modid].crafter][itemid].hasPattern){
					itemlist.push(itemid)
				}
			}
		});
		return itemlist
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
		console.log("Change RecipeItem " + item + " finished")
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
				MC.Items[citem.crafter][item.id] = {"bit":false,"buying":false,"c1":"","c2":"","c3":"","chisel":false,"craftCount":0,"fixedprice":false,"group":"","hasPattern":false,"label":"","maxCount":8,"price":0,"recipe":{},"selling":false,"tag":item.tag,"trader":0}
				MC.Mod[MC.Mods[citem.modid].name].items[item.id] = MC.Items[citem.crafter][item.id]
				MC.CItems[MC.Mods[citem.modid].name][item.id] = MC.convertItemID(item.id, true, true)
				if(!citem.itemid.equals(MC.Mods[citem.modid].itemid)){
					MC.Mods[citem.modid].itemid.push(citem.itemid)
				}
			}
		});
	},
	setForAll: function(what, items, newval){
		if ( !what.equals("recipe") && what.equals(Object.keys(MC.Items.minecraft.minecraft_jj_glass)) ) {
			if ( (typeof newval).equals(typeof MC.Items.minecraft.minecraft_jj_glass[what]) ) {
				$.each(items, function (i, itemid) {
					var citem = MC.convertItemID(itemid, false, false)
					if ( citem.valid ) {
						var oldvalue = MC.Items[MC.Mods[citem.modid].crafter][itemid][what]
						MC.Items[MC.Mods[citem.modid].crafter][itemid][what] = newval
						console.log("Changed " + what + " -- Crafter: " + MC.Mods[citem.modid].crafter + " -- ItemID: " + itemid + " -- Old Value: " + oldvalue + " -- New Value: " + newval)
					}
				});
			}
			else{
				console.log("Wrong type for the new value. Please set a " + (typeof MC.Items.minecraft.minecraft_jj_glass[what]) + ".")
			}
		}
		else{
			console.log("'" + what + "' is not a field in the item repository")
		}
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
			"filter_maxCountfrom_numinput",
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
			else if (filt.endsWith("filter_maxCountfrom_numinput")){ check = ( $('#' + filt).val() != "0" || $('#filter_maxCountto_numinput').val() != "0" )}
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
						else if ( id == "maxCountfrom" ) {
							var tmaxCount = MC.Mod[MC.viewing.Mod].items[item].maxCount
							if ( tmaxCount < (parseInt($('#' + filt).val()) || tmaxCount > parseInt($('#filter_maxCountto_numinput').val())) ) {
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
		MC.Listing.itemListBox = [];
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
			MC.Listing.itemListBox.push(item);
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
			$('#itemMaxCount_input').jqxNumberInput('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].maxCount);
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

	$('#mainSplitter').jqxSplitter({  width: 1598, height: 718, panels: [{ size: 300, min: 300 }, {min: 300, size: 300}] });
	$('#contentSplitter').jqxSplitter({ width: '100%', height: '100%', panels: [{ size: 620, min: 300, collapsible: false }, { min: 300, collapsible: true}] });
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
	$("#itemprice_input").jqxNumberInput({height: 25, width: 66, disabled: true, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 0, max: 6400});
	$("#itemMaxCount_input").jqxNumberInput({height: 25, width: 100, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 0});
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
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].maxCount = parseInt($('#itemMaxCount_input').val());
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
	$("#filter_maxCountfrom_numinput").jqxNumberInput({height: 25, width: 60, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 0});
	$("#filter_maxCountto_numinput").jqxNumberInput({height: 25, width: 60, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 0});
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
		$("#filter_maxCountfrom_numinput").val("0");
		$("#filter_maxCountto_numinput").val("0");

		MC.itemfilter();
	});

	$("#rc_craftcount").jqxNumberInput({height: 25, width: 63, disabled: false, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 0, max: 64});
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

MC.changeRecipeItem("advancedrocketry", "ore_jj_ingotTitaniumAluminide", "advancedrocketry_jj_productingot")
MC.changeRecipeItem("advancedrocketry", "ore_jj_plateTitaniumIridium", "advancedrocketry_jj_productplate_jj_1")
MC.changeRecipeItem("advancedrocketry", "ore_jj_ingotCopper", "mekanism_jj_ingot_jj_5")
MC.changeRecipeItem("advancedrocketry", "ore_jj_sheetIron", "libvulpes_jj_productsheet_jj_1")
MC.changeRecipeItem("advancedrocketry", "ore_jj_coilCopper", "libvulpes_jj_coil0_jj_4")
MC.changeRecipeItem("advancedrocketry", "ore_jj_plateTin", "libvulpes_jj_productplate_jj_5")
MC.changeRecipeItem("advancedrocketry", "ore_jj_plateGold", "libvulpes_jj_productplate_jj_2")
MC.changeRecipeItem("advancedrocketry", "ore_jj_plateSteel", "libvulpes_jj_productplate_jj_6")

MC.changeRecipeItem("advancedrocketry", "ore_jj_gearSteel", "libvulpes_jj_productgear_jj_6")
MC.changeRecipeItem("advancedrocketry", "ore_jj_gearTitaniumAluminide", "advancedrocketry_jj_productgear")
MC.changeRecipeItem("advancedrocketry", "ore_jj_stickTitaniumAluminide", "advancedrocketry_jj_productrod")
MC.changeRecipeItem("advancedrocketry", "ore_jj_dustDilithium", "libvulpes_jj_productdust")
MC.changeRecipeItem("advancedrocketry", "ore_jj_crystalDilithium", "libvulpes_jj_productcrystal")

var list2 = [
"libvulpes_jj_productplate_jj_9",
"libvulpes_jj_productfan_jj_6",
"libvulpes_jj_productrod_jj_6",
"libvulpes_jj_productsheet_jj_7",
"libvulpes_jj_productplate_jj_7",
"libvulpes_jj_productdust_jj_4",
"libvulpes_jj_productplate_jj_1",
"minecraft_jj_wooden_slab",
"libvulpes_jj_productdust_jj_2",
"libvulpes_jj_productrod_jj_7",
"libvulpes_jj_productrod_jj_1",
"advancedrocketry_jj_concrete",
"libvulpes_jj_productrod_jj_4",
"advancedrocketry_jj_productingot_jj_1",
"minecraft_jj_glass_pane",
"libvulpes_jj_battery",
"advancedrocketry_jj_misc_jj_1",
"advancedrocketry_jj_productplate",
"advancedrocketry_jj_productrod_jj_1",
"advancedrocketry_jj_metal0",
"advancedrocketry_jj_metal0_jj_1",
"libvulpes_jj_productgear_jj_7",
"libvulpes_jj_productingot_jj_6",
"libvulpes_jj_productsheet_jj_9",
"libvulpes_jj_coil0_jj_9",
"libvulpes_jj_productdust_jj_9",
"libvulpes_jj_productdust_jj_1",
"advancedrocketry_jj_thermite"
]

var list2 = [
"appliedenergistics2_jj_material",
"appliedenergistics2_jj_material_jj_8",
"appliedenergistics2_jj_material_jj_2",
"actuallyadditions_jj_item_dust_jj_5",
"appliedenergistics2_jj_material_jj_7",
"basemetals_jj_wood_gear",
"appliedenergistics2_jj_material_jj_5",
"",
"appliedenergistics2_jj_quartz_ore",
"minecraft_jj_quartz",
"appliedenergistics2_jj_part_jj_180"
]

$.each(list, function (j, item) {
	if ( list2[j] != null ) {
		if(!list2[j].equals("")){
			MC.changeRecipeItem("appliedenergistics2", item, list2[j])
		}
	}
});


MC.changeRecipeItem("basemetals", "ore_jj_blockAdamantine", "basemetals_jj_adamantine_block")
MC.changeRecipeItem("basemetals", "ore_jj_ingotAdamantine", "basemetals_jj_adamantine_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetAdamantine", "basemetals_jj_adamantine_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_plateAdamantine", "basemetals_jj_adamantine_plate")
MC.changeRecipeItem("basemetals", "ore_jj_dustAdamantine", "basemetals_jj_adamantine_powder")
MC.changeRecipeItem("basemetals", "ore_jj_shieldAdamantine", "basemetals_jj_adamantine_shield")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyAdamantine", "basemetals_jj_adamantine_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_blockAntimony", "basemetals_jj_antimony_block")
MC.changeRecipeItem("basemetals", "ore_jj_ingotAntimony", "basemetals_jj_antimony_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetAntimony", "basemetals_jj_antimony_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_plateAntimony", "basemetals_jj_antimony_plate")
MC.changeRecipeItem("basemetals", "ore_jj_dustAntimony", "basemetals_jj_antimony_powder")
MC.changeRecipeItem("basemetals", "ore_jj_shieldAntimony", "basemetals_jj_antimony_shield")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyAntimony", "basemetals_jj_antimony_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_blockAquarium", "basemetals_jj_aquarium_block")
MC.changeRecipeItem("basemetals", "ore_jj_ingotAquarium", "basemetals_jj_aquarium_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetAquarium", "basemetals_jj_aquarium_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_dustAquarium", "basemetals_jj_aquarium_powder")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyAquarium", "basemetals_jj_aquarium_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_blockBismuth", "basemetals_jj_bismuth_block")
MC.changeRecipeItem("basemetals", "ore_jj_ingotBismuth", "basemetals_jj_bismuth_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetBismuth", "basemetals_jj_bismuth_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_plateBismuth", "basemetals_jj_bismuth_plate")
MC.changeRecipeItem("basemetals", "ore_jj_dustBismuth", "basemetals_jj_bismuth_powder")
MC.changeRecipeItem("basemetals", "ore_jj_shieldBismuth", "basemetals_jj_bismuth_shield")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyBismuth", "basemetals_jj_bismuth_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_blockBrass", "basemetals_jj_brass_block")
MC.changeRecipeItem("basemetals", "ore_jj_ingotBrass", "basemetals_jj_brass_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetBrass", "basemetals_jj_brass_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_plateBrass", "basemetals_jj_brass_plate")
MC.changeRecipeItem("basemetals", "ore_jj_dustBrass", "basemetals_jj_brass_powder")
MC.changeRecipeItem("basemetals", "ore_jj_shieldBrass", "basemetals_jj_brass_shield")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyBrass", "basemetals_jj_brass_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_ingotBrick", "basemetals_jj_brick_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_blockBronze", "basemetals_jj_bronze_block")
MC.changeRecipeItem("basemetals", "ore_jj_ingotBronze", "basemetals_jj_bronze_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetBronze", "basemetals_jj_bronze_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_dustBronze", "basemetals_jj_bronze_powder")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyBronze", "basemetals_jj_bronze_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_ingotCharcoal", "basemetals_jj_charcoal_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_dustCharcoal", "basemetals_jj_charcoal_powder")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyCharcoal", "basemetals_jj_charcoal_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_ingotCoal", "basemetals_jj_coal_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_dustCoal", "basemetals_jj_coal_powder")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyCoal", "basemetals_jj_coal_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_blockColdiron", "basemetals_jj_coldiron_block")
MC.changeRecipeItem("basemetals", "ore_jj_ingotColdiron", "basemetals_jj_coldiron_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetColdiron", "basemetals_jj_coldiron_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_plateColdiron", "basemetals_jj_coldiron_plate")
MC.changeRecipeItem("basemetals", "ore_jj_dustColdiron", "basemetals_jj_coldiron_powder")
MC.changeRecipeItem("basemetals", "ore_jj_shieldColdiron", "basemetals_jj_coldiron_shield")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyColdiron", "basemetals_jj_coldiron_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_blockCopper", "basemetals_jj_copper_block")
MC.changeRecipeItem("basemetals", "ore_jj_ingotCopper", "basemetals_jj_copper_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetCopper", "basemetals_jj_copper_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_plateCopper", "basemetals_jj_copper_plate")
MC.changeRecipeItem("basemetals", "ore_jj_dustCopper", "basemetals_jj_copper_powder")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyCopper", "basemetals_jj_copper_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_blockCupronickel", "basemetals_jj_cupronickel_block")
MC.changeRecipeItem("basemetals", "ore_jj_ingotCupronickel", "basemetals_jj_cupronickel_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetCupronickel", "basemetals_jj_cupronickel_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_plateCupronickel", "basemetals_jj_cupronickel_plate")
MC.changeRecipeItem("basemetals", "ore_jj_dustCupronickel", "basemetals_jj_cupronickel_powder")
MC.changeRecipeItem("basemetals", "ore_jj_shieldCupronickel", "basemetals_jj_cupronickel_shield")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyCupronickel", "basemetals_jj_cupronickel_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetDiamond", "basemetals_jj_diamond_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyDiamond", "basemetals_jj_diamond_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_blockElectrum", "basemetals_jj_electrum_block")
MC.changeRecipeItem("basemetals", "ore_jj_ingotElectrum", "basemetals_jj_electrum_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetElectrum", "basemetals_jj_electrum_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_plateElectrum", "basemetals_jj_electrum_plate")
MC.changeRecipeItem("basemetals", "ore_jj_dustElectrum", "basemetals_jj_electrum_powder")
MC.changeRecipeItem("basemetals", "ore_jj_shieldElectrum", "basemetals_jj_electrum_shield")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyElectrum", "basemetals_jj_electrum_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetEmerald", "basemetals_jj_emerald_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_plateEmerald", "basemetals_jj_emerald_plate")
MC.changeRecipeItem("basemetals", "ore_jj_shieldEmerald", "basemetals_jj_emerald_shield")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyEmerald", "basemetals_jj_emerald_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_dustGold", "basemetals_jj_gold_powder")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyGold", "basemetals_jj_gold_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_blockInvar", "basemetals_jj_invar_block")
MC.changeRecipeItem("basemetals", "ore_jj_ingotInvar", "basemetals_jj_invar_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetInvar", "basemetals_jj_invar_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_dustInvar", "basemetals_jj_invar_powder")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyInvar", "basemetals_jj_invar_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_plateIron", "basemetals_jj_iron_plate")
MC.changeRecipeItem("basemetals", "ore_jj_dustIron", "basemetals_jj_iron_powder")
MC.changeRecipeItem("basemetals", "ore_jj_shieldIron", "basemetals_jj_iron_shield")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyIron", "basemetals_jj_iron_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_blockLead", "basemetals_jj_lead_block")
MC.changeRecipeItem("basemetals", "ore_jj_ingotLead", "basemetals_jj_lead_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetLead", "basemetals_jj_lead_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_plateLead", "basemetals_jj_lead_plate")
MC.changeRecipeItem("basemetals", "ore_jj_dustLead", "basemetals_jj_lead_powder")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyLead", "basemetals_jj_lead_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_ingotMercury", "basemetals_jj_mercury_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_dustMercury", "basemetals_jj_mercury_powder")
MC.changeRecipeItem("basemetals", "ore_jj_blockMithril", "basemetals_jj_mithril_block")
MC.changeRecipeItem("basemetals", "ore_jj_ingotMithril", "basemetals_jj_mithril_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetMithril", "basemetals_jj_mithril_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_dustMithril", "basemetals_jj_mithril_powder")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyMithril", "basemetals_jj_mithril_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_blockNickel", "basemetals_jj_nickel_block")
MC.changeRecipeItem("basemetals", "ore_jj_ingotNickel", "basemetals_jj_nickel_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetNickel", "basemetals_jj_nickel_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_plateNickel", "basemetals_jj_nickel_plate")
MC.changeRecipeItem("basemetals", "ore_jj_dustNickel", "basemetals_jj_nickel_powder")
MC.changeRecipeItem("basemetals", "ore_jj_shieldNickel", "basemetals_jj_nickel_shield")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyNickel", "basemetals_jj_nickel_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_blockObsidian", "basemetals_jj_obsidian_block")
MC.changeRecipeItem("basemetals", "ore_jj_ingotObsidian", "basemetals_jj_obsidian_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetObsidian", "basemetals_jj_obsidian_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_dustObsidian", "basemetals_jj_obsidian_powder")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyObsidian", "basemetals_jj_obsidian_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_blockPewter", "basemetals_jj_pewter_block")
MC.changeRecipeItem("basemetals", "ore_jj_ingotPewter", "basemetals_jj_pewter_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetPewter", "basemetals_jj_pewter_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_platePewter", "basemetals_jj_pewter_plate")
MC.changeRecipeItem("basemetals", "ore_jj_dustPewter", "basemetals_jj_pewter_powder")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyPewter", "basemetals_jj_pewter_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_blockPlatinum", "basemetals_jj_platinum_block")
MC.changeRecipeItem("basemetals", "ore_jj_ingotPlatinum", "basemetals_jj_platinum_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetPlatinum", "basemetals_jj_platinum_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_platePlatinum", "basemetals_jj_platinum_plate")
MC.changeRecipeItem("basemetals", "ore_jj_dustPlatinum", "basemetals_jj_platinum_powder")
MC.changeRecipeItem("basemetals", "ore_jj_shieldPlatinum", "basemetals_jj_platinum_shield")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyPlatinum", "basemetals_jj_platinum_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_ingotQuartz", "basemetals_jj_quartz_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetQuartz", "basemetals_jj_quartz_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_dustQuartz", "basemetals_jj_quartz_powder")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyQuartz", "basemetals_jj_quartz_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_blockSilver", "basemetals_jj_silver_block")
MC.changeRecipeItem("basemetals", "ore_jj_ingotSilver", "basemetals_jj_silver_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetSilver", "basemetals_jj_silver_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_plateSilver", "basemetals_jj_silver_plate")
MC.changeRecipeItem("basemetals", "ore_jj_dustSilver", "basemetals_jj_silver_powder")
MC.changeRecipeItem("basemetals", "ore_jj_shieldSilver", "basemetals_jj_silver_shield")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinySilver", "basemetals_jj_silver_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_blockStarsteel", "basemetals_jj_starsteel_block")
MC.changeRecipeItem("basemetals", "ore_jj_ingotStarsteel", "basemetals_jj_starsteel_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetStarsteel", "basemetals_jj_starsteel_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_dustStarsteel", "basemetals_jj_starsteel_powder")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyStarsteel", "basemetals_jj_starsteel_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_blockSteel", "basemetals_jj_steel_block")
MC.changeRecipeItem("basemetals", "ore_jj_ingotSteel", "basemetals_jj_steel_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetSteel", "basemetals_jj_steel_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_plateSteel", "basemetals_jj_steel_plate")
MC.changeRecipeItem("basemetals", "ore_jj_dustSteel", "basemetals_jj_steel_powder")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinySteel", "basemetals_jj_steel_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_blockTin", "basemetals_jj_tin_block")
MC.changeRecipeItem("basemetals", "ore_jj_ingotTin", "basemetals_jj_tin_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetTin", "basemetals_jj_tin_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_plateTin", "basemetals_jj_tin_plate")
MC.changeRecipeItem("basemetals", "ore_jj_dustTin", "basemetals_jj_tin_powder")
MC.changeRecipeItem("basemetals", "ore_jj_shieldTin", "basemetals_jj_tin_shield")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyTin", "basemetals_jj_tin_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_blockZinc", "basemetals_jj_zinc_block")
MC.changeRecipeItem("basemetals", "ore_jj_ingotZinc", "basemetals_jj_zinc_ingot")
MC.changeRecipeItem("basemetals", "ore_jj_nuggetZinc", "basemetals_jj_zinc_nugget")
MC.changeRecipeItem("basemetals", "ore_jj_plateZinc", "basemetals_jj_zinc_plate")
MC.changeRecipeItem("basemetals", "ore_jj_dustZinc", "basemetals_jj_zinc_powder")
MC.changeRecipeItem("basemetals", "ore_jj_shieldZinc", "basemetals_jj_zinc_shield")
MC.changeRecipeItem("basemetals", "ore_jj_dustTinyZinc", "basemetals_jj_zinc_smallpowder")
MC.changeRecipeItem("basemetals", "ore_jj_gemEmerald", "minecraft_jj_emerald")
MC.changeRecipeItem("basemetals", "minecraft_jj_Iron_nugget", "minecraft_jj_iron_nugget")




$('#mainSplitter').jqxSplitter({  width: 1598, height: 718, panels: [{ size: 300, min: 300 }, {min: 300, size: 300}] });
$('#contentSplitter').jqxSplitter({ width: '100%', height: '100%', panels: [{ size: 620, min: 300, collapsible: false }, { min: 300, collapsible: true}] });

*/