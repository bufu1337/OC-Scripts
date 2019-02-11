//------- jqxWindow -------

// set Attributes

$('#jqxWindow').jqxWindow({
	autoOpen: true,	//Boolean … Sets or gets whether the window will be shown after it's creation.
	animationType: 'fade',	//String …Sets or gets window's close and show animation type. … Possible Values: none, fade, slide, combined
	collapsed: false,	//Boolean …Determines whether the window is collapsed.
	collapseAnimationDuration: 150,	//Number …Determines the duration in milliseconds of the expand/collapse animation.
	content: '',	//String …Sets or gets window's content's html content.
	closeAnimationDuration: 350,	//Number …Sets or gets window's close animation duration.
	closeButtonSize: 16,	//Number …Sets or gets window's close button size.
	closeButtonAction: 'hide',	//String …This setting specifies what happens when the user clicks the jqxWindow's close button. …Possible Values: hide, close-clicking the close button removes the window from the DOM
	cancelButton: null,	//Object …Sets or gets cancel button. When a cancel button is specified you can use this button to interact with the user. When any user press the cacel button window is going to be closed and the dialog result will be in the following format: { OK: false, Cancel: true, None: false }.
	dragArea: null,	//Object …Sets or gets the screen area which is available for dragging(moving) the jqxWindow. Example value: { left: 300, top: 300, width: 600, height: 600 }. By default, the dragArea is null which means that the users will be able to drag the window in the document's body bounds.
	draggable: true,	//Boolean …Sets or gets whether the window is draggable.
	disabled: false,	//Boolean …Sets or gets whether the window is disabled.
	height: null,	//Number/String …Sets or gets the window's height.
	initContent: function() {
		
	},	//Method …Initializes the jqxWindow's content.
	isModal: false,	//Boolean …Sets or gets whether the window is displayed as a modal dialog. If the jqxWindow's mode is set to modal, the window blocks user interaction with the underlying user interface.
	keyboardCloseKey: 'esc',	//Number/string …Sets or gets the key which could be used for closing the window when it's on focus. Possible value is every keycode and the 'esc' strig (for the escape key). …Possible Values: keycodes or 'esc'
	keyboardNavigation: true,	//Boolean …Determines whether the keyboard navigation is enabled or disabled.
	minHeight: 50,	//Number/String …Sets or gets window's minimum height.
	maxHeight: 600,	//Number/String …Sets or gets window's maximum height.
	minWidth: 50,	//Number/String …Sets or gets window's minimum width.
	maxWidth: 600,	//Number/String …Sets or gets window's maximum width.
	modalOpacity: 0.3,	//Number …Sets or gets the jqxWindow's background displayed over the underlying user interface when the window is in modal dialog mode.
	modalZIndex: 18000,	//Number …Sets or gets the jqxWindow's z-index when it is displayed as a modal dialog.
	modalBackgroundZIndex: 12990,	//Number …Sets or gets the jqxWindow overlay's z-index when it is displayed as a modal dialog.
	okButton: null,	//Object …Sets or gets submit button. When a ok/submit button is specified you can use this button to interact with the user. When any user press the submit button window is going to be closed and the dialog result will be in the following format: { OK: true, Cancel: false, None: false }.
	position: 'center',	//Object/String …Sets or gets window's position. The value could be in the following formats: 'center', 'top, left', '{ x: 300, y: 500 }', '[300, 500]'.
	rtl: false,	//Boolean …Sets or gets a value indicating whether widget's elements are aligned to support locales using right-to-left fonts.
	resizable: true,	//Boolean …Enables or disables whether the end-user can resize the window.
	showAnimationDuration: 350,	//Number …Sets or gets window's show animation duration.
	showCloseButton: true,	//Boolean …Sets or gets whether a close button will be visible.
	showCollapseButton: false,	//Boolean …Sets or gets whether the collapse button will be visible.
	theme: '',	//String …Sets the widget's theme.
	title: '',	//String …Sets or gets window's title content.
	width: null,	//Number/String …Sets or gets the window's width.
	zIndex: 9001 //Number …Sets or gets the jqxWindow z-index.
});

// get Attributes

function getjqxwindow_attributes(editor) {
	var jqxwindow_attributes = new Object({
		autoOpen: editor.jqxWindow('autoOpen'),
		animationType: editor.jqxWindow('animationType'),
		collapsed: editor.jqxWindow('collapsed'),
		collapseAnimationDuration: editor.jqxWindow('collapseAnimationDuration'),
		content: editor.jqxWindow('content'),
		closeAnimationDuration: editor.jqxWindow('closeAnimationDuration'),
		closeButtonSize: editor.jqxWindow('closeButtonSize'),
		closeButtonAction: editor.jqxWindow('closeButtonAction'),
		cancelButton: editor.jqxWindow('cancelButton'),
		dragArea: editor.jqxWindow('dragArea'),
		draggable: editor.jqxWindow('draggable'),
		disabled: editor.jqxWindow('disabled'),
		height: editor.jqxWindow('height'),
		isModal: editor.jqxWindow('isModal'),
		isOpen: editor.jqxWindow('isOpen'),
		keyboardCloseKey: editor.jqxWindow('keyboardCloseKey'),
		keyboardNavigation: editor.jqxWindow('keyboardNavigation'),
		minHeight: editor.jqxWindow('minHeight'),
		maxHeight: editor.jqxWindow('maxHeight'),
		minWidth: editor.jqxWindow('minWidth'),
		maxWidth: editor.jqxWindow('maxWidth'),
		modalOpacity: editor.jqxWindow('modalOpacity'),
		modalZIndex: editor.jqxWindow('modalZIndex'),
		modalBackgroundZIndex: editor.jqxWindow('modalBackgroundZIndex'),
		okButton: editor.jqxWindow('okButton'),
		position: editor.jqxWindow('position'),
		rtl: editor.jqxWindow('rtl'),
		resizable: editor.jqxWindow('resizable'),
		showAnimationDuration: editor.jqxWindow('showAnimationDuration'),
		showCloseButton: editor.jqxWindow('showCloseButton'),
		showCollapseButton: editor.jqxWindow('showCollapseButton'),
		title: editor.jqxWindow('title'),
		width: editor.jqxWindow('width'),
		zIndex: editor.jqxWindow('zIndex')
	});
	return jqxwindow_attributes;
}


// Events

$('#jqxWindow').on('close', function(event) {
	//This event is triggered when the window is closed.
});
$('#jqxWindow').on('collapse', function(event) {
	//This event is triggered when the window is collapsed. 
});
$('#jqxWindow').on('created', function(event) {
	//This event is triggered when the user create new window. 
});
$('#jqxWindow').on('expand', function(event) {
	//This event is triggered when the window is expanded. 
});
$('#jqxWindow').on('moving', function(event) {
	//This event is triggered when the window is dragging by the user. 
});
$('#jqxWindow').on('moved', function(event) {
	//This event is triggered when the window is dropped by the user. 
});
$('#jqxWindow').on('open', function(event) {
	//This event is triggered when the window is displayed. 
});
$('#jqxWindow').on('resizing', function(event) {
	//This event is triggered when the end-user is resizing the window. 
});
$('#jqxWindow').on('resized', function(event) {
	//This event is triggered when the end-user has resized the window. 
});


// Methods

$('#jqxWindow').jqxWindow('bringToFront');	//Bringing the window to the front.
$('#jqxWindow').jqxWindow('close');	//Hiding/closing the current window (the action - hide or close depends on the closeButtonAction).
$('#jqxWindow').jqxWindow('collapse');	//Collapse the current window.
$('#jqxWindow').jqxWindow('closeAll');	//Closing all open windows which are not modal. 
$('#jqxWindow').jqxWindow('disable');	//Disabling the window.
$('#jqxWindow').jqxWindow('destroy');	//Destroys the widget. 
$('#jqxWindow').jqxWindow('enable');	//Enabling the window
$('#jqxWindow').jqxWindow('expand');	//Expand the current window.
$('#jqxWindow').jqxWindow('focus');	//Focuses the window.
$('#jqxWindow').jqxWindow('move', 300, 600);	//Moving the current window. Parameters: top, left
$('#jqxWindow').jqxWindow('open');	//Opening/showing the current window.
$('#jqxWindow').jqxWindow('resize', 500, 500);	//Resizes the window. The 'resizable' property is expected to be set to "true". Parameters: top, left
$('#jqxWindow').jqxWindow('setTitle', 'Sample title');	//Setting window's title Parameters: title(String)
$('#jqxWindow').jqxWindow('setContent', 'Sample content');	//Setting window's content. Parameters: content(String)





//------- jqxDropDownList -------

// set Attributes

$("#jqxDropDownList").jqxDropDownList({
	autoOpen: false,	//Boolean  … Sets or gets whether the DropDown is automatically opened when the mouse cursor is moved over the widget.
	autoItemsHeight: false,	//Boolean  … Sets or gets whether items will wrap when they reach the width of the dropDown.
	autoDropDownHeight: false,	//Boolean  … Sets or gets whether the height of the jqxDropDownList's ListBox displayed in the widget's DropDown is calculated as a sum of the items heights.
	animationType: 'slide',	//String  … Sets or gets the type of the animation. … Possible Values:'fade''slide''none'
	checkboxes: false,	//Boolean  … Determines whether checkboxes will be displayed next to the list items. (The feature requires jqxcheckbox.js)
	closeDelay: 400,	//Number  … Sets or gets the delay of the 'close' animation.
	disabled: false,	//Boolean  … Enables/disables the jqxDropDownList.
	displayMember: '',	//String  … Sets or gets the displayMember of the Items. The displayMember specifies the name of an object property to display. The name is contained in the collection specified by the 'source' property.
	dropDownHorizontalAlignment: 'left',	//String  … Sets or gets the DropDown's alignment. … Possible Values:'left''right'
	dropDownVerticalAlignment: 'bottom',	//String  … Sets or gets the DropDown's alignment. … Possible Values:'top''bottom'
	dropDownHeight: 200,	//Number  … Sets or gets the height of the jqxDropDownList's ListBox displayed in the widget's DropDown.
	dropDownWidth: 200,	//Number  … Sets or gets the width of the jqxDropDownList's ListBox displayed in the widget's DropDown.
	enableSelection: true,	//Boolean  … Enables/disables the selection.
	enableBrowserBoundsDetection: false,	//Boolean  … Sets or gets whether the dropdown detects the browser window's bounds and automatically adjusts the dropdown's position.
	enableHover: true,	//Boolean  … Enables/disables the hover state.
	filterable: false,	//Boolean  … Determines whether the Filtering is enabled.
	filterHeight: 27,	//Number  … Determines the Filter's height.
	filterDelay: 100,	//Number  … Determines the Filter's delay. After 100 milliseconds, the widget automatically filters its data based on the filter input's value. To perform filter only on "Enter" key press, set this property to 0.
	filterPlaceHolder: "Looking for",	//String  … Determines the Filter input's place holder.
	height: null,	//Number/String  … Sets or gets the jqxDropDownList's height.
	incrementalSearch: true,	//Boolean  … Sets or gets the incrementalSearch property. An incremental search begins searching as soon as you type the first character of the search string. As you type in the search string, jqxDropDownList automatically selects the found item.
	incrementalSearchDelay: 700,	//Number  … Sets or gets the incrementalSearchDelay property. The incrementalSearchDelay specifies the time-interval in milliseconds after which the previous search string is deleted. The timer starts when you stop typing.
	itemHeight: -1,	//Number  … Sets or gets the height of the jqxDropDownList Items. When the itemHeight == - 1, each item's height is equal to its desired height.
	openDelay: 350,	//Number  … Sets or gets the delay of the 'open' animation.
	placeHolder: "Please Choose:",	//String  … Text displayed when the selection is empty.
	popupZIndex: 20000,	//Number  … Sets or gets the popup's z-index.
	rtl: false,	//Boolean  … Sets or gets a value indicating whether widget's elements are aligned to support locales using right-to-left fonts.
	renderer: function (index, label, value) {
		
	},	//Function  … Callback function which is called when an item is rendered. By using the renderer function, you can customize the look of the list items.
	selectionRenderer: function (htmlString) {
		
	},	//Function  … Callback function which is called when the selected item is rendered in the jqxDropDownList's content area. By using the selectionRenderer function, you can customize the look of the selected item.
	searchMode: 'startswith',	//String  … Sets or gets the item incremental search mode. When the user types some text in a focused DropDownList, the jqxListBox widget tries to find the searched item using the entered text and the selected search mode … Possible Values:none''contains''containsignorecase''equals''equalsignorecase''startswithignorecase''startswith''endswithignorecase''endswith'
	scrollBarSize: 17,	//Number  … Sets or gets the scrollbars size.
	source: null,	//Array  … Sets or gets the items source.
	selectedIndex: -1,	//Number  … Sets or gets the selected index.
	template: 'default',	//String  … Determines the template as an alternative of the default styles. … Possible Values:'default' - the default template. The style depends only on the "theme" property value.'primary' - dark blue style for extra visual weight.'success' - green style for successful or positive action.'warning' - orange style which indicates caution.'danger' - red style which indicates a dangerous or negative action.'info' - blue button, not tied to a semantic action or use.
	theme: '',	//String  … Sets the widget's theme.
	valueMember: '',	//String  … Sets or gets the valueMember of the Items. The valueMember specifies the name of an object property to set as a 'value' of the list items. The name is contained in the collection specified by the 'source' property.
	width: null 	//Number/String  … Sets or gets the jqxDropDownList's width.
});


//get Attributes

function getjqxDropDownList_attributes(editor) {
	var jqxDropDownList_attributes = new Object({
		autoOpen: editor.jqxDropDownList('autoOpen'),
		autoItemsHeight: editor.jqxDropDownList('autoItemsHeight'),
		autoDropDownHeight: editor.jqxDropDownList('autoDropDownHeight'),
		animationType: editor.jqxDropDownList('animationType'),
		checkboxes: editor.jqxDropDownList('checkboxes'),
		closeDelay: editor.jqxDropDownList('closeDelay'),
		disabled: editor.jqxDropDownList('disabled'),
		displayMember: editor.jqxDropDownList('displayMember'),
		dropDownHorizontalAlignment: editor.jqxDropDownList('dropDownHorizontalAlignment'),
		dropDownVerticalAlignment: editor.jqxDropDownList('dropDownVerticalAlignment'),
		dropDownHeight: editor.jqxDropDownList('dropDownHeight'),
		dropDownWidth: editor.jqxDropDownList('dropDownWidth'),
		enableSelection: editor.jqxDropDownList('enableSelection'),
		enableBrowserBoundsDetection: editor.jqxDropDownList('enableBrowserBoundsDetection'),
		enableHover: editor.jqxDropDownList('enableHover'),
		filterable: editor.jqxDropDownList('filterable'),
		filterHeight: editor.jqxDropDownList('filterHeight'),
		filterDelay: editor.jqxDropDownList('filterDelay'),
		filterPlaceHolder: editor.jqxDropDownList('filterPlaceHolder'),
		getItems: editor.jqxDropDownList('getItems'),
		getCheckedItems: editor.jqxDropDownList('getCheckedItems'),
		getSelectedItem: editor.jqxDropDownList('getSelectedItem'),
		getSelectedIndex: editor.jqxDropDownList('getSelectedIndex'),
		height: editor.jqxDropDownList('height'),
		incrementalSearch: editor.jqxDropDownList('incrementalSearch'),
		incrementalSearchDelay: editor.jqxDropDownList('incrementalSearchDelay'),
		isOpened: editor.jqxDropDownList('isOpened'),
		itemHeight: editor.jqxDropDownList('itemHeight'),
		openDelay: editor.jqxDropDownList('openDelay'),
		placeHolder: editor.jqxDropDownList('placeHolder'),
		popupZIndex: editor.jqxDropDownList('popupZIndex'),
		rtl: editor.jqxDropDownList('rtl'),
		searchMode: editor.jqxDropDownList('searchMode'),
		scrollBarSize: editor.jqxDropDownList('scrollBarSize'),
		source: editor.jqxDropDownList('source'),
		selectedIndex: editor.jqxDropDownList('selectedIndex'),
		template: editor.jqxDropDownList('template'),
		val: editor.jqxDropDownList('val'),
		valueMember: editor.jqxDropDownList('valueMember'),
		width: editor.jqxDropDownList('width')
	});
	return jqxDropDownList_attributes;
}


//Events

$("#jqxDropDownList").on('bindingComplete', function (event) {
	//This event is triggered when the data binding operation is completed. 
	if (event.args) {
		var args = event.args;
	    var item = event.args.item;
	    var checkedItems = $("#jqxDropDownList").jqxDropDownList('getCheckedItems');
	}
});
$("#jqxDropDownList").on('close', function (event) {
	//This event is triggered when the popup ListBox is closed. 
	if (event.args) {
		var args = event.args;
	    var item = event.args.item;
	    var checkedItems = $("#jqxDropDownList").jqxDropDownList('getCheckedItems');
	}
});
$("#jqxDropDownList").on('checkChange', function (event) {
	//This event is triggered when an item is checked/unchecked. 
	if (event.args) {
		var args = event.args;
	    var item = event.args.item;
	    var checkedItems = $("#jqxDropDownList").jqxDropDownList('getCheckedItems');
	}
});
$("#jqxDropDownList").on('change', function (event) {
	//This event is triggered when the user selects an item. 
	if (event.args) {
		var args = event.args;
	    var item = event.args.item;
	    var checkedItems = $("#jqxDropDownList").jqxDropDownList('getCheckedItems');
	}
});
$("#jqxDropDownList").on('open', function (event) {
	//This event is triggered when the popup ListBox is opened. 
	if (event.args) {
		var args = event.args;
	    var item = event.args.item;
	    var checkedItems = $("#jqxDropDownList").jqxDropDownList('getCheckedItems');
	}
});
$("#jqxDropDownList").on('select', function (event) {
	//This event is triggered when the user selects an item. 
	if (event.args) {
		var args = event.args;
	    var item = event.args.item;
	    var checkedItems = $("#jqxDropDownList").jqxDropDownList('getCheckedItems');
	}
});
$("#jqxDropDownList").on('unselect', function (event) {
	//This event is triggered when the user unselects an item. 
	if (event.args) {
		var args = event.args;
	    var item = event.args.item;
	    var checkedItems = $("#jqxDropDownList").jqxDropDownList('getCheckedItems');
	}
});


// Methods

$("jqxDropDownList").jqxDropDownList('addItem', item);	//Adds a new item to the jqxDropDownList. Returns 'true', if the new item is added or 'false' if the item is not added.The following fields can be used for the new item:    label - determines the item's label.    value - determines the item's value.    disabled - determines whether the item is enabled/disabled.    checked - determines whether item is checked/unchecked.    hasThreeStates - determines whether the item's checkbox supports three states.    html - determines the item's display html. This can be used instead of label.    group - determines the item's group.
$("jqxDropDownList").jqxDropDownList('clearSelection');	//Clears all selected items.
$("jqxDropDownList").jqxDropDownList('clear');	//Clears all items.
$("jqxDropDownList").jqxDropDownList('close');	//Hides the popup listbox.
$("jqxDropDownList").jqxDropDownList('checkIndex', index);	//Checks a list item when the 'checkboxes' property value is true. The index is zero-based, i.e to check the first item, the 'checkIndex' method should be called with parameter 0.
$("jqxDropDownList").jqxDropDownList('checkItem', item);	//Checks an item.
$("jqxDropDownList").jqxDropDownList('checkAll');	//Checks all list items when the 'checkboxes' property value is true.
$("jqxDropDownList").jqxDropDownList('clearFilter');	//Clears the widget's filter when filtering is applied.
$("jqxDropDownList").jqxDropDownList('destroy');	//Destroys the widget.
$("jqxDropDownList").jqxDropDownList('disableItem', item);	//Disables an item. Item is an Object.  The following fields can be used for the new item:    label - determines the item's label.    value - determines the item's value.    disabled - determines whether the item is enabled/disabled.    checked - determines whether item is checked/unchecked.    hasThreeStates - determines whether the item's checkbox supports three states.    html - determines the item's display html. This can be used instead of label.    group - determines the item's group.
$("jqxDropDownList").jqxDropDownList('disableAt', index);	//Disables an item by index. Index is a number.
$("jqxDropDownList").jqxDropDownList('enableItem', item);	//Enables an item. Item is an Object  The following fields can be used for the new item:    label - determines the item's label.    value - determines the item's value.    disabled - determines whether the item is enabled/disabled.    checked - determines whether item is checked/unchecked.    hasThreeStates - determines whether the item's checkbox supports three states.    html - determines the item's display html. This can be used instead of label.    group - determines the item's group.
$("jqxDropDownList").jqxDropDownList('enableAt', index);	//Enables a disabled item by index. Index is a number.
$("jqxDropDownList").jqxDropDownList('ensureVisible', index);	//Ensures that an item is visible. index is number. When necessary, the jqxDropDownList scrolls to the item to make it visible.
$("jqxDropDownList").jqxDropDownList('focus');	//Sets the focus to the widget.
$("jqxDropDownList").jqxDropDownList('getItem', index);	//Gets item by index. The returned value is an Object with the following fields:     label - determines the item's label.    value - determines the item's value.    disabled - determines whether the item is enabled/disabled.    checked - determines whether item is checked/unchecked.    hasThreeStates - determines whether the item's checkbox supports three states.    html - determines the item's display html. This can be used instead of label.    group - determines the item's group.
$("jqxDropDownList").jqxDropDownList('getItemByValue', itemValue);	//Gets an item by its value. The returned value is an Object with the following fields:     label - determines the item's label.    value - determines the item's value.    disabled - determines whether the item is enabled/disabled.    checked - determines whether item is checked/unchecked.    hasThreeStates - determines whether the item's checkbox supports three states.    html - determines the item's display html. This can be used instead of label.    group - determines the item's group.
$("jqxDropDownList").jqxDropDownList('getItems');	//Gets all items. The returned value is an array of Items. Each item represents an Object with the following Item Fields:    label - determines the item's label.    value - determines the item's value.    disabled - determines whether the item is enabled/disabled.    checked - determines whether item is checked/unchecked.    hasThreeStates - determines whether the item's checkbox supports three states.    html - determines the item's display html. This can be used instead of label.    group - determines the item's group.
$("jqxDropDownList").jqxDropDownList('getCheckedItems');	//Gets the checked items. The returned value is an array of Items. Each item represents an Object with the following Item Fields:    label - determines the item's label.    value - determines the item's value.    disabled - determines whether the item is enabled/disabled.    checked - determines whether item is checked/unchecked.    hasThreeStates - determines whether the item's checkbox supports three states.    html - determines the item's display html. This can be used instead of label.    group - determines the item's group.
$("jqxDropDownList").jqxDropDownList('getSelectedItem');	//Gets the selected item. The returned value is an array of Items. Each item represents an Object with the following Item Fields:    label - determines the item's label.    value - determines the item's value.    disabled - determines whether the item is enabled/disabled.    checked - determines whether item is checked/unchecked.    hasThreeStates - determines whether the item's checkbox supports three states.    html - determines the item's display html. This can be used instead of label.    group - determines the item's group.
$("jqxDropDownList").jqxDropDownList('getSelectedIndex');	//Gets the index of the selected item. The returned value is the index of the selected item. If there's no selected item, -1 is returned.
$("jqxDropDownList").jqxDropDownList('insertAt', item, index);	//Inserts a new item to the jqxDropDownList. Returns 'true', if the new item is inserted or false if the insertaion fails. The first parameter is Object or String - the new item. The second parameter is Number - the item's index. The following fields can be used for the new item:     label - determines the item's label.    value - determines the item's value.    disabled - determines whether the item is enabled/disabled.    checked - determines whether item is checked/unchecked.    hasThreeStates - determines whether the item's checkbox supports three states.    html - determines the item's display html. This can be used instead of label.    group - determines the item's group.
$("jqxDropDownList").jqxDropDownList('indeterminateIndex', index);	//indeterminates a list item when the 'checkboxes' property value is true. The index is zero-based, i.e to indeterminate the first item, the 'indeterminateIndex' method should be called with parameter 0.
$("jqxDropDownList").jqxDropDownList('indeterminateItem', item);	//Indeterminates an item.
$("jqxDropDownList").jqxDropDownList('loadFromSelect', id);	//Loads list items from a 'select' tag.
$("jqxDropDownList").jqxDropDownList('open');	//Shows the popup listbox.
$("jqxDropDownList").jqxDropDownList('removeItem', item);	//Removes an item from the listbox. Parameter type: Object returned by the "getItem" method or String - the value of an item. Returns 'true', if the item is removed or 'false', if the item is not removed.
$("jqxDropDownList").jqxDropDownList('removeAt', index);	//Removes an item from the listbox. Parameter type: Number - the index of the item. The method returns 'true', if the item is removed or 'false', if the item is not removed.
$("jqxDropDownList").jqxDropDownList('selectIndex', index);	//Selects an item by index. The index is zero-based, i.e to select the first item, the 'selectIndex' method should be called with parameter 0.
$("jqxDropDownList").jqxDropDownList('selectItem', item);	//Selects an item.
$("jqxDropDownList").jqxDropDownList('setContent', content);	//Sets the content of the DropDownList.
$("jqxDropDownList").jqxDropDownList('updateItem', newitem, item);	//Updates an item. The first parameter is the new item. The second parameter could be an existing item or the value of an existing item. The following fields can be used for the item:     label - determines the item's label.    value - determines the item's value.    disabled - determines whether the item is enabled/disabled.    checked - determines whether item is checked/unchecked.    hasThreeStates - determines whether the item's checkbox supports three states.    html - determines the item's display html. This can be used instead of label.    group - determines the item's group.
$("jqxDropDownList").jqxDropDownList('updateAt', newitem, index);	//Updates an item. The first parameter is the new item. The second parameter is the index of the item to be updated.  The following fields can be used for the item:     label - determines the item's label.    value - determines the item's value.    disabled - determines whether the item is enabled/disabled.    checked - determines whether item is checked/unchecked.    hasThreeStates - determines whether the item's checkbox supports three states.    html - determines the item's display html. This can be used instead of label.    group - determines the item's group.
$("jqxDropDownList").jqxDropDownList('unselectIndex', index);	//Unselects item by index. The index is zero-based, i.e to unselect the first item, the 'unselectIndex' method should be called with parameter 0.
$("jqxDropDownList").jqxDropDownList('unselectItem', item);	//Unselects an item.
$("jqxDropDownList").jqxDropDownList('uncheckIndex', index);	//Unchecks a list item when the 'checkboxes' property value is true. The index is zero-based, i.e to uncheck the first item, the 'uncheckIndex' method should be called with parameter 0.
$("jqxDropDownList").jqxDropDownList('uncheckItem', item);	//Unchecks an item.
$("jqxDropDownList").jqxDropDownList('uncheckAll');	//Unchecks all list items when the 'checkboxes' property value is true.
$("jqxDropDownList").jqxDropDownList('val', value);	//Sets or gets the selected value.




//------- jqxProgressBar -------

//set Attributes

$('#jqxProgressBar').jqxProgressBar({
	animationDuration: 300 ,	//Number … Determines the duration of the progressbar's animation.
	colorRanges: [] ,	//Array …Determines different color segments. colorRanges Properties:  stop - each one color start from zero to particular position. With decimal number is set a concrete stop. Possible values from ProgressBar's min to max.  color - color of this segment.
	disabled: false ,	//Boolean …Determines whether the progress bar is disabled.
	height: 50 ,	//Number/String …Sets or gets the progress bar's height.
	layout: 'normal' ,	//String …Sets or gets the jqxProgressBar's layout. … Possible Values:'normal''reverse'-the slider is filled from right-to-left(horizontal progressbar) and from top-to-bottom(vertical progressbar)
	max: 100 ,	//Number …Sets or gets the progress bar's max value.
	min: 0 ,	//Number …Sets or gets the progress bar's min value.
	orientation: 'horizontal' ,	//String …Sets or gets the orientation. … Possible Values:'vertical''horizontal'
	rtl: false ,	//Boolean …Sets or gets a value indicating whether widget's elements are aligned to support locales using right-to-left fonts.
	showText: false ,	//Boolean …Sets or gets the visibility of the progress bar's percentage's text.
	template: 'default' ,	//String … Determines the template as an alternative of the default styles.... Possible Values:'default' - the default template. The style depends only on the "theme" property value.'primary' - dark blue style for extra visual weight.'success' - green style for successful or positive action.'warning' - orange style which indicates caution.'danger' - red style which indicates a dangerous or negative action.'info' - blue button, not tied to a semantic action or use.
	theme: '' ,	//String …Sets the widget's theme.
	value: 0 ,	//Number …Sets or gets the progress bar's value The value should be set between min(default value: 0) and max(default value: 100).
	width: 300 ,	//Number/String …Sets or gets the progress bar's width.
	//rendertext: null 	//html…Sets or gets a custom rendertext
});

var renderText = function (text) {
    return "<span class='jqx-rc-all' style='background: #ffe8a6; color: #e53d37; font-style: italic;'>" + text + "</span>";
}

//get Attributes

function getjqxProgressBar_attributes(editor) {
	var jqxProgressBar_attributes = new Object({
		animationDuration: editor.jqxProgressBar('animationDuration'),
		colorRanges: editor.jqxProgressBar('colorRanges'),
		disabled: editor.jqxProgressBar('disabled'),
		height: editor.jqxProgressBar('height'),
		layout: editor.jqxProgressBar('layout'),
		max: editor.jqxProgressBar('max'),
		min: editor.jqxProgressBar('min'),
		orientation: editor.jqxProgressBar('orientation'),
		rtl: editor.jqxProgressBar('rtl'),
		showText: editor.jqxProgressBar('showText'),
		template: editor.jqxProgressBar('template'),
		theme: editor.jqxProgressBar('theme'),
		value: editor.jqxProgressBar('value'),
		width: editor.jqxProgressBar('width'),
		rendertext: editor.jqxProgressBar('rendertext')
	});
	return jqxProgressBar_attributes;
}


//Events

$('#jqxProgressBar').on('complete', function (event) {	// Some code here. 
	// This event is triggered when the value is equal to the max. value. 
}); 
$('#jqxProgressBar').on('invalidvalue', function (event) {	// Some code here. 
	// This event is triggered when the user enters an invalid value( value which is not Number or is out of the min - max range. ) 
});
$('#jqxProgressBar').on('valueChanged', function (event) { 
	// This event is triggered when the value is changed. 
	var value = event.currentValue; 
});
		

//Methods

$('#jqxProgressBar').jqxProgressBar('actualValue', value);	//Sets the progress bar's value. 
$('#jqxProgressBar').jqxProgressBar('destroy'); 	//Destroys the widget. 
$("#jqxProgressBar").jqxProgressBar('val', value);		//Sets or gets the value. 




//------- jqxTree -------

//set Attributes

$('#jqxTree').jqxTree({ 
	animationShowDuration: 350 ,	//Number … Sets or gets the duration of the show animation.
	animationHideDuration: 150 ,	//Number … Sets or gets the duration of the hide animation.
	allowDrag: false ,	//Boolean … Enables the dragging of Tree Items.(requires jqxdragdrop.js)
	allowDrop: false ,	//Boolean … Enables the dropping of Tree Items.(requires jqxdragdrop.js)
	checkboxes: false ,	//Boolean … Sets or gets whether the tree should display a checkbox next to each item. In order to use this feature, you need to include the jqxcheckbox.js.
	dragStart: null ,	//Function … Callback function which is called when a drag operation starts."function (item){ 	// disable dragging of 'Café au lait' item.  if (item.label == 'Café au lait')  return false; 	 	// enable dragging for the item.  return true;}"
	dragEnd: null ,	//Function … Callback function which is called when a drag operation ends.function (dragItem, dropItem, args, dropPosition, tree){ 	// dragItem is the item which is dragged by the user. 	// dropItem is the item over which we dropped the dragged item. 	// args - dragEvent event arguments. 	// dropPosition - the position of the dragItem regarding the possition of the dropItem. The possible values are: 'inside' - when the dragItem is dropped over the dropItem,  'before' - when the dragItem is dropped above the dropItem.  'after' - when the dragItem is dropped below the dropItem. 	// tree - the jqxTree's jQuery object associated to the dropItem. If the tree's id is 'tree', this returns $("#tree")             	// to cancel the drop operation, return false.  }
	disabled: false ,	//Boolean … Gets or sets whether the tree is disabled.
	easing: 'easeInOutCirc' ,	//String … Sets or gets the animation's easing to one of the JQuery's supported easings.
	enableHover: true ,	//Boolean … Enables or disables the hover state.
	height: null ,	//Number/String … Sets or gets the tree's height.
	hasThreeStates: false ,	//Boolean … Sets or gets whether the tree checkboxes have three states - checked, unchecked and indeterminate.
	incrementalSearch: true ,	//Boolean … Determines whether the incremental search is enabled. The feature allows you to quickly find and select items by typing when the widget is on focus.
	keyboardNavigation: true ,	//Boolean … Enables or disables the key navigation.
	rtl: false ,	//Boolean … Sets or gets a value indicating whether widget's elements are aligned to support locales using right-to-left fonts.
	source: null ,	//Object … Specifies the jqxTree's data source. Use this property to populate the jqxTree.Each tree item in the source object may have the following fields:Item Fields  label - sets the item's label.  value - sets the item's value.  html - item's html. The html to be displayed in the item.  id - sets the item's id.  disabled - sets whether the item is enabled/disabled.checked - sets whether the item is checked/unchecked(when checkboxes are enabled).  expanded - sets whether the item is expanded or collapsed.  selected - sets whether the item is selected.  items - sets an array of sub items.  icon - sets the item's icon(url is expected).  iconsize - sets the size of the item's icon.
	toggleIndicatorSize: 16 ,	//Number … Sets or gets the size of the expand/collapse arrows.
	toggleMode: 'click' ,	//String … Sets or gets user interaction used for expanding or collapsing any item.Possible Values:'click''dblclick'
	theme: '' ,	//String … Sets the widget's theme.
	width: null 	//Number/String … Sets or gets the tree's width.
}); 


//get Attributes

function getjqxTree_attributes(editor) {
	var jqxTree_attributes = new Object({
		animationShowDuration: editor.jqxTree('animationShowDuration'),
		animationHideDuration: editor.jqxTree('animationHideDuration'),
		allowDrag: editor.jqxTree('allowDrag'),
		allowDrop: editor.jqxTree('allowDrop'),
		checkboxes: editor.jqxTree('checkboxes'),
		dragStart: editor.jqxTree('dragStart'),
		dragEnd: editor.jqxTree('dragEnd'),
		disabled: editor.jqxTree('disabled'),
		easing: editor.jqxTree('easing'),
		enableHover: editor.jqxTree('enableHover'),
		getCheckedItems: editor.jqxTree('getCheckedItems'),
		getUncheckedItems: editor.jqxTree('getUncheckedItems'),
		getItems: editor.jqxTree('getItems'),
		getSelectedItem: editor.jqxTree('getSelectedItem'),
		getPrevItem: editor.jqxTree('getPrevItem', $('#jqxTree').jqxTree('getSelectedItem')),
		getNextItem: editor.jqxTree('getNextItem', $('#jqxTree').jqxTree('getSelectedItem')),
		height: editor.jqxTree('height'),
		hasThreeStates: editor.jqxTree('hasThreeStates'),
		incrementalSearch: editor.jqxTree('incrementalSearch'),
		keyboardNavigation: editor.jqxTree('keyboardNavigation'),
		rtl: editor.jqxTree('rtl'),
		source: editor.jqxTree('source'),
		toggleIndicatorSize: editor.jqxTree('toggleIndicatorSize'),
		toggleMode: editor.jqxTree('toggleMode'),
		theme: editor.jqxTree('theme'),
		width: editor.jqxTree('width')
	});
	return jqxTree_attributes;
}


// Events


$('#jqxTree').on('added', function (event) { }); 	//This event is triggered when the user adds a new tree item.
$('#jqxTree').on('checkChange', function (event) { }); 	//This event is triggered when the user checks, unchecks or the checkbox is in indeterminate state.
$('#jqxTree').on('collapse', function (event) { }); 	//This event is triggered when the user collapses a tree item.
$('#jqxTree').on('dragStart', function (event) { }); 	//This event is triggered when the user starts a drag operation.
$('#jqxTree').on('dragEnd', function (event) { }); 	//This event is triggered when the user drops an item.
$('#jqxTree').on('expand', function (event) { }); 	//This event is triggered when the user expands a tree item.
$('#jqxTree').on('initialized', function (event) { }); 	//This event is triggered when the jqxTree is created and initialized.
$('#jqxTree').on('itemClick', function (event) { }); 	//This event is triggered when the user clicks a tree item.
$('#jqxTree').on('removed', function (event) { }); 	//This event is triggered when the user removes a tree item.
$('#jqxTree').on('select', function (event) { }); 	//This event is triggered when the user removes a tree item.


// Methods

$('#jqxTree').jqxTree('addBefore', item, id);	//Adds an item as a sibling of another item.
$('#jqxTree').jqxTree('addAfter', item, id);	//Adds an item as a sibling of another item.
$('#jqxTree').jqxTree('addTo', item, id);	//Adds an item.
$('#jqxTree').jqxTree('clear');	//Removes all elements.
$('#jqxTree').jqxTree('checkAll');	//Checks all tree items.
$('#jqxTree').jqxTree('checkItem', item, checked);	//Checks a tree item.
$('#jqxTree').jqxTree('collapseAll');	//Collapses all items.
$('#jqxTree').jqxTree('collapseItem', item);	//Collapses a tree item by passing an element as parameter.
$('#jqxTree').jqxTree('destroy');	//Destroy the jqxTree widget. The destroy method removes the jqxTree widget from the web page.
$('#jqxTree').jqxTree('disableItem', item);	//Disables a tree item.
$('#jqxTree').jqxTree('ensureVisible', item);	//Ensures the visibility of an element.
$('#jqxTree').jqxTree('enableItem', item);	//Enables a tree item.
$('#jqxTree').jqxTree('expandAll');	//Expandes all items.
$('#jqxTree').jqxTree('expandItem', item);	//Expands a tree item by passing an element as parameter.
$('#jqxTree').jqxTree('focus');	//Sets the focus to the widget.
$('#jqxTree').jqxTree('getCheckedItems');	//Gets an array with all checked tree items.Each tree item has the following fields:Item Fields    label - gets item's label.value - gets the item's value.    disabled - gets whether the item is enabled/disabled.    checked - gets whether the item is checked/unchecked.    element - gets the item's LI tag.    parentElement - gets the item's parent LI tag.    isExpanded - gets whether the item is expanded or collapsed.    selected - gets whether the item is selected or not.
$('#jqxTree').jqxTree('getUncheckedItems');	//Gets an array with all unchecked tree items.Each tree item has the following fields:Item Fields    label - gets item's label.value - gets the item's value.    disabled - gets whether the item is enabled/disabled.    checked - gets whether the item is checked/unchecked.    element - gets the item's LI tag.    parentElement - gets the item's parent LI tag.    isExpanded - gets whether the item is expanded or collapsed.    selected - gets whether the item is selected or not.
$('#jqxTree').jqxTree('getItems');	//Gets an array with all tree items.Each tree item has the following fields:Item Fields    label - gets item's label.value - gets the item's value.    disabled - gets whether the item is enabled/disabled.    checked - gets whether the item is checked/unchecked.    element - gets the item's LI tag.    parentElement - gets the item's parent LI tag.    isExpanded - gets whether the item is expanded or collapsed.    selected - gets whether the item is selected or not.
$('#jqxTree').jqxTree('getItem', item);	//Gets the tree item associated to a LI tag passed as parameter. The returned value is an Object.:Item Fields    label - gets item's label.value - gets the item's value.    disabled - gets whether the item is enabled/disabled.    checked - gets whether the item is checked/unchecked.    element - gets the item's LI tag.    parentElement - gets the item's parent LI tag.    isExpanded - gets whether the item is expanded or collapsed.    selected - gets whether the item is selected or not.
$('#jqxTree').jqxTree('getSelectedItem');	//Gets the selected tree item.:Item Fields    label - gets item's label.value - gets the item's value.    disabled - gets whether the item is enabled/disabled.    checked - gets whether the item is checked/unchecked.    element - gets the item's LI tag.    parentElement - gets the item's parent LI tag.    isExpanded - gets whether the item is expanded or collapsed.    selected - gets whether the item is selected or not.
$('#jqxTree').jqxTree('getPrevItem', item);	//Gets the item above another item. The returned value is an Object.:Item Fields    label - gets item's label.value - gets the item's value.    disabled - gets whether the item is enabled/disabled.    checked - gets whether the item is checked/unchecked.    element - gets the item's LI tag.    parentElement - gets the item's parent LI tag.    isExpanded - gets whether the item is expanded or collapsed.    selected - gets whether the item is selected or not.
$('#jqxTree').jqxTree('getNextItem', item);	//Gets the item below another item. The returned value is an Object.:Item Fields    label - gets item's label.value - gets the item's value.    disabled - gets whether the item is enabled/disabled.    checked - gets whether the item is checked/unchecked.    element - gets the item's LI tag.    parentElement - gets the item's parent LI tag.    isExpanded - gets whether the item is expanded or collapsed.    selected - gets whether the item is selected or not.
$('#jqxTree').jqxTree('hitTest', left, top);	//Gets an item at specific position. The method expects 2 parameters - left and top. The coordinates are relative to the document.
$('#jqxTree').jqxTree('removeItem', item);	//Removes an item.
$('#jqxTree').jqxTree('render');	//Renders the jqxTree widget.
$('#jqxTree').jqxTree('refresh');	//Refreshes the jqxTree widget. The refresh method will update the jqxTree's layout and size.
$('#jqxTree').jqxTree('selectItem', item);	//Selects an item.
$('#jqxTree').jqxTree('uncheckAll');	//Unchecks all tree items.
$('#jqxTree').jqxTree('uncheckItem', item);	//Unchecks a tree item.
$('#jqxTree').jqxTree('updateItem', item, newitem);	//Updates an item.
$('#jqxTree').jqxTree('val', value);	//Sets or gets the selected item.



//------- jqxDateTimeInput -------

//set Attributes

$("#jqxDateTimeInput").jqxDateTimeInput({
	animationType: 'slide', //String  … Sets or gets the type of the animation. Possible Values: 'fade' 'slide' 'none'
	allowNullDate: true, //Boolean  … Determines whether Null is allowed as a value. 
	allowKeyboardDelete: true, //Boolean  … Determines whether Backspace and Delete keys are handled by the widget. 
	clearString: 'Clear', //String  … Sets or gets the 'Clear' string displayed when the 'showFooter' property is true. 
	culture: default, //String  … Sets or gets the jqxDateTimeInput's culture. The culture settings are contained within a file with the language code appended to the name, e.g. jquery.glob.de-DE.js for German. To set the culture, you need to include the jquery.glob.de-DE.js and set the culture property to the culture's name, e.g. 'de-DE'. 
	closeDelay: 400, //Number  … Specifies the animation duration of the popup calendar when it is going to be hidden. 
	closeCalendarAfterSelection: true, //Boolean  … Sets or gets whether or not the popup calendar must be closed after selection. 
	dropDownHorizontalAlignment: 'left', //String  … Sets the DropDown's alignment. Possible Values: 'left' 'right'
	dropDownVerticalAlignment: 'bottom', //String  … Sets or gets the DropDown's alignment. Possible Values: 'top' 'bottom'
	disabled: false, //Boolean  … Determines whether the widget is disabled. 
	enableBrowserBoundsDetection: false, //Boolean  … When this property is set to true, the popup calendar may open above the input, if there's not enough space below the DateTimeInput. 
	enableAbsoluteSelection: false, //Boolean  … This setting enables the user to select only one symbol at a time when typing into the text input field. 
	firstDayOfWeek: 0, //Number  … Sets or gets which day to display in the first day column. By default the calendar displays 'Sunday' as first day.
	formatString: dd/MM/yyyy, //String  … Sets or gets the date time input format of the date. Possible Values: 'd'-the day of the month 'dd'-the day of the month 'ddd'-the abbreviated name of the day of the week 'dddd'-the full name of the day of the week 'h'-the hour, using a 12-hour clock from 1 to 12 'hh'-the hour, using a 12-hour clock from 01 to 12 'H'-the hour, using a 24-hour clock from 0 to 23 'HH'-the hour, using a 24-hour clock from 00 to 23 'm'-the minute, from 0 through 59 'mm'-the minutes,from 00 though59 'M'-the month, from 1 through 12; 'MM'-the month, from 01 through 12 'MMM'-the abbreviated name of the month 'MMMM'-the full name of the month 's'-the second, from 0 through 59 'ss'-the second, from 00 through 59 't'-the first character of the AM/PM designator 'tt'-the AM/PM designator 'y'-the year, from 0 to 99 'yy'-the year, from 00 to 99 'yyy'-the year, with a minimum of three digits 'yyyy'-the year as a four-digit number
	height: null, //Number/String  … Sets or gets the height of the jqxDateTimeInput widget. 
	min: Date(1900, 1, 1), //Date  … Sets or gets the jqxDateTimeInput's minumun date. 
	max: Date(2100, 1, 1), //Date  … Sets or gets the jqxDateTimeInput's maximum date. 
	openDelay: 350, //Number  … Specifies the animation duration of the popup calendar when it is going to be displayed. 
	placeHolder: , //String  … Determines the widget's place holder displayed when the widget's value is null. 
	popupZIndex: 20000, //Number  … Sets or gets the popup's z-index. 
	rtl: false, //Boolean  … Sets or gets a value indicating whether widget's elements are aligned to support locales using right-to-left fonts.
	readonly: false, //Boolean  … Set the readonly property . 
	showFooter: false, //Boolean  … Sets or gets a value indicating whether the dropdown calendar's footer is displayed.
	selectionMode: 'default', //String  … Sets or gets the dropdown calendar's selection mode. Possible Values: 'none' 'default' 'range'
	showWeekNumbers: true, //Boolean  … Sets or gets a value whether the week`s numbers are displayed. 
	showTimeButton: false, //Boolean  … Determines whether the time button is visible. 
	showCalendarButton: true, //Boolean  … Determines whether the calendar button is visible. 
	theme: '', //String  … Sets the widget's theme. 
	template: 'default', //String  … Determines the template as an alternative of the default styles. Possible Values: 'default' - the default template. The style depends only on the "theme" property value. 'primary' - dark blue style for extra visual weight. 'success' - green style for successful or positive action. 'warning' - orange style which indicates caution. 'danger' - red style which indicates a dangerous or negative action. 'info' - blue button, not tied to a semantic action or use.
	textAlign: 'left', //String  … Sets or gets the position of the text. 
	todayString: 'Today', //String  … Sets or gets the 'Today' string displayed in the dropdown Calendar when the 'showFooter' property is true. 
	//value: Today's Date, //Date  … Sets or gets the jqxDateTimeInput value. 
	width: null  //Number/String  … Sets or gets the width of the jqxDateTimeInput widget.
}); 


//get Attributes

function getjqxDateTimeInput_attributes(editor) {
	var jqxDateTimeInput_attributes = new Object({
		animationType: editor.jqxDateTimeInput('animationType');
		allowNullDate: editor.jqxDateTimeInput('allowNullDate');
		allowKeyboardDelete: editor.jqxDateTimeInput('allowKeyboardDelete');
		clearString: editor.jqxDateTimeInput('clearString');
		culture: editor.jqxDateTimeInput('culture');
		closeDelay: editor.jqxDateTimeInput('closeDelay');
		closeCalendarAfterSelection: editor.jqxDateTimeInput('closeCalendarAfterSelection');
		dropDownHorizontalAlignment: editor.jqxDateTimeInput('dropDownHorizontalAlignment');
		dropDownVerticalAlignment: editor.jqxDateTimeInput('dropDownVerticalAlignment');
		disabled: editor.jqxDateTimeInput('disabled');
		enableBrowserBoundsDetection: editor.jqxDateTimeInput('enableBrowserBoundsDetection');
		enableAbsoluteSelection: editor.jqxDateTimeInput('enableAbsoluteSelection');
		firstDayOfWeek: editor.jqxDateTimeInput('firstDayOfWeek');
		formatString: editor.jqxDateTimeInput('formatString');
		height: editor.jqxDateTimeInput('height');
		min: editor.jqxDateTimeInput('min');
		max: editor.jqxDateTimeInput('max');
		openDelay: editor.jqxDateTimeInput('openDelay');
		placeHolder: editor.jqxDateTimeInput('placeHolder');
		popupZIndex: editor.jqxDateTimeInput('popupZIndex');
		rtl: editor.jqxDateTimeInput('rtl');
		readonly: editor.jqxDateTimeInput('readonly');
		showFooter: editor.jqxDateTimeInput('showFooter');
		selectionMode: editor.jqxDateTimeInput('selectionMode');
		showWeekNumbers: editor.jqxDateTimeInput('showWeekNumbers');
		showTimeButton: editor.jqxDateTimeInput('showTimeButton');
		showCalendarButton: editor.jqxDateTimeInput('showCalendarButton');
		theme: editor.jqxDateTimeInput('theme');
		template: editor.jqxDateTimeInput('template');
		textAlign: editor.jqxDateTimeInput('textAlign');
		todayString: editor.jqxDateTimeInput('todayString');
		value: editor.jqxDateTimeInput('value');
		width: editor.jqxDateTimeInput('width');
	});
	return jqxDateTimeInput_attributes;
}


//Events

$('#jqxDateTimeInput').on('change', function (event){  //This event is triggered on blur when the value is changed . 
    var jsDate = event.args.date; 
    var type = event.args.type; // keyboard, mouse or null depending on how the date was selected.
}); 

$('#jqxDateTimeInput').on('close', function (event) { });	//This event is triggered when the popup calendar is closed. 

$('#jqxDateTimeInput').on('open', function (event) { }); 	//This event is triggered when the popup calendar is opened. 

$('#jqxDateTimeInput').on('textchanged', function (event) { }); 	//This event is triggered when the text is changed. 
	
$('#jqxDateTimeInput').on('valueChanged', function (event){  	//This event is triggered when the value is changed. 
    var jsDate = event.args.date; 
}); 


//Methods

$(#'jqxDateTimeInput').jqxDateTimeInput('close'); //After calling this method, the popup calendar will be hidden.
$(#'jqxDateTimeInput').jqxDateTimeInput('destroy'); //Destroys the widget.
$(#'jqxDateTimeInput').jqxDateTimeInput('focus'); //Focuses the widget.
$(#'jqxDateTimeInput').jqxDateTimeInput('getRange'); //Gets the selection range when the selectionMode is set to 'range'. The returned value is an Object with "from" and "to" fields. Each of the fields is a JavaScript Date Object. var range = $("'jqxDateTimeInput").jqxDateTimeInput('getRange');    var from = range.from;    var to = range.to;
$(#'jqxDateTimeInput').jqxDateTimeInput('getText'); //Returns the input field's text.
$(#'jqxDateTimeInput').jqxDateTimeInput('getDate'); //When the getDate method is called, the user gets the current date. The returned value is JavaScript Date Object.
$(#'jqxDateTimeInput').jqxDateTimeInput('getMaxDate'); //When the setMaxDate method is called, the user gets the maximum navigation date. The returned value is JavaScript Date Object.
$(#'jqxDateTimeInput').jqxDateTimeInput('getMinDate'); //When the getMinDate method is called, the user gets the minimum navigation date. The returned value is JavaScript Date Object. 
$(#'jqxDateTimeInput').jqxDateTimeInput('open'); //After calling this method, the popup calendar will be displayed.
$(#'jqxDateTimeInput').jqxDateTimeInput('setRange', date1, date2); //Sets the selection range when the selectionMode is set to 'range'. The required parameters are JavaScript Date Objects.
$(#'jqxDateTimeInput').jqxDateTimeInput('setMinDate', date); //When the setMinDate method is called, the user sets the minimum date to which it is possible to navigate.
$(#'jqxDateTimeInput').jqxDateTimeInput('setMaxDate', date); //When the setMaxDate method is called, the user sets the maximum date to which it is possible to navigate.
$(#'jqxDateTimeInput').jqxDateTimeInput('setDate', date); //When the setDate method is called, the user sets the date. The required parameter is a JavaScript Date Object.


//------- jqxInput -------

//set Attributes

$("#jqxInput").jqxInput({
	disabled: false, //Boolean  … Enables or disables the jqxInput.
	dropDownWidth: null, //Number/String  … Sets or gets the jqxInput's dropDown width.
	//displayMember: , //String  … Sets or gets the displayMember of the Items. The displayMember specifies the name of an object property to display. The name is contained
	height: null, //Number/String  … Sets or gets the jqxInput's height.
	items: 8, //Number  … Sets or gets the maximum number of items to display in the popup menu.
	minLength: 1, //Number  … Sets or gets the minimum character length needed before triggering auto-complete suggestions.
	maxLength: null, //Number  … Sets or gets the maximum character length of the input.
	opened: false, //Boolean  … Sets or gets a value indicating whether the auto-suggest popup is opened.
	placeHolder: "", //String  … Sets or gets the input's place holder.
	popupZIndex: 20000, //Number  … Sets or gets the auto-suggest popup's z-index.
	//query: "", //String  … Determines the input's query.
	//renderer: null, //function  … Enables you to update the input's value, after a selection from the auto-complete popup.
	rtl: false, //Boolean  … Sets or gets a value indicating whether widget's elements are aligned to support locales using right-to-left fonts.
	searchMode: 'default', //String  … Sets or gets the search mode. When the user types into the edit field, the jqxInput widget tries to find the searched item using the entered text and the selected search mode. Possible Values: 'none' 'contains' 'containsignorecase' 'equals' 'equalsignorecase' 'startswithignorecase' 'startswith' 'endswithignorecase' 'endswith'
	source: [], //Array, function  … Sets the widget's data source. The 'source' function is passed two arguments, the input field's value and a callback function. The 'source' function may be used synchronously by returning an array of items or asynchronously via the callback.
	theme: '', //String  … Sets the widget's theme.
	valueMember: "", //String  … Sets or gets the valueMember of the Items. The valueMember specifies the name of an object property to set as a 'value' of the list items. The name is contained in the collection specified by the 'source' property.
	width: null , //Number/String  … Sets or gets the jqxInput's width.
	//val: ""//String … Sets or gets the value.
}); 


//get Attributes

function getjqxInput_attributes(editor) {
	var jqxInput_attributes = new Object({
		disabled: editor.jqxInput('disabled');
		dropDownWidth: editor.jqxInput('dropDownWidth');
		displayMember: editor.jqxInput('displayMember');
		height: editor.jqxInput('height');
		items: editor.jqxInput('items');
		minLength: editor.jqxInput('minLength');
		maxLength: editor.jqxInput('maxLength');
		opened: editor.jqxInput('opened');
		placeHolder: editor.jqxInput('placeHolder');
		popupZIndex: editor.jqxInput('popupZIndex');
		query: editor.jqxInput('query');
		renderer: editor.jqxInput('renderer');
		rtl: editor.jqxInput('rtl');
		searchMode: editor.jqxInput('searchMode');
		source: editor.jqxInput('source');
		theme: editor.jqxInput('theme');
		valueMember: editor.jqxInput('valueMember');
		width: editor.jqxInput('width');
		val: editor.jqxInput('val');
	});
	return jqxInput_attributes;
}


//Events

$('#jqxInput').on('change', function (event) {	//This event is triggered when the value is changed. 
   var type = event.args.type; // keyboard, mouse or null depending on how the value was changed.
   var value = $('#jqxInput').jqxInput('val'); 
}); 

$('#jqxInput').on('close', function (event) { });	//This event is triggered when the auto-suggest popup is closed. 

$('#jqxInput').on('open', function (event) { }); 	//This event is triggered when the auto-suggest popup is opened. 

$('#jqxInput').on('select', function (event) { var value = $('#jqxInput').jqxInput('val'); }); 	//This event is triggered when an item is selected from the auto-suggest popup. 


//Methods

$('#jqxInput').jqxInput('destroy'); //Destroys the widget.
$('#jqxInput').jqxInput('focus'); //Focuses the widget.
$('#jqxInput').jqxInput('selectAll'); //Selects the text in the input field.




//------- jqxTabs -------

//set Attributes

$('#jqxTabs').jqxTabs({
	animationType: 'none', //String  … Sets or gets the animation type of switching tabs.Possible Values: 'none','fade'
	autoHeight: true, //Boolean  … Sets or gets whether the jqxTabs header's height will be equal to the item with max height.
	closeButtonSize: 16, //Number  … Sets or gets the close button size.
	collapsible: false, //Boolean  … Enables or disables the collapsible feature.
	contentTransitionDuration: 450, //Number  … Sets or gets the duration of the content's fade animation which occurs when the user selects a tab. This setting has effect when the 'animationType' is set to 'fade'.
	disabled: false, //Boolean  … Enables or disables the jqxTabs widget.
	enabledHover: true, //Boolean  … Enables or disables the tabs hover effect.
	enableScrollAnimation: true, //Boolean  … Sets or gets whether the scroll animation is enabled.
	height: 'auto', //Number/String  … Sets or gets widget's height.
	initTabContent: null, //function  … Callback function that the tab calls when a content panel needs to be initialized.
	keyboardNavigation: true, //Boolean  … Enables or disables the keyboard navigation.
	position: 'top', //String  … Sets or gets whether the tabs are positioned at 'top' or 'bottom'.Possible Values: 'top','bottom'
	reorder: false, //Boolean  … Enables or disables the reorder feature. When this feature is enabled, the end-user can drag a tab and drop it over another tab. As a result the tabs will be reordered.
	rtl: false, //Boolean  … Sets or gets a value indicating whether widget's elements are aligned to support locales using right-to-left fonts.
	scrollAnimationDuration: 250, //Number  … Sets or gets the duration of the scroll animation.
	selectedItem: 0, //Number  … Sets or gets selected tab.
	selectionTracker: false, //Boolean  … Sets or gets whether the selection tracker is enabled.
	scrollable: true, //Boolean  … Sets or gets whether the scrolling is enabled.
	scrollPosition: 'right', //String  … Sets or gets the position of the scroll arrows.Possible Values: 'left','right','both'
	scrollStep: 70, //Number  … Sets or gets the scrolling step.
	showCloseButtons: false, //Boolean  … Sets or gets whether a close button is displayed in each tab.
	toggleMode: 'click', //String  … Sets or gets user interaction used for switching the different tabs.Possible Values: 'click','dblclick','mouseenter','none'
	theme: '', //String  … Sets the widget's theme.
	width: 'auto' //Number/String  … Sets or gets widget's width.
});

//get Attributes

function getjqxtabs_attributes(editor) {
	var jqxtabs_attributes = new Object({
		animationType: editor.jqxTabs('animationType');
		autoHeight: editor.jqxTabs('autoHeight');
		closeButtonSize: editor.jqxTabs('closeButtonSize');
		collapsible: editor.jqxTabs('collapsible');
		contentTransitionDuration: editor.jqxTabs('contentTransitionDuration');
		disabled: editor.jqxTabs('disabled');
		enabledHover: editor.jqxTabs('enabledHover');
		enableScrollAnimation: editor.jqxTabs('enableScrollAnimation');
		height: editor.jqxTabs('height');
		initTabContent: editor.jqxTabs('initTabContent');
		keyboardNavigation: editor.jqxTabs('keyboardNavigation');
		position: editor.jqxTabs('position');
		reorder: editor.jqxTabs('reorder');
		rtl: editor.jqxTabs('rtl');
		scrollAnimationDuration: editor.jqxTabs('scrollAnimationDuration');
		selectedItem: editor.jqxTabs('selectedItem');
		selectionTracker: editor.jqxTabs('selectionTracker');
		scrollable: editor.jqxTabs('scrollable');
		scrollPosition: editor.jqxTabs('scrollPosition');
		scrollStep: editor.jqxTabs('scrollStep');
		showCloseButtons: editor.jqxTabs('showCloseButtons');
		toggleMode: editor.jqxTabs('toggleMode');
		theme: editor.jqxTabs('theme');
		width: editor.jqxTabs('width');
		val: editor.jqxTabs('val');
	});
	return jqxtabs_attributes;
}


//Events

$('#jqxTabs').on('add', function(event) {
	//This event is triggered when a new tab is added to the jqxTabs. 
});
$('#jqxTabs').on('created', function(event) {
	//This event is triggered when the jqxTabs is created. You should subscribe to this event before the jqxTabs initialization. 
});
$('#jqxTabs').on('collapsed', function(event) {
	//Theis event is triggered when any tab is collapsed. 
});
$('#jqxTabs').on('dragStart', function(event) {
	//This event is triggered when the drag operation started.
});
$('#jqxTabs').on('dragEnd', function(event) {
	//This event is triggered when the drag operation ended. 
});
$('#jqxTabs').on('expanded', function(event) {
	//This event is triggered when any tab is expanded. 
});
$('#jqxTabs').on('removed', function(event) {
	//This event is triggered when a tab is removed. 
});
$('#jqxTabs').on('selecting', function(event) {
	//This event is triggered when the user selects a tab. This event is cancelable. You can cancel the selection by setting the 'event.cancel = true' in the event callback. 
});
$('#jqxTabs').on('selected', function(event) {
	//This event is triggered when the user selects a new tab. 
});
$('#jqxTabs').on('tabclick', function(event) {
	//This event is triggered when the user click a tab. You can retrieve the clicked tab's index. 
});
$('#jqxTabs').on('unselecting', function(event) {
	//This event is triggered when the user selects a tab. The last selected tab is going to become unselected. This event is cancelable. You can cancel the selection by setting the 'event.cancel = true' in the event callback. 
});
$('#jqxTabs').on('unselected', function(event) {
	//This event is triggered when the user selects a tab. The last selected tab becomes unselected.
});


//Methods

$('#jqxTabs').jqxTabs('addAt', index, title, content); //Adding tab at indicated position.
$('#jqxTabs').jqxTabs('addFirst', html-element); //Adding tab at the beginning.
$('#jqxTabs').jqxTabs('addLast', html-element); //Adding tab at the end.
$('#jqxTabs').jqxTabs('collapse'); //Collapsing the current selected tab.
$('#jqxTabs').jqxTabs('disable'); //Disabling the widget.
$('#jqxTabs').jqxTabs('disableAt', index); //Disabling tab with indicated index.
$('#jqxTabs').jqxTabs('destroy'); //Destroys the widget.
$('#jqxTabs').jqxTabs('ensureVisible', index); //This method is ensuring the visibility of item with indicated index. If the item is currently not visible the method is scrolling to it.
$('#jqxTabs').jqxTabs('enableAt', index); //Enabling tab with indicated index.
$('#jqxTabs').jqxTabs('expand'); //Expanding the current selected tab.
$('#jqxTabs').jqxTabs('enable'); //Enabling the widget.
$('#jqxTabs').jqxTabs('focus'); //Focuses the widget.
$('#jqxTabs').jqxTabs('getTitleAt', index); //Gets the title of a Tab. The returned value is a "string".
$('#jqxTabs').jqxTabs('getContentAt', index); //Gets the content of a Tab. The returned value is a HTML Element.
$('#jqxTabs').jqxTabs('hideCloseButtonAt', index); //Hiding a close button at a specific position.
$('#jqxTabs').jqxTabs('hideAllCloseButtons'); //Hiding all close buttons.
$('#jqxTabs').jqxTabs('length'); //Returning the tabs count.
$('#jqxTabs').jqxTabs('removeAt', index); //Removing tab with indicated index.
$('#jqxTabs').jqxTabs('removeFirst'); //Removing the first tab.
$('#jqxTabs').jqxTabs('removeLast'); //Removing the last tab.
$('#jqxTabs').jqxTabs('select', index); //Selecting tab with indicated index.
$('#jqxTabs').jqxTabs('setContentAt', index, html-element); //Sets the content of a Tab.
$('#jqxTabs').jqxTabs('setTitleAt', index, html-element); //Sets the title of a Tab.
$('#jqxTabs').jqxTabs('showCloseButtonAt', index); //Showing close button at a specific position.
$('#jqxTabs').jqxTabs('showAllCloseButtons'); //Showing all close buttons.
$('#jqxTabs').jqxTabs('val', value); //





