/*
Class	AbstractScrollBarManager
Package	ch.component.scrollbar
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	1 mars 2006
*/

//import
import ch.component.scrollbar.ScrollBarManager;
import ch.component.scrollbar.ScrollManager;
import ch.component.scrollbar.ScrollBarModel;

/**
 * Store the {@code ScrollBarModel} to manage.
 * <p>The exemple beside show how a {@code AbstractScrollBarManager} can
 * manage many {@code ScrollBarModel} :<br><code>
 * var sc1:ScrollBar = ScrollBar.create(this.content1, this.mask1, ScrollType.VERTICAL);<br>
 * var sc2:ScrollBar = ScrollBar.create(this.content2, this.mask2, ScrollType.VERTICAL);<br>
 * <br>
 * //2 ways to adapt a manager to many scrollbar :<br>
 * var scb1:ScrollClickButton = sc1.getUpButton(this.upButton);<br>
 * scb1.addScrollBarModel(sc2.getModel());<br>
 * <br>
 * var scb2:ScrollClickButton = new ScrollClickButton(this.upButton, 4);<br>
 * scb2.addScrollBarModel(sc1.getModel());<br>
 * scb2.addScrollBarModel(sc2.getModel());<br>
 * </code></p>
 * <p>This process allows you to manage a single {@code ScrollBarModel}
 * that can be used by many {@code ScrollBar}.</p>
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		1 mars 2006
 * @version		1.6
 * @see			ch.component.scrollbar.ScrollClickButton
 * @see			ch.component.scrollbar.ScrollDragButton
 * @see			ch.component.scrollbar.ScrollWheelButton
 */
class ch.component.scrollbar.AbstractScrollBarManager implements ScrollBarManager
{
	//---------//
	//Variables//
	//---------//
	private var _scrollBarModels:Array;
	private var _enabled:Boolean;
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new AbstractScrollBarManager.
	 */
	private function AbstractScrollBarManager(Void)
	{
		_scrollBarModels = [];
		_enabled = true;
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Set if the {@code AbstractScrollBarManager} is enabled or not.
	 * <p>This method simply set a {@code Boolean} to the specified value. The
	 * purpose of this method is to be overriden into the subclasses.</p>
	 * 
	 * @param	value	{@code true} to enable the {@code AbstractScrollBarManager}, {@code false} otherwise.
	 */
	public function setEnabled(value:Boolean):Void
	{
		_enabled = value;
	}
	
	/**
	 * Get if the {@code AbstractScrollBarManager} is enabled or not.
	 * 
	 * @return	{@code true} if the {@code AbstractScrollBarManager} is enabled, {@code false} otherwise.
	 */
	public function isEnabled(Void):Boolean
	{
		return _enabled;
	}
	
	/**
	 * Add a {@code ScrollBarModel} to manage.
	 * 
	 * @param	scr	The {@code ScrollBarModel} to add.
	 */
	public function addScrollBarModel(scr:ScrollBarModel):Void
	{
		_scrollBarModels.push(scr);
	}
	
	/**
	 * Remove a {@code ScrollBarModel}.
	 * 
	 * @param	scr	The {@code ScrollBarModel} to remove.
	 */
	public function removeScrollBarModel(scr:ScrollBarModel):Void
	{
		var leng:Number = _scrollBarModels.length;
		for (var i:Number=0 ; i<leng ; i++)
		{
			if (_scrollBarModels[i] == scr)
			{
				_scrollBarModels.splice(i, 1);
				return;
			}
		}
	}
	
	/**
	 * Get the {@code ScrollBarModel} to manage.
	 * 
	 * @return	An {@code Array} of {@code ScrollBarModel}.
	 */
	public function getScrollBarModels(Void):Array
	{
		return _scrollBarModels;
	}
	
	/**
	 * Scroll all the managed {@code ScrollBar} with the
	 * specified value.
	 * <p>The source object provided by this method to the
	 * {@link ch.component.scrollbar.ScrollBarModel#scroll()}
	 * method is the current instance.</p>
	 * <p>Note that this method works even if the {@code AbstractScrollBarManager} is disabled.</p>
	 * 
	 * @param	value	The pixel to scroll.
	 */
	public function scroll(value:Number):Void
	{
		var leng:Number = _scrollBarModels.length;
		for (var i:Number=0 ; i<leng ; i++)
		{
			var mo:ScrollBarModel = _scrollBarModels[i];
			if (mo.isScrollable()) mo.scroll(value, this);
		}
	}
	
	/**
	 * Adjust the all the {@code ScrollBar} within the specified ratio.
	 * <p>The source object provided by this method to the
	 * {@link ch.component.scrollbar.ScrollBarModel#adjust()}
	 * method is the current instance.</p>
	 * <p>Note that this method works even if the {@code AbstractScrollBarManager} is disabled.</p>
	 * 
	 * @param	ratio	A {@code Number} between 0 and 1 inclusive.
	 */
	public function adjust(ratio:Number):Void
	{
		var leng:Number = _scrollBarModels.length;
		for (var i:Number=0 ; i<leng ; i++)
		{
			var mo:ScrollBarModel = _scrollBarModels[i];
			if (mo.isScrollable()) mo.adjust(ratio, this);
		}
	}
	
	/**
	 * Refresh the {@code ScrollBarModel} that listen the {@code AbstractScrollBarManager}.
	 * <p>Note that this method works even if the {@code AbstractScrollBarManager} is disabled.</p>
	 */
	public function refresh(Void):Void
	{
		var leng:Number = _scrollBarModels.length;
		for (var i:Number=0 ; i<leng ; i++)
		{
			_scrollBarModels[i].refresh(this);
		}
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the AbstractScrollBarManager instance.
	 */
	public function toString(Void):String
	{
		return "ch.component.scrollbar.AbstractScrollBarManager";
	}
}