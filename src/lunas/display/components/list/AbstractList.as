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

import lunas.display.components.AbstractComponent;
import lunas.display.components.list.AbstractListController;
import lunas.display.components.list.ListModel;
import lunas.display.group.RadioButtonGroup;

import pegas.events.UIEvent;
import pegas.events.UIEventType;

import vegas.data.iterator.Iterable;
import vegas.data.iterator.Iterator;
import vegas.util.ConstructorUtil;
import vegas.util.mvc.IController;
import vegas.util.mvc.IView;

/**
 * @author eKameleon
 */
class lunas.display.components.list.AbstractList extends AbstractComponent implements Iterable 
{

	/**
	 * Creates a new AbstractList instance.
	 */
	private function AbstractList () 
	{ 
		super() ;
	}
	
	public var cellRenderer:Function ; // override
	
	public var container:MovieClip ;
	
	public function get dataProvider():ListModel 
	{
		return getDataProvider() ;	
	}
	
	public function set dataProvider(data):Void 
	{
		setDataProvider(data) ;	
	}

	public function get labelField():String 
	{
		return getLabelField() ;	
	}
	
	public function set labelField(sField:String):Void 
	{
		setLabelField(sField) ;	
	}

	/**
	 * Protects the selected cell if this property is 'true'.
	 * If you use the 'setter' definition of the virtual property 'unSelect' method is launched.
	 * Returns a boolean.
	 */
	public function get protectSelected():Boolean
	{
		return _protectSelected ;
	}
	
	public function set protectSelected(b:Boolean):Void
	{
		_protectSelected = b ;
		unSelect() ;
	}

	public function get rowCount():Number 
	{
		return getRowCount() ;	
	}
	
	// TODO limiter la matrixContainer !!
	public function set rowCount(n:Number):Void 
	{
		setRowCount(n) ;
	}
	
	public function get rowHeight():Number 
	{
		return getRowHeight() ;	
	}
	
	public function set rowHeight(n:Number):Void 
	{
		setRowHeight(n) ;
	}
	
	public function get rowWidth():Number 
	{
		return getRowWidth() ;	
	}
	
	public function set rowWidth(n:Number):Void 
	{
		setRowWidth(n) ;
	}

	public function get selectedIndex():Number 
	{
		return getSelectedIndex() ;	
	}
	
	public function set selectedIndex(n:Number):Void 
	{
		setSelectedIndex(n) ;
	}

	public function get selectedItem() 
	{
		return getSelectedItem() ;	
	}
	
	public function set selectedItem( o ):Void 
	{
		setSelectedItem(o) ;
	}
	
	// ----o Constant
	
	static public var DEFAULT_LABEL_FIELD:String = "label" ;
	
	// ----o Public Methods
	
	public function addItem( oItem ) 
	{
		return _oModel.addItem( oItem ) ;
	}
	
	public function addItemAt( oItem , index:Number) 
	{
		return _oModel.addItemAt(oItem , index) ;
	}
	
	public function clear():Void 
	{
		unSelect() ;
		_oModel.clear() ;
	}
	
	public function contains( oItem ):Boolean 
	{
		return _oModel.contains(oItem) ;
	}

	public function editField(index:Number, fieldName:String, newData):Void 
	{
		_oModel.editField(index, fieldName, newData) ;
	}

	public function forceItemSelection( item ) : Void 
	{
  		var index : Number = _oModel.indexOf(item);
  		if (index > -1) 
  		{
  			var child:MovieClip = getContainer().getChildAt(index) ;
  			_selectedIndex = index ;
  			_selectedItem = item ;
  			child.setSelected( true, true ) ;
  		}
 	}

	public function getContainer():MovieClip 
	{
		return container ;
	}

	public function getDataProvider():ListModel 
	{
		return _oModel ;
	}
	
	public function getItemAt(index:Number) 
	{
		return _oModel.getItemAt(index) ;
	}
	
	public function getItemByKey(key:Number) 
	{
		return _oModel.getItemByKey(key) ;
	}

	public function getLabelField():String 
	{ 
		return _labelField || DEFAULT_LABEL_FIELD ;
	}

	public function getRowCount():Number 
	{ 
		return _rowCount ;
	}

	public function getRowHeight():Number 
	{ 
		return _rowHeight ;
	}

	public function getRowWidth():Number 
	{ 
		return _rowWidth ;
	}	

	public function getSelectedIndex():Number 
	{ 
		return _selectedIndex ;
	}

	public function getSelectedItem() 
	{ 
		return _selectedItem ;
	}	

	public function indexOf( oItem ):Number 
	{
		return _oModel.indexOf(oItem) ;
	}
	
	public function indexOfField(fieldName:String, value):Number 
	{
		return _oModel.indexOfField(fieldName, value) ;
	}

	public function initialize():Void 
	{
		_groupName = ConstructorUtil.getName(this) + "_group"  + hashCode() ;
		_eScroll = new UIEvent( UIEventType.SCROLL, this) ;
		_oModel = new ListModel() ;
	}

	public function isEmpty():Boolean 
	{
		return _oModel.isEmpty() ;
	}

	public function iterator():Iterator 
	{
		return _oModel.iterator() ;
	}
	
	public function notifyScroll():Void 
	{
		dispatchEvent(_eScroll) ;
	}

	public function removeItem( oItem ) 
	{
		return removeItem(oItem) ;
	}
	
	public function removeItemAt(index:Number) 
	{
		return removeItemsAt(index, 1) ;
	}

	public function removeItemsAt(index:Number, len:Number):Array 
	{
		return _oModel.removeItemsAt(index, len) ;
	}
	
	public function removeRange(from:Number, to:Number):Array 
	{
		return _oModel.removeRange(from, to) ;
	}
	
	public function replaceItemAt(index:Number, oItem):Void 
	{
		addItemAt(index, oItem) ;
	}
	
	public function selectedItemAt(index:Number, noEvent:Boolean):Void 
	{
		setSelectedIndex(index, noEvent) ;
	}
	
	public function selectedItemNext():Void 
	{
		var n:Number = getSelectedIndex() + 1 ;
		var m:Number = size() - 1 ;
		selectedItemAt((getSelectedIndex()>=m) ? 0 : n) ;
	}
	
	public function selectedItemPrev():Void 
	{
		var n:Number = getSelectedIndex() - 1 ;
		var m:Number = size() - 1 ;
		setSelectedIndex((n < 0) ? m : n) ;
	}
	
	public function setDataProvider( data ):Void 
	{
		clear() ;
		if (data) 
		{
			if (data instanceof Array) 
			{
				var l:Number = data.length ;
				for (var i:Number = 0 ; i<l ; i++) 
				{
					addItem(data[i]) ;
				}
			} 
			else if (data instanceof Iterable)
			{
				var it:Iterator = data.getIterator() ;
				while(it.hasNext()) 
				{
					addItem(it.next()) ;
				}
			}
		}
	}

	public function setItemIndex( oItem, index:Number):Void 
	{
		_oModel.setItemIndex(oItem, index) ;
	}

	public function setLabelField(s:String /*, render:Boolean*/ ):Void 
	{ 
		_labelField = s ;
		if (size() > 0)
		{
			var data:Array = toArray() ;
			clear() ;
			setDataProvider(data) ;
		}
	}

	public function setRowCount(n:Number):Void 
	{ 
		_rowCount = (n > 1) ? n : 1 ;
		container.setChildCount(n) ;
		update() ;
	}

	public function setRowHeight(n:Number, noRender:Boolean):Void 
	{
		_rowHeight = n ; 
		if (noRender != true) update() ;
	}	

	public function setRowWidth(n:Number, noRender:Boolean):Void 
	{
		_rowWidth = n ;
		if (noRender != true) update() ;
	}
	
	public function setSelectedIndex(index:Number, noEvent:Boolean):Void 
	{
		if (enabled) 
		{
			_selectedIndex = isNaN(index) ? null : index ;
			_selectedItem = _oModel.getItemAt( _selectedIndex ) ;
			if (noEvent) return ;
			if (_selectedIndex != null) 
			{
				getContainer().getChildAt(_selectedIndex).selected = true ;
			}
			else 
			{
				unSelect() ;
			}
		}
	}
	
	public function setSelectedItem(item, noEvent:Boolean):Void 
	{
		_selectedItem = item ; // TODO search the index object !!
		var index:Number = indexOf(item) ;
		if (index > -1)
		{
			setSelectedIndex(index, noEvent) ;
		}
	}
	
	public function size():Number 
	{
		return _oModel.size() ;
	}

	public function sortItems(compareFunc:Function, options:Number):Void 
	{
		_oModel.sortItems(compareFunc, options) ;
	}

	public function sortItemsBy(fieldNames , options ):Void 
	{
		_oModel.sortItemsBy(fieldNames , options ) ;
	}
	
	public function toArray():Array 
	{
		return _oModel.toArray() ;
	}
	
	public function unSelect():Void 
	{
		AbstractListController(_oController).unSelect() ;
		RadioButtonGroup.getInstance().unSelect(getGroupName()) ;
		_selectedItem = null ;
		_selectedIndex = null ;
	}

	private var _eScroll:UIEvent ;
	private var _labelField:String ;
	private var _rowCount:Number ;
	private var _rowHeight:Number ;
	private var _rowWidth:Number ;
	private var _oController:IController ;
	private var _oModel:ListModel ;
	private var _oView:IView ;
	private var _protectSelected:Boolean ;
	private var _selectedIndex:Number = null ;
	private var _selectedItem = null ;
	
}