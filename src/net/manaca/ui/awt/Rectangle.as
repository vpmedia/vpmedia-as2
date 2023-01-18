import net.manaca.lang.BObject;
import net.manaca.ui.awt.Dimension;
import net.manaca.ui.awt.Point;
import net.manaca.lang.IObject;

/**
 * Rectangle 指定了坐标空间中的一个区域，通过 Rectangle 对象的左上顶点的坐标（x，y）、宽度和高度可以定义这个区域。 
 * Rectangle 对象的 width 和 height 是 public 字段。创建 Rectangle 的构造方法，
 * 以及可以修改该对象的方法，都不会禁止将 width 或 height 设置为负值。 
 * @author Wersling
 * @version 1.0, 2006-4-6
 */
class net.manaca.ui.awt.Rectangle extends BObject {
	private var className : String = "net.manaca.ui.awt.Rectangle";
	private var _x:Number;
	private var _y:Number;
	private var _width:Number;
	private var _height:Number;
	private var _empty : Boolean;
	/**
	 * 构造一个Rectangle对象
	 */
	public function Rectangle(x:Number,y:Number,width:Number,height:Number) {
		super();
		if(x != undefined) setX(x); else setX(0);
		if(y != undefined) setY(y); else setY(0);
		if(width != undefined) setWidth(width); else setWidth(0);
		if(height != undefined) setHeight(height); else setHeight(0);
	}
	public function clone() : IObject
	{
		return new Rectangle(this.getX(),this.getY(),this.getWidth(),this.getHeight());
	}
	/**
	 * 检查此 Rectangle 是否包含指定位置的点（x，y）。
	 */
	public function contains(x:Number,y:Number):Boolean{
		return null;
	}
	
	/**
	 * 检查此 Rectangle 是否包含指定的 Point。
	 */
	public function containsByPoint(p:Point):Boolean{
		if(p.getX() < _x || p.getY() < _y || p.getX() > _x+_width || p.getY() > _y+_height){
			return false;
		}else{
			return true;
		}
	}
	
	/**
	 *  检查此 Rectangle 是否完整地包含指定的 Rectangle。
	 */
	public function containsByRectangle(r:Rectangle):Boolean{
		return null;
	}
	
	/**
	 * 获得此 Rectangle 的边界 Rectangle。
	 */
	public function getBounds():Rectangle{
		return new Rectangle(this.getX(),this.getY(),this.getWidth(),this.getHeight());
	}
	
	/**
	 * 获取高度值
	 * @return Number 高度值
	 */
	public function getHeight() :Number
	{
		return _height;
	}
	
	/**
	 * 返回此 Rectangle 的位置。
	 */
	public function getLocation():Point{
		return new Point(this.getX(),this.getY());
	}
	
	/**
	 * 获得此 Rectangle 的大小，用返回的 Dimension 表示。
	 */
	public function getSize():Dimension{
		return new Dimension(this.getWidth(),this.getHeight());
	}
	
	/**
	 * 获取宽度值
	 * @return Number 宽度值
	 */
	public function getWidth() :Number{
		return _width;
	}
	
	/**
	 * 获取X值
	 * @return Number X值
	 */
	public function getX() :Number{
		return _x;
	}
	
	/**
	 * 获取Y值
	 * @return Number Y值
	 */
	public function getY() :Number{
		return _y;
	}
	
	/**
	 * 确定此 Rectangle 是否为空。
	 */
	public function isEmpty():Boolean{
		return _empty;
	}
	
	/**
	 * 将此 Rectangle 移动到指定位置。
	 */
	public function setLocation(x:Number,y:Number):Void{
		setX(x);
		setY(y);
	}
	/**
	 * 将此 Rectangle 移动到指定位置。
	 */
	public function setLocationOfPoint(p:Point):Void{
		setX(p.getX());
		setY(p.getY());
	}
	
	/**
	 * 将此 Rectangle 的边界设置为指定的 x、y、width 和 height。
	 */
	public function setRect(x:Number,y:Number,width:Number,height:Number):Void{
		setLocation(x,y);
		setSize(width,height);
	}
	
	/**
	 * 将此 Rectangle 的大小设置为指定的宽度和高度。
	 */
	public function setSize(width:Number,height:Number):Void{
		setWidth(width);
		setHeight(height);
	}
	
	/**
	 * 设置此 Rectangle 的大小，以匹配指定的 Dimension。
	 */
	public function setSizeByDimension(d:Dimension):Void{
		setWidth(d.getWidth());
		setHeight(d.getHeight());
	}
	/**
	 * 设置X
	 * @param  value:Number - 要设置的X值
	 */
	public function setX(value:Number) :Void{
		if(value != undefined && value != null) _x = value;
	}

	/**
	 * 设置Y
	 * @param  value:Number - 要设置的Y值
	 */
	public function setY(value:Number) :Void{
		if(value != undefined && value != null)_y = value;
	}

	/**
	 * 设置宽度
	 * @param  value:Number - 要设置的宽度值
	 */
	public function setWidth(value:Number) :Void{
		_empty = (value > 0 ) ? false : true;
		_width = value;
	}

	/**
	 * 设置高度
	 * @param  value:Number - 要设置的高度值
	 */
	public function setHeight(value:Number) :Void{
		_empty = (value > 0 ) ? false : true;
		_height = value;
	}
	
	/**
	 * 将此 Rectangle 沿 x 坐标轴向右，沿 y 坐标轴向下移动指定距离。
	 * @param x:Number
	 * @param y:Number
	 */
	public function translate(x:Number,y:Number):Void{
		setWidth(getWidth() + x);
		setHeight(getHeight() + y);
	}
	
	/**
	 * 计算此 Rectangle 与指定 Rectangle 的并集。
	 * @param r:Rectangle
	 * @return Rectangle
	 */
	public function union(r:Rectangle):Rectangle{
		var x1:Number = Math.min(_x, r.getX());
		var x2:Number = Math.max(_x + _width, r.getX() + r.getWidth());
		var y1:Number = Math.min(_y, r.getY());
		var y2:Number = Math.max(_y + _height, r.getY() + r.getHeight());
		return new Rectangle(x1, y1, x2 - x1, y2 - y1);
	}
	
	public function toString():String{
		return "Rectangle - x: "+this.getX()+" y: "+this.getY()+" Width: "+this.getWidth()+" Height: "+this.getHeight();
	}

}