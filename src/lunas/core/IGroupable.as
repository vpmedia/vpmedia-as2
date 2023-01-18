
/**
 * This interface defines an object groupable in the application.
 * @author eKameleon
 */
interface lunas.core.IGroupable 
{

	/**
	 * Returns {@code true} if this object is grouped.
	 * @return {@code true} if this object is grouped.
	 */
	function getGroup():Boolean ; 
	
	/**
	 * Returns the name of the group of this object.
	 * @return the name of the group of this object.
	 */
	function getGroupName():String ; 

	/**
	 * Sets if the object is grouped or not.
	 */
	function setGroup(b:Boolean):Void ; 
	
	/**
	 * Sets the name of the group of this component.
	 * @param sName the name of the group or null to unregister the object.
	 */	
	function setGroupName(sName:String):Void ; 

}