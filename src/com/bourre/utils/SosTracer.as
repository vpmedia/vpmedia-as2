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
 * {@code SosTracer} uses Powerflasher SOS console
 * to log messages.
 * 
 * <p>See http://sos.powerflasher.com/english.html for
 * more informations about SOS Console.
 * 
 * <p>{@code XMLSocket} protocol is used for Pixlib /
 * SOS Console communication.
 * 
 * <p>Implements {@link LogListener} interface to listen to 
 * {@link com.bourre.log.Logger} events.
 * 
 * <p>Example
 * <code>
 *   Logger.getInstance().addLogListener( SosTracer.getInstance() );
 *   PixlibDebug.INFO( "Logging API ready" );
 * </code>
 * 
 * @author Francis Bourre
 * @author Pablo Costantini
 * @version 1.0
 */

import com.bourre.commands.Delegate;
import com.bourre.data.collections.Map;
import com.bourre.log.LogEvent;
import com.bourre.log.LogLevel;
import com.bourre.log.LogListener;
import com.bourre.log.PixlibStringifier;

class com.bourre.utils.SosTracer
	implements LogListener
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private static var _oInstance:SosTracer;
	
	private var _oXMLSocket:XMLSocket;
	private var _bIsConnected:Boolean;
	private var _aBuffer:Array;
	private var _mFormat : Map;
	
	
	//-------------------------------------------------------------------------
	// Public Properties
	//-------------------------------------------------------------------------
	
	/** SOS console IP Address. **/
	public static var IP:String = "localhost";
	
	/** SOS console communication port. **/
	public static var PORT:Number = 4445;
	
	
	public static var DEBUG_FORMAT:String = "DEBUG_FORMAT";
	public static var INFO_FORMAT:String = "INFO_FORMAT";
	public static var WARN_FORMAT:String = "WARN_FORMAT";
	public static var ERROR_FORMAT:String = "ERROR_FORMAT";
	public static var FATAL_FORMAT:String = "FATAL_FORMAT";
	
	public static var DEBUG_KEY:String = '<setKey><name>' + SosTracer.DEBUG_FORMAT + '</name><color>' + 0x1394D6 + '</color></setKey>\n';
	public static var INFO_KEY:String = '<setKey><name>' + SosTracer.INFO_FORMAT + '</name><color>' + 0x12C9AC + '</color></setKey>\n';
	public static var WARN_KEY:String = '<setKey><name>' + SosTracer.WARN_FORMAT + '</name><color>' + 0xFFCC00 + '</color></setKey>\n';
	public static var ERROR_KEY:String = '<setKey><name>' + SosTracer.ERROR_FORMAT + '</name><color>' + 0xFF6600 + '</color></setKey>\n';
	public static var FATAL_KEY:String = '<setKey><name>' + SosTracer.FATAL_FORMAT + '</name><color>' + 0xFF0000 + '</color></setKey>\n';
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Returns {@code SosTracer} instance.
	 * 
	 * <p>Always return the same instance.
	 * 
	 * @return {@code SosTracer} instance
	 */
	public static function getInstance() : SosTracer
	{
		if (!SosTracer._oInstance) SosTracer._oInstance = new SosTracer();
		return SosTracer._oInstance;
	}

	/**
	 * Clears SOS console.
	 */
	public function clearOutput() : Void
	{
		_oXMLSocket.send( "<clear/>\n" );
	}
	
	/**
	 * 
	 */
	public function getFoldMessage( sTitre : String, sMessage : String, level : LogLevel ) : String
	{
		var s:String = "";
		s += '<showFoldMessage key="' + _mFormat.get( level ) + '">';
		s += '<title>' + sTitre + '</title>';
		s += '<message>' + sMessage + '</message></showFoldMessage>';
		return s;
	}
	
	/**
	 * Sends message to SOS Console.
	 * 
	 * <p>If communication with console is not ready,
	 * messages are buffered.
	 * 
	 * <p>Buffered messages are send to console when connection is
	 * established.
	 *  
	 * @param o Log message
	 * @param level A {@link com.bourre.log.LogLevel} instance
	 */
	public function output( o, level : LogLevel ) : Void
	{
		var sLevel : String = level? _mFormat.get( level ) : SosTracer.DEBUG_FORMAT;
		
		var s:String = getFoldMessage	(
											unescape( String(o) ), 
											level.getName() + ' - [' + getTimer() + ']' + String(o),
											level
										);
		if (_bIsConnected)
		{
			_output( s );
			
		} else
		{	
			_buffer( s );
		}
	}
	
	/**
	 * {@code Unity2} specific callbacks
	 * 
	 * <p>Sends message to console
	 * 
	 * @param o
	 * @param infoObj Log info message
	 */
	public function update(o, infoObj) : Void
	{
		output((infoObj.getLevel() + ": ") + infoObj.getMessage());
	}
	
	/**
	 * {@link com.bourre.log.LogListener} callback implementation.
	 * 
	 * <p>{@link com.bourre.log.Logger} dispatches {@code onLog}
	 * event when messages are send to logging API.
	 * 
	 * @param e A {@link com.bourre.log.LogEvent} instance.
	 */
	public function onLog( e:LogEvent ) : Void
	{
		output( e.content, e.level );
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
	 * Constructs a new {@code SosTracer} instance.
	 * 
	 * <p>Constructor is private, use {@link #getInstance}
	 * method to instanciate {@code SosTracer} class.
	 */
	private function SosTracer()
	{
		_aBuffer = new Array();
		
		_buildColorKeys();
		
		_oXMLSocket = new XMLSocket();
		_oXMLSocket.onConnect = Delegate.create(this, _onConnect);
		_oXMLSocket.connect (SosTracer.IP, SosTracer.PORT);
	}
	
	/**
	 * Builds some pre-defined formats for logging messages.
	 */
	private function _buildColorKeys() : Void
	{
		_mFormat = new Map();

		_mFormat.put( LogLevel.DEBUG, SosTracer.DEBUG_FORMAT );
		_mFormat.put( LogLevel.INFO, SosTracer.INFO_FORMAT );
		_mFormat.put( LogLevel.WARN, SosTracer.WARN_FORMAT );
		_mFormat.put( LogLevel.ERROR, SosTracer.ERROR_FORMAT );
		_mFormat.put( LogLevel.FATAL, SosTracer.FATAL_FORMAT );
		
		_buffer( SosTracer.DEBUG_KEY );
		_buffer( SosTracer.INFO_KEY );
		_buffer( SosTracer.WARN_KEY );
		_buffer( SosTracer.ERROR_KEY );
		_buffer( SosTracer.FATAL_KEY );
	}
	
	
	/**
	 * Adds passed-in {@code s} message to buffer.
	 * 
	 * <p>Only use console is not already connected.
	 */
	private function _buffer( s:String ) : Void
	{
		_aBuffer.push( s );
	}
	
	/**
	 * Sends message to console.
	 * 
	 * @param s Message string
	 */
	private function _output( s:String ) : Void
	{
		_oXMLSocket.send( s );
	}
	
	/**
	 * {@code XmlSocket} callback
	 * 
	 * <p>Calls when connection with SOS Console
	 * is established.
	 */
	private function _onConnect() : Void
	{
		_emptyBuffer();
		_bIsConnected = true;
	}
	
	/**
	 * Sends all buffered messages to console.
	 */
	private function _emptyBuffer() : Void
	{
		var l:Number = _aBuffer.length;
		for (var i:Number = 0; i<l; i++) _output( _aBuffer[i] );
	}
	
}
