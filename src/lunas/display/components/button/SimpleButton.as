/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is LunAS Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import lunas.display.components.button.AbstractButton;

import pegas.events.ButtonEvent;
import pegas.events.ButtonEventType;

import vegas.events.Delegate;
import vegas.events.EventListener;

/**
 * The SimpleButton class is use over a clip with the 4 frame's labels with the name :
 * <ul>
 * <li>"disabled" : the frame when the button is disabled.</li>
 * <li>"down"     : the frame when the button is down.</li>
 * <li>"over"     : the frame when the button is over.</li>
 * <li>"up"       : the first frame when the button is up.</li>
 * </ul>
 * <p>The {@code stop()} method is call in the first frame of the component when the constructor is launched.</p>
 * @author eKameleon
 * @see pegas.events.ButtonEvent
 */
class lunas.display.components.button.SimpleButton extends AbstractButton 
{

	/**
	 * Creates a new SimpleButton instance.
	 */
	public function SimpleButton () 
	{
		
		super() ;
		
		_listenerDisabled = new Delegate(this, disabled) ;
		_listenerDown = new Delegate(this, down) ;
		_listenerOver = new Delegate(this, over) ;
		_listenerUp = new Delegate(this, up) ;
		
		addEventListener (ButtonEvent.DISABLED, _listenerDisabled) ;
		addEventListener (ButtonEvent.DOWN, _listenerDown) ;
		addEventListener (ButtonEvent.OVER, _listenerOver) ;
		addEventListener (ButtonEvent.UP, _listenerUp) ;
	
		getView().stop() ;
			
	}

	/**
	 * Invoqued when the button is disabled.
	 */
	public function disabled( e:ButtonEvent ): Void 
	{
		getView().gotoAndStop(ButtonEvent.DISABLED) ;
	}	
	
	/**
	 * Invoqued when the button is down.
	 */
	public function down( e:ButtonEvent ): Void 
	{
		getView().gotoAndStop(ButtonEvent.DOWN) ;
	}

	/**
	 * This method delegate the reference of the different views of the button over a other movieclip.
	 * You can override this method.	 
	 */
	public function getView():MovieClip 
	{
		return this ;
	}

	/**
	 * Invoqued when the button is over.
	 */
	public function over( e:ButtonEvent ):Void 
	{
		getView().gotoAndStop(ButtonEvent.OVER) ;
	}

	/**
	 * Invoqued when the button is up.
	 */
	public function up( e:ButtonEvent ):Void 
	{
		getView().gotoAndStop(ButtonEventType.UP) ;
	}

	private var _listenerDisabled:EventListener ;
	private var _listenerDown:EventListener ;
	private var _listenerOver:EventListener ;
	private var _listenerUp:EventListener ;	

}
