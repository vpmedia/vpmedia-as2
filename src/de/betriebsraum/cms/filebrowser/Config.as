class de.betriebsraum.cms.filebrowser.Config {
	
	
	private static var _INSTANCE:Config;
		
	
	private function Config() {		
		
	}	
	
	
	public static function getInstance():Config {
		
		if (_INSTANCE == null) _INSTANCE = new Config();		
		return _INSTANCE;
		
	}
	
	
	/***************************************************************************
	// Paths
	***************************************************************************/
	// relative to php scripts
	public function get uploadDir():String {
		return "../../upload/";
	}
	
	// relative to fileBrowser swf
	public function get downloadDir():String {
		return "upload/";
	}
	
	// relative to fileBrowser swf (or relative to swf into which fileBrowser swf is loaded!)
	public function get viewDir():String {
		return "upload/";
	}
	
	// relative to fileBrowser swf
	public function get uploadScript():String {
		return "php/flashservices/upload.php";
	}
	
	// absolute path
	public function get gatewayUrl():String {
		return "http://www.betriebsraum.de/FileBrowser/php/amfphp/gateway.php";
	}
	
	
	/***************************************************************************
	// FileTypes
	***************************************************************************/
	public function get fileTypes():Array {	
			
		return [{description: "All Formats (*.jpg,*.gif,*.png,*.swf,*.zip)", extension: "*.jpg;*.gif;*.png;*.swf;*.zip", macType: "JPEG;jp2_;GIFF;SWFL;ZIPP"},
		        {description: "All Image Formats (*.jpg,*.gif,*.png)", extension: "*.jpg;*.gif;*.png", macType: "JPEG;jp2_;GIFF"},
		        {description: "Flash Movies (*.swf)", extension: "*.swf", macType: "SWFL"},
		        {description: "Zip Files (*.zip)", extension: "*.zip", macType: "ZIPP"}];
		        	
	}
	
	
	
	/***************************************************************************
	// StatusBox
	***************************************************************************/
	public function get okLabel():String {		
		return "OK";		
	}
	
	public function get cancelLabel():String {		
		return "Cancel";		
	}
	
	public function get infoTitle():String {		
		return "Info";		
	}
	
	public function get loadTitle():String {		
		return "Loading";		
	}
	
	public function get loadMessage():String {		
		return "Loading data...";		
	}	
	
	public function get errorTitle():String {		
		return "Error";		
	}
	
	public function get errorMessage():String {		
		return "Connection error!";		
	}
	
	public function get noFilesSelectedMessage():String {		
		return "Please select one or more file(s)!";		
	}		
	
	public function get confirmDeleteTitle():String {		
		return "Warning";		
	}
	
	public function get confirmDeleteMessage():String {		
		return "Really delete selected files?";		
	}	
	
	public function get noFilesAddedMessage():String {		
		return "Please add one or more file(s) first!";		
	}
	
	public function get browseFilesErrorMessage():String {		
		return "Couldn't open file browser!";		
	}
	
	public function get cleanUpFilesMessage():String {		
		return "Duplicate/Illegal file types were removed!";		
	}
	
	public function get noThumbSizeSetMessage():String {		
		return "Please specify the thumbnail size!";		
	}
	
	public function get nonusedFilesMessage():String {		
		return "All files in this folder are currently in use!";		
	}	
	
	public function get uploadTitle():String {		
		return "Upload";		
	}
	
	public function get waitForUpload():String {		
		return "Initializing...";		
	}
	
	public function get downloadTitle():String {		
		return "Download";		
	}
	
	public function get waitForDownload():String {		
		return "Save file...";		
	}	
	
	public function get totalPercentLabel():String {		
		return "total: ";		
	}	
	
	
	/***************************************************************************
	// Tooltips
	***************************************************************************/	
	public function get browseTip():String {		
		return "Select file";		
	}
	
	public function get removeTip():String {		
		return "Remove selected file(s)";		
	}
	
	public function get refreshTip():String {		
		return "Refresh file list";		
	}
	
	public function get downloadTip():String {		
		return "Download selected file(s)";		
	}
	
	public function get nonusedTip():String {		
		return "Select nonused files";		
	}
	
	public function get deleteTip():String {		
		return "Delete selected file(s)";		
	}
	
	public function get uploadTip():String {		
		return "Upload file(s)";		
	}
	
	public function get viewTip():String {		
		return "Load selected image";		
	}
	
	
}