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

import com.code4net.as.patterns.ICommand;

class com.code4net.alf.actions.FiltersButtonManager implements ICommand {
	public static var ENABLE_ALL:Number = 0;
	public static var DISABLE_ALL:Number = 1;
	public static var TOGGLE:Number = 2;
	public static var DISABLE_ALL_ON_SELECT:Number = 3;
	public static var DISABLE:Number = 4;
	public static var ENABLE:Number = 5;
	  
	private var selectedFilters:Array;
	private var managedFilters:Array;

	
	public function FiltersButtonManager() {
		selectedFilters = new Array();
		managedFilters = new Array();
	}
	
	public function registerFilter (filter:Button) {
		managedFilters.push(filter);
	}
	
	public function execute(params:Object) {
		switch (params.actionType) {
			case ENABLE_ALL:
				if (! (eval(Selection.getFocus()) instanceof TextField)) {
					enableAll();
				}
				break;
			case DISABLE_ALL:
				if (! (eval(Selection.getFocus()) instanceof TextField)) {
					disableAll();
				}
				break;
			case TOGGLE:
				toggleFilter(params.filter);
				break;
			case DISABLE_ALL_ON_SELECT:
				disableAllOnSelect(params.filter);
				break;
			case DISABLE:
				disable (params.filter);
				break;
			case ENABLE:
				enable (params.filter);
				break;
		}
	}
	
	private function enableAll() {
		selectedFilters = new Array();
		
		for (var it in managedFilters) {
			selectedFilters[it] = managedFilters[it];
			Button(selectedFilters[it]).selected = true; 
		}
	}
	
	private function disableAll() {
		for (var it in selectedFilters) {
			Button(selectedFilters[it]).selected = false; 
			selectedFilters.splice(it,1);
		}
	}
	
	private function disableAllOnSelect (btn:Button) {
		disableAll();
		btn.selected = true;
	}
	
	private function toggleFilter (btn:Button) {
		btn.selected = !btn.selected;
		
		if (btn.selected) {
			enable (btn);
		} else {
			disable (btn);
		}
	}
	
	private function disable (btn:Button) {
		for (var it in selectedFilters) {
			if (selectedFilters[it] == btn) {
				selectedFilters.splice(it,1);
				return;
			}
		}
	}
	
	public function enable (btn:Button) {
		selectedFilters.push (btn);
	}
}