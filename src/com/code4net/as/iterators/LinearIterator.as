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
 
import com.code4net.as.iterators.IteratorBase;

class com.code4net.as.iterators.LinearIterator extends IteratorBase {

	public function LinearIterator(data) {
		super(data);
	}
	
	public function getNextElement () {
		if (_currentIndex + 1 < _datum.length) {
			return (_datum[++_currentIndex]);
		}
		return undefined;	
	}

	public function getPrevElement() {
		if(_currentIndex > 0)
			return (_datum[--_currentIndex]);
		
		return undefined;
	}

	public function gotoElement (elementNum:Number) {
		if (elementNum >= -1 && elementNum < _datum.length)
			return (_datum[_currentIndex = elementNum]);

		return undefined;
	}
	
	public function hasNext():Boolean {
		return Boolean(_datum[_currentIndex + 1]);
	}
	
	public function hasPrev():Boolean {
		return Boolean(_datum[_currentIndex - 1]);
	}
}