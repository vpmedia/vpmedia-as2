import gugga.common.BaseEnum;

/**
 * @author ivo
 */
class gugga.common.MediaTypes extends BaseEnum 
{
	public var Mp3:MediaTypes = new MediaTypes("MP3", 0);
	public var Flv:MediaTypes = new MediaTypes("FLV", 1);
	
	public function MediaTypes(aName:String, aOrderIndex:Number)
	{
		mName = aName;
		mOrderIndex = aOrderIndex;
	}
}