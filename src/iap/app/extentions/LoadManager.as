/*
 *This file is part of MovieClipCommander Framework.
 *
 *   MovieClipCommander Framework  is free software; you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation; either version 2 of the License, or
 *    (at your option) any later version.
 *
 *    MovieClipCommander Framework is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with MovieClipCommander Framework; if not, write to the Free Software
 *    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */
 import iap.app.ConfigurationManager;
import iap.app.GlobalParams;
import iap.manager.LoadingManager;

/**
* LoadManager extention for AppCommander
* --------------------------------------
* Wraps a LoadingManager class and provide a way to synchronize 
* a download of several data files. 
* @author      I.A.P Itzik Arzoni (itzik.mcc@gmail.com)
*/
class iap.app.extentions.LoadManager extends iap.commander.extentions.AbstractLoader {
	/**
	* Fires when loading of all components is complete
	* extra info:
	*   [B]downloads[/B] - all the downloads requested by getURL sorted by the names returned as a string from getURL
	*/
	static var EVT_LOAD_COMPLETE:String = "loadManagerComplete";
	
	private var __prefix:String;
	private var __postfix:String;
	private var __loadManager:LoadingManager;
	private var __dictionary:Object;
	private var __downloads:Object;

	private function init()	{
		__loadManager = new LoadingManager();
		__dictionary = new Object();
		__downloads = new Object();
		__loadManager.addEventListener(LoadingManager.EVT_LOAD_COMPLETE, this);
		configurePrefixes()
	}
	
	/**
	* adds a Url to download
	* @param	fileName	the fileName to download
	* @param	name	the name to give the download. (if omitted, the name is auto generated from the file name
	* @return	the name given to the download
	*/
	public function addURL(fileName:String, name:String):String {
		var newFileName:String = getProperFileName(fileName);
		var newName:String = __loadManager.addURL(newFileName);
		if (name == undefined) {
			name = newName;
		}
		__dictionary[newName] = name;
		return name;
	}
	
	/**
	* begin loading the files
	*/
	public function startLoading() {
		__loadManager.startLoading();
	}
	
	/**
	* gets an XML from the downloads
	* @param	name	the name of the download
	* @return	an XML object
	*/
	public function getXML(name:String):XML{
		return XML(__downloads[name]);
	}
	
	/**
	* resets the downloads  list
	*/
	private function reset() {
		__dictionary = new Array();
		__downloads = new Array();
	}
	
	/**
	* convert the new downlods by the dictionary definition
	* @param	downloadsObj	the raw donlods object
	*/
	private function importDownloads(downloadsObj:Object) {
		for (var o:String in downloadsObj) {
			__downloads[__dictionary[o]] = downloadsObj[o];
		}
	}
	
	public function handleEvent(evt:Object) {
//		trace(__commander+", handle event of type: "+evt.type);
		switch (evt.type) {
			case LoadingManager.EVT_LOAD_COMPLETE:
				if (evt.success) {
					importDownloads(evt.downloads);
					dispatchEvent(EVT_LOAD_COMPLETE, {downloads:__downloads, success:true});
					reset();
				} else {
					trace("~5ERROR: Loading manager failed loadin with status: "+evt.status);
					dispatchEvent(EVT_LOAD_COMPLETE, {downloads:__downloads, success:false});
				}
				break;
		}
	}
}
