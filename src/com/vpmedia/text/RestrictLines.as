/**
* @author Chris Hill
*/
import ascb.util.Proxy;
class com.vpmedia.text.RestrictLines {
	public static function decorate (tf:TextField, maxLines:Number) {
		if (tf.onChanged != null) {
			tf["__oldOnChanged"] = tf.onChanged;
		}
		tf.onChanged = Proxy.create (RestrictLines, onChanged, maxLines);
	}
	public static function onChanged (tf:TextField, maxLines:Number) {
		//execute old function
		tf["__oldOnChanged"] ();
		if (tf.bottomScroll > maxLines) {
			//reset to last known good size
			tf.text = tf["__oldText"];
		}
		//save the text  
		tf["__oldText"] = tf.text;
	}
}
