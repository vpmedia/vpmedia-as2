
import eka.colors.* ;

class eka.colors.TransformColor extends BasicColor {
	
	//  ------o Author Properties
	
	public static var className : String = "TransformColor" ;
	public static var classPackage : String = "eka.colors";
	public static var version : String = "1.0.0";
	public static var author : String = "niko|ekameleon";
	public static var link : String = "http://niko.informatif.org" ;
		
	//  ------o Constructor
	
	public function TransformColor (mc:MovieClip) { super (mc) }
	
	//  ------o Public Methods

	public function negative (n:Number):Void {
		setTransform ({ ra:-100, ga:-100, ba:-100, rb:255, gb:255, bb:255 });
	}

	public function addition (n:Number):Void {
		var o:Object = ColorRGB.hex2rgb(n)
		setTransform ( { rb:o.r , gb:o.g , bb:o.b });
	}
	
	public function substraction (n:Number):Void {
		var o:Object = ColorRGB.hex2rgb(n)
		setTransform ({ ra:-100, ga:-100, ba:-100, rb:o.r, gb:o.g, bb:o.b } );
	}
	
	public function difference (n:Number):Void {
		var o:Object = ColorRGB.hex2rgb(n) ;
		setTransform ( { rb:-o.r , gb:-o.g , bb:-o.b });
	}
	
	public function divide(n:Number):Void {
		var o:Object = ColorRGB.hex2rgb(n)
		setTransform ({ ra:_div(o.r) , ga:_div(o.g) , ba:_div(o.b) } );
	}
	
	public function multiply(n:Number):Void {
		var o:Object = ColorRGB.hex2rgb(n)
		setTransform ({ ra:o.r/2.55 , ga:o.g/2.55 , ba:o.b/2.55 });
	}
	
	public function linearDodge (n:Number):Void {
		var o:Object = ColorRGB.hex2rgb(n) ;
		setTransform ({ rb:o.r , gb:o.g, bb:o.b });
        }
	
	public function linearBurn (n:Number):Void {
		var o:Object = ColorRGB.hex2rgb(n) ;
		setTransform ({ rb:o.r-255 , gb:o.g-255, bb:o.b-255 });
	}
	
	public function colorDodge (n:Number):Void {
		var o:Object = ColorRGB.hex2rgb(n) ;
		setTransform ({ ra:_dodge(o.r) , ga:_dodge(o.g) , ba:_dodge(o.b) } );
	}
	
	public function screen (n:Number):Void {
		var o:Object = ColorRGB.hex2rgb(n)
		setTransform ({ ra:_scr(o.r), ga:_scr(o.g), ba:_scr(o.b), rb:o.r, gb:o.g, bb:o.b } );
	}
	
	//  ------o Private Methods
	
	private function _div(n:Number):Number {
		return 100/((n + 1)/256);
	}

	private function _dodge(n:Number):Number {
		return 100 / ((258 - n) / 256);
	}
	
	private function _scr(n:Number):Number {
		return 100 * (255 - n) / 255;
	}
	

}
