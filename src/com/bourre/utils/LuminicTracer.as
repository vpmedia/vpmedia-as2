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
 * {@code LuminicTracer} uses Luminic Box logging console
 * to log messages.
 * 
 * <p>See http://www.luminicbox.com/blog/?page=post&id=2 for
 * more informations about Lunimic Box.
 * 
 * <p>{@code LuminicTracer} implementation don't use any Luminic
 * API dependencies (only use {@code LocalConnection} for Luminic
 * Box communication.
 * 
 * <p>Implements {@link LogListener} interface to listen to 
 * {@link com.bourre.log.Logger} events.
 * 
 * <p>Example
 * <code>
 *   Logger.getInstance().addLogListener( LuminicTracer.getInstance() );
 *   PixlibDebug.INFO( "Logging API ready" );
 * </code>
 * 
 * @author Francis Bourre
 * @author Pablo Costantini
 * @version 1.0
 */
 
import com.bourre.log.LogEvent;
import com.bourre.log.LogListener;
import com.bourre.log.PixlibStringifier;

class com.bourre.utils.LuminicTracer
	implements LogListener
{
	//-------------------------------------------------------------------------
	// Public Properties
	//-------------------------------------------------------------------------
	
	public var isCollapsable : Boolean;
	
	
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private static var _oInstance:LuminicTracer;
	private var _lc : LocalConnection;
	private var _nCollapseDepth : Number;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Returns an {@code LuminicTracer} instance.
	 * 
	 * <p>Always return same the instance.
	 * 
	 * @return a {@code LuminicTracer} instance
	 */
	public static function getInstance() : LuminicTracer
	{
		if (!LuminicTracer._oInstance) LuminicTracer._oInstance = new LuminicTracer();
		return LuminicTracer._oInstance;
	}
	
	public function setCollapseDepth( n : Number ) : Void
	{
		if (n<1) n = 1;
		_nCollapseDepth = Math.min(n, 255);
	}
	
	/**
	 * {@link com.bourre.log.LogListener} callback implementation.
	 * 
	 * <p>{@link com.bourre.log.Logger} dispatches {@code onLog}
	 * event when messages are send to logging API.
	 * 
	 * @param e A {@link com.bourre.log.LogEvent} instance.
	 */
	public function onLog( e : LogEvent ) : Void 
	{
		var o:Object = new Object();
		o.loggerId = null;
		o.levelName = e.level.getName();
		o.time = new Date();
		
		if (isCollapsable)
		{
			o.argument = _serializeObj(e.content, 1);
		} else
		{
			var data : Object = new Object();
			data.type = "string";
			data.value = e.content.toString();
			o.argument = data;
		}
		_lc.send( "_luminicbox_log_console", "log", o );
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
	
	
	//-------------------------------------------------------------------------
	// Private implementation
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code LuminicTracer}.
	 * 
	 * <p>Constructor is {@code private} and can't be directly
	 * use.
	 * 
	 * <p>Uses {@link #getInstance} method to instanciate
	 * {@code LuminicTracer} class.
	 */
	private function LuminicTracer()
	{
		_lc = new LocalConnection();
		isCollapsable = true;
		setCollapseDepth( 4 );
	}
	
	/*
	 * Original code from Pablo Costantini // LuminicBox.Log.ConsolePublisher 
	 */
	private function _serializeObj(o,depth:Number) : Object
	{
		var type = _getType(o);
		var serial = new Object();
		if(!type.inspectable) 
		{
			serial.value = o;
		} else if(type.stringify) 
		{
			serial.value = o+"";
		} else 
		{
			if(depth <= _nCollapseDepth) 
			{
				if(type.name == "movieclip" || type.name == "button") serial.id = o + "";
				var items:Array = new Array();
				if(o instanceof Array) 
				{
					for(var pos:Number=0; pos<o.length; pos++) items.push( {property:pos,value:_serializeObj( o[pos], (depth+1) )} );
				} else 
				{
					for(var prop:String in o) items.push( {property:prop,value:_serializeObj( o[prop], (depth+1) )} );
				}
				serial.value = items;
			} else 
			{
				serial.reachLimit =true;
			}
		}
		serial.type = type.name;
		return serial;
	}
	
	private function _getType(o) : Object
	{
		var typeOf = typeof(o);
		var type = new Object();
		type.inspectable = true;
		type.name = typeOf;
		if(typeOf == "string" || typeOf == "boolean" || typeOf == "number" || typeOf == "undefined" || typeOf == "null") 
		{
			type.inspectable = false;
		} else if(o instanceof Date) 
		{
			// DATE
			type.inspectable = false;
			type.name = "date";
		} else if(o instanceof Array) 
		{
			// ARRAY
			type.name = "array";
		} else if(o instanceof Button) 
		{
			// BUTTON
			type.name = "button";
		} else if(o instanceof MovieClip) 
		{
			// MOVIECLIP
			type.name = "movieclip";
		} else if(o instanceof XML) 
		{
			// XML
			type.name = "xml";
			type.stringify = true;
		} else if(o instanceof XMLNode) 
		{
			// XML node
			type.name = "xmlnode";
			type.stringify = true;
		} else if(o instanceof Color) 
		{
			// COLOR
			type.name = "color";
		}
		return type;
	}
}