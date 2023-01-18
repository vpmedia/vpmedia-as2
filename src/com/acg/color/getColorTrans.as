
/**
* 컬러변경 클래스 <br>
* com.acg.color.colorUtil의 유틸리티 클래스입니다.
* @author 홍준수
* @date 2007.06.01
*/

class com.acg.color.getColorTrans {
	
	/**
	* 밝기변경 메소드
	* @param amt 변경치(0~100)
	* @return Object	
	*/
	
	public static function brightness(amt:Number) {
		var num1 = 100 - Math.abs(amt);
		var num2 = 0;
		if (amt > 0) {
			num2 = 256 * (amt / 100);
		} 
		return ({ra: num1, rb: num2, ga: num1, gb: num2, ba: num1, bb: num2});
	}
	
	/**
	* 밝기변경 메소드
	* @param amt 변경치(0~100)
	* @return Object	
	*/

	public static function brightOffset(amt:Number) {
		var num2 = 256 * (amt / 100);
		return ({ra: 100, rb: num2, ga: 100, gb: num2, ba: 100, bb: num2});
	}
	
	/**
	* 컨트라스트 변경 메소드
	* @param amt 변경치(0~100)
	* @return Object
	*/
	
	public static function contrast(amt:Number) {
		var returnTransform = {};
		returnTransform.ra = returnTransform.ga = returnTransform.ba = amt;
		returnTransform.rb = returnTransform.gb = returnTransform.bb = 128 - 1.280000E+000 * amt;
		return (returnTransform);
	}
	
	/**
	* tint변경 메소드
	* @param rgb 타겟 RGB
	* @param amt 변경치(0~100)
	*/
	
	public static function tint(rgb:Number , amt:Number) {
		if (rgb == undefined || rgb == null) {
			return;
		}
		var rr = rgb >> 16;
		var gg = rgb >> 8 & 255;
		var bb = rgb & 255;
		var amount = amt / 100;
		var returnTransform = {rb: rr * amount, gb: gg * amount, bb: bb * amount};
		returnTransform.ra = returnTransform.ga = returnTransform.ba = 100 - amt;
		return (returnTransform);
	}
}
