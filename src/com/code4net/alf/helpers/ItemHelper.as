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
 
class com.code4net.alf.helpers.ItemHelper {
	public static var ITEM_TYPE:Number = 0;
	public static var NAME:Number = 1;
	public static var LINKAGE_IDENTIFIER:Number = 2;
	public static var LINKAGE_CLASS_NAME:Number = 3;
	public static var NEW_NAME:Number = 4;
	
	public static var MOVIE_CLIP:String = "movie clip";
	public static var GRAPHIC:String = "graphic";
	public static var BITMAP:String = "bitmap";
	public static var COMPILED_CLIP:String = "compiled clip";
	public static var SOUND:String = "sound";
	public static var SCREEN:String = "screen";
	public static var FONT:String = "font";

	
	public static function deserialize(items:String):Array {
		var result:Array = items.split("##");
		var it;
		
		result.pop();
		
		for (it in result) {
			result[it] = result[it].split("||");
		}
		
		return result;
	}
}