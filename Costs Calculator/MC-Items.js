var MC = {
	Items: {},
	CItems: {},
	Mods: {},
	Mod: {},
	Traders: [],
	Listing: {itemListBox:[]},
	Suggest: { groups: [], comment1: [], comment2: [], comment3: [] },
	viewing: {
		Mod: "",
		Item: ""
	},
	rv_rules: [],
	item_selecting: false,
	valid_recipe: false,
	recipe_show: [],
	timer: {
		recipe: null,
		item: null
	},
	setALL_source: [
		["group", "comment1", "comment2", "comment3", "trader", "selling", "buying", "chisel", "bit", "hasPattern", "fixedprice", "price", "maxCount", "craftCount"],
		["Group", "Comment 1", "Comment 2", "Comment 3", "Trader", "Selling", "Buying", "Chisel", "Bit", "has Pattern", "Fixed Price", "Price", "max. Count", "Craft Count"]
	],
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
	itemfilter: function (gomod) {
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
			"filter_norecipe_check",
			"filter_selling_check",
			"filter_buying_check",
			"filter_chisel_check",
			"filter_bit_check",
			"filter_hasPattern_check"];
		var items = {};
		$.each(Object.keys(MC.Mod[MC.viewing.Mod].items), function (index, item) {
			items[item] = true
		});
		
		if ( gomod ) {
			var Suggest = { groups: [], comment1: [], comment2: [], comment3: [], trader: [] }
			$.each(MC.Mod[MC.viewing.Mod].items, function (index, item) {
				if ( item.group != "" && item.group.equals(Suggest.groups) == false ) {
					Suggest.groups.push(item.group);
					Suggest.groups.push(("-" + item.group));
				}
				if ( item.c1 != "" && item.c1.equals(Suggest.comment1) == false ) {
					Suggest.comment1.push(item.c1);
					Suggest.comment1.push(("-" + item.c1));
				}
				if ( item.c2 != "" && item.c2.equals(Suggest.comment2) == false ) {
					Suggest.comment2.push(item.c2);
					Suggest.comment2.push(("-" + item.c2));
				}
				if ( item.c3 != "" && item.c3.equals(Suggest.comment3) == false ) {
					Suggest.comment3.push(item.c3);
					Suggest.comment3.push(("-" + item.c3));
				}
				if ( item.trader != "" && item.trader.equals(Suggest.trader) == false ) {
					Suggest.trader.push(item.trader);
					Suggest.trader.push(("-" + item.trader));
				}
			});
			$("#filter_group_input").jqxComboBox({source: Suggest.groups});
			$('#filter_comment1_input').jqxComboBox({source: Suggest.comment1});
			$('#filter_comment2_input').jqxComboBox({source: Suggest.comment2});
			$('#filter_comment3_input').jqxComboBox({source: Suggest.comment3});
			$('#filter_trader_input').jqxComboBox({source: Suggest.comment3});
		}
		
		$.each(filters, function(i, filt) {
			var check = false;
			if ( filt.endsWith("_input") ) { check = ( $('#' + filt).val() != "" )}
			else if (filt.endsWith("_check")){ check = ( $('#' + filt).val() != null )}
			else if (filt.endsWith("_numinput")){ check = ( $('#' + filt).val() != "0" || $('#' + filt.replace("from", "to")).val() != "0" )}
			if ( check ) {
				var splits = []
				var id = filt.split("_")[1].replace("omment", "")
				if ( id.equals(["modid","itemid","dmg","tag","label"]) ) {
					splits = $('#' + filt).val().split(", ")
					if ( splits[splits.length - 1] == "" ) {
						splits.pop()
					}
				}
				if ( id.equals(["group","c1","c2","c3","trader"]) ) {
					$.each($('#' + filt).jqxComboBox('getSelectedItems'), function (index, item) {
						splits[index] = item.value
					});
				}
				$.each(Object.keys(MC.Mod[MC.viewing.Mod].items), function (index, item) {
					if ( items[item] ) {
						if ( id.equals(["modid","itemid","dmg"]) ) {
							$.each(splits, function (j, sp) {
								if ( MC.CItems[MC.viewing.Mod][item][id].toString().contains(sp.replace("-", "")) == sp.startsWith("-") ) {
									items[item] = false
								}
							});
						}
						else if ( id == "validrecipe" ) {
							if ( MC.CItems[MC.viewing.Mod][item]["valid_recipe"] != ($('#' + filt).val())  ) {
								items[item] = false
							}
						}
						else if ( id == "norecipe" ) {
							if((Object.keys(MC.Mod[MC.viewing.Mod].items[item].recipe).length > 0) == ($('#' + filt).val() )){
								items[item] = false
							}
						}
						else if( id.equals(["group","c1","c2","c3","trader"]) ){
							$.each(splits, function (j, sp) {
								if ( MC.Mod[MC.viewing.Mod].items[item][id].toString().equals(sp.replace("-", "")) == sp.startsWith("-") ) {
									items[item] = false
								}
							});
						}
						else if( filt.endsWith("_input") ){
							$.each(splits, function (j, sp) {
								if ( MC.Mod[MC.viewing.Mod].items[item][id].toString().contains(sp.replace("-", "")) == sp.startsWith("-") ) {
									items[item] = false
								}
							});
						}
						else if( filt.endsWith("_check") ){
							if ( MC.Mod[MC.viewing.Mod].items[item][id] != ($('#' + filt).val() ) ) {
								items[item] = false
							}
						}
						else if ( filt.endsWith("_numinput") ) {
							var temp = MC.Mod[MC.viewing.Mod].items[item][id.substring(0, id.length - 4)]
							if ( temp < parseInt($('#' + filt).val()) || temp > parseInt($('#' + filt.replace("from", "to")).val()) ) {
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
		$('#setALL_what').jqxDropDownList('selectIndex', 0);
	},
	save: function(what){
		if ('Blob' in window) {
			var fileName = 'MC-' + what + '.js';
			var JStextToWrite = "MC." + what + " = {\n" 
			var typ = 'application/javascript'
			var replaceforLUA = false
			if ( what == 'lua' ) {
				fileName = 'ALL_Items.lua';
				JStextToWrite = "return {\n" 
				typ = 'application/lua'
				what = 'Items'
				replaceforLUA = true
			}
			var objKeys = {}
			objKeys.main = Object.keys(MC[what])
			for(var i = 0; i < objKeys.main.length; i++) {
				JStextToWrite += "  " + JSON.stringify(objKeys.main[i]) + ":{\n";
				objKeys[objKeys.main[i]] = Object.keys(MC[what][objKeys.main[i]]);
				for(var j = 0; j < objKeys[objKeys.main[i]].length; j++) {
					JStextToWrite += "    " + JSON.stringify(objKeys[objKeys.main[i]][j]) + ":" + JSON.stringify(MC[what][objKeys.main[i]][objKeys[objKeys.main[i]][j]])
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
			if ( replaceforLUA ) {
				JStextToWrite = JStextToWrite.replaceAll(":", "=").replaceAll(":", "=").replaceAll("\"=", "=").replaceAll(",\"", ",").replaceAll("{\"", "{").replaceAll("  \"", "  ")
			}
			var textFileAsBlob = new Blob([JStextToWrite], { type: typ });
		
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
	},
	hide: function(div_name){
		$("#" + div_name).css({visibility: "hidden", display: "none"});
	},
	hide_SetALL: function(){
		$.each(MC.setALL_source[0], function (index, item) {
			var temp = "_check"
			if ( index < 5 ) { temp = "_input" }
			else if ( index > 10 ) { temp = "_numinput" }
			MC.hide("setALL_" + item + temp)
		});
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
					MC.itemfilter(true);
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
			if ( MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].group == "" ) {
				$('#itemgroup_input').jqxComboBox('clear')
			}
			else{
				$("#itemgroup_input").jqxComboBox('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].group);
			}
			if ( MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].c1 == "" ) {
				$('#itemcomment1_input').jqxComboBox('clearSelection')		
			}
			else{
				$('#itemcomment1_input').jqxComboBox('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].c1);			
			}
			if ( MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].c2 == "" ) {
				$('#itemcomment2_input').jqxComboBox('clearSelection')					
			}
			else{
				$('#itemcomment2_input').jqxComboBox('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].c2);						
			}
			if ( MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].c3 == "" ) {
				$('#itemcomment3_input').jqxComboBox('clearSelection')								
			}
			else{
				$('#itemcomment3_input').jqxComboBox('val', MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].c3);									
			}
			
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
	$('#btnSave').on('click', function () { MC.save('Items') });
	$("#btnSaveConvert").jqxButton({ width: 48, height: 48, imgWidth: 48, imgHeight: 48, imgPosition: "left", textPosition: "center", imgSrc: "save-convert.png", textImageRelation: "overlay" });
	$('#btnSaveConvert').on('click', function () { MC.save('CItems') });
	$("#btnSaveLUA").jqxButton({ width: 48, height: 48, imgWidth: 48, imgHeight: 48, imgPosition: "left", textPosition: "center", imgSrc: "save-lua.png", textImageRelation: "overlay" });
	$('#btnSaveLUA').on('click', function () { MC.save('lua') });

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
			$('#itemListBox').jqxListBox({ filterable: true, searchMode: 'contains', filterPlaceHolder: "Suche...", source: ['No mod selected! Please Select a mod first!'], width: '100%', height: '100%' });
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
		MC.Mod[MC.viewing.Mod].items[MC.viewing.Item].hasPattern = $('#itempattern_check').jqxCheckBox('checked');
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
		$("#itemListBox").jqxListBox('selectItem', temp_item);
		$('#itemDetailTabs').jqxTabs('select', 0);
		MC.item_selecting = false;
		$("#item_message")[0].innerHTML = "Item properties written successfully!!!"
		MC.show("item_message");
		if ( MC.timer.item != null ) {
			clearTimeout(MC.timer.item)
		}
		MC.timer.item = setTimeout(function(){ MC.hide("item_message") }, 10000);
	});
	$('#refreshsources_okButton').jqxButton({ width: '220px', disabled: false });
	$('#refreshsources_okButton').on('click', function () {
		MC.item_selecting = true;
		var temp_item = $("#itemListBox").jqxListBox('getSelectedItem');
		MC.createItemSource();
		$('#itemgroup_input').jqxInput('source', MC.Suggest.groups);
		$('#itemcomment1_input').jqxInput('source', MC.Suggest.comment1);
		$('#itemcomment2_input').jqxInput('source', MC.Suggest.comment2);
		$('#itemcomment3_input').jqxInput('source', MC.Suggest.comment3);
		$("#itemListBox").jqxListBox('selectItem', temp_item);
		MC.item_selecting = false;
	});

	MC.hide("item_message")
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
	$("#filter_norecipe_check").jqxCheckBox({height: 25, width: 100, hasThreeStates: true, checked: null});
	$("#filter_fixedprice_check").jqxCheckBox({height: 25, width: 100, hasThreeStates: true, checked: null});
	$("#filter_pricefrom_numinput").jqxNumberInput({height: 25, width: 60, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 0});
	$("#filter_priceto_numinput").jqxNumberInput({height: 25, width: 60, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 0, max: 6400});
	$("#filter_maxCountfrom_numinput").jqxNumberInput({height: 25, width: 60, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 0});
	$("#filter_maxCountto_numinput").jqxNumberInput({height: 25, width: 60, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 0});
	$('#filter_okButton').jqxButton({ width: '180px', disabled: false });
	$('#filter_okButton').on('click', function(){MC.itemfilter(false)});
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
		$("#filter_norecipe_check").jqxCheckBox({checked: null});
		$("#filter_fixedprice_check").jqxCheckBox({checked: null});
		$("#filter_pricefrom_numinput").val("0");
		$("#filter_priceto_numinput").val("0");
		$("#filter_maxCountfrom_numinput").val("0");
		$("#filter_maxCountto_numinput").val("0");

		MC.itemfilter();
	});

	$('#setALL_what').jqxDropDownList({source: MC.setALL_source[1], width: 110, height: 25 });
	$('#setALL_what').on('select', function(){
		MC.hide_SetALL()
		var index = $('#setALL_what').jqxDropDownList('getSelectedIndex');
		var temp = "_check"
		if ( index < 5 ) { temp = "_input" }
		else if ( index > 10 ) { temp = "_numinput" }
		MC.show("setALL_" + MC.setALL_source[0][index] + temp)
	});
	
	$('#setALL_group_input').jqxInput({source: MC.Suggest.groups, placeHolder: "Enter group...", height: 25, width: 200, minLength: 1});
	$('#setALL_comment1_input').jqxInput({source: MC.Suggest.comment1, placeHolder: "Enter comment...", height: 25, width: 200, minLength: 1});
	$('#setALL_comment2_input').jqxInput({source: MC.Suggest.comment2, placeHolder: "Enter comment...", height: 25, width: 200, minLength: 1});
	$('#setALL_comment3_input').jqxInput({source: MC.Suggest.comment3, placeHolder: "Enter comment...", height: 25, width: 200, minLength: 1});
	$("#setALL_trader_input").jqxInput({source: MC.Traders, placeHolder: "Enter trader...", height: 25, width: 200, minLength: 1});
	$("#setALL_selling_check").jqxCheckBox({height: 25, width: 200, checked: true});
	$("#setALL_buying_check").jqxCheckBox({height: 25, width: 200, checked: true});
	$("#setALL_chisel_check").jqxCheckBox({height: 25, width: 200, checked: true});
	$("#setALL_bit_check").jqxCheckBox({height: 25, width: 200, checked: true});
	$("#setALL_hasPattern_check").jqxCheckBox({height: 25, width: 200, checked: true});
	$("#setALL_fixedprice_check").jqxCheckBox({height: 25, width: 200, checked: true});
	$("#setALL_price_numinput").jqxNumberInput({height: 25, width: 200, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 0, max: 6400});
	$("#setALL_maxCount_numinput").jqxNumberInput({height: 25, width: 200, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 0});
	$("#setALL_craftCount_numinput").jqxNumberInput({height: 25, width: 200, spinButtons: true, decimalDigits: 0, inputMode: "simple", min: 0, max: 64});
	
	$('#setALL_okButton').jqxButton({ width: '180px', disabled: false });
	$('#setALL_okButton').on('click', function(){
		var index = $('#setALL_what').jqxDropDownList('getSelectedIndex')
		var temp = "_check"
		if ( index < 5 ) { temp = "_input" }
		else if ( index > 10 ) { temp = "_numinput";}
		var valnew = $("#setALL_" + MC.setALL_source[0][index] + temp).val()
		if ( index > 10 ) { valnew = parseInt(valnew) }
		MC.setForAll(MC.setALL_source[0][index].replace("omment",""), MC.Listing.itemListBox, valnew);
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
			if ( MC.timer.recipe != null ) {
				clearTimeout(MC.timer.recipe)
			}
			MC.timer.recipe = setTimeout(function(){ MC.hide("recipe_message") }, 10000);
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
			if ( MC.timer.recipe != null ) {
				clearTimeout(MC.timer.recipe)
			}
			MC.timer.recipe = setTimeout(function(){ MC.hide("recipe_message") }, 10000);
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
				$("#itemListBox").jqxListBox('selectItem', $("#itemListBox").jqxListBox('getSelectedItem'));
				$("#recipe_message")[0].style.color = "green"
				$("#recipe_message")[0].innerHTML = "Recipe copied successfully from: " + itemid
				MC.hide("cr_group");
				$("#cr_modbox").val("");
				$("#cr_itembox").val("");
				$("#cr_dmg").val("0");
				$("#cr_variant").val("0");
			}
			else{
				$("#recipe_message")[0].style.color = "red"
				$("#recipe_message")[0].innerHTML = "Cant copy recipe, item not valid: " + itemid
			}
			MC.show("recipe_message");
			if ( MC.timer.recipe != null ) {
				clearTimeout(MC.timer.recipe)
			}
			MC.timer.recipe = setTimeout(function(){ MC.hide("recipe_message") }, 10000);
		}
	});

	MC.go.Mod("");
});

/*OTHER

var ingots={               
"Thermal Foundation":[  
"Aluminium", thermalfoundation_jj_material_jj_132
"Electrum", thermalfoundation_jj_material_jj_161
"Invar", thermalfoundation_jj_material_jj_162
"Constantan", thermalfoundation_jj_material_jj_164
"Lumium", thermalfoundation_jj_material_jj_166
"Signalum", thermalfoundation_jj_material_jj_165
"Mithril", thermalfoundation_jj_material_jj_136
"Enderium", thermalfoundation_jj_material_jj_167
"Platinum", thermalfoundation_jj_material_jj_134
"Iridium" thermalfoundation_jj_material_jj_135
],  
"Base Metals":[ 
"Nickel", basemetals_jj_nickel_ingot
//"Zinc",
//"Platinum",
"ColdIron", basemetals_jj_coldiron_ingot
"Aquarium", basemetals_jj_aquarium_ingot
"Adamant", basemetals_jj_adamantine_ingot
"Starsteel", basemetals_jj_starsteel_ingot
"Bismuth", basemetals_jj_bismuth_ingot
"Antimon", basemetals_jj_antimony_ingot
"Redstone", basemetals_jj_redstone_ingot
"Obsidian" basemetals_jj_obsidian_ingot
],  
Minecraft:[ 
"Gold", minecraft_jj_gold_ingot
"Iron" minecraft_jj_iron_ingot
],  
"Modern Metals":[   
//"Aluminium",
"Magnesium", modernmetals_jj_magnesium_ingot
//"Iridium",
"Uranium", modernmetals_jj_uranium_ingot
//"Osmium",
"Zircomium", modernmetals_jj_zirconium_ingot
"Rutile", modernmetals_jj_rutile_ingot
"Tantal", modernmetals_jj_tantalum_ingot
"Mangan", modernmetals_jj_manganese_ingot
"Cadmium", modernmetals_jj_cadmium_ingot
"Wolfram", modernmetals_jj_tungsten_ingot
"Plutonium", modernmetals_jj_plutonium_ingot
"Chrom", modernmetals_jj_chromium_ingot
"Titanium" modernmetals_jj_titanium_ingot
],  
Mekanism:[  
//"Copper",
//"Tin",
"Osmium", mekanism_jj_ingot_jj_1
"RefinedObsidian", mekanism_jj_ingot
"RefinedGlowstone" mekanism_jj_ingot_jj_3
],  
"IndustrialCraft 2":[   
"Lead", ic2_jj_ingot_jj_3
"Silver", ic2_jj_ingot_jj_4
"Copper", ic2_jj_ingot_jj_2
"Bronze", ic2_jj_ingot_jj_1
"Tin", ic2_jj_ingot_jj_6
"Steel", ic2_jj_ingot_jj_5
],  
Tinkers:[   
"Alubrass", tconstruct_jj_ingots_jj_5
"Cobalt", tconstruct_jj_ingots
"Knightslime", tconstruct_jj_ingots_jj_3
"Ardit", tconstruct_jj_ingots_jj_1
"Manyullyn" tconstruct_jj_ingots_jj_2
],  
"Tech Reborn":[ 
//"Tin",
"Zinc", techreborn_jj_ingot_jj_18
"Brass", techreborn_jj_ingot_jj_1
"Tungsten", techreborn_jj_ingot_jj_15
"Chrome", techreborn_jj_ingot_jj_3
//"Titanium"  
],  
NuclearCraft:[  
"Yellorium", bigreactors_jj_ingotmetals
//"Uranium"
]
}

var ingotequal = {};
$.each(Object.keys(ingots), function (mod_i, mod_key) {
	$.each(ingots[mod_key], function (item_i, item) {
		$.each(Object.keys(ingots), function (mod_i2, mod_key2) {
			if(!mod_key.equals(mod_key2)){
				$.each(ingots[mod_key2], function (item_i2, item2) {
					if(item.equals(item2)){
						if(ingotequal[item] == null){
							ingotequal[item] = []
						}
						if(!mod_key.equals(ingotequal[item])){
							ingotequal[item].push(mod_key)
						}
						if(!mod_key2.equals(ingotequal[item])){
							ingotequal[item].push(mod_key2)
						}
					}
				})
			}
		})
	})
})
$.each(ingotequal, function (i, ing) {
	var str = "Ingot: " + i + " is in: "
	$.each(ing, function (j, mod) {
		str += mod + ", "
	})
	console.log(str.substring(0, str.length - 2))
})

Aluminium: [ "Thermal Foundation", "Modern Metals" ] --> thermal
Copper: [ "Mekanism", "IndustrialCraft 2" ] --> ic2
Iridium: [ "Thermal Foundation", "Modern Metals" ] --> thermal
Osmium: [ "Modern Metals", "Mekanism" ] --> meka
Platinum: [ "Thermal Foundation", "Base Metals" ] --> thermal
Tin: [ "Mekanism", "IndustrialCraft 2", "Tech Reborn" ] --> ic2
Uranium: [ "Modern Metals", "IndustrialCraft 2", "NuclearCraft" ] --> modern
Zinc: [ "Base Metals", "Tech Reborn" ] --> tech

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

var list2 = ["forestry_jj_ingot_bronze",
"minecraft_jj_wooden_slab",
"forestry_jj_ash",
"forestry_jj_bee_combs",
"forestry_jj_ingot_tin",
"forestry_jj_ingot_copper",
"forestry_jj_gear_bronze",
"forestry_jj_gear_copper",
"forestry_jj_gear_tin",
"minecraft_jj_trapdoor",
"basemetals_jj_stone_gear",
"minecraft_jj_glass_pane"]

0: "ore_jj_plateSteel"
1: "ore_jj_ingotCopper"
2: "ore_jj_ingotAluminum"
3: "ore_jj_fabricHemp"
4: "ore_jj_slabTreatedWood"
5: "ore_jj_paneGlass"
6: "ore_jj_ingotSteel"
7: "ore_jj_stickSteel"
8: "ore_jj_scaffoldingSteel"
9: "ore_jj_stickIron"
10: "ore_jj_plateAluminum"
11: "ore_jj_plateIron"
12: "ore_jj_plankTreatedWood"
13: "ore_jj_stickTreatedWood"
14: "ore_jj_plateCopper"
15: "ore_jj_plateElectrum"
16: "ore_jj_fiberHemp"
17: "ore_jj_ingotElectrum"
18: "ore_jj_stickAluminum"
19: "ore_jj_bricksStone"
20: "ore_jj_fenceSteel"
21: "ore_jj_wireSteel"
22: "ore_jj_ingotLead"
23: "ore_jj_blockSheetmetalIron"
24: "ore_jj_wireCopper"
25: "ore_jj_wireAluminum"
26: "ore_jj_fenceTreatedWood"



0: "ore_jj_dustDiamond"
1: "ore_jj_ingotBronze"
2: "ore_jj_ingotCopper"
3: "ore_jj_ingotSteel"
4: "ore_jj_circuitElite"
5: "ore_jj_circuitBasic"
6: "ore_jj_circuitAdvanced"
7: "ore_jj_circuitUltimate"
8: "ore_jj_alloyBasic"
9: "ore_jj_paneGlass"
10: "ore_jj_ingotRefinedObsidian"
11: "ore_jj_ingotRefinedGlowstone"
12: "ore_jj_ingotOsmium"
13: "ore_jj_alloyAdvanced"
14: "ore_jj_alloyElite"
15: "ore_jj_alloyUltimate"
16: "ore_jj_dustPetrotheum"
17: "ore_jj_oreOsmium"
18: "ore_jj_dustGold"
19: "ore_jj_dustIron"
20: "ore_jj_dustOsmium"
21: "ore_jj_ingotTin"

var list2 = ["mekanism_jj_otherdust",
"mekanism_jj_ingot_jj_2",
"mekanism_jj_ingot_jj_5",
"mekanism_jj_ingot_jj_4",
"mekanism_jj_controlcircuit_jj_2",
"mekanism_jj_controlcircuit",
"mekanism_jj_controlcircuit_jj_1",
"mekanism_jj_controlcircuit_jj_3",
"",
"minecraft_jj_glass_pane",
"mekanism_jj_ingot",
"mekanism_jj_ingot_jj_3",
"mekanism_jj_ingot_jj_1",
"mekanism_jj_enrichedalloy",
"mekanism_jj_reinforcedalloy",
"mekanism_jj_atomicalloy",
"",
"",
"mekanism_jj_dust_jj_1",
"mekanism_jj_dust",
"mekanism_jj_dust_jj_2",
"mekanism_jj_ingot_jj_6"]


0: "ore_jj_blockAluminum"
1: "ore_jj_blockAluminumbrass"
2: "ore_jj_blockBeryllium"
3: "ore_jj_blockBoron"
4: "ore_jj_blockCadmium"
5: "ore_jj_blockChromium"
6: "ore_jj_blockGalvanizedsteel"
7: "ore_jj_blockIridium"
8: "ore_jj_blockMagnesium"
9: "ore_jj_blockManganese"
10: "ore_jj_blockNichrome"
11: "ore_jj_blockOsmium"
12: "ore_jj_blockPlutonium"
13: "ore_jj_blockRutile"
14: "ore_jj_blockStainlesssteel"
15: "ore_jj_blockTantalum"
16: "ore_jj_blockThorium"
17: "ore_jj_blockTitanium"
18: "ore_jj_blockTungsten"
19: "ore_jj_blockUranium"
20: "ore_jj_blockZirconium"
21: "ore_jj_dustPetrotheum"
22: "ore_jj_dustPyrotheum"
23: "ore_jj_dustRutile"
24: "ore_jj_ingotAluminum"
25: "ore_jj_ingotAluminumbrass"
26: "ore_jj_ingotBeryllium"
27: "ore_jj_ingotBoron"
28: "ore_jj_ingotCadmium"
29: "ore_jj_ingotChromium"
30: "ore_jj_ingotGalvanizedsteel"
31: "ore_jj_ingotIridium"
32: "ore_jj_ingotMagnesium"
33: "ore_jj_ingotManganese"
34: "ore_jj_ingotNichrome"
35: "ore_jj_ingotOsmium"
36: "ore_jj_ingotPlutonium"
37: "ore_jj_ingotRutile"
38: "ore_jj_ingotStainlesssteel"
39: "ore_jj_ingotTantalum"
40: "ore_jj_ingotThorium"
41: "ore_jj_ingotTitanium"
42: "ore_jj_ingotTungsten"
43: "ore_jj_ingotUranium"
44: "ore_jj_ingotZirconium"
45: "ore_jj_nuggetAluminum"
46: "ore_jj_nuggetAluminumbrass"
47: "ore_jj_nuggetBeryllium"
48: "ore_jj_nuggetBoron"
49: "ore_jj_nuggetCadmium"
50: "ore_jj_nuggetChromium"
51: "ore_jj_nuggetGalvanizedsteel"
52: "ore_jj_nuggetIridium"
53: "ore_jj_nuggetMagnesium"
54: "ore_jj_nuggetManganese"
55: "ore_jj_nuggetNichrome"
56: "ore_jj_nuggetOsmium"
57: "ore_jj_nuggetPlutonium"
58: "ore_jj_nuggetRutile"
59: "ore_jj_nuggetStainlesssteel"
60: "ore_jj_nuggetTantalum"
61: "ore_jj_nuggetThorium"
62: "ore_jj_nuggetTitanium"
63: "ore_jj_nuggetTungsten"
64: "ore_jj_nuggetUranium"
65: "ore_jj_nuggetZirconium"
66: "ore_jj_oreCadmium"
67: "ore_jj_rodAluminum"
68: "ore_jj_rodAluminumbrass"
69: "ore_jj_rodBeryllium"
70: "ore_jj_rodBoron"
71: "ore_jj_rodCadmium"
72: "ore_jj_rodChromium"
73: "ore_jj_rodGalvanizedsteel"
74: "ore_jj_rodIridium"
75: "ore_jj_rodMagnesium"
76: "ore_jj_rodManganese"
77: "ore_jj_rodNichrome"
78: "ore_jj_rodOsmium"
79: "ore_jj_rodPlutonium"
80: "ore_jj_rodRutile"
81: "ore_jj_rodStainlesssteel"
82: "ore_jj_rodTantalum"
83: "ore_jj_rodThorium"
84: "ore_jj_rodTitanium"
85: "ore_jj_rodTungsten"
86: "ore_jj_rodUranium"
87: "ore_jj_rodZirconium"

var list2 = ["modernmetals_jj_aluminum_block",
"modernmetals_jj_aluminumbrass_block",
"modernmetals_jj_beryllium_block",
"modernmetals_jj_boron_block",
"modernmetals_jj_cadmium_block",
"modernmetals_jj_chromium_block",
"modernmetals_jj_galvanizedsteel_block",
"modernmetals_jj_iridium_block",
"modernmetals_jj_magnesium_block",
"modernmetals_jj_manganese_block",
"modernmetals_jj_nichrome_block",
"modernmetals_jj_osmium_block",
"modernmetals_jj_plutonium_block",
"modernmetals_jj_rutile_block",
"modernmetals_jj_stainlesssteel_block",
"modernmetals_jj_tantalum_block",
"modernmetals_jj_thorium_block",
"modernmetals_jj_titanium_block",
"modernmetals_jj_tungsten_block",
"modernmetals_jj_uranium_block",
"modernmetals_jj_zirconium_block",
"",
"",
"",
"modernmetals_jj_aluminum_ingot",
"modernmetals_jj_aluminumbrass_ingot",
"modernmetals_jj_beryllium_ingot",
"modernmetals_jj_boron_ingot",
"modernmetals_jj_cadmium_ingot",
"modernmetals_jj_chromium_ingot",
"modernmetals_jj_galvanizedsteel_ingot",
"modernmetals_jj_iridium_ingot",
"modernmetals_jj_magnesium_ingot",
"modernmetals_jj_manganese_ingot",
"modernmetals_jj_nichrome_ingot",
"modernmetals_jj_osmium_ingot",
"modernmetals_jj_plutonium_ingot",
"modernmetals_jj_rutile_ingot",
"modernmetals_jj_stainlesssteel_ingot",
"modernmetals_jj_tantalum_ingot",
"modernmetals_jj_thorium_ingot",
"modernmetals_jj_titanium_ingot",
"modernmetals_jj_tungsten_ingot",
"modernmetals_jj_uranium_ingot",
"modernmetals_jj_zirconium_ingot",
"modernmetals_jj_aluminum_nugget",
"modernmetals_jj_aluminumbrass_nugget",
"modernmetals_jj_beryllium_nugget",
"modernmetals_jj_boron_nugget",
"modernmetals_jj_cadmium_nugget",
"modernmetals_jj_chromium_nugget",
"modernmetals_jj_galvanizedsteel_nugget",
"modernmetals_jj_iridium_nugget",
"modernmetals_jj_magnesium_nugget",
"modernmetals_jj_manganese_nugget",
"modernmetals_jj_nichrome_nugget",
"modernmetals_jj_osmium_nugget",
"modernmetals_jj_plutonium_nugget",
"modernmetals_jj_rutile_nugget",
"modernmetals_jj_stainlesssteel_nugget",
"modernmetals_jj_tantalum_nugget",
"modernmetals_jj_thorium_nugget",
"modernmetals_jj_titanium_nugget",
"modernmetals_jj_tungsten_nugget",
"modernmetals_jj_uranium_nugget",
"modernmetals_jj_zirconium_nugget",
"",
"modernmetals_jj_aluminum_rod",
"modernmetals_jj_aluminumbrass_rod",
"modernmetals_jj_beryllium_rod",
"modernmetals_jj_boron_rod",
"modernmetals_jj_cadmium_rod",
"modernmetals_jj_chromium_rod",
"modernmetals_jj_galvanizedsteel_rod",
"modernmetals_jj_iridium_rod",
"modernmetals_jj_magnesium_rod",
"modernmetals_jj_manganese_rod",
"modernmetals_jj_nichrome_rod",
"modernmetals_jj_osmium_rod",
"modernmetals_jj_plutonium_rod",
"modernmetals_jj_rutile_rod",
"modernmetals_jj_stainlesssteel_rod",
"modernmetals_jj_tantalum_rod",
"modernmetals_jj_thorium_rod",
"modernmetals_jj_titanium_rod",
"modernmetals_jj_tungsten_rod",
"modernmetals_jj_uranium_rod",
"modernmetals_jj_zirconium_rod"]

0: "ore_jj_dustPetrotheum"
1: "ore_jj_ingotAoci"
2: "ore_jj_ingotAryxi"
3: "ore_jj_ingotBydoom"
4: "ore_jj_ingotDuxirete"
5: "ore_jj_ingotJosawriline"
6: "ore_jj_ingotMurol"
7: "ore_jj_ingotOdeznum"
8: "ore_jj_ingotOivi"
9: "ore_jj_ingotPetuxo"
10: "ore_jj_ingotRo"
11: "ore_jj_ingotSusimen"
12: "ore_jj_ingotUamaf"
13: "ore_jj_ingotUokuwixasi"
14: "ore_jj_oreAurine"
15: "ore_jj_oreAyzanite"
16: "ore_jj_oreDraxate"
17: "ore_jj_oreEukavoynt"
18: "ore_jj_oreIturite"
19: "ore_jj_oreNodemite"
20: "ore_jj_oreSivenium"

var list2 = ["",
"mores_jj_aoci_ingot",
"mores_jj_aryxi_ingot",
"mores_jj_bydoom_ingot",
"mores_jj_duxirete_ingot",
"mores_jj_josawriline_ingot",
"mores_jj_murol_ingot",
"mores_jj_odeznum_ingot",
"mores_jj_oivi_ingot",
"mores_jj_petuxo_ingot",
"mores_jj_ro_ingot",
"mores_jj_susimen_ingot",
"mores_jj_uamaf_ingot",
"mores_jj_uokuwixasi_ingot",
"mores_jj_aurine_ore",
"mores_jj_ayzanite_ore",
"mores_jj_draxate_ore",
"mores_jj_eukavoynt_ore",
"mores_jj_iturite_ore",
"mores_jj_nodemite_ore",
"mores_jj_sivenium_ore"]


0: "chisel_jj_limestone2_jj_7"
1: "minecraft_jj_iron_ingotwood"
2: "minecraft_jj_quartzBlack"
3: "ore_jj_crystalCertusQuartz"
4: "ore_jj_crystalFluix"
5: "ore_jj_dustSaltpeter"
6: "ore_jj_dustSulfur"
7: "ore_jj_gemAmber"
8: "ore_jj_gemApatite"
9: "ore_jj_gemMalachite"
10: "ore_jj_gemPeridot"
11: "ore_jj_gemRuby"
12: "ore_jj_gemSapphire"
13: "ore_jj_gemTanzanite"
14: "ore_jj_gemTopaz"
15: "ore_jj_ingotAdamantine"
16: "ore_jj_ingotAluminum"
17: "ore_jj_ingotAquarium"
18: "ore_jj_ingotBrass"
19: "ore_jj_ingotBronze"
20: "ore_jj_ingotChrome"
21: "ore_jj_ingotColdiron"
22: "ore_jj_ingotConstantan"
23: "ore_jj_ingotCopper"
24: "ore_jj_ingotElectrum"
25: "ore_jj_ingotEnderium"
26: "ore_jj_ingotFiery"
27: "ore_jj_ingotInvar"
28: "ore_jj_ingotIridium"
29: "ore_jj_ingotKnightmetal"
30: "ore_jj_ingotLead"
31: "ore_jj_ingotLumium"
32: "ore_jj_ingotMithril"
33: "ore_jj_ingotNickel"
34: "ore_jj_ingotOsmium"
35: "ore_jj_ingotPlatinum"
36: "ore_jj_ingotRefinedGlowstone"
37: "ore_jj_ingotRefinedObsidian"
38: "ore_jj_ingotSignalum"
39: "ore_jj_ingotSilver"
40: "ore_jj_ingotStarsteel"
41: "ore_jj_ingotSteel"
42: "ore_jj_ingotSteeleaf"
43: "ore_jj_ingotTin"
44: "ore_jj_ingotTitanium"
45: "ore_jj_ingotTungsten"
46: "ore_jj_ingotUranium"
47: "ore_jj_ingotYellorium"
48: "ore_jj_ingotZinc"
49: "ore_jj_itemRubber"
50: "ore_jj_itemSilicon"
51: "ore_jj_rodBasalz"
52: "ore_jj_rodBlitz"
53: "ore_jj_rodBlizz"
54: "ore_jj_workbench"

var list2 = ["",
"",
"",
"appliedenergistics2_jj_material",
"appliedenergistics2_jj_material_jj_7",
"thermalfoundation_jj_material_jj_772",
"ic2_jj_dust_jj_16",
"biomesoplenty_jj_gem_jj_7",
"forestry_jj_apatite",
"biomesoplenty_jj_gem_jj_5",
"biomesoplenty_jj_gem_jj_2",
"biomesoplenty_jj_gem_jj_1",
"biomesoplenty_jj_gem_jj_6",
"biomesoplenty_jj_gem_jj_4",
"biomesoplenty_jj_gem_jj_3",
"basemetals_jj_adamantine_ingot",
"thermalfoundation_jj_material_jj_132",
"basemetals_jj_aquarium_ingot",
"techreborn_jj_ingot_jj_1",
"ic2_jj_ingot_jj_1",
"techreborn_jj_ingot_jj_3",
"basemetals_jj_coldiron_ingot",
"thermalfoundation_jj_material_jj_164",
"ic2_jj_ingot_jj_2",
"thermalfoundation_jj_material_jj_161",
"thermalfoundation_jj_material_jj_167",
"twilightforest_jj_fiery_ingot",
"thermalfoundation_jj_material_jj_162",
"thermalfoundation_jj_material_jj_135",
"twilightforest_jj_knightmetal_ingot",
"ic2_jj_ingot_jj_3",
"thermalfoundation_jj_material_jj_166",
"thermalfoundation_jj_material_jj_136",
"basemetals_jj_nickel_ingot",
"mekanism_jj_ingot_jj_1",
"thermalfoundation_jj_material_jj_134",
"mekanism_jj_ingot_jj_3",
"mekanism_jj_ingot",
"thermalfoundation_jj_material_jj_165",
"ic2_jj_ingot_jj_4",
"basemetals_jj_starsteel_ingot",
"ic2_jj_ingot_jj_5",
"twilightforest_jj_steeleaf_ingot",
"ic2_jj_ingot_jj_6",
"modernmetals_jj_titanium_ingot",
"techreborn_jj_ingot_jj_15",
"modernmetals_jj_uranium_ingot",
"bigreactors_jj_ingotmetals",
"techreborn_jj_ingot_jj_18",
"ic2_jj_crafting",
"appliedenergistics2_jj_material_jj_5",
"thermalfoundation_jj_material_jj_2052",
"thermalfoundation_jj_material_jj_2050",
"thermalfoundation_jj_material_jj_2048",
"minecraft_jj_crafting_table"]


0: "ore_jj_blockDepletedUranium"
1: "ore_jj_dustGraphite"
2: "ore_jj_dustObsidian"
3: "ore_jj_dustPetrotheum"
4: "ore_jj_dustPyrotheum"
5: "ore_jj_dustQuartz"
6: "ore_jj_gemBoronNitride"
7: "ore_jj_ingotAmericium242"
8: "ore_jj_ingotAmericium242Oxide"
9: "ore_jj_ingotAmericium243"
10: "ore_jj_ingotBerkelium247"
11: "ore_jj_ingotBerkelium248"
12: "ore_jj_ingotBerkelium248Oxide"
13: "ore_jj_ingotBeryllium"
14: "ore_jj_ingotBoron"
15: "ore_jj_ingotBronze"
16: "ore_jj_ingotCalifornium249"
17: "ore_jj_ingotCalifornium249Oxide"
18: "ore_jj_ingotCalifornium251"
19: "ore_jj_ingotCalifornium251Oxide"
20: "ore_jj_ingotCalifornium252"
21: "ore_jj_ingotCopper"
22: "ore_jj_ingotCurium243"
23: "ore_jj_ingotCurium243Oxide"
24: "ore_jj_ingotCurium245"
25: "ore_jj_ingotCurium245Oxide"
26: "ore_jj_ingotCurium246"
27: "ore_jj_ingotCurium247"
28: "ore_jj_ingotCurium247Oxide"
29: "ore_jj_ingotGraphite"
30: "ore_jj_ingotHardCarbon"
31: "ore_jj_ingotLead"
32: "ore_jj_ingotMagnesium"
33: "ore_jj_ingotNeptunium236"
34: "ore_jj_ingotNeptunium236Oxide"
35: "ore_jj_ingotNeptunium237"
36: "ore_jj_ingotPlutonium239"
37: "ore_jj_ingotPlutonium239Oxide"
38: "ore_jj_ingotPlutonium241"
39: "ore_jj_ingotPlutonium241Oxide"
40: "ore_jj_ingotPlutonium242"
41: "ore_jj_ingotThorium232Oxide"
42: "ore_jj_ingotTin"
43: "ore_jj_ingotTough"
44: "ore_jj_ingotUranium233"
45: "ore_jj_ingotUranium233Oxide"
46: "ore_jj_ingotUranium235"
47: "ore_jj_ingotUranium235Oxide"
48: "ore_jj_ingotUranium238"
49: "ore_jj_ingotZirconium"
50: "ore_jj_oreBeryllium"
51: "ore_jj_oreMagnesium"
52: "ore_jj_plateAdvanced"
53: "ore_jj_plateBasic"
54: "ore_jj_plateDU"
55: "ore_jj_plateElite"
56: "ore_jj_record"
57: "ore_jj_solenoidCopper"
58: "ore_jj_solenoidMagnesiumDiboride"


var list2 = ["nuclearcraft_jj_block_depleted_uranium",
"nuclearcraft_jj_dust_jj_8",
"nuclearcraft_jj_gem_dust_jj_3",
"",
"",
"nuclearcraft_jj_gem_dust_jj_2",
"nuclearcraft_jj_gem_jj_1",
"nuclearcraft_jj_americium_jj_4",
"nuclearcraft_jj_americium_jj_5",
"nuclearcraft_jj_americium_jj_8",
"nuclearcraft_jj_berkelium",
"nuclearcraft_jj_berkelium_jj_4",
"nuclearcraft_jj_berkelium_jj_5",
"nuclearcraft_jj_ingot_jj_9",
"nuclearcraft_jj_ingot_jj_5",
"nuclearcraft_jj_alloy",
"nuclearcraft_jj_californium",
"nuclearcraft_jj_californium_jj_1",
"nuclearcraft_jj_californium_jj_8",
"nuclearcraft_jj_californium_jj_9",
"nuclearcraft_jj_californium_jj_12",
"nuclearcraft_jj_ingot",
"nuclearcraft_jj_curium",
"nuclearcraft_jj_curium_jj_1",
"nuclearcraft_jj_curium_jj_4",
"nuclearcraft_jj_curium_jj_5",
"nuclearcraft_jj_curium_jj_8",
"nuclearcraft_jj_curium_jj_12",
"nuclearcraft_jj_curium_jj_13",
"nuclearcraft_jj_ingot_jj_8",
"nuclearcraft_jj_alloy_jj_2",
"nuclearcraft_jj_ingot_jj_2",
"nuclearcraft_jj_ingot_jj_7",
"nuclearcraft_jj_neptunium",
"nuclearcraft_jj_neptunium_jj_1",
"nuclearcraft_jj_neptunium_jj_4",
"nuclearcraft_jj_plutonium_jj_4",
"nuclearcraft_jj_plutonium_jj_5",
"nuclearcraft_jj_plutonium_jj_8",
"nuclearcraft_jj_plutonium_jj_9",
"nuclearcraft_jj_plutonium_jj_12",
"nuclearcraft_jj_thorium_jj_5",
"nuclearcraft_jj_ingot_jj_1",
"nuclearcraft_jj_alloy_jj_1",
"nuclearcraft_jj_uranium",
"nuclearcraft_jj_uranium_jj_1",
"nuclearcraft_jj_uranium_jj_4",
"nuclearcraft_jj_uranium_jj_5",
"nuclearcraft_jj_uranium_jj_8",
"nuclearcraft_jj_ingot_jj_10",
"modernmetals_jj_beryllium_ore",
"nuclearcraft_jj_ore_jj_7",
"nuclearcraft_jj_part_jj_1",
"nuclearcraft_jj_part",
"nuclearcraft_jj_part_jj_2",
"nuclearcraft_jj_part_jj_3",
"",
"",
""]



$.each(list, function (j, item) {
	if ( list2[j] != null ) {
		if(!list2[j].equals("")){
			MC.changeRecipeItem("nuclearcraft", item, list2[j])
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

MC.changeRecipeItem("buildcraftfactory", "ore_jj_gearStone", "buildcraftcore_jj_gearStone")
MC.changeRecipeItem("buildcraftfactory", "ore_jj_gearDiamond", "buildcraftcore_jj_gear_diamond")
MC.changeRecipeItem("buildcraftfactory", "ore_jj_gearIron", "buildcraftcore_jj_gear_iron")
MC.changeRecipeItem("buildcraftsilicon", "ore_jj_gearDiamond", "buildcraftcore_jj_gear_diamond")

MC.changeRecipeItem("cyclicmagic", "minecraft_jj_Iron_nugget", "minecraft_jj_iron_nugget")
MC.changeRecipeItem("cyclicmagic", "ore_jj_workbench", "minecraft_jj_crafting_table")
MC.changeRecipeItem("cyclicmagic", "ore_jj_gemEmerald", "minecraft_jj_emerald")
MC.changeRecipeItem("cyclicmagic", "ore_jj_blockCoal", "minecraft_jj_coal_block")
MC.changeRecipeItem("cyclicmagic", "minecraft_jj_tallgrass", "minecraft_jj_tallgrass_jj_1")
MC.changeRecipeItem("cyclicmagic", "ore_jj_chestEnder", "minecraft_jj_ender_chest")

MC.changeRecipeItem("defiledlands", "ore_jj_gemHephaestite", "defiledlands_jj_hephaestite")
MC.changeRecipeItem("defiledlands", "ore_jj_ingotUmbrium", "defiledlands_jj_umbrium_ingot")
MC.changeRecipeItem("defiledlands", "ore_jj_gemScarlite", "defiledlands_jj_scarlite")
MC.changeRecipeItem("defiledlands", "ore_jj_stoneDefiled", "defiledlands_jj_stone_defiled")
MC.changeRecipeItem("defiledlands", "ore_jj_essenceDestroyer", "defiledlands_jj_essence_destroyer")
MC.changeRecipeItem("defiledlands", "ore_jj_ingotRavaging", "defiledlands_jj_ravaging_ingot")


normal
$('#mainSplitter').jqxSplitter({  width: 1278, height: 900, panels: [{ size: 300, min: 100 }, {min: 200, size: 300}] });
$('#contentSplitter').jqxSplitter({ width: '100%', height: '100%', panels: [{ size: 500, min: 100, collapsible: false }, { min: 100, collapsible: true}] });
	
lappy
$('#mainSplitter').jqxSplitter({  width: 1598, height: 718, panels: [{ size: 300, min: 300 }, {min: 300, size: 300}] });
$('#contentSplitter').jqxSplitter({ width: '100%', height: '100%', panels: [{ size: 620, min: 300, collapsible: false }, { min: 300, collapsible: true}] });

*/