import ch.sfug.widget.BaseWidget;
/**
 * a class that creates an instance of a BaseWidget or subclass of it depending on the position and size of a placeholder movieclip
 * @author loop
 */
class ch.sfug.utils.mc.PlaceholderFactory {

	/**
	 * returns the instance of the Widget with a emptymovieclip at the same place and with sdame width and height as the placeholder
	 */
	public static function build( mc:MovieClip, clas:Function ):BaseWidget {

		var nmc:MovieClip = mc._parent.createEmptyMovieClip( mc._name + "_builded", 100 );
		var inst:BaseWidget = new clas( nmc );
		inst.move( mc._x, mc._y );
		inst.height = mc._height;
		inst.width = mc._width;
		mc.swapDepths( 100 );
		mc.removeMovieClip();

		return inst;
	}

}