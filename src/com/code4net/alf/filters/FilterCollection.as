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
 
import com.code4net.alf.filters.IFilter;

class com.code4net.alf.filters.FilterCollection implements IFilter{
	public static var UNION_FILTER:Number = 1;
	public static var JOIN_FILTER:Number = 2;
	
	private var FILTER_NAME:String = "FilterCollection";
	private var filters_union:Array;
	private var filters_join:Array; 

	public function FilterCollection() {
		filters_join = new Array();
		filters_union = new Array();
	}	
	
	public function execute(item:Array):Boolean {
		var it_union, it_join;
		var filter_union:IFilter;
		var filter_join:IFilter;
		var br:Boolean;
		
		for (it_union in filters_union) {
			filter_union = IFilter(filters_union[it_union]);
			if (filter_union.execute(item) == true) {
				br = true;
				
				for (it_join in filters_join) {
					filter_join = IFilter(filters_join[it_join]);
					if (filter_join.execute (item) == false) {
						br = false;
					}
				}
				
				if (br) return true;
			}
		}
		
		return false;
	}
	
	public function getFilterName():String {
		return FILTER_NAME;
	}
	
	public function addFilter(filter:IFilter,filter_type:Number) {
		switch (filter_type) {
			case UNION_FILTER:
				filters_union[filter.getFilterName()] = filter;
				break;
			case JOIN_FILTER:
				filters_join[filter.getFilterName()] = filter;
				break;
		}
	}
	
	public function removeFilter(filter:IFilter,filter_type:Number) {
		switch (filter_type) {
			case UNION_FILTER:	
				delete filters_union[filter.getFilterName()];
				break;
			case JOIN_FILTER:
				delete filters_join[filter.getFilterName()];
		}
	}
}