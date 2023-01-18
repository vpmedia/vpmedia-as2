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
 
import com.bourre.commands.Delegate;
import com.bourre.data.collections.RecordSet;
import com.bourre.events.EventType;
import com.bourre.log.PixlibStringifier;
import com.bourre.remoting.BasicFaultEvent;
import com.bourre.remoting.BasicResult;
import com.bourre.remoting.BasicResultEvent;
import com.bourre.remoting.RemotingDebug;
import com.bourre.remoting.ServiceMethod;

class com.bourre.remoting.ServiceResponder 
{
	public static var onResultEVENT : EventType = new EventType( "onResult" );
	public static var onFaultEVENT : EventType = new EventType( "onFault" );

	private var _dResult : Delegate;
	private var _dFault : Delegate;
	private var _oServiceMethod : ServiceMethod;
	private var _oResultTarget : BasicResult;
	
	public function ServiceResponder( 	scope, 
										fResult:Function, 
										fFault:Function	) 
	{
		if (!fFault) 
		{
			fFault = scope["onFault"];
			if (!fResult) fResult = scope["onResult"];
		}
		
		if ( typeof(fResult) != "function" )
		{
			RemotingDebug.WARN( scope + ".onResult method is undefined, " + this + " won't return any ResultEvent." );
		}
			
		if ( typeof(fFault) != "function" )
		{
			RemotingDebug.WARN( scope + ".onFault method is undefined, " + this + " won't return any FaultEvent." );
		}
		
		_dResult = new Delegate( scope, fResult );		_dFault = new Delegate( scope, fFault );
	}
	
	public function setServiceMethodName( o : ServiceMethod ) : Void
	{
		_oServiceMethod = o;
	}
	
	public function getServiceMethodName() : ServiceMethod
	{
		return _oServiceMethod;
	}
	
	public function buildResultEvent( rawResult ) : BasicResultEvent
	{
		return new BasicResultEvent( ServiceResponder.onResultEVENT, rawResult, _oServiceMethod );
	}
	
	public function onResult( rawResult ) : Void 
	{
		RemotingDebug.DEBUG( rawResult );
		
		rawResult = rawResult.serverInfo? new RecordSet(rawResult) : rawResult;
		_dResult.setArguments( buildResultEvent( rawResult ) );
		_dResult.execute();
	}
	
	public function onStatus( rawFault : Object ) : Void 
	{
		RemotingDebug.ERROR( rawFault );
		
		/*
		code
		line
		level
		details
		description
		exceptionStack
		*/
		
		_dFault.setArguments( new BasicFaultEvent( 	ServiceResponder.onFaultEVENT, 
													rawFault.code,
													rawFault.line,
													rawFault.level,
													rawFault.details, 
													rawFault.description,
													rawFault.exceptionStack,
													_oServiceMethod ) );
		_dFault.execute();
	}
	
	public function onDebugEvents( debugEvents : Array ) : Void 
	{
		RemotingDebug.DEBUG( "ServiceResponder.onDebugEvents call" );
		var l:Number = debugEvents.length;
		for (var i:Number = 0; i<l; i++) RemotingDebug.DEBUG( debugEvents[ i ] );
	}
	
	public function _resolve( s : String ) : Void 
	{
		RemotingDebug.DEBUG( "ServiceResponder._resolve(" + s + ")" );
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