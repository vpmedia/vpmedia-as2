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

import com.code4net.as.iterators.LinearIterator;

class com.code4net.alf.persistence.PersistentFilters {
	private var filters_so:SharedObject;
	
	public function PersistentFilters(defaultSelection:Button) {
		filters_so = SharedObject.getLocal("FlashResourceLibrary");
		
		if (!filters_so.data.toggledFilters) {
			filters_so.data.toggledFilters = new Array();
			addFilter(defaultSelection);
		}
	}
	
	public function getToggledFilters():LinearIterator {
		return new LinearIterator(filters_so.data.toggledFilters);
	}
	
	public function addFilter(filter:Button) {
		var arr:Array = filters_so.data.toggledFilters;
		
		for (var it = 0; it < arr.length; it++) {
			if (arr[it] == filter._name) {
				return;
			}
		}
		
		filters_so.data.toggledFilters.push(filter._name);
		filters_so.flush();
	}
	
	public function removeFilter (filter:Button) {
		var arr:Array = filters_so.data.toggledFilters;
		
		for (var it = 0; it < arr.length; it++) {
			if (arr[it] == filter._name) {
				filters_so.data.toggledFilters.splice(it,1);
				filters_so.flush();
				return;
			}
		}
	}
}