	/*
	************************************************
	
	    TITLE: Marching Ants Path Class
		VERSION: 1.0
	    AUTHOR: Mario Klingemann <mario@quasimondo.com>
	    CREATED: October 6, 2005
	    
	    http://www.quasimondo.com
		
		Basic Usage:
		var demo:MarchingAntsPath = new MarchingAntsPath();
		some_canvas_mc.clear();
		demo.draw( some_canvas_mc, [new Point(0,0),new Point(100,50),new Point(0,150)] );
		
		Advanced Usage:
		var colors:Array = new Array(0xffff8000,0x00000000,0xff000000,0x00000000);
		var pattern:Array = new Array( 4,2,4,2 );
		var demo:MarchingAntsPath = new MarchingAntsPath( colors, pattern );
		var updateSpeed:Number = 100;
		var stepSize:Number = -2;
		var closePath:Boolean = true;
		some_canvas_mc.clear();
		demo.draw( some_canvas_mc, [new Point(0,0),new Point(100,50),new Point(0,150)], updateSpeed, stepSize, closePath );
		
		The path will be automatically animated until the clear() method is called.
		
	************************************************
	*/
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	
	class com.quasimondo.tools.MarchingAntsPath
	{
		
		private var patternLength:Number;
		
		private var colors:Array;
		private var pattern:Array;
		
		private var patternMap:BitmapData;
		private var copyRect:Rectangle;
		
		static private var copyPoint:Point = new Point(1,0);
		
		private var updateID:Number;
		private var lastUpdate:Number;
		
		public function MarchingAntsPath( colors:Array, pattern:Array )
		{
			setPattern( colors, pattern );
			
		}
		
		public function setPattern( colors:Array, pattern:Array ):Void
		{
			if ( colors==null ){
				this.colors = Array( 0xff000000, 0xffffffff );
			} else {
				this.colors = colors.slice();
			}
			if (pattern == null || pattern.length != this.colors.length){
				this.pattern = Array( 2, 2 );
			} else {
				this.pattern = pattern.slice();
			}
			initBitmap();
		}
		
		public function draw( canvas:MovieClip, points:Array, speed:Number, steps:Number, closePath:Boolean ):Void
		{
			paint( canvas, points, closePath );
			
			if (speed == null) speed = 32;
			if (speed!=0 && speed < 10 ) speed = 10;
			
			if (steps == null) steps = 1;
			steps = ((steps % patternLength) + patternLength ) % patternLength;
			
			clearInterval( updateID );
			if (speed!=0){
				updateID = setInterval( this, "update", speed, steps );
			}
			
			if (getTimer()-lastUpdate > speed) update(steps);
			
		}
		
		public function clear():Void
		{
			clearInterval( updateID );
		}
		
		private function line( canvas:MovieClip, p1:Point, p2:Point, offset:Number ):Number
		{
			var norm:Point = p2.subtract(p1);
			
			var angle:Number = Math.atan2(norm.y,norm.x);
			
			var len:Number = norm.length;
			if (len==0){
				return offset;
			}
			
			var mx:Number = norm.x / len;
			var my:Number = norm.y / len;
			
			
			var dx:Number = 0.6* my;
			var dy:Number = -0.6 * mx;
			
			var ox:Number = Math.min(p1.x,p2.x) - mx * offset;
			var oy:Number = Math.min(p1.y,p2.y) - my * offset;
			
		

			canvas.moveTo( p1.x + dx, p1.y + dy );
			canvas.beginBitmapFill( patternMap, new Matrix( mx,my,-my,mx,ox,oy) );
			canvas.lineTo (p2.x + dx , p2.y + dy );
			canvas.lineTo (p2.x - dx , p2.y - dy );
			canvas.lineTo( p1.x - dx, p1.y - dy );
			canvas.lineTo( p1.x + dx, p1.y + dy );
			canvas.endFill();
			
			return ( offset + len) % patternLength;
		}
		
		private function paint( canvas:MovieClip, points:Array, closePath:Boolean ):Void
		{
			var offset:Number = 0;
			var n:Number = ( closePath ? points.length : points.length-1 );
			
			for ( var i:Number = 0; i < n ; i++)
			{
				offset = line( canvas, points[ i % points.length], points[ (i+1) % points.length ], offset );
			}
			
		}
		
		private function update( steps:Number ):Void
		{
			do{
				var p:Number = patternMap.getPixel32( patternMap.width - 1, 0 );
				patternMap.copyPixels( patternMap, copyRect, copyPoint );
				patternMap.setPixel32( 0 , 0 , p );
			} while ( --steps > 0 );
			
			lastUpdate = getTimer();
		}
		
		private function initBitmap():Void
		{
			patternLength=0;
			for (var i = 0; i < pattern.length; i++)
			{
				patternLength += pattern[i];
			}
			
			patternMap = new BitmapData( patternLength, 1, true, 0);
			
			var x:Number = 0;
			for (var i = 0 ; i < pattern.length; i++ )
			{
				for (var j = 0 ; j <  pattern[i]; j++ )
				{
					patternMap.setPixel32( x++ , 0, colors[i] );
				}
			}
			
			copyRect = new Rectangle( 0 , 0 , patternLength - 1 , 1 );
		}
		
	}
	