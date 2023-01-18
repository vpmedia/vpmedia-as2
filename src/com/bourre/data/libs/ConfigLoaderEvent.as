import com.bourre.data.libs.ConfigLoader;
import com.bourre.data.libs.LibEvent;
import com.bourre.events.EventType;
import com.bourre.log.PixlibStringifier;

class com.bourre.data.libs.ConfigLoaderEvent 
	extends LibEvent 
{
	public function ConfigLoaderEvent( e : EventType, oLib : ConfigLoader ) 
	{
		super( e, oLib );
	}
	
	public function getLib() : ConfigLoader
	{
		return ConfigLoader( super.getLib() );
	}
	
	public function getConfig() : Object
	{
		return getLib().getConfig();
	}

	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
}