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

import lunas.display.components.button.EasyButton;
import lunas.display.components.cell.CellDecorator;
import lunas.display.components.cell.CellIndex;
import lunas.display.components.ICell;
import lunas.events.CellEvent;

/**
 * The EasyCell class.
 * @author eKameleon
 */
class lunas.display.components.cell.EasyCell extends EasyButton implements ICell 
{

	/**
	 * Creates a new EasyCell instance.
	 */
	public function EasyCell () 
	{ 
		super() ;
		_cellDecorator = new CellDecorator() ;
	}
	
	public function get cellIndex():CellIndex 
	{
		return getCellIndex() ;	
	}
	
	public function get listOwner():MovieClip 
	{
		return getListOwner() ;
	}

	public function set listOwner(mcList:MovieClip):Void 
	{
		setListOwner(mcList) ;
	}

	public function getCellIndex():CellIndex 
	{
		return _cellDecorator.getCellIndex() ;
	}
	
	public function getListOwner():MovieClip 
	{
		return _cellDecorator.getListOwner() ;
	}

	public function getPreferredHeight():Number 
	{
		return _cellDecorator.getPreferredHeight() ;	
	}

	public function getPreferredWidth():Number 
	{
		return _cellDecorator.getPreferredWidth() ;
	}
	
	public function initButtonEvent():Void 
	{
		_eButton = new CellEvent(null, this) ;	
	}
	
	public function setCellIndex( itemIndex:Number , columnIndex:Number ):Void 
	{
		_cellDecorator.setCellIndex(itemIndex, columnIndex) ;
	}

	public function setListOwner(owner:MovieClip):Void 
	{
		_cellDecorator.setListOwner(owner) ;
	}
	
	/*override*/ public function setSize(w:Number, h:Number):Void 
	{
		var s:Object = _cellDecorator.getSize(w, h) ;
		super.setSize(s.w, s.h) ;
	}
	
	public function setValue ():Void 
	{
		// override
	}

	private var _cellDecorator:CellDecorator ;
	private var _eButton:CellEvent ;
	
}
