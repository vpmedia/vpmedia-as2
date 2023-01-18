import com.bourre.log.PixlibStringifier;
import com.bourre.structures.Rectangle;
import com.bourre.utils.Geom;
import com.bourre.visual.MovieClipHelper;

class com.bourre.visual.ScreenProtectionUI 
	extends MovieClipHelper
{

	public static var DEFAULT_ID : String = "ScreenProtectionUI";
	public static var DEFAULT_DEPTH : Number = 9996;
	
	public function ScreenProtectionUI ( target : MovieClip, depth : Number, id : String, settings : Rectangle )
	{
		super( id?id:ScreenProtectionUI.DEFAULT_ID, target? target:_level0 );
		
		var w : Number = settings.width ? settings.width : Stage.width;		var h : Number = settings.height ? settings.width : Stage.height;		var x : Number = settings.x ? settings.x : 0;		var y : Number = settings.y ? settings.y : 0;

		view = Geom.buildRectangle( view, depth?depth:ScreenProtectionUI.DEFAULT_DEPTH, w, h );
		view._alpha = 0;
		move( x, y );
		view.onPress = new Function();
		view.useHandCursor = false;
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