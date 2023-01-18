/**
 *  Copyright (C) 2006 Xavi Beumala
 *  
 *	This program is free software; you can redistribute it and/or modify 
 *	it under the terms of the GNU General Public License as published by 
 *	the Free Software Foundation; either version 2 of the License, or 
 *	(at your option) any later version.
 *	
 *	This program is distributed in the hope that it will be useful, but 
 *	WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
 *	or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
 *	for more details.
 *	
 *	You should have received a copy of the GNU General Public License along
 *	with this program; if not, write to the Free Software Foundation, Inc., 59 
 *	Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *	
 *  @author Xavi Beumala
 *  @link http://www.code4net.com
 */
 
import com.code4net.alf.helpers.ItemHelper;

class com.code4net.alf.helpers.LibraryHelper {
	public static function getLibraryItems():Array {
		var result:String = MMExecute("fl.runScript (fl.configURI + \"Commands/alf/library.jsfl\",\"getLibrary\")");
		return ItemHelper.deserialize(result);
	}
	
	public static function addItemToDocument (itemName:String) {
		MMExecute("fl.runScript (fl.configURI + \"Commands/alf/library.jsfl\",\"addItemToDocument\",\"" + itemName + "\");");
	}
	
	public static function selectInLibrary (itemName:String) {
		MMExecute("fl.runScript (fl.configURI + \"Commands/alf/library.jsfl\",\"selectInLibrary\",\"" + itemName + "\");");
	}
	
	public static function editItem (itemName:String) {
		MMExecute("fl.runScript (fl.configURI + \"Commands/alf/library.jsfl\",\"editItem\",\"" + itemName + "\");");
	}
	
	public static function editScreen(itemName : String) {
		MMExecute("fl.runScript (fl.configURI + \"Commands/alf/library.jsfl\",\"editScreen\",\"" + itemName + "\");");	
	}
	
	public static function changeItemClass (item:Array,className:String) {
		switch (item[ItemHelper.ITEM_TYPE]) {
			case ItemHelper.MOVIE_CLIP:
				MMExecute("fl.runScript (fl.configURI + \"Commands/alf/library.jsfl\",\"selectInLibrarySilently\",\"" + item[ItemHelper.NAME] + "\");");
				MMExecute("fl.runScript (fl.configURI + \"Commands/alf/library.jsfl\",\"setLibraryItemProperty\",\"linkageClassName," + className + "\");");
				break;
			case ItemHelper.SCREEN:
				break;
		}
	}
	
	public static function changeItemProperties (item:Array) {
		switch (item[ItemHelper.ITEM_TYPE]) {
			case ItemHelper.MOVIE_CLIP:
				MMExecute("fl.runScript (fl.configURI + \"Commands/alf/library.jsfl\",\"selectInLibrarySilently\",\"" + item[ItemHelper.NAME] + "\");");
				MMExecute("fl.runScript (fl.configURI + \"Commands/alf/library.jsfl\",\"setLibraryItemProperty\",\"name," + item[ItemHelper.NEW_NAME]+ "\");");			
				MMExecute("fl.runScript (fl.configURI + \"Commands/alf/library.jsfl\",\"setLibraryItemProperty\",\"linkageIdentifier," + item[ItemHelper.LINKAGE_IDENTIFIER]+ "\");");			
				MMExecute("fl.runScript (fl.configURI + \"Commands/alf/library.jsfl\",\"setLibraryItemProperty\",\"linkageClassName," + item[ItemHelper.LINKAGE_CLASS_NAME]+ "\");");
				break;
			case ItemHelper.SCREEN:
				MMExecute("fl.runScript (fl.configURI + \"Commands/alf/library.jsfl\",\"editScreen\",\"" + item[ItemHelper.NAME] + "\");");
	
				if (item[ItemHelper.NEW_NAME] != item[ItemHelper.NAME]) {
					MMExecute("fl.runScript (fl.configURI + \"Commands/alf/library.jsfl\",\"renameScreen\",\"" + item[ItemHelper.NEW_NAME]+ "\");");			
				}
				MMExecute("fl.runScript (fl.configURI + \"Commands/alf/library.jsfl\",\"setScreenProperty\",\"linkageID," + item[ItemHelper.LINKAGE_IDENTIFIER]+ "\");");			
				MMExecute("fl.runScript (fl.configURI + \"Commands/alf/library.jsfl\",\"setScreenProperty\",\"className," + item[ItemHelper.LINKAGE_CLASS_NAME]+ "\");");
				break;
		}
	}
}