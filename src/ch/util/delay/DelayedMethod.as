/*
Class	DelayedMethod
Package	ch.util.delay
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	12 févr. 2006
*/

//import
import ch.util.delay.DelayedValue;

/**
 * A {@code DelayedMethod} object retrieves automatically the value of method
 * of another instance.
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		12 févr. 2006
 * @version		1.0
 */
class ch.util.delay.DelayedMethod implements DelayedValue
{
	//---------//
	//Variables//
	//---------//
	private var _targetObject:Object;
	private var _targetMethodName:String;
	private var _methodValues:Array;
	
	//-----------------//
	//Getters & Setters//
	//-----------------//	
	
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new DelayedMethod.
	 * <p>This will check if the {@code targetMethodName} exists in the {@code targetObject}
	 * and if it is really a function. The {@code methodParameters} array can be hard-coded values or some
	 * other {@code DelayedValue} objects.</p>
	 * 
	 * @param	targetObject		The target object.
	 * @param	targetMethodName	The method in the {@code targetObject}.
	 * @param	methodParameters	An array of hard-coded values or {@code DelayedValue} or {@code null}.
	 */
	public function DelayedMethod(targetObject:Object, targetMethodName:Object, methodParameters:Array)
	{
		//check if the target object exists
		if (targetObject == null)
		{
			throw new Error(this+".<init> : targetObject is undefined");
		}
		
		//check if the target method exists
		if (targetMethodName == null)
		{
			throw new Error(this+".<init> : targetMethodName is undefined");
		}
		
		//check the method
		if (typeof targetObject[targetMethodName] != "function")
		{
			throw new Error(this+".<init> : "+targetObject+"."+targetMethodName+" is not a function");
		}
		
		_targetObject = targetObject;
		_targetMethodName = targetMethodName;
		_methodValues = methodParameters;
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
	 * Get the target method name.
	 * 
	 * @return	The target method name.
	 */
	public function getTargetMethodName(Void):String
	{
		return _targetMethodName;
	}
	
	/**
	 * Get the method parameters.
	 * 
	 * @return	The parameters.
	 */
	public function getMethodParameters(Void):Array
	{
		return _methodValues;
	}
	
	/**
	 * Get the value of the specified {@code DelayedValue}.
	 * 
	 * @return	A value or {@code null}.
	 */
	public function getValue(Void):Object
	{
		//check if they are parameters to set
		if (_methodValues == null)
		{
			return _targetObject[_targetMethodName]();
		}
		
		var params:Array = [];
		var length:Number = _methodValues.length;
		for (var i:Number=0 ; i<length ; i++)
		{
			//check if it is a DelayedValue
			if (_methodValues[i] instanceof DelayedValue)
			{
				params.push(DelayedValue(_methodValues[i]).getValue());
			}
			else
			{
				params.push(_methodValues[i]);
			}
		}
		
		//call the method
		return _targetObject[_targetMethodName].apply(_targetObject, params);
	}
	
	/**
	 * Represent the current instance into a String.
	 *
	 * @return	A String representing the DelayedMethod instance.
	 */
	public function toString(Void):String
	{
		return "ch.util.delay.DelayedMethod";
	}
}