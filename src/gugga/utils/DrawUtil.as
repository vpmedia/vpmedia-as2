import flash.geom.ColorTransform;
import flash.geom.Point;
class gugga.utils.DrawUtil 
{
	public static function fillRect(aContainer:MovieClip, aColor:Number, aAlpha:Number, aX:Number, aY:Number, aWidth:Number, aHeight:Number){
		aContainer.beginFill(aColor, aAlpha);
		aContainer.moveTo(aX, aY);
		aContainer.lineTo(aX, aY + aHeight);
		aContainer.lineTo(aX + aWidth, aY + aHeight);
		aContainer.lineTo(aX + aWidth, aY);
		aContainer.lineTo(aX, aY);
		aContainer.endFill();
	}
	
	public static function fillPolygon(aContainer:MovieClip, aColor:Number, aAlpha:Number, aPoints:Array){
		aContainer.beginFill(aColor, aAlpha);
		aContainer.moveTo(aPoints[0].x, aPoints[0].y);

		for(var i = 1; i < aPoints.length; i++){
			aContainer.lineTo(aPoints[i].x, aPoints[i].y);
		}

		aContainer.lineTo(aPoints[0].x, aPoints[0].y);
		aContainer.endFill();
	}
	
	public static function createBoundingBoxCover(aName:String, aContainer:MovieClip):MovieClip
	{
		var cover:MovieClip = aContainer.createEmptyMovieClip(aName, aContainer.getNextHighestDepth());
		fillRect(cover, 0xFF0000, 0, 0, 0, 1, 1);
		
		var boundsObject:Object = aContainer.getBounds(aContainer);
		cover._x = boundsObject.xMin;
		cover._y = boundsObject.yMin;
		cover._width = boundsObject.xMax - boundsObject.xMin;
		cover._height = boundsObject.yMax - boundsObject.yMin;

		return cover;
	}
	
	public static function createCoverForMovieClip(aName:String, aContainer:MovieClip, aTarget:MovieClip):MovieClip
	{
		var newMovieClip:MovieClip = aContainer.createEmptyMovieClip(aName, aContainer.getNextHighestDepth());
		
		DrawUtil.fillRect(newMovieClip, 0xFF0000, 0, 0, 0, 1, 1);
		
		newMovieClip._x = aTarget._x;
		newMovieClip._y = aTarget._y;
		newMovieClip._width = aTarget._width;
		newMovieClip._height= aTarget._height;
		
		return newMovieClip;
	}
	
	public static function createCoverForMovieClips(aName:String, aContainer:MovieClip, aTargets:Array):MovieClip
	{	
		var newMovieClip:MovieClip = aContainer.createEmptyMovieClip(aName, aContainer.getNextHighestDepth(), {_width:1, _height:1});
		if (aTargets.length == 0)
		{
			return newMovieClip;
		}

		DrawUtil.fillRect(newMovieClip, 0xFF0000, 0, 0, 0, 1, 1);
		
		var tempMovieClip:MovieClip = aTargets[0];
		
		var x1:Number = tempMovieClip._x;
		var y1:Number = tempMovieClip._y;
		var x2:Number = x1 + tempMovieClip._width;
		var y2:Number = y1 + tempMovieClip._height;
		
		for (var i:Number = 1; i < aTargets.length; i++)
		{
			tempMovieClip = aTargets[i];
			x1 = Math.min(x1, tempMovieClip._x);
			y1 = Math.min(y1, tempMovieClip._y);
			x2 = Math.max(x2, tempMovieClip._x + tempMovieClip._width);
			y2 = Math.max(y2, tempMovieClip._y + tempMovieClip._height);
			
		}
		
		newMovieClip._x = x1;
		newMovieClip._y = y1;
		newMovieClip._width = x2;
		newMovieClip._height= y2;
		
		return newMovieClip;
	}
	
	public static function drawArc(aCanvas:MovieClip, aCenter:Point, aRadius:Number, aAngle:Number, aStartAngle:Number):Point
	{
		var angleMid:Number;
		var bx:Number;
		var by:Number;
		var cx:Number;
		var cy:Number;
		
		var segs:Number = Math.ceil(Math.abs(aAngle)/(Math.PI/4));
		var segAngle:Number = aAngle/segs;
		var theta:Number = segAngle;
		var angle:Number = aStartAngle;
		
		if (segs>0) {
			for (var i:Number = 0; i < segs; i++) {
				angle += theta;
				angleMid = angle - (theta / 2);
				bx = aCenter.x + Math.cos(angle) * aRadius;
				by = aCenter.y + Math.sin(angle) * aRadius;
				cx = aCenter.x + Math.cos(angleMid) * (aRadius / Math.cos(theta / 2));
				cy = aCenter.y + Math.sin(angleMid) * (aRadius / Math.cos(theta / 2));
				aCanvas.curveTo(cx, cy, bx, by);
			}
		}

		return new Point(bx, by);
	}
	
	public static function getRelativePolarAngle(aCenter:Point, aPoint:Point):Number
	{
		var quadrantOffsetAngle:Number = 0; // First Quadrant
		var xOffset:Number = aPoint.x - aCenter.x;
		var yOffset:Number = aPoint.y - aCenter.y;
		
		if(xOffset < 0)
		{
			quadrantOffsetAngle = Math.PI; // Second and Third Quadrant
		}
		else if(xOffset > 0 && yOffset < 0)
		{
			quadrantOffsetAngle = 2 * Math.PI; //Fourth Quadrant
		}
		
		return (quadrantOffsetAngle + Math.atan(yOffset /xOffset)); 
	}
	
	public static function colorMovieClip(aMovieClip:MovieClip, aColor:Number)
	{
		var colorTransform = new ColorTransform();
		colorTransform.rgb = aColor;
		aMovieClip.transform.colorTransform = colorTransform;
	}
	
	public static function convertCoordinateSystem(aPoint:Point, aSourceCoordinateSystem:MovieClip, aTargetCoordinateSystem:MovieClip) : Point
	{
		aSourceCoordinateSystem.localToGlobal(aPoint);
		aTargetCoordinateSystem.globalToLocal(aPoint);
		
		return aPoint;
	}
	
	public static function convertCoordinateSystemX(aX:Number, aSourceCoordinateSystem:MovieClip, aTargetCoordinateSystem:MovieClip) : Number
	{
		var point : Point = new Point(aX, 0);
		convertCoordinateSystem(point, aSourceCoordinateSystem, aTargetCoordinateSystem);
		
		return point.x;
	}
	
	public static function convertCoordinateSystemY(aY:Number, aSourceCoordinateSystem:MovieClip, aTargetCoordinateSystem:MovieClip) : Number
	{
		var point : Point = new Point(0, aY);
		convertCoordinateSystem(point, aSourceCoordinateSystem, aTargetCoordinateSystem);
		
		return point.y;
	}
}