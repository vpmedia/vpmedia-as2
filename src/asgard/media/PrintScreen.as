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

import asgard.display.DisplayObject;
import asgard.events.PrintScreenEvent;

import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Rectangle;

import pegas.process.AbstractAction;
import pegas.process.Action;

import vegas.events.Delegate;
import vegas.events.TimerEvent;
import vegas.util.Timer;

/**
 * This class capture a BitmapData over a movieclip or a DisplayObject.
 * @author eKameleon
 */
class asgard.media.PrintScreen extends AbstractAction implements Action
{

	/**
	 * Creates a new PrintScreen instance.
	 */	
	function PrintScreen( display , x:Number, y:Number, width:Number, height:Number ) 
	{
		
		_buffer = [] ;
		
		_eClear = new PrintScreenEvent(PrintScreenEvent.CLEAR, this) ;
		_eFinish = new PrintScreenEvent(PrintScreenEvent.FINISH, this) ;
		_eProgress = new PrintScreenEvent(PrintScreenEvent.PROGRESS, this) ;
		_eStart = new PrintScreenEvent(PrintScreenEvent.START, this) ;

		_rec = new Rectangle() ;
		
		_timer = new Timer( DEFAULT_PROGRESS_DELAY ) ;
		_timer.addEventListener( TimerEvent.TIMER , new Delegate(this, _onTimer ) ) ;
		
		setTarget( display ) ;
		
		if (isNaN(x))
		{
			x = 0 ;	
		}
		
		if (isNaN(y))
		{
			y = 0 ;	
		}
		
		var w:Number = isNaN(width)  ? _target._width  : width ;
		var h:Number = isNaN(height) ? _target._height : height ;
		
		setRectangle( x, y, w, h ) ;
		
	}

	/**
	 * The default delay to notify the PrintScreen.PROGRESS event.
	 */	
	static public var DEFAULT_PROGRESS_DELAY:Number = 5 ;

	/**
	 * Returns the height of the capture.
	 * @return the height of the capture.
	 */
	public function get height():Number
	{
		return _rec.height ;	
	}

	/**
	 * (read-only) Returns {@code true} if the process is in progress.
	 * @return {@code true} if the process is in progress.
	 */
	public function get running():Boolean 
	{
		return getRunning() ;	
	}

	/**
	 * Returns the width of the capture.
	 * @return the width of the capture.
	 */
	public function get width():Number
	{
		return _rec.width ;	
	}

	/**
	 * Clear the buffer of this PrintScreen object.
	 */
	public function clear():Void
	{
		if (_bmp)
		{
			_bmp.dispose() ;
		}
		_bmp = new BitmapData( _rec.width , _rec.height ) ;
		_cpt = 0 ;
		_time = 0 ;
		_buffer = [] ;
		notifyCleared() ;
	}
	
	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	public function clone() 
	{
		var rec:Rectangle = getRectangle() ;
		return  new PrintScreen( getTarget() , rec.x, rec.y, rec.width, rec.height) ;
	}

	/**
	 * Returns the internal BitmapData reference.
	 * @return the internal BitmapData reference.
	 */
	public function getBitmapData():BitmapData
	{
		return _bmp ;	
	}

	/**
	 * Returns the Array representation of the PrintScreen's buffer.
	 * @return the Array representation of the PrintScreen's buffer.
	 */
	public function getBuffer():Array
	{
		return _buffer ;	
	}

	/**
	 * Returns the delay in ms between the capture and the end of the process.
	 * @return the delay in ms between the capture and the end of the process.
	 */
	public function getDelay():Number
	{
		return _timer.getDelay() ;
	}
	
	/**
	 * Returns the Rectangle reference of this PrintScreen object.
	 * @return the Rectangle reference of this PrintScreen object.
	 */
	public function getRectangle():Rectangle
	{
		return _rec ;	
	}

	/**
	 * Returns the progress percent value of the capture process.
	 * @return the progress percent value of the capture process.
	 */
	public function getPercent():Number
	{
		var n:Number = Math.min(100, Math.ceil( _cpt / ( _size / 100 ) ) );
		return (isNaN(n)) ? 0 : n ;
	}

	/**
	 * Returns the MovieClip display of this PrintScreen object.
	 * @return the MovieClip display of this PrintScreen object.
	 */
	public function getTarget():MovieClip
	{
		return _target ;
	}

	/**
	 * Returns {@code true} if the process is in progress.
	 * @return {@code true} if the process is in progress.
	 */
	public function getRunning():Boolean 
	{
		return _isRunning ;	
	}
	
	/**
	 * Returns the elapsed time during the capture (in ms).
	 * @return the elapsed time during the capture (in ms).
	 */
	public function getTime():Number
	{
		return isNaN(_time) ? 0 : _time ;	
	}
	
	/**
	 * Notify an PrintScreenEvent when the process is cleared.
	 */
	public function notifyCleared():Void 
	{
		dispatchEvent(_eClear) ;
	}	

	/**
	 * Notify an PrintScreenEvent when the process is finished.
	 */
	public function notifyFinished():Void 
	{
		_timer.stop() ;
		_setRunning(false) ;
		dispatchEvent(_eFinish) ;
	}

	/**
	 * Notify an PrintScreenEvent when the process is in progress.
	 */
	public function notifyProgress():Void 
	{
		dispatchEvent(_eProgress) ;
	}
	
	/**
	 * Notify an PrintScreenEvent when the process is started.
	 */
	public function notifyStarted():Void 
	{
		dispatchEvent(_eStart) ;
		_setRunning(true) ;
		_timer.start() ;
	}

	/**
	 * Run the capture process.
	 */
	public function run():Void
	{
		
		clear() ;
		
		if ( _target == null )
		{
			return ;	
		}
		
		notifyStarted() ;
		
		_time = getTimer() ;
		_bufferize() ;
		_time = getTimer() - _time ;
		
		notifyFinished() ;
		
	}
	
	/**
	 * Sets the delay in ms between the capture and the end of the process.
	 */
	public function setDelay( time:Number ):Void
	{
		_timer.setDelay( time ) ;	
	}
	
	/**
	 * Sets the internal rectangle area properties.
	 * @param x the x origin position of the internal capture area.
	 * @param y the y origin position of the internal capture area.
	 * @param width the width of the internal capture area.
	 * @param height the height of the internal capture area.
	 */
	public function setRectangle( x:Number, y:Number, width:Number, height:Number ):Void
	{
		_rec.x = isNaN(x) ? 0 : x ;
		_rec.y = isNaN(y) ? 0 : y ;
		_rec.width = isNaN(width) ? 0 : width ;
		_rec.height = isNaN(height) ? 0 : height ;
		if (_bmp != null)
		{
			_bmp.dispose() ;	
		}
		
		_size = _rec.width * _rec.height ;
	}
	
	/**
	 * Sets the display of this PrintScreen object.
	 * @param display can be a DisplayObject (use the view property) or a MovieClip.
	 */
	public function setTarget( display ):Void
	{
		if ( display instanceof MovieClip )
		{
			_target = display ;
		}
		else if ( display instanceof DisplayObject )
		{
			_target = display.view ;
		} 
		else
		{
			_target = null ;	
		}
	}
	
	/**
	 * Returns the size of the buffer.
	 * @return the size of the buffer.
	 */
	public function size():Number
	{
		return _size ;	
	}
	
	/**
	 * The internal BitmapData reference to copy the picture.
	 */
	private var _bmp:BitmapData ;
	
	/**
	 * The internal array buffer to capture all pixel colors of the display.
	 */
	private var _buffer:Array ;
	
	/**
	 * Defines when the process is in progress the number of pixel captured.
	 */
	private var _cpt:Number ;
	
	/**
	 * The internal delay between the end of the capture and the PrintScreenEvent.FINISH event.
	 */
	private var _delay:Number ;

	/**
	 * The event notify when the capture is cleared.
	 */
	private var _eClear:PrintScreenEvent ;

	/**
	 * The event notify when the capture is finished.
	 */
	private var _eFinish:PrintScreenEvent ;

	/**
	 * The event notify when the capture is in progress.
	 */
	private var _eProgress:PrintScreenEvent ;

	/**
	 * The event notify when the capture is started.
	 */
	private var _eStart:PrintScreenEvent ;

	/**
	 * The event notify when the capture is cleared.
	 */
	private var _isRunning:Boolean ;

	/**
	 * The internal Rectangle area to capture the bitmap.
	 */
	private var _rec:Rectangle ;

	/**
	 * The numbers of pixels to capture.
	 */
	private var _size:Number ;
	
	/**
	 * The internal target of this PrintScreen object.
	 */
	private var _target:MovieClip ;

	/**
	 * The elapsed time during the capture (in ms).
	 */
	private var _time:Number ;

	/**
	 * The internal timer to notify the progress of the capture process.
	 */
	private var _timer:Timer ;

	/**
	 * Creates the buffer of all pixels.
	 */
	private function _bufferize():Void
	{
		var x:Number = _rec.x ;
		var y:Number = _rec.y ;
		var h:Number = _rec.height ;
		var w:Number = _rec.width  ;
		var m:Matrix = new Matrix() ;
		m.translate( -x, -y ) ;
		_bmp.draw( _target , m, null, 1 , _rec ) ;
		for ( var i:Number = 0 ; i < h ; i++ ) 
		{
			for ( var j:Number = 0 ; j < w ; j++ ) 
			{
				_buffer[_cpt] = _bmp.getPixel(j, i) ;
				_cpt ++ ;
			}
		}
	}	

	private function _onTimer():Void
	{
		notifyProgress() ;
	}

	/**
	 * This protected method is an internal method to change the _isRunning value.
	 */
	/*protected*/ private function _setRunning(b:Boolean):Void 
	{
		_isRunning = b ;	
	}

}