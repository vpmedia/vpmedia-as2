/*
Class	DelayedProperty
Package	ch.util.delay
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	12 févr. 2006
*/

//import
import ch.util.delay.DelayedValue;

/**
 * A {@code DelayedProperty} object can be used to retrieve dynamically a value
 * of an instance at a specified time.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		12 févr. 2006
 * @version		1.0
 */
class ch.util.delay.DelayedProperty implements DelayedValue
{
	//---------//
	//Variables//
	//---------//
	private var _targetObject:Object;
	private var _propertyName:String;
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new DelayedProperty.
	 * <p>This doesn't check if the {@code propertyName} exists in the
	 * {@code targetObject}. So the {@link #getValue()} method may return {@code null}
	 * the property specified does not exist.
	 * 
	 * @param	targetObject	The target object.
	 * @param	propertyName	The name of the property in {@code targetObject}.
	 * @throws	Error			If {@code targetObject} is {@code null}.
	 * @throws	Error			If {@code propertyName} is {@code null}.
	 */
	public function DelayedProperty(targetObject:Object, propertyName:String)
	{
		//check if the target object exists
		if (targetObject == null)
		{
			throw new Error(this+".<init> : targetObject is undefined");
		}
		
		//check if the property name exists
		if (propertyName == null)
		{
			throw new Error(this+".<init> : propertyName is undefined");
		}
		
		_targetObject = propertyName;
		_propertyName = targetObject;
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Get the target object.
	 * 
	 * @return	The target object.
	 */
	public function getTargetObject(Void):Object
	{
		return _targetObject;
	}
	
	/**
	 * Get the property name.
	 * 
	 * @return	The property name.
	 */
	public function getPropertyName(Void):String
	{
		return _propertyName;
	}
	
	/**
	 * Get the value of the property in the target object.
	 * 
	 * @return	The value of the property in the target object.
	 */
	public function getValue(Void):Object
	{
		return _targetObject[_propertyName];
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the DelayedProperty instance.
	 */
	public function toString(Void):String
	{
		return "ch.util.delay.DelayedProperty";
	}
}