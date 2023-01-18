/*
 Copyright aswing.org, see the LICENCE.txt.
*/
 
import net.manaca.ui.awt.Brush;
import net.manaca.ui.awt.Pen;
 
/**
 * Graphics, use to paint graphics contexts on a MovieClip.
 * @author iiley
 */
class net.manaca.ui.awt.Graphics {
	private var className : String = "net.manaca.ui.awt.Graphics";
	private var target_mc:MovieClip;
	
	/**
	 * 构造一个 Graphics 拥有一个MovieClip目标
	 * Create a graphics with target MovieClip.
	 * @param target_mc where the graphics contexts will be paint on.
	 * 			所有图型都绘制在 target_mc 上 
	 */
	public function Graphics(target_mc:MovieClip){
		this.target_mc = target_mc;
	}
	
	/**
	 * 设置一个目标MovieClip
	 * @param 
	 */
	private function setTarget(target_mc:MovieClip):Void{
		this.target_mc = target_mc;
	}
	
	/**
	 * 清除
	 */
	private function dispose():Void{
		target_mc = null;
	}
	
	private function startPen(p:Pen):Void{
		p.setTo(target_mc);
	}

	private function endPen():Void{
		target_mc.lineStyle();
		target_mc.moveTo(0, 0); //avoid a drawing error
	}
	
	private function startBrush(b:Brush):Void{
		b.beginFill(target_mc);
	}
	
	private function endBrush():Void{
		target_mc.moveTo(0, 0); //avoid a drawing error
	}
	
	//-------------------------------Public Functions-------------------
	/**
	 * Clears the graphics contexts drawn on the target MovieClip.
	 * 清除绘制的内容
	 */
	public function clear():Void {
		if(target_mc!=undefined) target_mc.clear();
	}
	
	/**
	 * 绘制一条线
	 * Draws a line. 
	 * 
	 * Examples:
	 *	_g = new Graphics(this);
		 _g.drawLine(new Pen(new ASColor(0x3300ff,50),1,100),10,10,100,10);
	 * 
	 * Between the points (x1, y1) and (x2, y2) in the target MovieClip. 
	 * @param p the pen to draw
	 * @param x1 the x corrdinate of the first point.
	 * @param y1 the y corrdinate of the first point.
	 * @param x2 the x corrdinate of the sencod point.
	 * @param y2 the y corrdinate of the sencod point.
	 */
	public function drawLine(p:Pen, x1:Number, y1:Number, x2:Number, y2:Number):Void {
		startPen(p);
		target_mc.moveTo(x1, y1);
		target_mc.lineTo(x2, y2);
		//target_mc.lineTo(x1, y1);//line back to avoid a flash player bug
		endPen();
	}
	
	/**
	 * 绘制一个 多边型
	 * Draws a polygon.
	 * Start with the points[0] and end of the points[0] as a closed path. 
	 * 
	 * @param p the pen to draw
	 * @param points the Array contains all vertex points in the polygon.
	 */
	public function drawPolygon(p:Pen, points:Array):Void{
		startPen(p);
		polygon(points);
		endPen();
	}
	
	/**
	 * 绘制一个具有填充 多边型
	 * Fills a polygon.
	 * Start with the points[0] and end of the points[0] as a closed path. 
	 * 
	 * @param b the brush to fill.
	 * @param points the Array contains all vertex points in the polygon.
	 */	
	public function fillPolygon(b:Brush, points:Array):Void{
		startBrush(b);
		polygon(points);
		endBrush();
	}
	
	/**
	 * 绘制一个具有填充的 环状多边型
	 * Fills a polygon ring.
	 * @param b the brush to fill.
	 * @param points1 the first polygon's points.
	 * @param points2 the second polygon's points.
	 */
	public function fillPolygonRing(b:Brush, points1:Array, points2:Array):Void{
		startBrush(b);
		polygon(points1);
		polygon(points2);
		endBrush();
	}
	
	/**
	 * 绘制一个 矩形
	 * Draws a rectange.
	 * @param pen the pen to draw.
	 * @param x the left top the rectange bounds' x corrdinate.
	 * @param y the left top the rectange bounds' y corrdinate.
	 * @param w the width of rectange bounds.
	 * @param h the height of rectange bounds.
	 */
	public function drawRectangle(pen:Pen, x:Number, y:Number, w:Number, h:Number):Void {
		this.startPen(pen);
		this.rectangle(x, y, w, h);
		this.endPen();
	}
	
	/**
	 * 绘制一个具有填充的 矩形
	 * Fills a rectange.
	 * @param brush the brush to fill.
	 * @param x the left top the rectange bounds' x corrdinate.
	 * @param y the left top the rectange bounds' y corrdinate.
	 * @param w the width of rectange bounds.
	 * @param h the height of rectange bounds.
	 */	
	public function fillRectangle(brush:Brush, x:Number, y:Number, width:Number, height:Number):Void{
		startBrush(brush);
		rectangle(x,y,width,height);
		endBrush();
	}
	
	/**
	 * 绘制一个具有填充的 环状矩形
	 * Fills a rectange ring.
	 * @param brush the brush to fill.
	 * @param cx the center of the ring's x corrdinate.
	 * @param cy the center of the ring's y corrdinate.
	 * @param w1 the first rectange's width.
	 * @param h1 the first rectange's height.
	 * @param w2 the second rectange's width.
	 * @param h2 the second rectange's height.
	 */	
	public function fillRectangleRing(brush:Brush, cx:Number, cy:Number, w1:Number, h1:Number, w2:Number, h2:Number):Void{
		startBrush(brush);
		rectangle(cx-w1/2, cy-h1/2, w1, h1);
		rectangle(cx-w2/2, cy-h2/2, w2, h2);
		endBrush();
	}
	
	/**
	 * 绘制一个具有填充的 具有指定厚度的 环状矩形
	 * Fills a rectange ring with specified thickness.
	 * @param brush the brush to fill.
	 * @param x the left top the ring bounds' x corrdinate.
	 * @param y the left top the ring bounds' y corrdinate.
	 * @param w the width of ring periphery bounds.
	 * @param h the height of ring periphery bounds.
	 * @param t the thickness of the ring.
	 */
	public function fillRectangleRingWithThickness(brush:Brush, x:Number, y:Number, w:Number, h:Number, t:Number):Void{
		startBrush(brush);
		rectangle(x, y, w, h);
		rectangle(x+t, y+t, w - t*2, h - t*2);
		endBrush();
	}	
	
	/**
	 * 绘制一个 圆
	 * Draws a circle.
	 * @param p the pen to draw.
	 * @param cx the center of the circle's x corrdinate.
	 * @param cy the center of the circle's y corrdinate.
	 * @param radius the radius of the circle.
	 */
	public function drawCircle(p:Pen, cx:Number, cy:Number, radius:Number):Void{
		startPen(p);
		circle(cx, cy, radius);
		endPen();		
	}
	
	/**
	 * 绘制一个具有填充的 圆
	 * Fills a circle.
	 * @param b the brush to draw.
	 * @param cx the center of the circle's x corrdinate.
	 * @param cy the center of the circle's y corrdinate.
	 * @param radius the radius of the circle.
	 */
	public function fillCircle(b:Brush, cx:Number, cy:Number, radius:Number):Void{
		startBrush(b);
		circle(cx, cy, radius);
		endBrush();
	}
	
	/**
	 * 绘制一个具有填充的 圆环
	 * Fills a circle ring.
	 * @param b the brush to draw.
	 * @param cx the center of the ring's x corrdinate.
	 * @param cy the center of the ring's y corrdinate.
	 * @param r1 the first circle radius.
	 * @param r2 the second circle radius.
	 */
	public function fillCircleRing(b:Brush, cx:Number, cy:Number, r1:Number, r2:Number):Void{
		startBrush(b);
		circle(cx, cy, r1);
		circle(cx, cy, r2);
		endBrush();
	}
	
	/**
	 * 绘制一个具有填充的和指定厚度 圆环
	 * Fills a circle ring with specified thickness.
	 * @param b the brush to draw.
	 * @param cx the center of the ring's x corrdinate.
	 * @param cy the center of the ring's y corrdinate.
	 * @param r the radius of circle periphery.
	 * @param t the thickness of the ring.
	 */
	public function fillCircleRingWithThickness(b:Brush, cx:Number, cy:Number, r:Number, t:Number):Void{
		startBrush(b);
		circle(cx, cy, r);
		r -= t;
		circle(cx, cy, r);
		endBrush();
	}
	
	/**
	 * 绘制一个 椭圆
	 * Draws a ellipse.
	 * @param brush the brush to fill.
	 * @param x the left top the ellipse bounds' x corrdinate.
	 * @param y the left top the ellipse bounds' y corrdinate.
	 * @param w the width of ellipse bounds.
	 * @param h the height of ellipse bounds.
	 */	
	public function drawEllipse(p:Pen, x:Number, y:Number, width:Number, height:Number):Void{
		startPen(p);
		ellipse(x, y, width, height);
		endPen();
	}
	
	/**
	 * 绘制一个具有填充 椭圆
	 * Fills a rectange.
	 * @param brush the brush to fill.
	 * @param x the left top the ellipse bounds' x corrdinate.
	 * @param y the left top the ellipse bounds' y corrdinate.
	 * @param w the width of ellipse bounds.
	 * @param h the height of ellipse bounds.
	 */		
	public function fillEllipse(b:Brush, x:Number, y:Number, width:Number, height:Number):Void{
		startBrush(b);
		ellipse(x, y, width, height);
		endBrush();
	}
	
	/**
	 * 绘制一个具有填充 环状椭圆
	 * Fill a ellipse ring.
	 * @param brush the brush to fill.
	 * @param cx the center of the ring's x corrdinate.
	 * @param cy the center of the ring's y corrdinate.
	 * @param w1 the first eclipse's width.
	 * @param h1 the first eclipse's height.
	 * @param w2 the second eclipse's width.
	 * @param h2 the second eclipse's height.
	 */
	public function fillEllipseRing(brush:Brush, cx:Number, cy:Number, w1:Number, h1:Number, w2:Number, h2:Number):Void{
		startBrush(brush);
		ellipse(cx-w1/2, cy-h1/2, w1, h1);
		ellipse(cx-w2/2, cy-h2/2, w2, h2);
		endBrush();
	}
	
	/**
	 * 绘制一个具有指定厚度 环状椭圆
	 * Fill a ellipse ring with specified thickness.
	 * @param brush the brush to fill.
	 * @param x the left top the ring bounds' x corrdinate.
	 * @param y the left top the ring bounds' y corrdinate.
	 * @param w the width of ellipse periphery bounds.
	 * @param h the height of ellipse periphery bounds.
	 * @param t the thickness of the ring.
	 */
	public function fillEllipseRingWithThickness(brush:Brush, x:Number, y:Number, w:Number, h:Number, t:Number):Void{
		startBrush(brush);
		ellipse(x, y, w, h);
		ellipse(x+t, y+t, w-t*2, h-t*2);
		endBrush();
	}	
	
	/**
	 * 绘制一个圆角矩形
	 * Draws a round rectangle.
	 * @param pen the pen to draw.
	 * @param x the left top the rectangle bounds' x corrdinate.
	 * @param y the left top the rectangle bounds' y corrdinate.
	 * @param width the width of rectangle bounds.
	 * @param height the height of rectangle bounds.
	 * @param radius the top left corner's round radius.左上角 圆弧半径
	 * @param trR the top right corner's round radius. 右上角 圆弧半径(miss this param default to same as radius)
	 * @param blR the bottom left corner's round radius. 左下角 圆弧半径(miss this param default to same as radius)
	 * @param brR the bottom right corner's round radius. 右下角 圆弧半径(miss this param default to same as radius)
	 */
	public function drawRoundRect(pen:Pen, x:Number, y:Number, width:Number, height:Number, radius:Number, trR:Number, blR:Number, brR:Number):Void{
		startPen(pen);
		roundRect(x, y, width, height, radius, trR, blR, brR);
		endPen();
	}
	
	/**
	 * 绘制一个具有填充 圆角矩形
	 * Fills a round rectangle.
	 * @param brush the brush to fill.
	 * @param x the left top the rectangle bounds' x corrdinate.
	 * @param y the left top the rectangle bounds' y corrdinate.
	 * @param width the width of rectangle bounds.
	 * @param height the height of rectangle bounds.
	 * @param radius the top left corner's round radius.左上角 圆弧半径
	 * @param trR the top right corner's round radius. 右上角 圆弧半径(miss this param default to same as radius)
	 * @param blR the bottom left corner's round radius.左下角 圆弧半径 (miss this param default to same as radius)
	 * @param brR the bottom right corner's round radius. 右下角 圆弧半径(miss this param default to same as radius)
	 */	
	public function fillRoundRect(brush:Brush, x:Number, y:Number, width:Number, height:Number, radius:Number, trR:Number, blR:Number, brR:Number):Void{
		startBrush(brush);
		roundRect(x,y,width,height,radius,trR,blR,brR);
		endBrush();
	}
	
	/**
	 * 绘制一个具有填充 圆角矩形
	 * Fill a round rect ring.
	 * @param brush the brush to fill
	 * @param cx the center of the ring's x corrdinate
	 * @param cy the center of the ring's y corrdinate
	 * @param w1 the first round rect's width 外圆宽
	 * @param h1 the first round rect's height 外圆高
	 * @param r1 the first round rect's round radius 外圆半径
	 * @param w2 the second round rect's width 内圆宽
	 * @param h2 the second round rect's height 内圆高
	 * @param r2 the second round rect's round radius 内圆半径
	 */	
	public function fillRoundRectRing(brush:Brush,cx:Number,cy:Number,w1:Number,h1:Number,r1:Number, w2:Number, h2:Number, r2:Number):Void{
		startBrush(brush);
		roundRect(cx-w1/2, cy-h1/2, w1, h1, r1);
		roundRect(cx-w2/2, cy-h2/2, w2, h2, r2);
		endBrush();
	}
	
	/**
	 * 绘制一个具有填充和指定厚度 圆角矩形
	 * Fill a round rect ring with specified thickness.
	 * @param brush the brush to fill
	 * @param x the left top the ring bounds' x corrdinate
	 * @param y the left top the ring bounds' y corrdinate
	 * @param w the width of ring periphery bounds
	 * @param h the height of ring periphery bounds
	 * @param r the round radius of the round rect 外圆半径
	 * @param t the thickness of the ring 厚度
	 * @param ir the inboard round radius, default is <code>r-t</code> 内圆半径
	 */	
	public function fillRoundRectRingWithThickness(brush:Brush, x:Number, y:Number, w:Number, h:Number, r:Number, t:Number, ir:Number):Void{
		startBrush(brush);
		roundRect(x, y, w, h, r);
		if(ir == undefined) ir = r - t;
		roundRect(x+t, y+t, w-t*2, h-t*2, ir);
		endBrush();
	}	
	
	public function beginFill(brush:Brush):Void{
		startBrush(brush);
	}
	public function endFill():Void{
		endBrush();
		target_mc.moveTo(0, 0); //avoid a drawing error
	}
	public function beginDraw(pen:Pen):Void{
		startPen(pen);
	}
	public function endDraw():Void{
		endPen();
		target_mc.moveTo(0, 0); //avoid a drawing error
	}
	public function moveTo(x:Number, y:Number):Void{
		target_mc.moveTo(x, y);
	}
	public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):Void{
		target_mc.curveTo(controlX, controlY, anchorX, anchorY);
	}
	public function lineTo(x:Number, y:Number):Void{
		target_mc.lineTo(x, y);
	}
	
	//---------------------------------------------------------------------------
	
	/**
	 * Paths a polygon.
	 * @see #drawPolygon()
	 * @see #fillPolygon()
	 */
	public function polygon(points:Array):Void{
		target_mc.moveTo(points[0].x, points[0].y);
		for(var i:Number=1; i<points.length; i++){
			target_mc.lineTo(points[i].x, points[i].y);
		}
		target_mc.lineTo(points[0].x, points[0].y);
	}
	
	/**
	 * Paths a rectangle.
	 * @see #drawRectangle()
	 * @see #fillRectangle()
	 */
	public function rectangle(x:Number,y:Number,width:Number,height:Number):Void{
		target_mc.moveTo(x, y);
		target_mc.lineTo(x+width,y);
		target_mc.lineTo(x+width,y+height);
		target_mc.lineTo(x,y+height);
		target_mc.lineTo(x,y);
	}
	
	/**
	 * Paths a ellipse.
	 * @see #drawEllipse()
	 * @see #fillEllipse()
	 */
	public function ellipse(x:Number, y:Number, width:Number, height:Number):Void{
		var pi:Number = Math.PI;
        var xradius:Number = width/2;
        var yradius:Number = height/ 2;
        var cx:Number = x + xradius;
        var cy:Number = y + yradius;
        target_mc.moveTo(xradius + cx, 0 + cy);
        target_mc.curveTo(xradius + cx, (yradius * Math.tan(pi / 8)) + cy, (xradius * Math.cos(pi / 4)) + cx, (yradius * Math.sin(pi / 4)) + cy);
        target_mc.curveTo((xradius * Math.tan(pi / 8)) + cx, yradius + cy, 0 + cx, yradius + cy);
        target_mc.curveTo(((-xradius) * Math.tan(pi / 8)) + cx, yradius + cy, ((-xradius) * Math.cos(pi / 4)) + cx, (yradius * Math.sin(pi / 4)) + cy);
        target_mc.curveTo((-xradius) + cx, (yradius * Math.tan(pi / 8)) + cy, (-xradius) + cx, 0 + cy);
        target_mc.curveTo((-xradius) + cx, ((-yradius) * Math.tan(pi / 8)) + cy, ((-xradius) * Math.cos(pi / 4)) + cx, ((-yradius) * Math.sin(pi / 4)) + cy);
        target_mc.curveTo(((-xradius) * Math.tan(pi / 8)) + cx, (-yradius) + cy, 0 + cx, (-yradius) + cy);
        target_mc.curveTo((xradius * Math.tan(pi / 8)) + cx, (-yradius) + cy, (xradius * Math.cos(pi / 4)) + cx, ((-yradius) * Math.sin(pi / 4)) + cy);
        target_mc.curveTo(xradius + cx, ((-yradius) * Math.tan(pi / 8)) + cy, xradius + cx, 0 + cy);		
	}
	
	/**
	 * Paths a circle
	 * @see #drawCircle()
	 * @see #fillCircle()
	 */
	public function circle(cx:Number, cy:Number, r:Number):Void{
		//start at top center point
		ellipse(cx-r, cy-r, r*2, r*2);
//		target_mc.moveTo(cx, cy - r);
//		target_mc.curveTo(cx + r, cy - r, cx + r, cy);
//		target_mc.curveTo(cx + r, cy + r, cx, cy + r);
//		target_mc.curveTo(cx - r, cy + r, cx - r, cy);
//		target_mc.curveTo(cx - r, cy - r, cx, cy - r);
	}
	
	/**
	 * Paths a round rect.
	 * @see #drawRoundRect()
	 * @see #fillRoundRect()
	 * @param radius top left radius, if other corner radius if undefined, will be set to this radius
	 */
	public function roundRect(x:Number,y:Number,width:Number,height:Number, radius:Number, trR:Number, blR:Number, brR:Number):Void{
		var tlR:Number = radius;
		if(trR == undefined) trR = radius;
		if(blR == undefined) blR = radius;
		if(brR == undefined) brR = radius;
		//Bottom right
		target_mc.moveTo(x+blR, y+height);
		target_mc.lineTo(x+width-brR, y+height);
		target_mc.curveTo(x+width, y+height, x+width, y+height-brR);
		//Top right
		target_mc.lineTo (x+width, y+trR);
		target_mc.curveTo(x+width, y, x+width-trR, y);
		//Top left
		target_mc.lineTo (x+tlR, y);
		target_mc.curveTo(x, y, x, y+tlR);
		//Bottom left
		target_mc.lineTo (x, y+height-blR );
		target_mc.curveTo(x, y+height, x+blR, y+height);
	}
	
	/**
	 * path a wedge.
	 */
	public function wedge(radius:Number, x:Number, y:Number, angle:Number, rot:Number):Void {
		target_mc.moveTo(0, 0);
		target_mc.lineTo(radius, 0);
		var nSeg:Number = Math.floor(angle/30);
		var pSeg:Number = angle-nSeg*30;
		var a:Number = 0.268;
		var endx:Number;
		var endy:Number;
		var ax:Number;
		var ay:Number;
		var storeCount:Number=0;
		for (var i:Number = 0; i<nSeg; i++) {
			endx = radius*Math.cos((i+1)*30*(Math.PI/180));
			endy = radius*Math.sin((i+1)*30*(Math.PI/180));
			ax = endx+radius*a*Math.cos(((i+1)*30-90)*(Math.PI/180));
			ay = endy+radius*a*Math.sin(((i+1)*30-90)*(Math.PI/180));
			target_mc.curveTo(ax, ay, endx, endy);
			storeCount=i+1;
		}
		if (pSeg>0) {
			a = Math.tan(pSeg/2*(Math.PI/180));
			endx = radius*Math.cos((storeCount*30+pSeg)*(Math.PI/180));
			endy = radius*Math.sin((storeCount*30+pSeg)*(Math.PI/180));
			ax = endx+radius*a*Math.cos((storeCount*30+pSeg-90)*(Math.PI/180));
			ay = endy+radius*a*Math.sin((storeCount*30+pSeg-90)*(Math.PI/180));
			target_mc.curveTo(ax, ay, endx, endy);
		}
		target_mc.lineTo(0, 0);
		target_mc._rotation = rot;
		target_mc._x = x;
		target_mc._y = y;
	}	
	
	
}
