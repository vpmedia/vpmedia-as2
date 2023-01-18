 /**
 * 功能：扩张Color类，主要用于MC的颜色渐变
 * 使用：
 * 
 * @author Wersling
 * @version 1.0, 2005-8-29
 * @updatelist 2005-8-29, Wersling, 
*/
import mx.events.EventDispatcher;
import net.manaca.util.Delegate;
import net.manaca.lang.BObject;
import net.manaca.util.ArrayUtil;

class net.manaca.util.ColorUtil extends BObject {
	private var className : String = "net.manaca.util.ColorUtil";
	private var _time_out:Number;
	private var _target : MovieClip;
	private var _color : Color;
	private var _step_int : Number;
	public function ColorUtil (target : MovieClip)
	{
		_target = target;
		_color = new Color (_target);
	}
	/**
	*=============================================
	* 函数：setRGB (RGB : Number)
	* 参数：1.RGB ：十六位颜色值；
	* 说明：设置mc颜色
	* =============================================
	* */
	public function setRGB (RGB : Number):Void
	{
		if ( ! isNaN (RGB) || RGB < 0xFFFFFF || RGB > 0)
		{
			_color.setRGB (RGB);
		}
	}
	/**
	*=============================================
	* 函数：setChangeRGB (RGB : Number, step_int : Number, Nom : Number)
	* 参数：1.RGB ：新的颜色值；
	*		2.step_int ：操作步骤；
	* 		3.Nom ：可选，触发监听的一个值；
	* 说明：将MC的颜色渐变到另一个颜色。
	* =============================================
	* */
	public function setChangeRGB (RGB : Number, all_step : Number):Void
	{
		clearInterval (_time_out);
		_step_int = 0;
		var r:Number = _color.getRGB();
		var f:Function = Delegate.create (this, changeColor);
		_time_out = setInterval(f,25,r,RGB,all_step);
	}
	/**
	*=============================================
	* 函数：changeColor(newCol : Array, delCol : Array)
	* 参数：1.newCol ：新的颜色值；
	*		2.delCol ：每次增加的颜色值；
	* 说明：无
	* =============================================
	* */
	private function changeColor (newCol : Number, endCol : Number,all_step:Number):Void{
		_step_int ++;
		if(_step_int > all_step){
			clearInterval (_time_out);
		}else{
			_color.setRGB(rgsGradual(newCol,endCol,_step_int/all_step));
		}
	}
	/**
	*=============================================
	* 函数：getColArray (RGB : Number)
	* 参数：1.RGB ：十六位颜色值；
	* 说明：将一个RGB分别存放在一个数组中
	* =============================================
	* */
	private function getColArray (RGB : Number) : Array
	{
		var _A = new Array();
		_A [0] = Math.floor (RGB / 65536);
		_A [1] = Math.floor (RGB % 65536 / 256);
		_A [2] = RGB % 256;
		return _A;
	}
	
	/**
	 *  Performs a linear brightness adjustment of an RGB color.
	 *
	 *  <p>The same amount is added to the red, green, and blue channels
	 *  of an RGB color.
	 *  Each color channel is limited to the range 0 through 255.
	 *
	 *  @param rgb Original RGB color.
	 *
	 *  @param brite Amount to be added to each color channel.
	 *  The range for this parameter is -255 to 255;
	 *  -255 produces black while 255 produces white.
	 *  If this parameter is 0, the RGB color returned
	 *  is the same as the original color.
	 *
	 *  @return Brightened RGB color.
	 *  @review
	 */
	public static function adjustBrightness(rgb:Number, brite:Number):Number
	{
		var r:Number = Math.max(Math.min(((rgb >> 16) & 0xFF) + brite, 255), 0);
		var g:Number = Math.max(Math.min(((rgb >> 8) & 0xFF) + brite, 255), 0);
		var b:Number = Math.max(Math.min((rgb & 0xFF) + brite, 255), 0);
		
		return (r << 16) | (g << 8) | b;
	}
	
	/**
	 * 获取指定系数的饱和度数组
	 */
	public static function adjustDesaturate(brite:Number):Array
	{
		var grayluma:Array = [.3, .59, .11, 0, 0];

		var redIdentity		= [1, 0, 0, 0, 0];
		var greenIdentity	= [0, 1, 0, 0, 0];
		var blueIdentity	= [0, 0, 1, 0, 0];
		var alphaIdentity	= [0, 0, 0, 1, 0];
		
		var colmatrix:Array = new Array();
		colmatrix = colmatrix.concat( ArrayUtil.interpolateArrays(grayluma,	redIdentity,	brite) );
		colmatrix = colmatrix.concat( ArrayUtil.interpolateArrays(grayluma,	greenIdentity,	brite) );
		colmatrix = colmatrix.concat( ArrayUtil.interpolateArrays(grayluma,	blueIdentity,	brite) );
		colmatrix = colmatrix.concat( alphaIdentity ); // alpha not affected
		return colmatrix;
	} 

	/**
	 *  Performs a scaled brightness adjustment of an RGB color.
	 *
	 *  @param rgb Original RGB color.
	 *
	 *  @param brite The percentage to brighten or darken the original color.
	 *  If positive, the original color is brightened toward white
	 *  by this percentage; if negative, it is darkened toward black
	 *  by this percentage.
	 *  The range for this parameter is -100 to 100;
	 *  -100 produces black while 100 produces white.
	 *  If this parameter is 0, the RGB color returned
	 *  is the same as the original color.
	 *
	 *  @return Brightened RGB color.
	 *  @review
	 */
	public static function adjustBrightness2(rgb:Number, brite:Number):Number
	{
		var r:Number;
		var g:Number;
		var b:Number;
		
		if (brite == 0)
			return rgb;
		
		if (brite < 0)
		{
			brite = (100 + brite) / 100;
			r = ((rgb >> 16) & 0xFF) * brite;
			g = ((rgb >> 8) & 0xFF) * brite;
			b = (rgb & 0xFF) * brite;
		}
		else // bright > 0
		{
			brite /= 100;
			r = ((rgb >> 16) & 0xFF);
			g = ((rgb >> 8) & 0xFF);
			b = (rgb & 0xFF);
			
			r += ((0xFF - r) * brite);
			g += ((0xFF - g) * brite);
			b += ((0xFF - b) * brite);
			
			r = Math.min(r, 255);
			g = Math.min(g, 255);
			b = Math.min(b, 255);
		}
	
		return (r << 16) | (g << 8) | b;
	}

	/**
	 *  Performs an RGB multiplication of two RGB colors.
	 *  
	 *  <p>This always results in a darker number than either
	 *  original color unless one of them is white,
	 *  in which case the other one is returned.</p>
	 *
	 *  @param rgb1 First RGB color to use in RGB multiplication.
	 *
	 *  @param rgb2 Second RGB color to use in RGB multiplication.
	 *
	 *  @return RGB multiplication of the two colors.
	 *  @review
	 */
	public static function rgbMultiply(rgb1:Number, rgb2:Number):Number
	{
		var r1:Number = (rgb1 >> 16) & 0xFF;
		var g1:Number = (rgb1 >> 8) & 0xFF;
		var b1:Number = rgb1 & 0xFF;
		
		var r2:Number = (rgb2 >> 16) & 0xFF;
		var g2:Number = (rgb2 >> 8) & 0xFF;
		var b2:Number = rgb2 & 0xFF;
		
		return ((r1 * r2 / 255) << 16) |
			   ((g1 * g2 / 255) << 8) |
			    (b1 * b2 / 255);
	}
	
	/**
	 * 按照指定系数，将一个颜色转为另一个颜色
	 */
	public static function rgsGradual(rgb1:Number, rgb2:Number,t:Number):Number{
		var r1:Number = (rgb1 >> 16) & 0xFF;
		var g1:Number = (rgb1 >> 8) & 0xFF;
		var b1:Number = rgb1 & 0xFF;
		
		var r2:Number = (rgb2 >> 16) & 0xFF;
		var g2:Number = (rgb2 >> 8) & 0xFF;
		var b2:Number = rgb2 & 0xFF;
		var a:Array  = ArrayUtil.interpolateArrays([r1,g1,b1],[r2,g2,b2],t);
		return (a[0] << 16) |
			   (a[1] << 8) |
			    a[2];
	}
}
