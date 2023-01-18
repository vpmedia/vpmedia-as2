import net.manaca.ui.controls.skin.mnc.AbstractSkin;
import net.manaca.ui.awt.Graphics;
import net.manaca.ui.awt.Pen;
/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-31
 */
class net.manaca.ui.controls.skin.mnc.IconSkin extends AbstractSkin{
	private var className : String = "net.manaca.ui.controls.skin.mnc.IconSkin";
	public function IconSkin(){
		super();
	}
	/**
	 * 绘制一个最小化图标
	 */
	public function drawMinIcon(mc:MovieClip,color:Number,width:Number, height:Number):Void{
		this.drawfillRectangle(mc,color,0,0,width,height,0);
		this.drawfillRectangle(mc,color,1,height-3,width-3,2,100);
	}
	/**
	 * 绘制一个最大化图标
	 */
	public function drawMaxIcon(mc:MovieClip,color:Number,width:Number, height:Number):Void{
		this.drawfillRectangle(mc,color,0,0,width,height,0);
		var _g:Graphics = new Graphics(mc);
		_solidBrush.setColor(color);
		_solidBrush.setAlpha(100);
		_g.fillRectangleRing(_solidBrush,width/2+1,height/2-1,width-2,height-4,width-4,height-6);
		_g.fillRectangleRing(_solidBrush,width/2-1,height/2+2,width-2,height-4,width-4,height-6);
	}
	/**
	 * 绘制一个关闭图标
	 */
	public function drawCloseIcon(mc:MovieClip,color:Number,width:Number, height:Number):Void{
		this.drawfillRectangle(mc,color,0,0,width,height,0);
		var _g:Graphics = new Graphics(mc);
		_g.drawLine(new Pen(color,2,100),2,2,width-2,height-2);
		_g.drawLine(new Pen(color,2,100),2,height-2,width-2,2);
	}
	
	/**
	 * 向下的箭头
	 */
	public function drawBottomIcon(mc:MovieClip,color:Number,width:Number, height:Number):Void{
		this.drawfillRectangle(mc,color,0,0,width,height,0);
		var _g:Graphics = new Graphics(mc);
		_solidBrush.setColor(color);
		_solidBrush.setAlpha(100);
		_g.fillPolygon(_solidBrush,[{x:0,y:0},{x:width,y:0},{x:width/2,y:height}]);
	}
	/**
	 * 向上的箭头
	 */
	public function drawTopIcon(mc:MovieClip,color:Number,width:Number, height:Number):Void{
		this.drawfillRectangle(mc,color,0,0,width,height,0);
		var _g:Graphics = new Graphics(mc);
		_solidBrush.setColor(color);
		_solidBrush.setAlpha(100);
		_g.fillPolygon(_solidBrush,[{x:width/2,y:0},{x:0,y:height},{x:width,y:height}]);
	}
	/**
	 * 向左的箭头
	 */
	public function drawLeftIcon(mc:MovieClip,color:Number,width:Number, height:Number):Void{
		this.drawfillRectangle(mc,color,0,0,width,height,0);
		var _g:Graphics = new Graphics(mc);
		_solidBrush.setColor(color);
		_solidBrush.setAlpha(100);
		_g.fillPolygon(_solidBrush,[{x:0,y:height/2},{x:width,y:0},{x:width,y:height}]);
	}
	/**
	 * 向右的箭头
	 */
	public function drawRigthIcon(mc:MovieClip,color:Number,width:Number, height:Number):Void{
		this.drawfillRectangle(mc,color,0,0,width,height,0);
		var _g:Graphics = new Graphics(mc);
		_solidBrush.setColor(color);
		_solidBrush.setAlpha(100);
		_g.fillPolygon(_solidBrush,[{x:0,y:0},{x:width,y:height/2},{x:0,y:height}]);
	}
}