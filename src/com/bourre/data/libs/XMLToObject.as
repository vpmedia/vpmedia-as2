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
 * @version 3.0
 */

import com.bourre.commands.Delegate;
import com.bourre.data.libs.AbstractLib;
import com.bourre.data.libs.IXMLToObjectDeserializer;
import com.bourre.data.libs.XMLToObjectDeserializer;
import com.bourre.data.libs.XMLToObjectEvent;
import com.bourre.events.EventType;
import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;

class com.bourre.data.libs.XMLToObject extends AbstractLib
{
	private var _oTarget;
	private var _oDeserializer:IXMLToObjectDeserializer;
	
	public static var onLoadInitEVENT:EventType = AbstractLib.onLoadInitEVENT;
	public static var onLoadProgressEVENT:EventType = AbstractLib.onLoadProgressEVENT;
	public static var onTimeOutEVENT:EventType = AbstractLib.onTimeOutEVENT;	public static var onErrorEVENT:EventType = AbstractLib.onErrorEVENT;
	
	public function deserializeData(oXML:XMLNode, oL) : Object
	{
		var l:Number = oXML.childNodes.length;
    	for (var x = 0; x < l; x++) _oDeserializer.deserialize( oL, oXML.childNodes[x] );
		return oL;
	}
	
	private function _onLoadXML(bSuccess:Boolean) : Void
	{
		var oXML = getContent();
		var sURL:String = this.getURL();
		
		if (bSuccess) 
		{
    		switch (oXML.status) 
    		{
   				 case 0 :
      				PixlibDebug.INFO( 'XML parsing was completed successfully' + ' : ' + sURL );
      				break;
    			case -2 :
      				PixlibDebug.ERROR( 'A CDATA section was not properly terminated' + ' : ' + sURL );
      				break;
    			case -3 :
      				PixlibDebug.ERROR( 'The XML declaration was not properly terminated' + ' : ' + sURL );
      				break;
    			case -4 :
      				PixlibDebug.ERROR( 'The DOCTYPE declaration was not properly terminated' + ' : ' + sURL );
      				break;
    			case -5 :
      				PixlibDebug.ERROR( 'A comment was not properly terminated' + ' : ' + sURL );
      				break;
    			case -6 :
      				PixlibDebug.ERROR( 'An XML element was malformed' + ' : ' + sURL );
      				break;
    			case -7 :
      				PixlibDebug.FATAL( 'Out of memory' + ' : ' + sURL );
      				break;
    			case -8 :
      				PixlibDebug.ERROR( 'An attribute value was not properly terminated' + ' : ' + sURL );
      				break;
    			case -9 :
     				 PixlibDebug.ERROR( 'A start-tag was not matched with an end-tag' + ' : ' + sURL );
      				break;
    			case -10 :
      				PixlibDebug.ERROR( 'An end-tag was encountered without a matching start-tag' + ' : ' + sURL );
      				break;
    			default :
      				PixlibDebug.ERROR( 'An unknown error has occurred' + ' : ' + sURL );
      				break;
    		}
    		
    		if (oXML.status == 0)
    		{
    			readData();
    		} else
    		{
    			PixlibDebug.ERROR( 'XML was loaded successfully, but was unable to be parsed : ' + sURL );
    		}
    		
  		} else 
  		{
			fireEventType( XMLToObject.onErrorEVENT  ); 
    		PixlibDebug.ERROR( 'Unable to load/parse XML : ' + sURL );
  		}
	}
	
	/*
	 *
	 */

	public function XMLToObject( o, deserializer:IXMLToObjectDeserializer ) 
	{
		super();
		setDeserializer ( deserializer );
		setContent( new XML() );
		if (o != undefined) setObject( o );
	}
	
	public function setDeserializer ( deserializer:IXMLToObjectDeserializer ) : Void
	{
		deserializer.setOwner( this );
		_oDeserializer = deserializer? deserializer : new XMLToObjectDeserializer( this );
	}
	
	public function getDeserializer () : IXMLToObjectDeserializer 
	{
		return _oDeserializer;
	}
	
	public function initEventSource() : Void
	{
		_e = new XMLToObjectEvent(null, this);
	}
	
	public function onLoadInit() : Void
	{
		// overwriting for delaying 'onLoadInit' broadcast
	}

	public function readData() : Void
	{
		getDeserializer().setOwner( this );
		deserializeData( getContent().firstChild, getObject() );
    	super.onLoadInit();
	}
 
 	public function load(sURL:String) : Void
	{
		if (sURL != undefined) setURL( sURL );
		
		if (getObject() == undefined) 
		{
			PixlibDebug.WARN( "You must specify an object to decorate with 'setObject' method before using 'load' method with XMLToObject" );
			setObject( new Object() );
		}
		
  		getContent().ignoreWhite = true;
  		getContent().onLoad = Delegate.create(this, _onLoadXML);
  		getContent().load( this.getURL() );
  		super.load();
  	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
	
	// XML to deserialize
	public function setContent(oXML:XML) : Void
	{
		super.setContent( oXML );
	}
	
	public function getContent() : XML
	{
		return XML( super.getContent() );
	}
	
	// Object to decorate
	public function setObject(o) : Void
	{
		_oTarget = o;
	}
	
	public function getObject()
	{
		return _oTarget;
	}
}