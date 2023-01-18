/*
Class	DelayedValueFactory
Package	ch.util.delay
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	12 févr. 2006
*/

import ch.util.delay.DelayedMethod;
import ch.util.delay.DelayedProperty;
import ch.util.delay.DelayedValue;

/**
 * Creates dynamicall a DelayedValue from the specified parameters.
 * <p><strong>Using :</strong><br><br><code>
 * var clip:MovieClip = this.createEmptyMovieClip("myClip", 0);<br>
 * var dv1:DelayedValue = DelayedValueFactory.create(clip, "_alpha");<br>
 * var dv2:DelayedValue = DelayedValueFactory.create(clip, "createEmptyMovieClip", ["otherClip", 0]);
 * </code></p>
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		12 févr. 2006
 * @version		1.0
 */
class ch.util.delay.DelayedValueFactory
{
	//-----------//
	//Constructor//
	//-----------//
	
	/**
	 * Create a new DelayedValueFactory.
	 */
	private function DelayedValueFactory(Void)
	{
		//empty
	}
	
	//--------------//
	//Public methods//
	//--------------//
	
	/**
	 * Create a new DelayedValue with the specified parameters.
	 * <p>The {@code targetObject} parameter need to be specified. The {@code specValue} parameter
	 * can be one of the following :<br>
	 * <ul>
	 * 		<li>The name of a method into {@code targetObject}.</li>
	 * 		<li>The name of an attribute into {@code targetObject}.</li>
	 * </ul>
	 * <p>If the {@code specValue} int the {@code targetObject} is {@code null}, it will be considerated
	 * as a {@link DelayedProperty} ! Note that if you're using an attribute name for the {@code specValue},
	 * the {@code params} will not be used.</p>
	 * 
	 * @param	targetObject	The target object.
	 * @param	specValue		The name of the method/attribute.
	 * @param	params			The parameters of the method or {@code null}.
	 * @return	A new {@code DelayedValue}.
	 * @throws	Error			If {@code targetObject} is {@code null}.
	 */
	public function create(targetObject:Object, specValue:String, params:Array):DelayedValue
	{
		//check the target object
		if (targetObject == null)
		{
			throw new Error("ch.util.delay.DelayedValueFactory.createDelayedValue : targetObject is undefined");
		}
		
		//if it is a function, return the object
		if (typeof targetObject[specValue] == "function")
		{
			return new DelayedMethod(targetObject, specValue, params);
		}
		
		//otherwise a property
		return new DelayedProperty(targetObject, specValue);
	}
}