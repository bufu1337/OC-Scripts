$(document).ready(function () {
	$('#mainSplitter').jqxSplitter({  width: 1598, height: 718, panels: [{ size: 300, min: 300 }, {min: 300, size: 300}] });
	$('#contentSplitter').jqxSplitter({ width: '100%', height: '100%', panels: [{ size: 620, min: 300, collapsible: false }, { min: 300, collapsible: true}] });
	MC.go.Mod("");
});