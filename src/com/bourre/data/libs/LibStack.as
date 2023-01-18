/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
 /**
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.core.HashCodeFactory;
import com.bourre.data.collections.Queue;
import com.bourre.data.libs.AbstractLib;
import com.bourre.data.libs.ILib;
import com.bourre.data.libs.ILibListener;
import com.bourre.data.libs.LibEvent;
import com.bourre.events.EventType;
import com.bourre.events.IEvent;
import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;

class com.bourre.data.libs.LibStack 
	extends AbstractLib
	implements ILibListener
{
	private var _a : Queue;
	private var _oCurrentLib : ILib;
	
	public static var onLoadInitEVENT:EventType = AbstractLib.onLoadInitEVENT;
	public static var onLoadProgressEVENT:EventType = AbstractLib.onLoadProgressEVENT;
	public static var onTimeOutEVENT:EventType = AbstractLib.onTimeOutEVENT;
	
	public static var onLoadStartEVENT:EventType = new EventType("onLoadStart");	public static var onLoadCompleteEVENT:EventType = new EventType("onLoadComplete");
	
	public function LibStack()
	{
		super();
		_sPrefixURL = null;
		_a = new Queue();
	}
	
	public function initEventSource() : Void
	{
		_e = new LibEvent(null, this);
	}
	
	// Clears the queue
	public function clear() : Void
	{
		_a.clear();
	}
	
	// Adds the specified element to the queue and returns his name.
	public function enqueue(o:ILib, sName:String, sURL:String) : String
	{
		if (sName != undefined) 
		{
			o.setName( sName );
			if (sURL != undefined)
			{
				o.setURL( sURL );
			} else if (o.getURL() == undefined)
			{
				PixlibDebug.WARN( "You passed ILib object without any url property in " + this + ".enqueue()." );
			}
		} else if(o.getName() == undefined)
		{
			PixlibDebug.WARN( "You passed ILib object without any name property in " + this + ".enqueue()." );
		}
		
		if (o.getName() == undefined) o.setName( 'library' + HashCodeFactory.getKey( o ));
		
		_a.enqueue(o);
		return o.getName();
	}
	
	public function load() : Void
	{
		// todo : test b4 running if current loading is processing.
		if (!isEmpty()) _loadNextEntry();
	}
	
	private function _loadNextEntry() : Void
	{
		if (_oCurrentLib != undefined) _oCurrentLib.removeListener( this );
		_oCurrentLib = ILib( _a.dequeue() );
		if ( _sPrefixURL != null ) _oCurrentLib.prefixURL( _sPrefixURL );
		_oCurrentLib.addListener( this );
		_oCurrentLib.execute();
	}
	
	private function _onLoadStart() : Void
	{
		fireEventType( LibStack.onLoadStartEVENT );
	}
	
	private function _onLoadComplete() : Void
	{
		_oCurrentLib.removeListener( this );
		fireEventType( LibStack.onLoadCompleteEVENT );
	}
	
	public function onLoadInit(e:LibEvent) : Void
	{
		fireEvent(e);
		if (isEmpty())
		{
			_onLoadComplete();
		} else
		{
			_loadNextEntry();
		}
	}
	
	public function onLoadProgress(e:LibEvent) : Void
	{
		fireEvent(e);
	}

	public function onTimeOut(e:LibEvent) : Void
	{
		fireEvent(e);
		if (isEmpty())
		{
			_onLoadComplete();
		} else
		{
			_loadNextEntry();
		}
	}
	
	// Checks if the queue is empty.
	public function isEmpty() : Boolean
	{
		return _a.isEmpty();
	}
	
	// Returns an Array of the elements in the queue.  
	public function getElements() : Array
	{
		return _a.getElements();
	}
	
	public function getLength() : Number
	{
		return _a.getLength();
	}
	
	public function execute( e : IEvent ) : Void
	{
		var a:Array = _a.getElements();
		var l:Number = a.length;
		while(--l>-1)
		{
			var oLib:ILib = a[l];
			if (oLib.getURL() == undefined)
			{
				PixlibDebug.ERROR( this + " encounters ILib object without url property, load fails." );
				return;
			}
		}
		
		_onLoadStart();
		super.execute( e );
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
}