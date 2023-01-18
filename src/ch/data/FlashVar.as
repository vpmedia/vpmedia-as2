/*
Class	FlashVar
Package	ch.data
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	2 nov. 2005
*/

/**
 * Represent a {@code FlashVar}.
 * <p>A {@code FlashVar} is a variable loaded on the {@code _root} trought
 * an HTML page or by the URL when loading another SWF.</p> 
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		2 nov. 2005
 * @version		1.0
 */
class ch.data.FlashVar
{
	//---------//
	//Variables//
	//---------//
	private static var	__target:MovieClip = _root; //target clip
	private static var	__flashvars:Array = []; //the registered flashvars
	private var			_name:String; //name
	private var			_value:String; //value
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new FlashVar.
	 * 
	 * @param	name	The name.
	 * @param	value	The value.
	 */
	private function FlashVar(name:String, value:String)
	{
		_name = name;
		_value = value;
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Get the current target {@code MovieClip} to check
	 * the FlashVars.
	 * <p>By default, the target is initialized as {@code _root}.</p>
	 * 
	 * @return	The current {@code MovieClip} target.
	 */
	public static function getTarget(Void):MovieClip
	{
		return __target;
	}
	
	/**
	 * Set the target to check the FlashVars.
	 * <p>If {@code clip} does not exist, an {@code Error} is
	 * thrown.</p>
	 * 
	 * @param	clip	The new target {@code MovieClip}.
	 * @throws	Error	If {@code clip} is {@code null}.
	 */
	public static function setTarget(clip:MovieClip):Void
	{
		//check
		if (clip == null)
		{
			throw new Error("ch.data.FlashVar.setTarget : clip is undefined");
		}
		
		__target = clip;
	}
	
	/**
	 * Register a new {@code FlashVar}.
	 * 
	 * @param	name		The name of the {@code FlashVar}.
	 * @param	mustExist	{@code true} if the variable must exist.
	 * @return	The created {@code FlashVar}.
	 * @throws	Error	If {@code name} does not exist in {@link #TARGET} and
	 * 					{@code mustExist} is {@code true}.
	 */
	public static function register(name:String, mustExist:Boolean):FlashVar
	{
		var value:String = __target[name];
		
		//check if the value exist
		if (mustExist && value == null)
		{
			throw new Error("ch.data.FlashVar.register : FlashVar '"+name+"' does not exist in "+__target);
		}
		
		var fv:FlashVar = new FlashVar(name, value);
		__flashvars.push(fv);
		return fv;
	}
	
	/**
	 * Get the registered flashvars.
	 * 
	 * @return	An {@code Array} containing all the {@code FlashVar} registered.
	 */
	public static function getRegisteredFlashVars(Void):Array
	{
		return __flashvars;
	}
	
	/**
	 * Indicates if a variable exists on the target clip.
	 * 
	 * @param	name	Name of the variable.
	 * @return	{@code true} if the variable exists.
	 */
	public static function exists(name:String):Boolean
	{
		return __target[name] != null;
	}
	
	/**
	 * Get the name of the {@code FlashVar}.
	 * 
	 * @return	The name.
	 */
	public function getName(Void):String
	{
		return _name;
	}
	
	/**
	 * Get the value of the {@code FlashVar}.
	 * 
	 * @return	The value.
	 */
	public function getValue(Void):String
	{
		return _value;
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the FlashVar instance.
	 */
	public function toString(Void):String
	{
		return "ch.data.FlashVar";
	}
}