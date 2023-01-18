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
import com.code4net.alf.helpers.ItemHelper;
import com.code4net.alf.view.FormBase;
import com.code4net.alf.view.IResultView;
import com.code4net.as.dataTypes.HashMap;

class com.code4net.alf.view.ClassSearchView extends FormBase
											implements IResultView {
	
	private var classes:HashMap;
	private var classResultsList:List;
	private var itemsResultsList:List;
	
	public function loadComplete () {
		classResultsList.addEventListener("change",Delegate.create(this,selectedClassChange));
		itemsResultsList.addEventListener("change",Delegate.create(this,selectedItemChange));
	}
	
	public function addItem(item : Object) {
		var items:Array;
		if (!classes.hasKey(item.label)) {
			items = new Array();
			items.push(item.data);
			classes.put(item.label,items);
			classResultsList.addItem (item);
		} else {
			items = classes.get(item.label);
			items.push (item.data);
		}
	}

	public function clean() {
		classes = new HashMap();
		classResultsList.dataProvider = new Array();
		itemsResultsList.dataProvider = new Array();
	}

	public function sort() {
		classResultsList.dataProvider.sortItemsBy("label", "ASC");
		itemsResultsList.dataProvider.sortItemsBy("label", "ASC");
	}
	
	private function selectedClassChange(evt:Object) {
		var className = List(evt.target).selectedItem.label;
		var items:Array = classes.get (className);
		var it;
		
		itemsResultsList.dataProvider = new Array();
		
		for (it in items) {
			itemsResultsList.addItem ({label:items[it][ItemHelper.NAME],data:items[it]});
		}
		
		FlashLibrary.getInstance().onSelectItem(null);
	}
	
	private function selectedItemChange (evt:Object) {
		if (List(evt.target).selectedItems.length > 1) {
			var items:Array = List(evt.target).selectedItems;
			FlashLibrary.getInstance().onSelectMultipleItems(items);
		} else {
			var item:Array = List(evt.target).selectedItem.data; 
			FlashLibrary.getInstance().onSelectItem(item);
		}
	}
	
	public function focusResultList() {
		Selection.setFocus(classResultsList);
	}
}