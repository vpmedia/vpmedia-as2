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

class com.code4net.alf.filters.TextPatternFilter implements IFilter {
	private var FILTER_NAME:String = "TexPatternFilter";
	
	private var pattern:String;
	private var searchField:Number;
	
	public function TextPatternFilter(pattern:String,searchField:Number) {
		this.pattern = pattern;
		this.searchField = searchField;
	}
	
	public function execute(item : Array) : Boolean {
		var base:String = String (item[searchField]).toLowerCase();
		return ((base.indexOf(pattern.toLowerCase()) >= 0 &&  base != "undefined" && base != "")); 
		//&&0036			   (pattern != "" && base != "");
	}

	public function getFilterName() : String {
		return FILTER_NAME;
	}
}