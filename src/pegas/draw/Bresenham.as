/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is PEGAS Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import flash.display.BitmapData;

import vegas.util.MathsUtil;

/**
 * Allows to connect two points p1 (X, y) and p2 (X, y) by a segment.
 * With this algorithm it's easy to plot a straight line with a pixel.
 * <p><b>Example :</b>
 * {@code
 * import pegas.draw.Bresenham ;
 * 
 * var mc:MovieClip = createEmptyMovieClip("container", 1) ;
 * 
 * MovieClip.prototype.drawLine = function () 
 * {
 *     var p1 = { x : 0 , y : 0 } ;
 *     var p2 = { x : this._xmouse , y : this._ymouse } ;
 *     var line:Array = Bresenham.getLine( p1, p2 ) ;
 *     this.clear() ;
 *     this.lineStyle(1, 0xFF0000, 100) ;
 *     var l:Number = line.length ;
 *     for (var i:Number = 0 ; i<l ; i++) 
 *     {
 *         var p = line[i] ;
 *         this.lineTo( p.x , p.y ) ;
 *     }
 * }
 * 
 * this.onMouseDown = function () 
 * {
 *     mc.clear() ;
 *     mc._x = mc._parent._xmouse ;
 *     mc._y = mc._parent._ymouse ;
 *     this.onMouseMove = function () 
 *     {
 *         mc.drawLine() ;
 *     }
 * }
 * 
 * this.onMouseUp = function () 
 * {
 *     delete onMouseMove ;
 * }
 * 
 * }
 * @author eKameleon
 */
class pegas.draw.Bresenham 
{

	/**
	 * Creates a new Bresenham instance.
	 */
	public function Bresenham( bdTarget:BitmapData , nColor:Number ) 
	{
		_bdOutput = bdTarget ;
		color = isNaN(nColor) ? 0xFFFFFF : nColor ;
	}

	/**
	 * Defines the color of the line. 
	 */
	public var color:Number ;

	/**
	 * Draw the line between 2 points with x and y coordinates.
	 */
	public function draw(p1, p2):Void 
	{
        
		_bdOutput.draw() ;
		
		var error:Number ;
		
		var x0:Number = p1.x ;
		var y0:Number = p1.y ;
		
		var x1:Number = p2.x ;
		var y1:Number = p2.y ;
		
        var dx:Number = x1 - x0;
        var dy:Number = y1 - y0;
        var yi:Number = 1 ;
       
        if( dx < dy ) 
        {
			//-- swap end points
            x0 ^= x1 ;
			x1 ^= x0 ;
			x0 ^= x1 ;
            y0 ^= y1 ;
			y1 ^= y0 ;
			y0 ^= y1 ;
        }

        if( dx < 0 ) 
        {
			dx = -dx ;
			yi = -yi ;
        }
       
        if( dy < 0 ) 
        {
			dy = -dy ;
			yi = -yi ;
        }
               
        if( dy > dx ) 
        {
			error = -( dy >> 1 );
            for( ; y1 < y0 ; y1++ ) 
            {
                _bdOutput.setPixel32(x1, y1, color) ;
				error += dx ;
				if( error > 0 ) {
					x1 += yi;
                   error -= dy ;
				}
			}
		} 
		else 
		{
			error = -( dx >> 1 );
            for( ; x0 < x1 ; x0++ ) 
            {
				_bdOutput.setPixel32(x0, y0, color) ;
				error += dy;
				if( error > 0 )
				{
					y0 += yi;
                    error -= dx;
				}
			}
        }
	}

	/**
	 * Returns an array representation of all points to draw a line between to point defines by the coordinates x and y in the passed-in arguments.
	 * @return an array representation of all points to draw a line between to point defines by the coordinates x and y in the passed-in arguments.
	 */
	static public function getLine(p1, p2):Array 
	{
		
		var dx,dy,x,y,s1,s2,e,temp,swap:Number ;
		
		dy = Math.abs( p2.y - p1.y ) ;
		dx = Math.abs( p2.x - p1.x ) ;
        s1 = MathsUtil.sign( p2.x - p1.x ) ;
		s2 = MathsUtil.sign ( p2.y - p1.y ) ;
		x = p1.x ;
		y = p1.y ;
		if (dy>dx) {
			temp = dx ;
			dx = dy ;
			dy = temp ;
			swap = 1 ;
		} else  {
			swap = 0 ;
		}
		e = 2 * dy - dx ;
		var ar:Array = [] ;
		for ( var i:Number = 0 ; i<dx ;i++) {
			ar.push ( {x:x ,y:y} ) ;
			while (e>=0) {
				if (swap==1) x+= s1 ;
				else y+=s2 ;
				e-=2*dx;
			}
			if (swap==1) y+=s2 ;
			else x += s1 ;
			e+=2*dy ;
		}
		return ar ;
	}

	private var _bdOutput:BitmapData ;

}

/*
  TODO : test and implements in this class the AS3 Andre Michelle implementation ! Bench & co... 
  http://blog.andre-michelle.com/2006/as3-bresenhams-line-algorithm/
	
  ActionScript:
	private function bresenham( x0: int, y0: int, x1: int, y1: int, value: int ): void
	{
        var error: int;
        var dx: int = x1 - x0;
        var dy: int = y1 - y0;
        var yi: int = 1;
       
        if( dx < dy )
        {
                //-- swap end points
                x0 ^= x1; x1 ^= x0; x0 ^= x1;
                y0 ^= y1; y1 ^= y0; y0 ^= y1;
        }

        if( dx < 0 )
        {
                dx = -dx; yi = -yi;
        }
       
        if( dy < 0 )
        {
                dy = -dy; yi = -yi;
        }
               
        if( dy > dx )
        {
                error = -( dy >> 1 );
               
                for( ; y1 < y0 ; y1++ )
                {
                        output.setPixel32( x1, y1, value );
                        error += dx;
                        if( error > 0 )
                        {
                                x1 += yi;
                                error -= dy;
                        }
                }
        }
        else
        {
                error = -( dx >> 1 );
               
                for( ; x0 < x1 ; x0++ )
                {
                        output.setPixel32( x0, y0, value );
                        error += dy;
                        if( error > 0 )
                        {
                                y0 += yi;
                                error -= dx;
                        }
                }
        }
	}
*/