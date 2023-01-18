/*
Class	ScrollManager
Package	ch.component.scrollbar
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	28 févr. 2006
*/

//import
import ch.component.scrollbar.ScrollType;
import ch.component.scrollbar.ScrollBarModel;

/**
 * Manage the scrolling of a MovieClip behind a mask.
 * <p>This class manages the calculation of the scroll and the effect of the 
 * scroll. If you want to customize your scroll effects on the content, you can
 * simply override the {@link #move(MovieClip,String,Number)} method to set your personnal effect.</p>
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		28 févr. 2006
 * @version		1.8
 */
class ch.component.scrollbar.ScrollManager
{
	//---------//
	//Variables//
	//---------//
	
	/**
	 * Represent the top/left margin.
	 * <p>By default, this value is 0.</p>
	 */
	public var margin1:Number;
	
	/**
	 * Represent the bottom/right margin.
	 * <p>By default, this value is 0.</p>
	 */
	public var margin2:Number;
	
	private var _target:MovieClip;
	private var _delimiter:MovieClip;
	private var _scrollType:ScrollType;
	private var _position:String;
	private var _currentTargetPosition:Number;			//bugfix : with this new variable, the ratio can be calculated on the
	private var _size:String;							//next content position, so if there is currently a Tween on the content,
														//the scroll won't be affected.
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new ScrollManager.
	 * <p>The {@code target} represent the clip that will be behind the mask. The
	 * {@code delimiter} is supposed to be the mask of the {@code target}. The
	 * {@code scrollType} set the direction of the scroll.</p>
	 * 
	 * @param	target		The target clip.
	 * @param	delimiter	The target clip delimiter (mask).
	 * @param	scrollType	The {@code ScrollType} to use.
	 * @throws	Error		If {@code target} is {@code null}.
	 * @throws	Error		If {@code delimiter} is {@code null}.
	 */
	public function ScrollManager(target:MovieClip, delimiter:MovieClip, scrollType:ScrollType)
	{
		if (target == null) throw new Error(this+".<init> : target is not defined");
		if (delimiter == null) throw new Error(this+".<init> : delimiter is not defined");
		
		margin1 = 0;
		margin2 = 0;
		
		_target = target;
		_delimiter = delimiter;
		_scrollType = null;
		_currentTargetPosition = null;
		
		setScrollType(scrollType);
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Get the target clip.
	 * 
	 * @return	The target clip.
	 */
	public function getTarget(Void):MovieClip
	{
		return _target;
	}
	
	/**
	 * Get the target clip delimiter.
	 * 
	 * @return	The clip delimiter.
	 */
	public function getDelimiter(Void):MovieClip
	{
		return _delimiter;
	}
	
	/**
	 * Set the scroll type to use on the target content.
	 * 
	 * @param	type	The {@code ScrollType} to set.
	 * @throws	Error	If {@code type} is {@code null}.
	 */
	public function setScrollType(type:ScrollType):Void
	{
		if (type == null) throw new Error(this+".setScrollType : type is not defined");
		
		_position = type.getScrollProperty();
		_size = type.getSizeProperty();
		_scrollType = type;
		
		//check the properties into the delimiter and the target
		if (_target[_position] == null) throw new Error(this+".setScrollType : property '"+_position+"' does not exist in "+_target);
		if (_target[_size] == null) throw new Error(this+".setScrollType : property '"+_size+"' does not exist in "+_target);
		if (_delimiter[_position] == null) throw new Error(this+".setScrollType : property '"+_position+"' does not exist in "+_delimiter);
		if (_delimiter[_size] == null) throw new Error(this+".setScrollType : property '"+_size+"' does not exist in "+_delimiter);
		
		//initialize the scroll
		init();
	}
	
	/**
	 * Initilalize the content.
	 * <p>This method simply set the _x/_y position (depending on the scroll type) of
	 * the content MovieClip. It is automatically called when the {@code setScrollType}
	 * method is called.</p>
	 */
	public function init(Void):Void
	{
		var m:Number = getMaxMove();
		
		_target[_position] = m;
		_currentTargetPosition = m;
	}
	
	/**
	 * Get the scroll type.
	 * 
	 * @return	The {@code ScrollType} used.
	 */
	public function getType(Void):ScrollType
	{
		return _scrollType;
	}
	
	/**
	 * Get the minimum allowed position.
	 * <p>The returned value is an integer rounded with <code>Math.floor()</code></p>
	 * 
	 * @return	The minimum allowed position.
	 */
	public function getMinMove(Void):Number
	{
		return Math.floor(_delimiter[_position]-_target[_size]+_delimiter[_size]-margin2);		
	}
	
	/**
	 * Get the maximum allowed position.
	 * <p>The returned value is an integer rounded with <code>Math.round()</code></p>
	 * 
	 * @return	The maximum allowed position.
	 */
	public function getMaxMove(Void):Number
	{
		return Math.round(_delimiter[_position]+margin1);
	}
	
	/**
	 * Get the virtual position of the content.
	 * <p>This position is the real position where the
	 * target content should be. Instead of the {@code getCurrentPosition} method,
	 * this method returns the real virtual position.</p>
	 * 
	 * @return	The virtual position.
	 */
	public function getVirtualPosition(Void):Number
	{
		return _currentTargetPosition;
	}
	
	/**
	 * Get the current position of the target relatively to 0.
	 * <p>This method return the position where the target should
	 * be if the center point is 0.</p>
	 * 
	 * @return	A {@code Number} between 0 and <code>getMaxMove()-getMinMove()</code> inclusive.
	 */
	public function getCurrentPosition(Void):Number
	{
		return getMaxMove()-_currentTargetPosition;
	}
	
	/**
	 * Set the current position of the target.
	 * 
	 * @param	position	A {@code Number} between 0 and <code>getMaxMove()-getMinMove()</code>
	 * 						inclusive.
	 * @return	The number of pixel scrolled.
	 * @throws	Error		If {@code position} is invalid.
	 */
	public function setCurrentPosition(position:Number):Number
	{
		if (position < 0 || position > getMaxMove()-getMinMove())
		{
			throw new Error(this+".setCurrentPosition : position is invalid ("+position+")");
		}
		
		var toScroll:Number = (_delimiter[_position]+position)-_currentTargetPosition;
		return scroll(toScroll);
	}
	
	/**
	 * Update the current position of the target.
	 * <p>This method simple take the current position of the
	 * target. If you call it, it is recommended to stop all the
	 * tweens in order to have the correct value. Note that if
	 * the value of the target is lower that {@code getMinMove()} or
	 * greater that {@code getMaxMove()}, the virtual position will be
	 * set to the maximum or the minimum, so the ratio won't exceed 1 or
	 * be lower thant 0 !</p>
	 * 
	 * @param	updateContentPosition	Indicates whethever the content position must be updated (false by default).
	 */
	public function updateCurrentPosition(updateContentPosition:Boolean):Void
	{
		_currentTargetPosition = _target[_position];
		
		var min:Number = getMinMove();
		var max:Number = getMaxMove();
		
		//update the position by checking if the content is scrollable
		if (updateContentPosition && _target[_size] < _delimiter[_size])
		{
			_target[_position] = _delimiter[_position];
			_currentTargetPosition = min;
		}
		//check if the minimum position is bypassed
		else if (_currentTargetPosition < min)
		{
			_currentTargetPosition = min;
			if (updateContentPosition) _target[_position] = min;
		}
		//check if the maximum position is bypassed
		else if (_currentTargetPosition > max)
		{
			_currentTargetPosition = max;
			if (updateContentPosition) _target[_position] = max;
		}
	}
	
	/**
	 * Get the current real ratio of the position between the target clip and
	 * the delimiter clip.
	 * <p>This method take the current position of the content. So if you have
	 * a Tween affecting it, the value returned by this method will be altered.</p>
	 * 
	 * @return	A {@code Number} between 0 and 1 inclusive.
	 * @see		#getRatio()
	 */
	public function getRealRatio(Void):Number
	{
		return -_target[_position]/(getMinMove()-getMaxMove());
	}
	
	/**
	 * Get the ratio of the position between the target clip and
	 * the delimiter clip.
	 * <p>This method return the ratio calculated on the target virtual position. It means
	 * that if a Tween is currently acting on the content {@code MovieClip}, your ratio
	 * won't change : it will be calculated as if the content was on his final place.</p>
	 * 
	 * @param	A {@code Number} between 0 and 1 inclusive.
	 * @see		#getRealRatio()
	 */
	public function getRatio(Void):Number
	{
		return -getCurrentPosition()/(getMinMove()-getMaxMove());
	}
	
	/**
	 * Set the ratio of the target.
	 * 
	 * @param	ratio	A {@code Number} between 0 and 1 inclusive.
	 * @return	The number of pixels scrolled.
	 * @throws	Error	If {@code ratio} is invalid.
	 */
	public function setRatio(ratio:Number):Number
	{
		if (ratio == null || ratio < 0 || ratio > 1) throw new Error(this+".setRatio : ratio is not valid ("+ratio+")");
		
		var newPosition:Number = ratio*(getMinMove()-getMaxMove());
		var toScroll:Number = (getMaxMove()+newPosition)-_currentTargetPosition;
		
		return scroll(toScroll);
	}
	
	/**
	 * Get the size ratio between the content and the background.
	 * 
	 * @return	The size ratio of the content.
	 */
	public function getContentRatio(Void):Number
	{
		return _delimiter[_size]/_target[_size];
	}
	
	/**
	 * Get the allowed scroll value.
	 * <p>If this method returns 0, then no more scroll is available
	 * in the specified position.</p>
	 * 
	 * @param	value	The number of pixels to scroll.
	 * @return	The number of pixels that can be scrolled.
	 * @throws	Error	If {@code value} is {@code null}.
	 */
	public function getAllowedScroll(value:Number):Number
	{
		if (value == null) throw new Error(this+".getAllowedScroll : value is not defined");
		
		var newPos:Number = _currentTargetPosition+value;
		if (newPos >= getMaxMove()) value = getMaxMove() - _currentTargetPosition;
		else if (newPos <= getMinMove()) value = getMinMove() - _currentTargetPosition;
		
		return value;
	}
	
	/**
	 * Scroll the target clip relatively with the specified value.
	 * <p>This method checks automatically the value.</p>
	 * 
	 * @param	value	The value to scroll.
	 * @return	The number of pixels scrolled.
	 */
	public function scroll(value:Number):Number
	{
		var toScroll:Number = getAllowedScroll(value);
		_currentTargetPosition += toScroll;

		move(_target, _position, toScroll);
		
		return toScroll;
	}
	
	/**
	 * Move the specified {@code property} of the specified {@code target} within
	 * the specified {@code valueToMove} value.
	 * <p>By default, this method set the {@code property} of the {@code target} to
	 * the virtual position.</p>  
	 * 
	 * @param		target		The {@code MovieClip} to move.
	 * @param		property	The property to use for the moving ({@code _x} or {@code _y}).
	 * @param		valueToMove	The number of pixels to move.
	 */
	public function move(target:MovieClip, property:String, valueToMove:Number):Void
	{
		target[property] = getVirtualPosition();
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the ScrollManager instance.
	 */
	public function toString(Void):String
	{
		return "ch.component.scrollbar.ScrollManager";
	}
	
	//---------------//
	//Private methods//
	//---------------//
}