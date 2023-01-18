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
 * {@code AbstractModel} is the base class for {@code Model} implementation 
 * in MVC (Model View Controller) architecture.
 * 
 * <p>The model represents enterprise data and the business rules that govern access to 
 * and updates of this data. 
 * 
 * <p>{@code AbstractModel} is an abstract class and can't be directly use.
 * 
 * <p>All custom models must extends {@code AbstractModel} and 
 * implement {@link IModel} interface.
 * 
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.events.EventBroadcaster;
import com.bourre.events.IEvent;
import com.bourre.log.PixlibStringifier;
import com.bourre.mvc.IModel;

class com.bourre.mvc.AbstractModel implements IModel
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private var _oEB:EventBroadcaster;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Notifies all registred listeners for passed-in {@code e} event.
	 * 
	 * @param e {@link com.bourre.events.IEvent} instance
	 */
	public function notifyChanged(e:IEvent) : Void
	{
		_oEB.broadcastEvent(e);
	}
	
	/**
	 * Adds the passed-in {@code oL} listener as model's listener.
	 * 
	 * <p>Usually call by {@link AbstractView#registerWithModel} method when
	 * MVC Design is deployed.
	 * 
	 * @param oL Listener object
	 */
	public function addModelListener(oL) : Void
	{
		_oEB.addListener(oL);
	}
	
	/**
	 * Removes the passed-in {@code oL} listener from model.
	 * 
	 * @param oL Listener object
	 */
	public function removeModelListener(oL) : Void
	{
		_oEB.removeListener(oL);
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
	 * Constructs a new {@code AbstractModel} instance.
	 */
	private function AbstractModel()
	{
		_oEB = new EventBroadcaster( this );
	}
}