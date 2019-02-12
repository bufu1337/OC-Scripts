//var fs = require('fs');
var dataAdapter = null;
var MC = {
	Mod: {},
	Trader: {},
	ItemNames: [],
	ResourceGroups: [],
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
	CalculateCosts: function(smod, sitem){
		$.each(Object.keys(MC.Mod), function (index, modname) {
			$.each(Object.keys(MC.Mod[modname].items), function (index, itemname) {
				var checkthis = true;
				var pricenomatter = false;
				if ( smod != null && sitem != null ){
					if ( !smod.equals(modname) || !sitem.equals(itemname) ){
						checkthis = false;	
					}
					else if ( smod.equals(modname) && sitem.equals(itemname) ){
						pricenomatter = true;
					}
				}
				if ( !MC.Mod[modname].items[itemname].fixedprice && checkthis && (MC.Mod[modname].items[itemname].price.equals("0") || pricenomatter)) {
					var overallprice = 100000;
					var count = 1;
					$.each(Object.keys(MC.Mod[modname].items[itemname].receipt), function (index, receipttable) {
						$.each(MC.Mod[modname].items[itemname].receipt[receipttable], function (index, receipt) {
							var can_calc = true;
							var price = 0;
							var minusprice = 0;
							$.each(Object.keys(receipt.IN), function (index, receiptitems) {
								$.each(receipt.IN[receiptitems].things, function (index, names) {
									var tempprice = MC.Mod[names.mod].items[names.item].price;
									var blocks = 1;
									if ( tempprice.equals("0") ) {
										can_calc = false;
									}
									else{
										if ( tempprice.endsWith("b") ) {
											tempprice = tempprice.split("b")[0];
											blocks = 9;
											//tempprice = parseInt() * 9 / MC.Mod[names.mod].items[names.item].count * parseInt(receipt.IN[receiptitems].count);
										}
										if ( tempprice.includes("/") ){
											tempprice = tempprice.split("/")[0];
										}
										var newprice = parseInt(tempprice) / MC.Mod[names.mod].items[names.item].count * parseInt(receipt.IN[receiptitems].count) * blocks;
										if ( price == 0 || newprice < price){
											price = newprice;
										}
									}
								});												
							});	
							$.each(Object.keys(receipt.OUT), function (index, receipt_outitems) {
								$.each(receipt.OUT[receipt_outitems].things, function (index, names) {
									if ( names.mod.equals(modname) && names.item.equals(itemname)) {
										price = price / receipt.OUT[receipt_outitems].count;
									}
									else{
										if ( MC.Mod[names.mod].items[names.item].price.equals("0") ) {
											can_calc = false;
										}
										if ( MC.Mod[names.mod].items[names.item].price.endsWith("b") ) {
											minusprice += parseInt(MC.Mod[names.mod].items[names.item].price.split("b")[0]) * 9 / MC.Mod[names.mod].items[names.item].count * parseInt(receipt.IN[receiptitems].count);
										}
										else{
											minusprice += parseInt(MC.Mod[names.mod].items[names.item].price) / MC.Mod[names.mod].items[names.item].count * parseInt(receipt.IN[receiptitems].count);
										}
									}
								});												
							});	
							if ( can_calc && overallprice > (price - minusprice)) {
								console.log("price");
								console.log(price);
								console.log("minusprice");
								console.log(minusprice);
								overallprice = price - minusprice;
								console.log("overallprice");
								console.log(overallprice);
							}
						});							
					});
					if ( overallprice != 100000 ) {
						console.log("overallprice.toString().includes");
						console.log(overallprice.toString().includes("\."));
						if ( overallprice.toString().includes("\.") ) {
							var oaprice = overallprice;
							while ( oaprice.toString().includes("\.") && oaprice < 576) {
								console.log("count: " + count);
								count++;
								oaprice = overallprice * count;
								console.log("oaprice: " + oaprice);
							}																			
							overallprice = oaprice;
						}
						if ( overallprice > 64 ) {
							overallprice = overallprice / 9;
							var oaprice2 = overallprice;
							var tempcount = 1;
							while ( oaprice2.toString().includes("\.") && oaprice2 < 64) {
								tempcount++;
								oaprice2 = overallprice * tempcount;
							}			
							count *	tempcount;	
							if ( count == 1 ) {
								MC.Mod[modname].items[itemname].price = oaprice.toString() + "b";
							}
							else{
								MC.Mod[modname].items[itemname].price = oaprice.toString() + "/" + count + "b";
							}
							MC.Mod[modname].items[itemname].count = count;
						}
						else{
							if ( count == 1 ) {
								MC.Mod[modname].items[itemname].price = overallprice.toString();
							}
							else{
								MC.Mod[modname].items[itemname].price = overallprice.toString() + "/" + count;
							}
							MC.Mod[modname].items[itemname].count = count;
						}
					}
				}
			});
		});
	},
	Definitions: {
		crafting_items: ["Werkbank"],
		receipt_io_count: 12
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
	hide: function(div_name){
		$("#" + div_name).css({visibility: "hidden", display: "none"});
	},
	show: function(div_name){
		$("#" + div_name).css({visibility: "visible", display: "block"});
	},
	sort:{ 
		Item: function(modname){
			var tempItems = {};
			var tempgroups = [];
			$.each(Object.keys(MC.Mod[modname].items), function (index, value) {
				tempgroups.push(MC.Mod[modname].items[value].group);
			});
			tempgroups.sort();
			var sortingarray = Object.keys(MC.Mod[modname].items).sort();
			$.each(tempgroups, function (index, value) {
				$.each(sortingarray, function (index2, value2) {
					if ( value.equals(MC.Mod[modname].items[value2].group) ) {
						tempItems[value2] = MC.Mod[modname].items[value2];
					}
				});
			});
			MC.Mod[modname].items = tempItems;
		},
		Items: function(){
			$.each(Object.keys(MC.Mod), function (index, value) {
				MC.sort.Item(value);
			});
		},
		Mod: function(){
			var tempMods = {};
			var sortingarray = Object.keys(MC.Mod).sort();
			$.each(sortingarray, function (index, value) {
				tempMods[value] = MC.Mod[value];
			});
			MC.Mod = tempMods;
		}
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
				$('#itemHeader').html("<b class='headerstyle'>Mod-Name: </b>" + modname + " <b class='headerstyle'>ISO:</b> " + MC.Mod[modname].iso + " <b class='headerstyle'>Item-Count:</b> " + Object.keys(MC.Mod[modname].items).length);
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
	

	$('#modwindow').jqxWindow({
		cancelButton: $('#modwindow_cancelButton'),	//Object …Sets or gets cancel button. When a cancel button is specified you can use this button to interact with the user. When any user press the cacel button window is going to be closed and the dialog result will be in the following format: { OK: false, Cancel: true, None: false }.
		draggable: false,	//Boolean …Sets or gets whether the window is draggable.
		height: 270,	//Number/String …Sets or gets the window's height.
		initContent: function() {
			$("#modname_input").jqxInput({placeHolder: "Enter a Mod name...", height: 25, width: 300, minLength: 1});
			$("#modiso_input").jqxInput({placeHolder: "Enter a Mod iso...", height: 25, width: 300, minLength: 1});
			$('#moddescription_area').jqxTextArea({ placeHolder: 'Enter a Mod description...', height: 90, width: 307, minLength: 1 });
			$('#modValidator').jqxValidator({
				rules: [
					{ input: '#modname_input', message: 'Modname is required!', action: 'keyup, blur', rule: 'required' },
					{ input: '#modname_input', message: 'Modname is already existing!', action: 'valueChanged', rule: function (input, commit) {
							var spliced_modlist = [];
							input = input[0].value;
							$.each(Object.keys(MC.Mod), function (index, value) {
								if ( !value.equals(MC.editing.Mod) ) {
									spliced_modlist.push(value);
								}
							});
							if ( (input.equals(Object.keys(MC.Mod)) && MC.mode.Mod.equals("add")) || (MC.mode.Mod.equals("edit") && input.equals(spliced_modlist)) ) {
								return false;
							}
							return true;
						}
					}
				]
			});
			$('#modValidator').on('validationSuccess', function(event) {//This event is triggered when the window is closed.
				if(MC.mode.Mod.equals("edit")){
					var newname = $('#modname_input').jqxInput('val');
					var tempMods = {};
					var tempItems = {};
					$.each(Object.keys(MC.Mod), function (index, value) {
						if ( !value.equals(MC.editing.Mod) ) {
							tempMods[value] = MC.Mod[value];
						}
						else{
							tempItems = MC.Mod[value].items;
						}
					});
					MC.Mod = tempMods;
					MC.Mod[newname] = {
						iso: $('#modiso_input').jqxInput('val'),
						description: $('#moddescription_area').jqxTextArea('val'),
						items: tempItems
					}
					MC.go.ModList();
		
					$.each($("#modListBox").jqxListBox('getItems'), function (index, value) {
						if ( newname.equals(value.label) ) {
							$("#modListBox").jqxListBox('unselectIndex', value.index);
							$("#modListBox").jqxListBox('selectIndex', value.index);
						}
					});
					if ( !MC.viewing.Item.isEmpty() ){
						$.each($("#itemListBox").jqxListBox('getItems'), function (index, value) {
							if ( MC.viewing.Item.equals(value.label) ) {
								$("#itemListBox").jqxListBox('selectIndex', value.index);
							}
						});
					}
				}
				else if(MC.mode.Mod.equals("add")){
					var newname = $('#modname_input').jqxInput('val');
					MC.Mod[newname] = {
						iso: $('#modiso_input').jqxInput('val'),
						description: $('#moddescription_area').jqxTextArea('val'),
						items: {}
					};
					MC.go.ModList();
					$.each($("#modListBox").jqxListBox('getItems'), function (index, value) {
						if ( newname.equals(value.label) ) {
							$("#modListBox").jqxListBox('selectIndex', value.index);
						}
					});
				}
				$('#modwindow').jqxWindow('close');
			});
			$('#modwindow_okButton').jqxButton({ width: '100px', disabled: false });
			$('#modwindow_okButton').on('click', function () {
				$('#modValidator').jqxValidator('validate');
			});
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
		//okButton: $('#modwindow_okButton'),	//Object …Sets or gets submit button. When a ok/submit button is specified you can use this button to interact with the user. When any user press the submit button window is going to be closed and the dialog result will be in the following format: { OK: true, Cancel: false, None: false }.
		resizable: false,	//Boolean …Enables or disables whether the end-user can resize the window.
		showCloseButton: false,	//Boolean …Sets or gets whether a close button will be visible.
		title: '',	//String …Sets or gets window's title content.
		width: 420,	//Number/String …Sets or gets the window's width.
		zIndex: 9001 //Number …Sets or gets the jqxWindow z-index.
	});
	$('#itemwindow').jqxWindow({
		cancelButton: $('#itemwindow_cancelButton'),	//Object …Sets or gets cancel button. When a cancel button is specified you can use this button to interact with the user. When any user press the cacel button window is going to be closed and the dialog result will be in the following format: { OK: false, Cancel: true, None: false }.
		draggable: false,	//Boolean …Sets or gets whether the window is draggable.
		height: 470,	//Number/String …Sets or gets the window's height.
		initContent: function() {
			$("#itemname_input").jqxInput({placeHolder: "Enter a name...", height: 25, width: 300, minLength: 1});
			$("#itemgroup_input").jqxInput({placeHolder: "Enter a group...", height: 25, width: 300, minLength: 1});
			$("#itemresourcegroup_input").jqxInput({placeHolder: "Enter a resource group...", height: 25, width: 300, minLength: 1});
			$('#itemdescription_area').jqxTextArea({ placeHolder: 'Enter a description...', height: 90, width: 307, minLength: 1 });
			$("#itemtrader_input").jqxInput({placeHolder: "Enter a trader...", height: 25, width: 300});
			$("#itemselling_check").jqxCheckBox({height: 25, width: 80, checked: true});
			$("#itembuying_check").jqxCheckBox({height: 25, width: 80, checked: true});
			$("#itemchisel_check").jqxCheckBox({height: 25, width: 80, checked: true});
			$("#itembit_check").jqxCheckBox({height: 25, width: 120, checked: true});
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
			$('#itemaddreceipt_button').jqxButton({ width: '180px', disabled: false });
			$('#itemaddreceipt_button').on('click', function () {
				MC.go.Add.Receipt();	
			});
			$('#itemValidator').jqxValidator({
				rules: [
					{ input: '#itemname_input', message: 'Item-name is required!', action: 'keyup, blur', rule: 'required' },
					{ input: '#itemname_input', message: 'Item-name is already existing!', action: 'valueChanged', rule: function (input, commit) {
							var spliced_itemlist = [];
							input = input[0].value;
							$.each(Object.keys(MC.Mod[MC.viewing.Mod].items), function (index, value) {
								if ( !value.equals(MC.editing.Item) ) {
									spliced_itemlist.push(value);
								}
							});
							if ( (input.equals(Object.keys(MC.Mod[MC.viewing.Mod].items)) && MC.mode.Item.equals("add")) || (MC.mode.Item.equals("edit") && input.equals(spliced_itemlist)) ) {
								return false;
							}
							return true;
						}
					}
				]
			});
			$('#itemValidator').on('validationSuccess', function(event) {//This event is triggered when the window is closed.
				var tempgroup = $("#itemgroup_input").jqxInput('val');
				if ( tempgroup.isEmpty() ){
					tempgroup = "- No Group -";
				}
				var newname = $('#itemname_input').jqxInput('val');
				if(MC.mode.Item.equals("edit")){
					var tempItems = {};
					$.each(Object.keys(MC.Mod[MC.editing.Mod].items), function (index, value) {
						if ( !value.equals(MC.editing.Item) ) {
							tempItems[value] = MC.Mod[MC.editing.Mod].items[value];
						}
					});
					MC.Mod[MC.editing.Mod].items = tempItems;
				}
				if ( MC.mode.Item.equals("add", "edit") ) {
					
					MC.Mod[MC.editing.Mod].items[newname] = {
						description: $('#itemdescription_area').jqxTextArea('val'),
						group: tempgroup,
						resource_group: $('#itemresourcegroup_input').jqxInput('val'),
						chisel: $("#itemchisel_check").jqxCheckBox('checked'),
						chiselsbit: $("#itembit_check").jqxCheckBox('checked'),
						fixedprice: $("#itemfixedprice_check").jqxCheckBox('checked'),
						price: $('#itemprice_input').jqxInput('val'),
						count: 1,
						buying: $("#itembuying_check").jqxCheckBox('checked'),
						selling: $("#itemselling_check").jqxCheckBox('checked'),
						trader: "",
						receipt: MC.itemreceipts_temp
					};
					$.each(Object.keys(MC.itemreceipts_temp), function (index, receipttable) {
						$.each(MC.itemreceipts_temp[receipttable], function (index2, receipt) {
							$.each(Object.keys(receipt), function (index3, IO) {
								$.each(Object.keys(receipt[IO]), function (index4, receiptitems) {
									$.each(receipt[IO][receiptitems].things, function (index5, names) {
										if ( !names.mod.equals(Object.keys(MC.Mod)) ) {
											MC.Mod[names.mod] = {description: "", iso: "", items: {} }
										}
										if ( !names.item.equals(Object.keys(MC.Mod[names.mod].items)) ) {
											MC.Mod[names.mod].items[names.item] = {description: "", group: "- No Group -", resource_group: "", chisel: false, chiselsbit: false, fixedprice: false, price: "0", count: 0, buying: true, selling: true, trader: "", receipt: {} }
										}	
									});																
								});												
							});					
						});
					});
					if ( MC.Mod[MC.editing.Mod].items[newname].fixedprice && MC.Mod[MC.editing.Mod].items[newname].price.includes("/") && MC.Mod[MC.editing.Mod].items[newname].count == 1 ) {
						if ( MC.Mod[MC.editing.Mod].items[newname].price.endsWith("b") ){
							MC.Mod[MC.editing.Mod].items[newname].count = parseInt(MC.Mod[MC.editing.Mod].items[newname].price.split("b")[0].split("/")[1]);
						}
						else{
							MC.Mod[MC.editing.Mod].items[newname].count = parseInt(MC.Mod[MC.editing.Mod].items[newname].price.split("/")[1]);
						}
					}
					MC.itemreceipts_temp = {},
					MC.go.ModList();
					$.each($("#modListBox").jqxListBox('getItems'), function (index, value) {
						if ( MC.editing.Mod.equals(value.label) ) {
							$("#modListBox").jqxListBox('unselectIndex', value.index);
							$("#modListBox").jqxListBox('selectIndex', value.index);
						}
					});
					$.each($("#itemListBox").jqxListBox('getItems'), function (index, value) {
						if ( newname.equals(value.label) ) {
							$("#itemListBox").jqxListBox('selectIndex', value.index);
						}
					});
				}
				$('#itemwindow').jqxWindow('close')
			});
			$('#itemwindow_okButton').jqxButton({ width: '180px', disabled: false });
			$('#itemwindow_okButton').on('click', function () {
				$('#itemValidator').jqxValidator('validate');
			});
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
		//okButton: $('#itemwindow_okButton'),	//Object …Sets or gets submit button. When a ok/submit button is specified you can use this button to interact with the user. When any user press the submit button window is going to be closed and the dialog result will be in the following format: { OK: true, Cancel: false, None: false }.
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
				source: MC.Definitions.crafting_items,	//Array  … Sets or gets the items source.
				selectedIndex: 0,	//Number  … Sets or gets the selected index.
				width: 200 	//Number/String  … Sets or gets the jqxDropDownList's width.
			});

			for (var h = 0; h < MC.Definitions.receipt_io_count; h++){
				$("#rc" + h + "_count").jqxInput({placeHolder: "How Many?...", height: 25, width: 90, minLength: 1});
				$("#rc" + h + "_count").jqxInput('val', "1");
				$("#rc" + h + "_modbox0").jqxInput({placeHolder: "Enter Mod name...", height: 25, width: 130, minLength: 1, items: 30, searchMode: 'contains', source: Object.keys(MC.Mod)});
				$("#rc" + h + "_itembox0").jqxInput({placeHolder: "Enter Item name...", height: 25, width: 200, minLength: 1, items: 30, searchMode: 'contains', source: MC.ItemNames});
				$("#rc" + h + "_modbox0").on('change', function (event) {
 					var id = event.target.id.split("_modbox")[0].split("rc")[1];
					var value = $("#rc" + id + "_modbox0").val();
					if ( value.isEmpty() ) {$("#rc" + id + "_itembox0").jqxInput({source: MC.ItemNames});}
					else if ( MC.Mod[value] != null ) {$("#rc" + id + "_itembox0").jqxInput({source: Object.keys(MC.Mod[value].items)});}
					else{$("#rc" + id + "_itembox0").jqxInput({source: []});}
				});
				$("#addButton" + h).jqxButton({width: 30, height: 23, imgSrc: "plus.png", imgWidth: 20, imgHeight: 20, imgPosition: "center", textPosition: "center", textImageRelation: "imageAboveText"});
				$("#removeButton" + h).jqxButton({width: 30, height: 23, imgSrc: "minus.png", imgWidth: 20, imgHeight: 20, imgPosition: "center", textPosition: "center", textImageRelation: "imageAboveText"});
				$("#addButton" + h).click(function (event) {
					var addid = parseInt(event.currentTarget.id.split("addButton")[1]);
					if(MC.rc_inputcount[addid] > 20){
						alert("Only 20 textboxes allow");
						return false;
					}
					var newTextBoxDiv = $(document.createElement('div')).attr("id", "rc" + addid + "_div" + MC.rc_inputcount[addid]);
					newTextBoxDiv.after().html("<input type='textbox' id='rc" + addid + "_modbox" + MC.rc_inputcount[addid] + "' autocomplete='off' style='float:left; margin: 3px 5px;'/><input type='textbox' id='rc" + addid + "_itembox" + MC.rc_inputcount[addid] + "' style='margin: 3px 5px;' autocomplete='off'/>");
					newTextBoxDiv.appendTo("#rc" + addid + "_group");
					$("#rc" + addid + "_modbox" + MC.rc_inputcount[addid]).jqxInput({placeHolder: "Enter Mod name...", height: 25, width: 130, minLength: 1, items: 30, searchMode: 'contains', source: Object.keys(MC.Mod)});
					$("#rc" + addid + "_itembox" + MC.rc_inputcount[addid]).jqxInput({placeHolder: "Enter Item name...", height: 25, width: 200, minLength: 1, items: 30, searchMode: 'contains', source: MC.ItemNames});
					$("#rc" + addid + "_modbox" + MC.rc_inputcount[addid]).on('change', function (event) { 
						var id = event.target.id.split("modbox")[1];
						var value = $("#rc" + 0 + "_modbox" + id).val();
						if ( value.isEmpty() ) {$("#rc" + 0 + "_itembox" + id).jqxInput({source: MC.ItemNames});}
						else if ( MC.Mod[value] != null ) {$("#rc" + 0 + "_itembox" + id).jqxInput({source: Object.keys(MC.Mod[value].items)});}
						else{$("#rc" + 0 + "_itembox" + id).jqxInput({source: []});}
					});
					MC.rc_inputcount[addid]++;
					var heightcalc = [[1,2],[0,2],[0,1],[4,5],[3,5],[3,4],[7,8],[6,8],[6,7],[10,11],[9,11],[9,10]];
					if ( MC.rc_inputcount[addid] > MC.rc_inputcount[heightcalc[addid][0]] && MC.rc_inputcount[addid] > MC.rc_inputcount[heightcalc[addid][1]]) {
						$('#receiptwindow').jqxWindow({
							height: $('#receiptwindow').jqxWindow('height') + 35
						})
					}
				});
				$("#removeButton" + h).click(function () {
					var rid = parseInt(event.currentTarget.id.split("removeButton")[1]);
					if(MC.rc_inputcount[rid]==1){
						return false;
					}
					MC.rc_inputcount[rid]--;
					$("#rc" + rid + "_div" + MC.rc_inputcount[rid]).remove();
					var heightcalc = [[1,2],[0,2],[0,1],[4,5],[3,5],[3,4],[7,8],[6,8],[6,7],[10,11],[9,11],[9,10]];
					console.log(MC.rc_inputcount[rid] + " >= " + MC.rc_inputcount[heightcalc[rid][0]] + " || " + MC.rc_inputcount[rid] + " >= " + MC.rc_inputcount[heightcalc[rid][1]]);
					if ( MC.rc_inputcount[rid] >= MC.rc_inputcount[heightcalc[rid][0]] && MC.rc_inputcount[rid] >= MC.rc_inputcount[heightcalc[rid][1]]) {
						$('#receiptwindow').jqxWindow({
							height: $('#receiptwindow').jqxWindow('height') - 35
						})
					}
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
		if(MC.mode.Mod.equals("edit")){
			$('#modname_input').jqxInput('val', MC.editing.Mod);
			$('#modiso_input').jqxInput('val', MC.Mod[MC.editing.Mod].iso);
			$('#moddescription_area').jqxTextArea('val', MC.Mod[MC.editing.Mod].description);
			$('#modwindow').jqxWindow('setTitle', 'Edit Mod: ' + MC.editing.Mod);
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
		MC.editing.Mod = "";
		MC.mode.Mod = "";
	});

	$('#itemwindow').on('open', function(event) { //This event is triggered when the window is displayed.
		$("#itemgroup_input").jqxInput({source: MC.Mod[MC.viewing.Mod].groups});
		$("#itemresourcegroup_input").jqxInput({source: MC.ResourceGroups});
		if(MC.mode.Item.equals("edit")){
			MC.itemreceipts_temp = MC.Mod[MC.editing.Mod].items[MC.editing.Item].receipt.Copy();
			$("#itemname_input").jqxInput('val', MC.editing.Item);
			$("#itemgroup_input").jqxInput('val', MC.Mod[MC.editing.Mod].items[MC.editing.Item].group);
			$("#itemresourcegroup_input").jqxInput('val', MC.Mod[MC.editing.Mod].items[MC.editing.Item].resource_group);
			$('#itemdescription_area').jqxTextArea('val', MC.Mod[MC.editing.Mod].items[MC.editing.Item].description);
			$("#itemtrader_input").jqxInput('val', MC.Mod[MC.editing.Mod].items[MC.editing.Item].trader);
			$("#itemselling_check").jqxCheckBox({checked: MC.Mod[MC.editing.Mod].items[MC.editing.Item].selling});
			$("#itembuying_check").jqxCheckBox({checked: MC.Mod[MC.editing.Mod].items[MC.editing.Item].buying});
			$("#itemfixedprice_check").jqxCheckBox({checked: MC.Mod[MC.editing.Mod].items[MC.editing.Item].fixedprice});
			$('#itemprice_input').jqxInput('val', MC.Mod[MC.editing.Mod].items[MC.editing.Item].price);
			$("#itemchisel_check").jqxCheckBox('val', MC.Mod[MC.editing.Mod].items[MC.editing.Item].chisel);
			$("#itembit_check").jqxCheckBox('val', MC.Mod[MC.editing.Mod].items[MC.editing.Item].chiselsbit);
			var rcount = 0;
			$.each(Object.keys(MC.Mod[MC.editing.Mod].items[MC.editing.Item].receipt), function (index, receipttable) {
				rcount += MC.Mod[MC.editing.Mod].items[MC.editing.Item].receipt[receipttable].length;
			});
			$('#itemreceiptcount').html('Receipts: ' + rcount);
			$('#itemwindow').jqxWindow('setTitle', 'Edit Item: ' + MC.editing.Item + ' -------- Mod: ' +  MC.editing.Mod);	
		}
		else if(MC.mode.Item.equals("add")){
			$("#itemname_input").jqxInput('val', "");
			$("#itemgroup_input").jqxInput('val', "");
			$('#itemdescription_area').jqxTextArea('val', "");
			$("#itemtrader_input").jqxInput('val', "");
			$("#itemchisel_check").jqxCheckBox({checked: false});
			$("#itembit_check").jqxCheckBox({checked: false});
			$("#itemselling_check").jqxCheckBox({checked: true});
			$("#itembuying_check").jqxCheckBox({checked: true});
			$("#itemfixedprice_check").jqxCheckBox({checked: false});
			$("#itemprice_input").jqxInput({disabled: true});
			$('#itemprice_input').jqxInput('val', "");
			$('#itemreceiptcount').html('Receipts: 0');
			$('#itemwindow').jqxWindow('setTitle', 'Add Item to Mod: ' +  MC.editing.Mod);		
		}
		else{
			$('#itemwindow').jqxWindow('close')
		}
	});
	$('#itemwindow').on('close', function(event) {//This event is triggered when the window is closed.
		MC.editing.Mod = "";
		MC.editing.Item = "";
		MC.mode.Item = "";
	});
	
	$('#receiptwindow').on('open', function(event) { //This event is triggered when the window is displayed.
		if(MC.mode.Receipt.equals("add")){
			$("#crafting_item").jqxDropDownList('selectIndex', 0 );
			for (var i = 0; i < MC.Definitions.receipt_io_count; i++){
				$("#rc" + i + "_count").jqxInput('val', "1");
				$("#rc" + i + "_modbox0").jqxInput('val', "");
				$("#rc" + i + "_itembox0").jqxInput('val', "");
				$("#rc" + i + "_modbox0").jqxInput({source: Object.keys(MC.Mod)});
				$("#rc" + i + "_itembox0").jqxInput({source: MC.ItemNames});
				while ( MC.rc_inputcount[i] != 1 ) {
					$("#removeButton" + i).click();
				}
			}
			$("#rc10_modbox0").jqxInput('val', MC.editing.Mod);
			$("#rc10_itembox0").jqxInput('val', MC.editing.Item);	
		}
		else if(MC.mode.Receipt.equals("edit")){
					
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
				if ( MC.itemreceipts_temp[ci] == null ) {
					MC.itemreceipts_temp[ci] = new Array();
				}
				for (var i = 0; i < MC.Definitions.receipt_io_count; i++){
					if ( i > MC.Definitions.receipt_io_count - 4 ) {
						io = "OUT";
					}
					if ( $("#rc" + i + "_itembox0").jqxInput('val').isEmpty() == false && $("#rc" + i + "_modbox0").jqxInput('val').isEmpty() == false ) {
						entered[io]["item" + pe[io]] = {count: $("#rc" + i + "_count").jqxInput('val'), things: new Array()};
						for (var j = 0; j < MC.rc_inputcount[i]; j++){
							entered[io]["item" + pe[io]].things.push({
								mod: $("#rc" + i + "_modbox" + j).jqxInput('val'),
								item: $("#rc" + i + "_itembox" + j).jqxInput('val')
							});
							pe[io]++;
						}
					}
					pe[io] = 0;
				}
				MC.itemreceipts_temp[ci].push(entered);
				var rcount = 0;
				$.each(Object.keys(MC.itemreceipts_temp), function (index, receipttable) {
					rcount += MC.itemreceipts_temp[receipttable].length;
				});
				$('#itemreceiptcount').html('Receipts: ' + rcount);
			}
		}
		MC.editing.Receipt = "";
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
	MC.go.Mod("");
	

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

