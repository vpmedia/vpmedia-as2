import net.manaca.ui.awt.Brush;
/**
 * 一个基于有渐变能力的比刷，基于beginGradientFill方法
 * @author Wersling
 * @version 1.0, 2006-5-13
 * @availability ActionScript 1.0；Flash Player 6
 */
class net.manaca.ui.awt.GradientBrush implements Brush{
	public static var LINEAR:String = "linear";
	public static var RADIAL:String = "radial";
	
	private var fillType:String;
	private var colors:Array;
	private var alphas:Array;
	private var ratios:Array;
	private var matrix:Object;
	private var spreadMethod : String;
	private var interpolationMethod : String;

	private var focalPointRatio : Number;
	/**
	 * 构造一个有渐变能力的比刷
	 * @param fillType:String - 有效值为字符串"linear"和字符串"radial"。
	 * @param colors:Array - 用于渐变色的 RGB 十六进制颜色值的数组；例如，红色为 0xFF0000，蓝色为 0x0000FF。可以至多指定 15 种颜色。对于每种颜色，请确保在 alphas 和 ratios 参数中指定对应值。
	 * @param alphas:Array - colors 数组中对应颜色的 Alpha 值数组；有效值为 0 到 100。如果值小于 0，则 Flash 使用 0。如果值大于 100，则 Flash 使用 100。
	 * @param ratios:Array - 颜色分布比率数组；有效值为 0 到 255。该值定义颜色采样率为 100% 之处的宽度百分比。为 colors 参数中的每个值指定一个值。
	 * @param matrix:Object - 可以是任意以下三种形式的转换矩阵：
	 * 					<li>matrix 对象（仅 Flash Player 8 和更高版本支持它），如 flash.geom.Matrix 类定义的那样。</il>
	 * 					<li>可以使用属性 a、b、c、d、e、f、g、h 和 i，这些属性可用于描述下列格式的 3 x 3 矩阵</il>
	 * 					<li>具有下列属性的对象：matrixType、x, y、w、h、r。如：<code>matrix = {matrixType:"box", x:100, y:100, w:200, h:200, r:(45/180)*Math.PI};</code></li>
	 * @param spreadMethod:String [可选] - 在 Flash Player 8 中添加。可以是"pad"、"reflect"或"repeat"，它控制渐变填充的模式。默认值为"pad"。
	 * @param interpolationMethod:String [可选] - 在 Flash Player 8 中添加。可以是"RGB"或"linearRGB"。如果使用"linearRGB"，则在渐变中以线性方式分布颜色。默认值为"RGB"。
	 * @param focalPointRatio:Number [optional] - 在 Flash Player 8 中添加。一个数字，控制渐变焦点的位置。值 0 表示焦点位于中心。值 1 表示焦点位于渐变圆的一条边界上。值 -1 表示焦点位于渐变圆的另一条边界上。小于 -1 或大于 1 的值将被舍入为 -1 或 1。
	 */
	public function GradientBrush(fillType:String, colors:Array, alphas:Array, ratios:Array, matrix:Object,spreadMethod:String,interpolationMethod:String,focalPointRatio:Number){
		this.fillType = fillType;
		this.colors = colors;
		this.alphas = alphas;
		this.ratios = ratios;
		this.matrix = matrix;
		if(spreadMethod) this.spreadMethod = spreadMethod;
		if(interpolationMethod) this.interpolationMethod = interpolationMethod;
		if(focalPointRatio) this.focalPointRatio = focalPointRatio;
	}
	
	public function getFillType():String{
		return fillType;
	}
	public function setFillType(t:String):Void{
		fillType = t;
	}
		
	public function getColors():Array{
		return colors;
	}
	public function setColors(cs:Array):Void{
		colors = cs;
	}
	
	public function getAlphas():Array{
		return alphas;
	}
	public function setAlphas(as:Array):Void{
		alphas = as;
	}
	
	public function getRatios():Array{
		return ratios;
	}
	public function setRatios(rs:Array):Void{
		ratios = rs;
	}
	
	public function getMatrix():Object{
		return matrix;
	}
	public function setMatrix(m:Object):Void{
		matrix = m;
	}
	
	public function beginFill(target:MovieClip):Void{
		target.beginGradientFill(fillType, colors, alphas, ratios, matrix,spreadMethod,interpolationMethod,focalPointRatio);
	}
	
	public function endFill(target:MovieClip):Void{
		target.endFill();
	}	
}
