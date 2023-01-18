/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is LunAS Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import asgard.display.Direction;

import lunas.display.container.ListContainerDisplay;
import lunas.model.ContainerModel;

/**
 * This container use a matrix layout pattern.
 * @author eKameleon
 */
class lunas.display.container.MatrixContainerDisplay extends ListContainerDisplay 
{
	
	/**
	 * Creates a new MatrixContainerDisplay instance.
	 * @param sName:String the name of the display.
	 * @param target:MovieClip the DisplayObject instance control this target.
	 * @param id (optional) the id of the model.
	 * @param bGlobal (optional) the flag to use a global event flow or a local event flow.
	 * @param sChannel (optional) the name of the global event flow if the {@code bGlobal} argument is {@code true}.
	 * @param childs (optional) An Array of items to insert in the model.
	 */
	public function MatrixContainerDisplay(sName:String, target:MovieClip , id , bGlobal:Boolean , sChannel:String , childs:Array ) 
	{ 
		super( sName, target, id, bGlobal, sChannel, childs ) ;
	}

	/**
	 * Returns {@code true} if the autosize mode is active.
	 * @return {@code true} if the autosize mode is active.
	 */
	public function get autoSize():Boolean 
	{
		return getAutoSize() ;
	}

	/**
	 * Sets if the autosize mode is active.
	 */
	public function set autoSize(b:Boolean):Void 
	{
		setAutoSize(b) ;
	}
	
	/**
	 * Returns the number of columns in the matrix layout if the direction of this container is Direction.HORIZONTAL.
	 * @return the number of columns in the matrix layout if the direction of this container is Direction.HORIZONTAL.
	 * @see asgard.display.Direction
	 */
	public function get columns():Number 
	{
		return getColumns() ;
	}

	/**
	 * Sets the number of columns in the matrix layout if the direction of this container is Direction.HORIZONTAL.
	 * @see asgard.display.Direction
	 */
	public function set columns(n:Number):Void 
	{
		setColumns(n) ;
	}

	/**
	 * Returns the number of lines in the matrix layout if the direction of this container is Direction.VERTICAL.
	 * @return the number of ls in the matrix layout if the direction of this container is Direction.VERTICAL.
	 * @see asgard.display.Direction
	 */
	public function get lines():Number 
	{
		return getLines() ;
	}

	/**
	 * Sets the number of lines in the matrix layout if the direction of this container is Direction.VERTICAL.
	 * @see asgard.display.Direction
	 */
	public function set lines(n:Number):Void 
	{
		setLines(n) ;
	}
	
	/**
	 * Refreshs the childs position in the container.
	 */
	/*override*/ public function changeChildsPosition():Void 
	{
		if ( (_columns > 1 && _nDirection == 0) || (_lines>1 && _nDirection == 1) ) 
		{
			var m:ContainerModel = getModel() ;
			var oC ;
			var c:Number ;
			var l:Number ;
			var n:Number = m.size() ;
			for (var i:Number = 0 ; i<n ; i++) 
			{
				c = (_nDirection == Direction.HORIZONTAL) ? (i%_columns) : Math.floor(i/_lines) ;
				l = (_nDirection == Direction.HORIZONTAL) ? Math.floor(i/_columns) : (i%_lines) ;
				oC = m.getChildAt(i) ;
				oC._x = c * (oC._width + _nSpace) ; 
				oC._y = l * (oC._height + _nSpace) ;
			}
		} 
		else 
		{
			super.changeChildsPosition() ;
		}
	}
	
	/**
	 * Returns {@code true} if the autosize mode is active.
	 * @return {@code true} if the autosize mode is active.
	 */
	public function getAutoSize():Boolean 
	{
		return _autoSize ;
	}

	/**
	 * Returns the number of columns in the matrix layout if the direction of this container is Direction.HORIZONTAL.
	 * @return the number of columns in the matrix layout if the direction of this container is Direction.HORIZONTAL.
	 * @see asgard.display.Direction
	 */
	public function getColumns():Number 
	{ 
		return _columns ;
	}

	/**
	 * Returns the number of lines in the matrix layout if the direction of this container is Direction.VERTICAL.
	 * @return the number of lines in the matrix layout if the direction of this container is Direction.VERTICAL.
	 * @see asgard.display.Direction
	 */
	public function getLines():Number 
	{ 
		return _lines ;
	}
	
	/**
	 * Resize the container.
	 */
	public function resize():Void 
	{
		
		if ( ( _lines > 1 && _nDirection == 1) || ( _columns > 1 && _nDirection == 0 ) ) 
		{
			if (getAutoSize()) 
			{
				_w = container._width ;  
				_h = container._height ;
			}
			_bound = 
			{
				w : getW() , 
				h : getH() 
			};
		} 
		else 
		{
			super.resize() ;
		}
	}

	/**
	 * Sets the autosize policy of this container.
	 */
	public function setAutoSize(b:Boolean):Void 
	{
		_autoSize = b ;
		doLater() ;
	}
	
	/**
	 * Sets the number of columns in the matrix layout if the direction of this container is Direction.HORIZONTAL.
	 * @see asgard.display.Direction
	 */
	public function setColumns(n:Number):Void 
	{
		_columns = (n>1) ? n : 1 ;
		update() ;
	}

	/**
	 * Sets the number of lines in the matrix layout if the direction of this container is Direction.VERTICAL.
	 * @see asgard.display.Direction
	 */
	public function setLines(n:Number):Void 
	{
		_lines = (n>1) ? n : 1 ;
		update() ;
	}

	private var _lines:Number = 3 ;
	private var _columns:Number = 3 ; 
	private var _autoSize:Boolean = true ;
	
}