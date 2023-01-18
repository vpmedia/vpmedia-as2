

/**
 * Cette classe est une enum�ration utilis� par certain layout
 */
class com.liguo.layout.Align {
				
	public static var className:String = "Align";
	public static var classPackage:String = "com.liguo.layout";
	public static var version:String = "0.2.0";
	public static var author:String = "Nicolas D�sy (liguorien)";
	public static var link:String = "http://www.liguorien.com";
		
	/**
	 * utilis� pour l'alignement horizontal
	 */
	public static var LEFT:Align = new Align(0);
	
	/**
	 * utilis� pour l'alignement horizontal
	 */
	public static var CENTER:Align = new Align(0.5);
	
	/**
	 * utilis� pour l'alignement horizontal
	 */
	public static var RIGHT:Align = new Align(1);
			
	/**
	 * utilis� pour l'alignement vertical
	 */
	public static var TOP:Align = new Align(0);
	
	/**
	 * utilis� pour l'alignement vertical
	 */
	public static var MIDDLE:Align = new Align(0.5);
	
	/**
	 * utilis� pour l'alignement vertical
	 */
	public static var BOTTOM:Align = new Align(1);	
	
	
	/**
	 *contient la valeur de l'alignement
	 */
	private var _value:Number;
	
	
	
	/**
	 *@constructor
	 */
	private function Align(value:Number){
		_value = value;
	}	
	
	/**
	 *calcule l'alignement pour une certaine dimension
	 *@param size:Number La dimension
	 *@return la position
	 */
	public function getPosition(size:Number) : Number{
		return size * _value;
	}
}
