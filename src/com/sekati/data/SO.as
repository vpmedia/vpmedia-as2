/**
 * com.sekati.data.SO
 * @version 1.1.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.core.CoreObject;
import com.sekati.events.Dispatcher;
import com.sekati.events.Event;
import com.sekati.utils.Delegate;

/**
 * SharedObject wrapper class.
 */
class com.sekati.data.SO extends CoreObject {

	private var _this:SO;
	private var _so:SharedObject;
	private var _name:String;
	private static var onSOStatusEVENT:String = "onSOStatus";
	private static var onSOSyncEVENT:String = "onSOSync";

	/**
	 * SO Constructor
	 * @param so_name (String) shared object name
	 * @return Void
	 * @throws Error if no so_name was passed.
	 */
	public function SO(so_name:String) {
		super( );
		if(!so_name) {
			throw new Error( "@@@ " + this.toString( ) + " Error: instance Constructor expects so_name param." );
			return;	
		}
		_name = so_name;
		_this = this;
		_so = SharedObject.getLocal( _name );
		_so.onStatus = Delegate.create( _this, so_onStatus );
		_so.onSync = Delegate.create( _this, so_onSync );
	}

	/**
	 * onStatus event handler dispatches event
	 * @param info (Object)
	 * @return Void
	 */
	public function so_onStatus(info:Object):Void {
		trace( "status info: " + info );
		var e:Event = new Event( onSOStatusEVENT, this, {info:info} );
		Dispatcher.$.dispatchEvent( e );
	}

	/**
	 * onSync event handler dispatches event
	 */
	public function so_onSync(obj:Object):Void {
		trace( "sync obj: " + obj );
		var e:Event = new Event( onSOSyncEVENT, this, {obj:obj} );
		Dispatcher.$.dispatchEvent( e );
	}

	/**
	 * write a property value to the shared object
	 * @param prop (String) property name
	 * @param val (Object) value to wrote to property
	 * @return Void
	 */
	public function write(prop:String, val:Object):Void {
		_so.data[prop] = val;
		_so.flush( );
	}

	/**
	 * read a property value from the shared object
	 * @param prop (String) property to read
	 * @return Object - property value
	 */
	public function read(prop:String):Object {
		return _so.data[prop];
	}

	/**
	 * destroy the shared object
	 * @return Void
	 */
	public function clear():Void {
		_so.clear( );
	}

	/**
	 * get the size of the shared object in bytes.
	 * @return Number
	 */
	public function getSize():Number {
		return _so.getSize( );
	}

	/**
	 * return recursively formatted data of shared object
	 * @return String
	 */
	public function getData():String {
		var str:String = _name + "={\n";
		for (var prop in _so.data) {
			str += prop + ": " + _so.data[prop] + "\n";
		}
		str += "};";
		return str;
	}

	/**
	 * Show FlashPlayer storage System settings.
	 * @return Void
	 */
	public function showSettings():Void {
		System.showSettings( 1 );	
	}

	/**
	 * Destroy sharedObject data and instance
	 * @return Void
	 */
	public function destroy():Void {
		_so.data = null;
		_so.flush( );
		delete this;
		super.destroy( );
	}		
}