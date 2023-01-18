
import andromeda.model.IValueObject;

import vegas.core.CoreObject;
import vegas.core.Identifiable;
import vegas.core.IEquality;
import vegas.util.ConstructorUtil;

/**
 * This class is a basic implementation of the IValueObject interface. This class is really useful with a remote 'AMF' value object.
 * @author eKameleon
 */
class andromeda.model.SimpleValueObject extends CoreObject implements IEquality, IValueObject 
{
	
	/**
	 * Creates a new SimpleValueObject instance.
	 */
	public function SimpleValueObject() 
	{
		super();
	}

	/**
	 * The id of this value object.
	 */
	public var id ;

	/**
	 * Compares the specified object with this object for equality. This method compares the ids of the objects with the {@code Identifiable.getID()} method.
	 * @return {@code true} if the the specified object is equal with this object.
	 */
	public function equals( o ):Boolean
	{
		if (o instanceof Identifiable)
		{
			return Identifiable(o).getID() == this.getID() ;			
		}
		else
		{
			return false ;
		}
	}

	/**
	 * Returns the id of the value object.
	 * @return the id of the value object.
	 */
	public function getID() 
	{
		return this.id ;
	}
	
	/**
	 * Sets the id of the value object.
	 */
	public function setID(id) : Void 
	{
		this.id = id ;		
	}

	/**
	 * Returns the {@code String} representation of this object.
	 * @return the {@code String} representation of this object.
	 */
	public function toString():String
	{
		return "[" + ConstructorUtil.getName(this) + " " + id + "]" ;
	}

}