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

import asgard.events.HTTPStatusEvent;
import asgard.events.IOErrorEvent;
import asgard.events.ProgressEvent;
import asgard.events.SecurityErrorEvent;

import vegas.core.HashCode;
import vegas.core.IFormattable;
import vegas.data.Set;
import vegas.events.BasicEvent;
import vegas.events.Event;
import vegas.events.EventDispatcher;
import vegas.events.EventListener;
import vegas.events.EventListenerCollection;
import vegas.events.EventType;
import vegas.events.IEventDispatcher;
import vegas.util.ConstructorUtil;

/**
 * The FileReference class provides a means to upload and download files between a user's computer and a server. 
 * An operating-system dialog box prompts the user to select a file to upload or a location for download. 
 * Each FileReference object refers to a single file on the user's disk and has properties that contain information 
 * about the file's size, type, name, creation date, modification date, and creator type (Macintosh only).
 * @author eKameleon
 */
class asgard.net.FileReference extends flash.net.FileReference implements IEventDispatcher, IFormattable
{
	
	/**
	 * Creates a new FileReference instance.
	 * @param bGlobal the flag to use a global event flow or a local event flow.
	 * @param sChannel the name of the global event flow if the {@code bGlobal} argument is {@code true}.
	 */
	public function FileReference(  bGlobal:Boolean , sChannel:String ) 
	{
		this.addListener(this) ;
		initEvents() ;
		setGlobal( bGlobal , sChannel ) ;
	}

	/**
	 * (read-only) Returns the value of the isGlobal flag of this instance. Use the {@code setGlobal} method to modify this value.
	 * @return {@code true} if the instance use a global EventDispatcher to dispatch this events.
	 */
	public function get isGlobal():Boolean 
	{
		return getIsGlobal() ;
	}

	/**
	 * Allows the registration of event listeners on the event target.
	 * @param eventName A string representing the event type to listen for. If eventName value is "ALL" addEventListener use addGlobalListener
	 * @param listener The object that receives a notification when an event of the specified type occurs. This must be an object implementing the {@code EventListener} interface.
	 * @param useCapture Determinates if the event flow use capture or not.
	 * @param priority Determines the priority level of the event listener.
	 * @param autoRemove Apply a removeEventListener after the first trigger
	 */
	public function addEventListener( eventName:String, listener:EventListener, useCapture:Boolean, priority:Number, autoRemove:Boolean):Void 
	{
		_dispatcher.addEventListener.apply(_dispatcher, arguments);
	}

	/**
	 * Allows the registration of global event listeners on the event target.
	 * 
	 * @param listener The object that receives a notification when an event of the specified type occurs. This must be an object implementing the <b>EventListener</b> interface.
	 * @param priority Determines the priority level of the event listener.
	 * @param autoRemove Apply a removeEventListener after the first trigger
	 */
	public function addGlobalEventListener(listener:EventListener, priority:Number, autoRemove:Boolean):Void 
	{
		_dispatcher.addGlobalEventListener.apply(_dispatcher, arguments) ;
	}

	/**
	 * Dispatches an event into the event flow.
	 * @param event The Event object that is dispatched into the event flow.
	 * @param isQueue if the EventDispatcher isn't register to the event type the event is bufferized.
	 * @param target the target of the event.
	 * @param contect the context of the event.
	 * @return the reference of the event dispatched in the event flow.
	 */
	public function dispatchEvent(event, isQueue:Boolean, target, context):Event 
	{
		return _dispatcher.dispatchEvent.apply(_dispatcher, arguments) ;
	}

	/**
	 * Returns the internal {@code EventDispatcher} reference.
	 * @return the internal {@code EventDispatcher} reference.
	 */
	public function getEventDispatcher():EventDispatcher 
	{
		return _dispatcher ;
	}

	/**
	 * Returns the {@code EventListenerCollection} of the specified event name.
	 * @return the {@code EventListenerCollection} of the specified event name.
	 */
	public function getEventListeners(eventName:String):EventListenerCollection 
	{
		return _dispatcher.getEventListeners(eventName) ;
	}
	
	/**
	 * Returns the event name use if the process is cancel.
	 * @return the event name use if the process is cancel.
	 */
	public function getEventTypeCANCEL():String
	{
		return _eCancel.getType() ;
	}

	/**
	 * Returns the event name use if the process is complete.
	 * @return the event name use if the process is complete.
	 */
	public function getEventTypeCOMPLETE():String
	{
		return _eComplete.getType() ;
	}

	/**
	 * Returns the event name use when a HTTPStatusEvent is invoqued.
	 * @return the event name use when a HTTPStatusEvent is invoqued.
	 */
	public function getEventTypeHTTPError():String
	{
		return _eHTTPError.getType() ;
	}

	/**
	 * Returns the event name use when a IOErrorEvent is invoqued.
	 * @return the event name use when a IOErrorEvent is invoqued.
	 */
	public function getEventTypeIOError():String
	{
		return _eIOError.getType() ;
	}

	/**
	 * Returns the event name use when the upload or the download is started.
	 * @return the event name use when the upload or the download is started.
	 */
	public function getEventTypeOpen():String
	{
		return _eOpen.getType() ;
	}
	
	/**
	 * Returns the event name use when the process is in progress.
	 * @return the event name use when the process is in progress.
	 */
	public function getEventTypeProgress():String
	{
		return _eProgress.getType() ;
	}

	/**
	 * Returns the event name use when a SecurityErrorEvent is invoqued.
	 * @return the event name use when a SecurityErrorEvent is invoqued.
	 */
	public function getEventTypeSecurityError():String
	{
		return _eSecurity.getType() ;
	}

	/**
	 * Returns the event name use when the file is selected.
	 * @return the event name use when the file is selected.
	 */
	public function getEventTypeSelect():String
	{
		return _eSelect.getType() ;
	}

	/**
	 * Returns the {@code EventListenerCollection} of this EventDispatcher.
	 * @return the {@code EventListenerCollection} of this EventDispatcher.
	 */
	public function getGlobalEventListeners():EventListenerCollection 
	{
		return _dispatcher.getGlobalEventListeners() ;
	}
	
	/**
	 * Returns the value of the isGlobal flag of this instance.
	 * @return {@code true} if the instance use a global EventDispatcher to dispatch this events.
	 */
	public function getIsGlobal():Boolean 
	{
		return _isGlobal ;
	}

	/**
	 * Returns a {@code Set} of all register event's name in this EventListener.
	 * @return a {@code Set} of all register event's name in this EventListener.
	 */
	public function getRegisteredEventNames():Set 
	{
		return _dispatcher.getRegisteredEventNames() ;
	}

	/**
	 * Returns the EventDispatcher parent reference of this instance.
	 * @return the EventDispatcher parent reference of this instance.
	 */
	public function getParent():EventDispatcher 
	{
		return _dispatcher.parent ;
	}

	/**
	 * Returns a hash code value for the object.
	 * @return a hash code value for the object.
	 */
	public function hashCode():Number 
	{
		return null ;
	}

	/**
	 * Checks whether the EventDispatcher object has any listeners registered for a specific type of event.
	 * This allows you to determine where altered handling of an event type has been introduced in the event flow heirarchy by an EventDispatcher object.
	 */ 
	public function hasEventListener(eventName:String):Boolean 
	{
		return _dispatcher.hasEventListener(eventName) ;
	}
	
	/**
	 * Initialize all internal events of this object.
	 */
	public function initEvents():Void
	{
		_eCancel    = new BasicEvent ( EventType.CANCEL , this ) ;
		_eComplete  = new BasicEvent ( EventType.COMPLETE , this ) ;
		_eHTTPError = new HTTPStatusEvent( HTTPStatusEvent.HTTP_STATUS , null, this ) ;
		_eIOError   = new IOErrorEvent ( IOErrorEvent.IO_ERROR , null , null , this ) ;
		_eOpen      = new BasicEvent( EventType.OPEN , this ) ;
		_eProgress  = new ProgressEvent( ProgressEvent.PROGRESS, null, null, this ) ;
		_eSecurity  = new SecurityErrorEvent( SecurityErrorEvent.SECURITY_ERROR, null, null , this) ;
		_eSelect    = new BasicEvent( EventType.SELECT , this ) ;
	}



	/**
	 * Creates and returns the internal {@code EventDispatcher} reference (this method is invoqued in the constructor).
	 * You can overrides this method if you wan use a global {@code EventDispatcher} singleton.
	 * @return the internal {@code EventDispatcher} reference.
	 */
	public function initEventDispatcher():EventDispatcher 
	{
		return new EventDispatcher(this) ;
	}

	/** 
	 * Removes a listener from the EventDispatcher object.
	 * If there is no matching listener registered with the {@code EventDispatcher} object, then calling this method has no effect.
	 * @param Specifies the type of event.
	 * @param the class name(string) or a {@code EventListener} object.
	 */
	public function removeEventListener(eventName:String, listener, useCapture:Boolean):EventListener 
	{
		return _dispatcher.removeEventListener.apply(_dispatcher, arguments) ;
	}

	/** 
	 * Removes a global listener from the EventDispatcher object.
	 * If there is no matching listener registered with the EventDispatcher object, then calling this method has no effect.
	 * @param the string representation of the class name of the EventListener or a EventListener object.
	 */
	public function removeGlobalEventListener( listener ):EventListener 
	{
		return _dispatcher.removeGlobalEventListener.apply(_dispatcher, arguments) ;
	}

	/**
	 * Sets the internal {@code EventDispatcher} reference.
	 */
	public function setEventDispatcher( e:EventDispatcher ):Void 
	{
		_dispatcher = e || initEventDispatcher() ;
	}
	
	/**
	 * Sets the event name use if the process is cancel.
	 */
	public function setEventTypeCANCEL( type:String ):Void
	{
		_eCancel.setType( type ) ;
	}

	/**
	 * Sets the event name use if the process is complete.
	 */
	public function setEventTypeCOMPLETE( type:String ):Void
	{
		_eComplete.setType( type ) ;
	}

	/**
	 * Sets the event name use when a HTTPStatusEvent is invoqued.
	 */
	public function setEventTypeHTTPError( type:String ):Void
	{
		_eHTTPError.setType( type ) ;
	}

	/**
	 * Sets the event name use when a IOErrorEvent is invoqued.
	 */
	public function setEventTypeIOError( type:String ):Void
	{
		_eIOError.setType( type ) ;
	}

	/**
	 * Sets the event name use when the upload or the download is started.
	 */
	public function setEventTypeOpen( type:String ):Void
	{
		_eOpen.setType( type ) ;
	}
	
	/**
	 * Sets the event name use when the process is in progress.
	 */
	public function setEventTypeProgress( type:String ):Void
	{
		_eProgress.setType( type ) ;
	}

	/**
	 * Returns the event name use when a SecurityErrorEvent is invoqued.
	 * @return the event name use when a SecurityErrorEvent is invoqued.
	 */
	public function setEventTypeSecurityError( type:String ):Void
	{
		_eSecurity.setType( type ) ;
	}

	/**
	 * Returns the event name use when the file is selected.
	 * @return the event name use when the file is selected.
	 */
	public function setEventTypeSelect( type:String ):Void
	{
		_eSelect.setType( type ) ;
	}

	/**
	 * Sets if the instance use a global {@code EventDispatcher} to dispatch this events, if the {@code flag} value is {@code false} the instance use a local EventDispatcher.
	 * @param flag the flag to use a global event flow or a local event flow.
	 * @param channel the name of the global event flow if the {@code flag} argument is {@code true}.  
	 */
	public function setGlobal( flag:Boolean , channel:String ):Void 
	{
		_isGlobal = flag ;
		setEventDispatcher( flag ? EventDispatcher.getInstance( channel ) : null ) ;
	}

	/**
	 * Sets the parent EventDispatcher reference of this instance.
	 */
	public function setParent(parent:EventDispatcher):Void 
	{
		_dispatcher.parent = parent ;
	}

	/**
	 * Returns the string representation of this object.
	 * @return the string representation of this object.
	 */
	public function toString():String 
	{
		var str:String = "[" + ConstructorUtil.getName(this) ;
		if (name.length > 0)
		{
			str += " name:" + name ;	
		}
		str += "]" ;
		return str ;
	}
	
	/**
	 * The internal EventDispatcher reference of this object.
	 */
	private var _dispatcher:EventDispatcher ;

	private var _eCancel:Event ;
	
	private var _eComplete:Event ;
	
	private var _eHTTPError:Event ;
	
	private var _eIOError:Event ;
	
	private var _eOpen:Event ;
	
	private var _eProgress:Event ;
	
	private var _eSecurity:Event ;
	
	private var _eSelect:Event ;

	static private var _initHashCode:Boolean = HashCode.initialize( FileReference.prototype ) ;

	/**
	 * The internal flag to indicate if the event flow is global.
	 */
	private var _isGlobal:Boolean ;
	
	/**
	 * Dispatched when a file upload or download is canceled by the user.
	 */
	/*protected*/ private function onCancel( file:FileReference ):Void
	{
		dispatchEvent( _eCancel ) ;
	}
	
	/**
	 * Dispatched when download is complete or when upload generates an HTTP status code of 200.
	 */
	/*protected*/ private function onComplete( file:FileReference ):Void
	{
		dispatchEvent( _eComplete ) ;
	}

	/**
	 * Dispatched when an upload fails and an HTTP status code is available to describe the failure.
	 * In AS2 the flash.net.FileReference class don't return the status code of the HTTP error.
	 */
	/*protected*/ private function onHTTPError( file:FileReference ):Void 
	{
		dispatchEvent( _eHTTPError ) ;	
	}

	/**
	 * Dispatched when the upload or download fails.
	 */
	/*protected*/ private function onIOError( file:FileReference ):Void 
	{
		IOErrorEvent(_eIOError).text = this + " io error notify with the file : " + file.name ;
		IOErrorEvent(_eIOError).errorID = this.hashCode() ;
		dispatchEvent( _eIOError ) ; 
	}

	/**
	 * Dispatched when an upload or download operation starts.
	 */
	/*protected*/ private function onOpen( file:FileReference ):Void
	{
		dispatchEvent( _eOpen ) ;
	}
	
	/**
	 * Dispatched periodically during the file upload or download operation.
	 */
	/*protected*/ private function onProgress( file:FileReference, bytesLoaded:Number, bytesTotal:Number ):Void
	{
		ProgressEvent(_eProgress).bytesLoaded = bytesLoaded ;
		ProgressEvent(_eProgress).bytesTotal  = bytesTotal ;
		dispatchEvent( _eProgress ); 
	}

	/**
	 * Dispatched when a call to the {@code FileReference.upload()} or {@code FileReference.download()} method tries to upload a file to a server or get a file from a server that is outside the caller's security sandbox.
	 */
	/*protected*/ private function onSecurityError( file:FileReference, errorString:String ):Void 
	{
		SecurityErrorEvent(_eSecurity).text    = errorString ;
		SecurityErrorEvent(_eSecurity).errorID = hashCode() ;
		dispatchEvent( _eSecurity );
	}

	/**
	 * Dispatched when the user selects a file for upload or download from the file-browsing dialog box.
	 */
	/*protected*/ private function onSelect( file:FileReference ):Void
	{
		dispatchEvent( _eSelect ) ;
	}

}