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
 
import com.code4net.alf.filters.BitmapFilter;
import com.code4net.alf.filters.CompiledFilter;
import com.code4net.alf.filters.FontFilter;
import com.code4net.alf.filters.GraphicFilter;
import com.code4net.alf.filters.IFilter;
import com.code4net.alf.filters.MCFilter;
import com.code4net.alf.filters.ScreenFilter;
import com.code4net.alf.filters.SoundFilter;

class com.code4net.alf.filters.FilterFactory {
	private static var createdFilters:Array = new Array();
	
	private static var BITMAP:String = "bitmap_btn";
	private static var COMPILED:String = "compiled_btn";
	private static var FONT:String = "font_btn";
	private static var GRAPHIC:String = "graphic_btn";
	private static var SOUND:String = "sound_btn";
	private static var MC:String = "mc_btn";
	private static var SCREEN:String = "screen_btn";
	
	public static function getFilter (filterType:String):IFilter {
		if (!createdFilters[filterType]) {
			switch (filterType) {
				case BITMAP:
					createdFilters[filterType] = new BitmapFilter();
					break;
				case COMPILED:
					createdFilters[filterType] = new CompiledFilter(); 
					break;
				case FONT:
					createdFilters[filterType] = new FontFilter();
					break;
				case GRAPHIC:
					createdFilters[filterType] = new GraphicFilter();
					break;
				case SOUND:
					createdFilters[filterType] = new SoundFilter();
					break;
				case MC:
					createdFilters[filterType] = new MCFilter();
					break;
				case SCREEN:
					createdFilters[filterType] = new ScreenFilter();
			}
		}
		
		return IFilter(createdFilters[filterType]);
	}
}