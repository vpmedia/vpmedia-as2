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
 * {@code BubbleEventBroadcaster}
 * 
 * TODO complete documentation (wait for a possible refactoring)
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.events.BubbleEvent;
import com.bourre.events.EventBroadcaster;
import com.bourre.events.IEvent;
import com.bourre.events.ListenerArray;
import com.bourre.log.PixlibStringifier;

class com.bourre.events.BubbleEventBroadcaster
	extends EventBroadcaster
{
	//-------------------------------------------------------------------------
	// Public Properties
	//-------------------------------------------------------------------------
	
	/** **/
	public var parent:BubbleEventBroadcaster;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Constructs a new {@code BubbleEventBroadcaster} instance.
	 * 
	 */ 
	public function BubbleEventBroadcaster( owner, parent:BubbleEventBroadcaster ) 
	{
		super( owner );
		this.parent = parent? parent : null;
	}

	/**
	 * Starts receiving bubble events from passed-in child.
	 * 
	 * @param child a {@link BubbleEventBroadcaster} instance that will send bubble events.
	 */
	public function addChild( child : BubbleEventBroadcaster ) : Void
	{
		child.parent = this;
	}
	
	/**
	 * Stops receiving bubble events from passed-in child.
	 * 
	 * @param child a {@link BubbleEventBroadcaster} instance that will stop
	 * to send bubble events.
	 */
	public function removeChild( child : BubbleEventBroadcaster ) : Void
	{
		child.parent = null;
	}
	
	/**
	 * Broadcasts event to suscribed listeners if event {@link #propagation} property is set 
	 * to {@code true}.
	 * 
	 * <p>The event is bubbled to the parent if event {@link #bubble} property is set 
	 * to {@code true}.
	 * 
	 * @param e an {@link BubbleEvent} instance to broadcast or bubble.
	 */
	public function broadcastEvent( e : BubbleEvent ) : Void
	{
		if ( e.propagation ) super.broadcastEvent( e );
		if ( e.bubbles && parent )
		{
			_broadcastTo( parent, e );
			parent.broadcastEvent( e );
		}

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
	 * Overrides {@link EventBroadcatser#_broadcast} method.
	 */
	private function _broadcast(aL:ListenerArray, e:BubbleEvent) : Void
	{
		var l:Number = aL.length;
		while( --l > -1 )
		{
			if (!e.propagation) 
			{
				break;
			} else
			{
				_broadcastTo(aL[l], e);
			}
			
		}
	}
	
	/**
	 * Broadcasts event to specific target
	 */
	private function _broadcastTo(o, e:IEvent ) : Void
	{
		var sType:String = typeof(o);
		if (sType == "object" || sType == "movieclip") 
		{
			if (o.handleEvent != undefined)
			{
				o.handleEvent(e);
			} else
			{
				o[String(e.getType())](e);
			}
		} else
		{
			o.apply( this, [e] );
		}
	}
}