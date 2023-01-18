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
 
import mx.controls.List;
import mx.utils.Delegate;

import com.code4net.alf.FlashLibrary;
import com.code4net.alf.view.FormBase;
import com.code4net.alf.view.IResultView;

class com.code4net.alf.view.NameSearchView extends FormBase
										   implements IResultView {
	public var resultsList:List;
	
	public function loadComplete () {
		resultsList.addEventListener("change",Delegate.create(this,resultsSelectionChange));
	}
	
	public function clean () {
		resultsList.dataProvider = new Array();
	}
	
	public function addItem(item : Object) {
		resultsList.addItem (item);	
	}

	public function sort() {
		resultsList.dataProvider.sortItemsBy("label", "ASC");
	}
	
	private function resultsSelectionChange(evt:Object) {
		if (List(evt.target).selectedItems.length > 1) {
			var items:Array = List(evt.target).selectedItems;
			FlashLibrary.getInstance().onSelectMultipleItems(items);
		} else {
			var item:Array = List(evt.target).selectedItem.data; 
			FlashLibrary.getInstance().onSelectItem(item);
		}
	}
	
	public function focusResultList() {
		Selection.setFocus(resultsList);
	}
}