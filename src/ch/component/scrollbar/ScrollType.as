/*
Class	ScrollType
Package	ch.component.scrollbar
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	28 july 2006
*/

/**
 * Define the scroll types.
 * <p>This class allows you to create your own scroll types. By default,
 * two types are defined : {@code VERTICAL} and {@code HORIZONTAL}. Note that
 * if you want to create your own scroll types, there must be a correlation
 * between the two properties (_x/_width or _y/_height).</p>
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		28 juil. 2006
 * @version		1.8
 */
class ch.component.scrollbar.ScrollType
{
	//---------//
	//Constants//
	//---------//
	
	//static instances
	private static var __hScroll:ScrollType = new ScrollType("_x", "_width", false);
	private static var __vScroll:ScrollType = new ScrollType("_y", "_height", false);
	
	/**
	 * Type vertical.
	 * <p>This type uses {@code _y} as scroll property and
	 * {@code _height} as size property.</p>
	 */
	public static function get VERTICAL():ScrollType { return __vScroll; }
	
	/**
	 * Type horizontal.
	 * <p>This type uses {@code _x} as scroll property and
	 * {@code _width} as size property.</p>
	 */
	public static function get HORIZONTAL():ScrollType { return __hScroll; }

	//---------//
	//Variables//
	//---------//
	private var _scrollProperty:String;
	private var _sizeProperty:String;
	
	//-----------------//
	//Getters & Setters//
	//-----------------//	
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new ScrollType.
	 * 
	 * @param	scrollProperty		The property to be moved by the scroller.
	 * @param	sizeProperty		The property representing the size.
	 */
	public function ScrollType(scrollProperty:String, sizeProperty:String)
	{
		_scrollProperty = scrollProperty;
		_sizeProperty = sizeProperty;
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Get the scroll property.
	 * 
	 * @return	The scroll property;
	 */
	public function getScrollProperty(Void):String
	{
		return _scrollProperty;
	}
	
	/**
	 * Get the size property.
	 * 
	 * @return	The size property.
	 */
	public function getSizeProperty(Void):String
	{
		return _sizeProperty;
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the ScrollType instance.
	 */
	public function toString(Void):String
	{
		return "ch.component.scrollbar.ScrollType";
	}
	
	//---------------//
	//Private methods//
	//---------------//
}