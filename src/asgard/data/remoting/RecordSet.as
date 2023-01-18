/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import asgard.data.iterator.RecordSetIterator;
import asgard.events.RecordSetEvent;
import asgard.net.remoting.RemotingService;

import vegas.data.iterator.Iterable;
import vegas.data.iterator.Iterator;
import vegas.errors.Warning;
import vegas.util.ArrayUtil;
import vegas.util.mvc.AbstractModel;

// TODO setDeliveryMode : see RecordSet class (macromedia in mc.remoting package).
// TODO finir la documentation
// TODO voir toute la gestion remote et local du RecordSet (finir) !!!!
// TODO finir de mettre en place la sérialization avec toSource():String
// TODO place a method in the RecordSet class to inject this feature only if the user want use this method.
/*if (oResult instanceof RecordSet) // in the onResult method of the Responder ??  
	{
		RecordSet(oResult).setParentService( getService() ) ;
	}
*/
/**
 * <p><b>Example :</b></p>
 * {@code
 * import asgard.data.remoting.RecordSet ;
 * import asgard.events.RemotingEvent ;
 * import asgard.net.remoting.RemotingService ;
 * 
 * import vegas.data.iterator.Iterator ;
 * import vegas.events.Delegate ;
 * 
 * var gatewayUrl:String = "http://localhost/remoting/php/gateway.php" ; // sets your gateway url
 * var serviceName:String = "Gallery" ;
 * 
 * var onFault:Function  = function(e:RemotingEvent):Void 
 * {
 *     var type:String = e.getType() ;
 *     var target:RemotingService = e.getTarget() ;
 *     trace("> " + e.getType() + " > " + e.getCode()) ;
 *     trace("> level : " + e.getLevel()) ;
 *     trace("> line  : " + e.getLine()) ;
 *     trace("> methodName : " + e.getMethodName()) ;
 *     trace("> description : " +  e.getDescription()) ;
 * } ;
 * 
 * var onFinish:Function = function (e:RemotingEvent):Void 
 * {
 *     trace(">> " +  e.getType()) ;
 * } ;
 * 
 * var onResult:Function = function(e:RemotingEvent):Void 
 * {
 *     var type:String = e.getType() ;
 *     var target:RemotingService = e.getTarget() ;
 *     var result:RecordSet = e.getResult() ;
 *     trace(">> " + type + " : " + target) ;
 *     trace("------ use RecordSetIterator") ;
 *     trace(">>>> " + result) ;
 *     var it:Iterator = result.iterator() ;
 *     while(it.hasNext()) 
 *     {
 *         trace("   > " + it.next().title ) ;
 *     }
 * } ;
 * 
 * var onStart:Function = function (e:RemotingEvent):Void 
 * {
 *     trace(">> " +  e.getType()) ;
 * } ;
 * 
 * var service:RemotingService = new RemotingService( gatewayUrl, serviceName ) ;
 * service.addEventListener( RemotingEvent.FAULT, new Delegate(this, onFault)  ) ;
 * service.addEventListener( RemotingEvent.FINISH, new Delegate(this, onFinish)  ) ;
 * service.addEventListener( RemotingEvent.RESULT, new Delegate(this, onResult)  ) ;
 * service.addEventListener( RemotingEvent.START, new Delegate(this, onStart)  ) ;
 * 
 * service.methodName = "getGallery" ;
 * service.params = ["gallery"] ;
 * service.trigger() ;
 * }
 * @author eKameleon
 */
class asgard.data.remoting.RecordSet extends AbstractModel implements Iterable 
{

	/**
	 * Creates a new RecordSet instance.
	 */
	public function RecordSet( o ) {
		
		_eAdd    = new RecordSetEvent(RecordSetEvent.ADD_ITEMS, this) ;
		_eClear  = new RecordSetEvent(RecordSetEvent.CLEAR_ITEMS, this);
		_eRemove = new RecordSetEvent(RecordSetEvent.REMOVE_ITEMS, this) ;
		_eSort   = new RecordSetEvent(RecordSetEvent.SORT_ITEMS, this) ;
		_eUpdate = new RecordSetEvent(RecordSetEvent.UPDATE_ITEMS, this) ;
		
		_items = [] ;
		mTiles = [] ;
		
		if (serverInfo == null) 
		{
			if (serverinfo != null) 
			{
				serverInfo = serverinfo ;
			}
		}
		
		if (o) 
		{
		
			if (o instanceof Array)
			{
				mTiles = o ;
			} 
			else 
			{
				parse(o) ;
			}		
		}
		
		// TODO ??? voir ici ce qui cloche en comparaison avec script MM.
		
		if (serverInfo) 
		{
			parse(this) ;	
		}

	}

	public var serverInfo:Object ;

	public var serverinfo:Object ;

	public var serviceName:String ; 

	public function addItem(oItem) 
	{
		return addItemAt(size(), oItem) ; 
	}

	public function addItemAt(index:Number, oItem) 
	{
		var l:Number = size() ;
		var b:Boolean = true ;
		
		if (index >= 0 && index < l ) {
			
			_items.splice(index, 0, oItem) ;
			
		} else {
			
			 if (index == l) {
			 	_items[index] = oItem ;	
			 } else {
			 	return null ;	
			 }
		}
		oItem.__ID__ = _id ++ ;
		_eAdd.index = index ;
		notifyChanged( _eAdd ) ;
		return oItem ;
	}

	public function checkLocal():Boolean 
	{
		try {
			if ( isLocal()) {
				return false ;
			} else {
				throw new Warning(this + " Operation not allowed on partial recordset") ;
			}
		} catch (e:Warning) {
			trace(e.toString()) ;
			return true ;
		}
	}
	
	/**
	 * Removes all the items from a RecordSet
	 */
	public function clear():Void 
	{
		_id = 0 ;
		mTiles = new Array();
		_eClear.removedItems = _items.splice(0) ;
		notifyChanged(_eClear) ;
	}

	/**
	 * Returns {@code true} if the specified item is in the model.
	 */
	public  function contains( oItem ):Boolean 
	{
		return ArrayUtil.contains(_items, oItem) ;
	}

	public function editField(index:Number, fieldName:String , value):Void 
	{
		
		if ( checkLocal() ) return ;
		if (index<0 || index > size()) return ;
		_items[index][fieldName] = value ;
		
	}	

	public function filter(filter:Function, context):RecordSet 
	{
		
		if ( checkLocal() ) {
		  return null ;
		}

		var rs:RecordSet = new RecordSet() ;
		rs.setColumnNames(mTiles) ;
	
		var len:Number = size() ;
		for(var i:Number = 0; i < len ; i++) {
			var item:Object = getItemAt(i) ;
			if ((item != null) && (item != 1) && filter(item, context))	{
				rs.addItem(item);
			}
		}
		return rs ;
		
	}


	public function getColumnNames():Array 
	{
		return mTiles ;
	}

	public function getItemAt(id:Number) 
	{
		if (isEmpty() || (id < 0) || (id >= size()) ) {
			return null ;
		}
		if (isLocal()) {
			return _items[id] ;
		}
	}


	/**
	 * Returns a unique ID corresponding to the record, at the specified index.
	 * The RecordSet object assigns each record a unique ID. The ID is not part 
	 * of the record; it is a separate item that is associated with the record
	 * internally within the RecordSet object. Unlike a record index, its ID will
	 * not change when the RecordSet object is sorted or when records are added or
	 * deleted. When a record is deleted, its ID is retired and will never be used
	 * again in this RecordSet object.
	 */
	public function getItemID( index:Number ) 
	{
		return _items[index].hashCode() ;
	}

	/**
	 * Returns the number of records in the local RecordSet.
	 */
	public function getLocalLength():Number 
	{
		return size() ;	
	}

	public function getLength():Number 
	{
		return size() ;	
	}

	/**
	 * Returns the number of records that have been downloaded from the server.
	 * The count does not include records that have been requested but not yet arrived.
	 * For local RecordSet objects, this will always return the same value as the getLocalLength method.
	 */
	public function getNumberAvailable():Number 
	{
		return isLocal() ? size() : mRecordsAvailable ; 
	}

	/**
	 * Returns the number of records available on the server. 
	 */
	public function getRemoteLength():Number 
	{
		if( isLocal())
			return mRecordsAvailable ;
		else
			return mTotalCount ;
	}

	public function indexOf( oItem ):Number 
	{
		return ArrayUtil.indexOf(_items, oItem) ;
	}

	public function indexOfField(fieldName:String, value):Number 
	{
		var l:Number = _items.length ;
		while (--l > -1) {
			if (_items[l][fieldName] == value) return l ;
		}
		return -1 ;
	}

	public function isEmpty():Boolean 
	{
		return _items.length == 0 ;
	}

	function isFullyPopulated():Boolean 
	{
		return isLocal() ;
	}

	function isLocal():Boolean 
	{
		return mRecordSetID == null ;
	}

	/**
	 * Returns a new instance of RecordSetIterator for the RecordSet in use.
	 */
	public function iterator():Iterator 
	{
		return new RecordSetIterator(this) ;
	}

	public function parse( oRaw ):Void 
	{
		
		clear();
		
		mTiles = oRaw.serverInfo.columnNames ;
		
		mRecordsAvailable = 0 ;
		
		// implements setData !
		// setData((serverInfo.cursor == null) ? 0 : (serverInfo.cursor - 1), serverInfo.initialData);
		
		var aItems:Array = oRaw.serverInfo.initialData ;
		
		
		var l:Number = aItems.length ;
		for (var i:Number = 0 ; i<l ; i++) {
			var item:Object = {} ;
			var aProperties:Array = aItems[i] ;
			var count:Number = aProperties.length ;
			for (var j:Number = 0 ; j<count ; j++) {
				item[ mTiles[ j ] ] = aProperties[j] ;
			}
			_items.push( item );
		}
		
		//serverInfo = null ;
		
	}

	/**
	 * Register the RecordSet instance.
	 */
	static public function register():Boolean 
	{
		return Object.registerClass( "RecordSet", RecordSet ) ;
	}

	public function removeItem(oItem) 
	{
		var index:Number = indexOf(oItem) ;
		if (index > -1) {
			return removeItemAt(index) ;
		} else {
			return null ;
		}
	}
	
	public function removeItemAt(index:Number) 
	{
		var ret = getItemAt(index) ; 
		removeItemsAt(index, 1);
		return ret;
	}

	public function removeItemsAt(index:Number, len:Number):Array 
	{
		var oldItems = _items.splice(index, len) ;
		_eRemove.firstItem = index ;
		_eRemove.lastItem = index + len - 1 ;
		_eRemove.removedItems = [].concat(oldItems) ;
		notifyChanged ( _eRemove ) ;
		return oldItems ;
	}
	
	public function removeRange(from:Number, to:Number):Array 
	{
		if (isNaN(from)) return null ;
		return removeItemsAt(from, to - from) ;
	}
	
	/**
	 * Replaces a record in the RecordSet object at the specified index.
	 */
	public function replaceItemAt( index:Number, item:Object ):Void 
	{
		if (index>=0 && index<=size()) {
			var tmpID = getItemID(index) ;
			_items[index] = item ;
			_items[index].__ID__ = tmpID ;
			_eUpdate.index = index ;
			notifyChanged( _eUpdate ) ;
		}
	}
	
	public function setItemIndex( oItem, index:Number):Void 
	{
		var id:Number = indexOf(oItem) ;
		if (id == -1 || id == index) return ;
		else {
			var tmp = oItem ;
			_items.splice(id, 1) ;
			_items.splice(index, 0, tmp) ;
			_eUpdate.index = index ;
			notifyChanged( _eUpdate ) ;
		}
	}

	public function setColumnNames(ar:Array):Void 
	{
		mTiles = ar ;	
	}

	public function setParentService( service ):Void 
	{
		_nc = service.getConnection() ;
	}

	/**
	 * Returns the number of records in the RecordSet.
	 */
	public function size():Number 
	{
		if (isLocal()) {
			return _items.length ;
		} else {
			return mTotalCount ;
		}
	}
	
	public function sortItems(compareFunc:Function, options:Number):Void 
	{
		if (checkLocal()) return ;
		_items.sort(compareFunc, options) ;
		notifyChanged(_eSort) ;
	}

	public function sortItemsBy( fieldNames , options ):Void 
	{
		if (checkLocal()) return ;
		_items.sortOn( fieldNames, options ) ;
		notifyChanged(_eSort) ;
	}
	
	public function toArray():Array 
	{
		return _items ;
	}

	// ----o Virtual Properties

	public function get columnNames():Array 
	{
		return getColumnNames() ;
	}

	public function get items():Array 
	{
		return _items ;
	}

	public function get length():Number 
	{
		return getLength() ;
	}
	
	// ----o Private Properties
	
	private var mTiles : Array;
	private var _items : Array ;

	private var _eAdd:RecordSetEvent = null ;
	private var _eClear:RecordSetEvent = null ;
	private var _eRemove:RecordSetEvent = null ;
	private var _eSort:RecordSetEvent = null ;
	private var _eUpdate:RecordSetEvent = null ;

	private var _id:Number = 0 ;

	// -- server-associated RecordSet only
	
	private var mDeliveryMode:String;	
	private var mRecordsAvailable:Number ;
	private var mRecordSetID:Number = null ;
	private var mRecordSetService:RemotingService ;
	private var mTotalCount:Number ;

	// -- only if deliverymode = "page"
	private var mPageSize:Number;
	private var mNumPrefetchPages:Number;
	private var mAllNotified:Boolean;
	private var mOutstandingRecordCount:Number;

	private var _nc ;

	static private var _initRegister:Boolean = register() ;	

	/**
	
	private function getRecordSetService():RemotingService {
		// see MM code
		return mRecordSetService ;
	}
	
	private function setData( ) {
		trace(">>>>>>>>>>>>>> " + this + " : " + arguments) ;	
	}

	*/
}