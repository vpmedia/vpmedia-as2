/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is ASGard Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.core.CoreObject;
import vegas.data.iterator.OrderedIterator;
import vegas.errors.IllegalArgumentError;
import vegas.errors.UnsupportedOperation;
import vegas.util.MathsUtil;

/**
 * This iterator control the timeline in a MovieClip target.
 * @author eKameleon
 */
class asgard.display.TimelineIterator extends CoreObject implements OrderedIterator 
{
	
	/**
	 * Creates a new TimelineIterator instance.
	 * @param target The MovieClip reference of this iterator.
	 * @param framePosition the default framePosition of the specified MovieClip target (default frame 1).
	 * @param stepSize (optional) the step between two frames returns by the iterator (default 1).
	 * @throws IllegalArgumentError if the {@code target} argument of this constructor is empty.
	 */
	public function TimelineIterator( target:MovieClip , framePosition:Number, stepSize:Number )
	{
		super();
		
		if (target == null)
		{
			throw new IllegalArgumentError( this + " can't be instanciate with an empty MovieClip reference in the first argument of the constructor.") ;	
		}
		
		this._target = target ;
		
		this._step = (stepSize > 1) ? stepSize : DEFAULT_STEP ; 
		if ( !isNaN(framePosition) )
		{
			this.seek(framePosition) ;	
		} 
	}

	/**
	 * The default step value in all the PageByPageIterators.
	 */
	static public var DEFAULT_STEP:Number = 1 ;

	/**
	 * (read-only) The current frame of the iterator.
	 */
	public function get currentFrame():Number
	{
		return _target._currentframe ;	
	}

	/**
	 * (read-only) Returns the target reference of this iterator.
	 */
	public function get target():MovieClip
	{
		return _target ;	
	}

	/**
	 * (read-only) The current frame of the iterator.
	 */
	public function get totalFrames():Number
	{
		return _target._totalFrames ;	
	}
	
	/**
	 * Returns the step size of this PageByPageIterator.
	 * @return the step size of this PageByPageIterator.
	 */
	public function getStepSize():Number
	{
		return _step ;	
	}

	/**
	 * Checks to see if there is a previous element that can be iterated to.
	 * @return {@code true} if the iterator has more elements.
	 */
	public function hasPrevious() : Boolean 
	{
		return _target._currentFrame > 1 ;
	}

	/**
	 * Returns {@code true} if the iteration has more elements.
	 * @return {@code true} if the iterator has more elements.
	 */
	public function hasNext() : Boolean 
	{
		return _target._currentFrame < _target._totalFrames ;
	}

	/**
	 * Returns the current page number.
	 * @return the current page number.
	 */
	public function key() 
	{
		return _target._currentFrame ;
	}

	/**
	 * Seek the key pointer of the iterator over the last frame of the timeline.
	 */
	public function last():Void 
	{
		_target.gotoAndStop(_target._totalFrames) ;
	}

	/**
	 * Returns the next Array page of elements or the next element in the Array if the getStepSize() value is 1.
	 * @return the next Array page of elements or the next element in the Array if the getStepSize() value is 1.
	 */
	public function next() 
	{
		var k:Number = _target._currentFrame ;
		k += _step ;
		k = (k < _target._totalFrames) ? k : _target._totalFrames ;
		_target.gotoAndStop(k) ;
		return k ;
	}

	/**
	 * Returns the previous Array page of elements or the previous element in the Array if the getStepSize() value is 1.
	 * @return the previous element from the collection.
	 */
	public function previous() 
	{
		var k:Number = _target._currentFrame ;
		k -= _step ;
		k = (k > 1) ? k : 1 ;
		_target.gotoAndStop(k) ;
		return k ;
	}

	/**
	 * Unsupported operation in this iterator.
	 * @throws UnsupportedOperation the method remove() in this iterator is unsupported. 
	 */
	public function remove() 
	{
		throw new UnsupportedOperation(this + " remove method is unsupported by this instance.") ;
	}

	/**
	 * Resets the key pointer of the iterator.
	 */
	public function reset():Void 
	{
		_target.gotoAndStop(1) ;
	}

	/**
	 * Seek the key pointer of the iterator.
	 */
	public function seek(n : Number):Void 
	{
		_target.gotoAndStop(MathsUtil.clamp( n, 1, _target._totalFrames )) ;
	}
	
	/**
	 * The numbers of frame to step with the iterator.
	 */
	private var _step:Number ;
	
	/**
	 * The MovieClip target of this iterator.
	 */
	private var _target:MovieClip ;

}