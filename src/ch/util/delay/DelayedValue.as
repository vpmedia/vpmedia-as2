/*
Class	DelayedValue
Package	ch.util.delay
Project	MainAPI

Created by :	Tabin Cedric - thecaptain
Created at :	12 févr. 2006
*/

/**
 * Represents a class that provide a value from an instance
 * of a function.
 * <p>It is very useful for delayed functions if you have many objects
 * to manage with differents values to be retrieved. You can create dynamically
 * some {@code DelayedValue} using the {@code DelayedValueFactory} class.</p>
 * 
 * @author		Tabin Cedric - thecaptain
 * @since		12 févr. 2006
 * @version		1.0
 * @see			ch.util.delay.DelayedValueFactory
 */
interface ch.util.delay.DelayedValue
{
	/**
	 * Get the value of the specified {@code DelayedValue}.
	 * 
	 * @return	A value or {@code null}.
	 */
	public function getValue(Void):Object;
}