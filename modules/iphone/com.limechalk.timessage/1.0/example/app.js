var MessageDialogModule = require('com.limechalk.timessage');
var TiMessageDialog = MessageDialogModule.createMessageDialog();


// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});

Ti.API.info("Is supported? " + TiMessageDialog.isSupported() ? "yes" : "no");
Ti.API.info("Is attachment supported? " + TiMessageDialog.isAttachmentSupported() ? "yes" : "no");

var button = Ti.UI.createButton({
	width: 250,
	height: 36,
	title: "Open Message Dialog"
});
button.addEventListener('click', function(e) {
	Ti.API.info("Opening message dialog");
	
	TiMessageDialog.addEventListener('error', function(e) {
		alert("Error: " + JSON.stringify(e));
	});
	
	TiMessageDialog.recipients = ["+639176490093"];
	TiMessageDialog.message = "This is a test message";
	TiMessageDialog.attachmentPath = Titanium.Filesystem.getFile(Titanium.Filesystem.resourcesDirectory + "KS_nav_ui.png").nativePath;
	TiMessageDialog.attachmentName = "KS_nav_ui.png";
	
	// open the dialog
	TiMessageDialog.openDialog({animated: false});
});

win.add(button);

win.open();





