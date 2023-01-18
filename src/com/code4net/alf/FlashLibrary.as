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
 
import mx.controls.Button;
import mx.controls.RadioButton;
import mx.controls.RadioButtonGroup;
import mx.controls.TextInput;
import mx.screens.Form;
import mx.utils.Delegate;

import com.code4net.alf.actions.AttachItemAction;
import com.code4net.alf.actions.ChangeSearchTypeAction;
import com.code4net.alf.actions.EditItemAction;
import com.code4net.alf.actions.FiltersButtonManager;
import com.code4net.alf.actions.FocusListAction;
import com.code4net.alf.actions.InputTextAction;
import com.code4net.alf.actions.SelectInLibraryAction;
import com.code4net.alf.filters.FilterCollection;
import com.code4net.alf.filters.FilterFactory;
import com.code4net.alf.filters.IFilter;
import com.code4net.alf.filters.TextPatternFilter;
import com.code4net.alf.helpers.ItemHelper;
import com.code4net.alf.helpers.LibraryHelper;
import com.code4net.alf.helpers.SearchAlgorithm;
import com.code4net.alf.persistence.PersistentFilters;
import com.code4net.alf.view.IResultView;
import com.code4net.as.iterators.LinearIterator;
import com.code4net.as.managers.shortcut.Shortcut;
import com.code4net.as.managers.ShortcutManager;

class com.code4net.alf.FlashLibrary extends Form {
	private static var instance:FlashLibrary;
	
	private var mc_btn:Button;
	private var graphic_btn:Button;
	private var bitmap_btn:Button;
	private var sound_btn:Button;
	private var font_btn:Button;
	private var compiled_btn:Button;
	private var screen_btn:Button;
	
	private var filtersManager:FiltersButtonManager;
	
	private var close_btn:Button;
	private var edit_btn:Button;
	private var select_btn:Button;
	private var attach_btn:Button;
	private var apply_btn:Button;

	private var name_rb:RadioButton;
	private var linkage_rb:RadioButton;
	private var className_rb:RadioButton;
	private var searchType_rb:RadioButtonGroup;
	
	public var searchPattern:TextInput;

	private var searchType:Number; 
	private var libraryItems:Array;
	private var activeFilters:FilterCollection;
	private var filters_so:PersistentFilters;
	
	public var currentResultsView:Form;
	private var classSearchView:Form;
	private var nameSearchView:Form;
	
	private var symbolType_txt:TextField;
	private var symbolName_txt:TextInput;
	private var linkage_txt:TextInput;
	private var class_txt:TextInput;
	
	public var selectedItems:Array;
	
	public function FlashLibrary() {
		addEventListener("load",loadComplete);
		instance = this;
	}
	
	public function loadComplete() {
		registerAssets();
		registerShortcuts();
		initApp();
	}
	
	private function registerAssets() {
		name_rb.data = ItemHelper.NAME;
		linkage_rb.data = ItemHelper.LINKAGE_IDENTIFIER;
		className_rb.data = ItemHelper.LINKAGE_CLASS_NAME;
		searchType_rb.addEventListener("click",Delegate.create(this,searchTypeChange));
		
		var callback:Function = Delegate.create (this,filterTypeToggled);
		mc_btn.addEventListener ("draw",callback);
		graphic_btn.addEventListener ("draw",callback);
		bitmap_btn.addEventListener ("draw",callback);
		sound_btn.addEventListener ("draw",callback);
		font_btn.addEventListener ("draw",callback);
		compiled_btn.addEventListener ("draw",callback);
		screen_btn.addEventListener ("draw",callback);
				
		searchPattern.restrict = "a-z 0-9 \\-\\_\\.\\$\\&";
		searchPattern.addEventListener("change",Delegate.create(this,invalidateSearchPattern));
		
		var action:Function = Delegate.create(this,buttonAction);
		close_btn.addEventListener("click",action);
		edit_btn.addEventListener("click",action);
		attach_btn.addEventListener("click",action);
		select_btn.addEventListener("click",action);
		apply_btn.addEventListener("click",action);
	}
	
	private function registerShortcuts() {
		var s:ShortcutManager = ShortcutManager.getInstance();
		
		filtersManager = new FiltersButtonManager();
		filtersManager.registerFilter(mc_btn);
		filtersManager.registerFilter(graphic_btn);
		filtersManager.registerFilter(bitmap_btn);
		filtersManager.registerFilter(sound_btn);
		filtersManager.registerFilter(font_btn);
		filtersManager.registerFilter(compiled_btn);
		filtersManager.registerFilter(screen_btn);
		
		s.registerShortcut(new Shortcut(filtersManager,{actionType:FiltersButtonManager.DISABLE_ALL_ON_SELECT,filter:mc_btn},[Key.CONTROL,Key.SHIFT],"1"));
		s.registerShortcut(new Shortcut(filtersManager,{actionType:FiltersButtonManager.TOGGLE,filter:mc_btn},[Key.SHIFT],"1"));
		
		s.registerShortcut(new Shortcut(filtersManager,{actionType:FiltersButtonManager.DISABLE_ALL_ON_SELECT,filter:graphic_btn},[Key.CONTROL,Key.SHIFT],"2"));
		s.registerShortcut(new Shortcut(filtersManager,{actionType:FiltersButtonManager.TOGGLE,filter:graphic_btn},[Key.SHIFT],"2"));
		
		s.registerShortcut(new Shortcut(filtersManager,{actionType:FiltersButtonManager.DISABLE_ALL_ON_SELECT,filter:bitmap_btn},[Key.CONTROL,Key.SHIFT],"3"));
		s.registerShortcut(new Shortcut(filtersManager,{actionType:FiltersButtonManager.TOGGLE,filter:bitmap_btn},[Key.SHIFT],"3"));
		
		s.registerShortcut(new Shortcut(filtersManager,{actionType:FiltersButtonManager.DISABLE_ALL_ON_SELECT,filter:sound_btn},[Key.CONTROL,Key.SHIFT],"4"));
		s.registerShortcut(new Shortcut(filtersManager,{actionType:FiltersButtonManager.TOGGLE,filter:sound_btn},[Key.SHIFT],"4"));
		
		s.registerShortcut(new Shortcut(filtersManager,{actionType:FiltersButtonManager.DISABLE_ALL_ON_SELECT,filter:font_btn},[Key.CONTROL,Key.SHIFT],"5"));
		s.registerShortcut(new Shortcut(filtersManager,{actionType:FiltersButtonManager.TOGGLE,filter:font_btn},[Key.SHIFT],"5"));
		
		s.registerShortcut(new Shortcut(filtersManager,{actionType:FiltersButtonManager.DISABLE_ALL_ON_SELECT,filter:compiled_btn},[Key.CONTROL,Key.SHIFT],"6"));
		s.registerShortcut(new Shortcut(filtersManager,{actionType:FiltersButtonManager.TOGGLE,filter:compiled_btn},[Key.SHIFT],"6"));
		
		s.registerShortcut(new Shortcut(filtersManager,{actionType:FiltersButtonManager.DISABLE_ALL_ON_SELECT,filter:screen_btn},[Key.CONTROL,Key.SHIFT],"7"));
		s.registerShortcut(new Shortcut(filtersManager,{actionType:FiltersButtonManager.TOGGLE,filter:screen_btn},[Key.SHIFT],"7"));

		s.registerShortcut(new Shortcut(filtersManager,{actionType:FiltersButtonManager.DISABLE_ALL},[Key.SHIFT],"d"));
		s.registerShortcut(new Shortcut(filtersManager,{actionType:FiltersButtonManager.ENABLE_ALL},[Key.SHIFT],"a"));
		
		
		s.registerShortcut(new Shortcut(new AttachItemAction(),null,[Key.CONTROL,Key.SHIFT],Key.ENTER));
		s.registerShortcut(new Shortcut(new EditItemAction(),null,[Key.CONTROL],Key.ENTER));
		s.registerShortcut(new Shortcut(new SelectInLibraryAction(),null,[Key.SHIFT],Key.ENTER));
		
		s.registerShortcut(new Shortcut(new FocusListAction(),null,[],Key.DOWN));
		s.registerShortcut(new Shortcut(new ChangeSearchTypeAction(name_rb),null,[Key.CONTROL],"n"));
		s.registerShortcut(new Shortcut(new ChangeSearchTypeAction(linkage_rb),null,[Key.CONTROL],"l"));
		s.registerShortcut(new Shortcut(new ChangeSearchTypeAction(className_rb),null,[Key.CONTROL],"s"));
		s.registerShortcut(new Shortcut(new InputTextAction(),null,[],null));
	}
	
	private function initApp() {
		activeFilters = new FilterCollection();
		libraryItems = LibraryHelper.getLibraryItems();
		loadSelectedFilters();
		searchTypeChange({target:searchType_rb});
	}
	
	private function loadSelectedFilters() {
		filters_so = new PersistentFilters(mc_btn);
		var it:LinearIterator = filters_so.getToggledFilters();
		
		while (it.hasNext()) {
			Button(this[it.getNextElement()]).onRelease();
		}
	}
	
	private function invalidateSearchPattern() {
		activeFilters.addFilter(new TextPatternFilter(searchPattern.text,searchType),
						  FilterCollection.JOIN_FILTER);
		
		var results = SearchAlgorithm.search(libraryItems,activeFilters);
		
		IResultView(currentResultsView).clean();
		
		for (var it in results) {
			IResultView(currentResultsView).addItem ({label:results[it][searchType],data:results[it]});	
		}
		
		IResultView(currentResultsView).sort();
	}
	
	public function searchTypeChange(evt:Object) {
		searchType = Number(searchType_rb.selectedRadio.data);
		
		switch (searchType) {
			case ItemHelper.NAME:
			case ItemHelper.LINKAGE_IDENTIFIER:
				if (currentResultsView != nameSearchView) {
					currentResultsView.visible = false;
					currentResultsView = nameSearchView;
					currentResultsView.visible = true;
				}
				break;
				
			case ItemHelper.LINKAGE_CLASS_NAME:
				if (currentResultsView != classSearchView) {
					currentResultsView.visible = false;
					currentResultsView = classSearchView;
					currentResultsView.visible = true;
				}
				break;
		}
		
		onSelectItem(null);
		invalidateSearchPattern();
	}
	
	private function filterTypeToggled (evt:Object) {
		var btn:Button = Button(evt.target);
		var filter:IFilter;

		if (btn.selected) {
			filters_so.addFilter(btn);
			filtersManager.execute({actionType:FiltersButtonManager.ENABLE,filter:btn});
			activeFilters.addFilter(FilterFactory.getFilter(btn._name),FilterCollection.UNION_FILTER);
		} else {
			filters_so.removeFilter(btn);
			filtersManager.execute({actionType:FiltersButtonManager.DISABLE,filter:btn});
			activeFilters.removeFilter(FilterFactory.getFilter(btn._name),FilterCollection.UNION_FILTER);
		}
		
		invalidateSearchPattern();
	}
	
	public function onSelectItem(item:Array) {
		if (item) {
			selectedItems = new Array();
			selectedItems.push(item);
			
			symbolName_txt.enabled = true;
			linkage_txt.enabled = true;
			setItemInfo(item);
		} else {
			setItemInfo (null);
		}
	}
	
	public function onSelectMultipleItems(selectedItems:Array) {
		this.selectedItems = selectedItems;
		setItemInfo (null);
		
		symbolName_txt.enabled = false;
		linkage_txt.enabled = false;
	}
	
	public function buttonAction (evt:Object) {
		var btn:Button = evt.target;
		
		switch (evt.target) {
			case close_btn:
				XMLUI.cancel();
				break;
			case select_btn:
				new SelectInLibraryAction().execute();
				break;
			case attach_btn:
				new AttachItemAction().execute();
				break;
			case edit_btn:
				new EditItemAction().execute();
				break;
			case apply_btn:
				var it:LinearIterator = new LinearIterator(selectedItems);
				var item:Array;
				
				if (it.length > 1) {
					while (it.hasNext()) {
						item = it.getNextElement().data;
						LibraryHelper.changeItemClass(item,class_txt.text);
					}
				} else {
					item = it.getNextElement();
					item[ItemHelper.LINKAGE_CLASS_NAME] = class_txt.text;
					item[ItemHelper.NEW_NAME] = symbolName_txt.text;
					item[ItemHelper.LINKAGE_IDENTIFIER] = linkage_txt.text;
					LibraryHelper.changeItemProperties(item);
				}
				
				libraryItems = LibraryHelper.getLibraryItems();
				invalidateSearchPattern();
				break;
		}
	}
	
	public function setItemInfo(item:Array) {
		if (item) {
			symbolType_txt.text = item[ItemHelper.ITEM_TYPE];
			symbolName_txt.text = item[ItemHelper.NAME];
			linkage_txt.text = item[ItemHelper.LINKAGE_IDENTIFIER] ? item[ItemHelper.LINKAGE_IDENTIFIER] : "";
			class_txt.text = item[ItemHelper.LINKAGE_CLASS_NAME] ? item[ItemHelper.LINKAGE_CLASS_NAME] : "";
		} else {
			symbolType_txt.text = "";
			symbolName_txt.text = "";
			linkage_txt.text = "";
			class_txt.text = "";
		}
	}
	
	public static function getInstance():FlashLibrary {
		return instance;
	}
}