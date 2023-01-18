/*
	CASA Framework for ActionScript 2.0
	Copyright (C) 2007  CASA Framework
	http://casaframework.org
	
	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License as published by the Free Software Foundation; either
	version 2.1 of the License, or (at your option) any later version.
	
	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	Lesser General Public License for more details.
	
	You should have received a copy of the GNU Lesser General Public
	License along with this library; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/

/**
	@author Aaron Clinger
	@version 02/10/07
*/

class org.casaframework.util.TextFieldUtil {
	
	/**
		Determines if textfield has more text than can be displayed at once.
		
		@param target_txt: Textfield to check for text overflow.
		@return Returns <code>true</code> if textfield has overflow text; otherwise <code>false</code>.
	*/
	public static function hasOverFlow(target_txt:TextField):Boolean {
		return target_txt.maxscroll > 1;
	}
	
	/**
		Removes text overflow on a plain text textfield with the option of an ommission indicator.
		
		@param target_txt: Textfield to remove overflow.
		@param omissionIndicator: <strong>[optional]</strong> Text indication that an omission has occured; normally <code>"..."</code>; defaults to no indication.
	*/
	public static function removeOverFlow(target_txt:TextField, omissionIndicator:String):Void {
		if (!TextFieldUtil.hasOverFlow(target_txt))
			return;
		
		if (omissionIndicator == undefined)
			omissionIndicator = '';
		
		var lines:Array = target_txt.text.split('. ');
		var words:Array;
		var lastSentence:String;
		var sentences:String;
		
		while (TextFieldUtil.hasOverFlow(target_txt)) {
			var lastSentence = lines.pop();
			target_txt.text = lines.join('. ') + '.';
		}
		
		sentences = lines.join('. ') + '. ';
		words = lastSentence.split(' ');
		target_txt.text += lastSentence;
		
		while (TextFieldUtil.hasOverFlow(target_txt)) {
			words.pop();
			target_txt.text = sentences + words.join(' ') + omissionIndicator;
		}
	}
	
	private function TextFieldUtil() {} // Prevents instance creation
}