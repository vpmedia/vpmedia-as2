import TextField.StyleSheet;

/**
 * 增强的样式表
 * @author Wersling
 * @version 1.0, 2006-5-30
 */
class net.manaca.text.css.SwellStyleSheet extends StyleSheet {
	private var className : String = "net.manaca.text.css.SwellStyleSheet";
	function SwellStyleSheet() {
		super();
	}
	public function transform(styleObject):TextFormat {
        trace("tranform called");
        return null;
    }
	
}