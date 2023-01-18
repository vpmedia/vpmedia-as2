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

import pegas.draw.AbstractPen;

/**
 * The Canvas pen is used to draw a complex shape with differents points in a data model.
 * <p><b>Example :</b></p>
 * {@code
 * import pegas.draw.Canvas ;
 * var mc:MovieClip = createEmptyMovieClip("container", 1) ;
 * mc._x = 200 ;
 * mc._y = 200 ;
 * 
 * // the model used to draw the shape in the canvas.
 * var data:Array = 
 * [
 *     ['S',[2, 0xFFFFFF, 100]] , // lineStyle(2, 0xFFFFFF, 100)
 *     ['F',[0xFF0000, 100]] , // beginFill(0xFF0000)
 *     ['M',[0,0]] , // moveTo (0,0)
 *     ['L',[80,90]] , // lineTo (80,90)
 *     ['L',[20,90]] , // lineTo (20,90)
 *     ['L',[20,50]],  // lineTo (20,50)
 *     ['EF'] // endFill ()
 * ] ;
 * 
 * var c:Canvas = new Canvas(mc, data) ;
 * trace ("canvas : " + c) ;
 * c.draw() ;
 * }
 * <p><b>Thanks :</b> Peter Hall - <a href='http://www.peterjoel.com/blog/'>Peter Joel Blog</a></p>
 * @author eKameleon
 */
class pegas.draw.Canvas extends AbstractPen 
{

	/**
	 * Creates a new Canvas instance.
	 * @param target the movieclip reference.
	 * @param data the model of this canvas.
	 * @param isNew this argument flag defines if the shape is draw in a new subcontainer in the target reference.
	 */
	public function Canvas(target:MovieClip, data:Array, isNew:Boolean) 
	{
		setData(data) ;
		initialize(target, isNew) ;
	}
	
	/**
	 * (read-write) Returns the array representation of the model of this canvas.
	 * @return the array representation of the model of this canvas.
	 */
	public function get data():Array 
	{
		return getData() ;
	}

	/**
	 * Sets the array representation of the model of this canvas.
	 */
	public function set data(aData:Array):Void 
	{
		setData(aData) ;	
	}

	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	/*override*/ public function clone() 
	{
		return new Canvas(getTarget(), getData()) ;
	}
	
	/**
	 * Converts the curves in the model to lines.
	 */
	public function curvesToLines():Void 
	{
		var d:Array = _data ;
		var e:Array ;
		var value:Array ;
		var l:Number = d.length ;
		while (--l > -1) 
		{
			e = d[l];
			value = e[1];
			if( e[0] == "C" )
			{
				d[l] = ["L",[value[2],value[3]]];
			}
		}
	}
	
	/**
	 * Returns the array representation of the model of this canvas.
	 */
	public function getData():Array 
	{
		return _data ;
	}

	public function removeTransform():Void 
	{
		this.C = MovieClip.prototype.curveTo ;
		this.L = MovieClip.prototype.lineTo ;
		this.M = MovieClip.prototype.moveTo ;
	}

	/**
	 * Draws the shape with the canvas pen.
	 */
	/*override*/ public function draw():Void 
	{
		Canvas.process(_target, this) ;
	}

	/**
	 * Converts the lines in the model to curves.
	 */
	public function linesToCurves():Void 
	{
		var i:Number = 0 ;
		var key:String ;
		var value:Array ;
		var e:Array ;
		var d:Array = _data ;
		var len:Number = d.length;
		var ax:Number = 0 ;
		var ay:Number = 0 ;
		while ( i<len ) 
		{
			e = d[i] ;
			key = e[0] ;
			value = e[1] ;
			if( key == "L" )
			{
				d[i] = ["C", [(ax+value[0])/2 , (ay+value[1])/2 , value[0], value[1]]] ;
				ax = value[0] ;
				ay = value[1] ;
			} 
			else if ( key == "C" )
			{
				ax = value[2] ;
				ay = value[3] ;
			}
			else if ( key == "M" )
			{
				ax = value[0] ;
				ay = value[1] ;
			}
			i++ ;
		}
	}

	/**
	 * This static method launch the process to draw in a specified movieclip target the canvas defined with the (@code draw} argument.
	 * @param target the movieclip reference.
	 * @param draw the {@code Canvas} reference used to draw in the {@code target} reference.
	 */
	static public function process( target:MovieClip , draw:Canvas ):Void 
	{
		var t:MovieClip = target ;
		var d:Array = draw.getData() ;
		var len:Number = draw.size() ;
		if (t && len > 0) 
		{
			var c:Array ;
			var i:Number = 0 ;
			while (i < len) 
			{
				c = d[i++] ;
				draw[c[0]].apply(t, c[1]) ;
			}
		}
	}

	 /**
	  * Sets the array representation of the model of this canvas.
	  */
	public function setData(arData:Array):Void 
	{
		_data = arData || [] ;
	}

	/**
	 * Apply a transform method in this Canvas. Uses the {@code CanvasTransform} tool class and this static methods.
	 * @param transform the method effect used to transform the shape.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import pegas.draw.Canvas ;
	 * import pegas.draw.CanvasTransform ;
	 * 
	 * var data:Array = 
	 * [
	 *     ['S',[2,0xFF0000,100]],
	 *     ['F',[0x000000]],
	 *     ['L',[80,0]],
	 *     ['L',[160,0]],
	 *     ['L',[160,50]],
	 *     ['L',[160,100]],
	 *     ['L',[80,100]],
	 *     ['L',[0,100]],
	 *     ['L',[0,50]],
	 *     ['L',[0,0]],
	 *     ['EF']
	 * ] ;
	 * 
	 * this.createEmptyMovieClip("canvas_mc", 1) ;
	 * canvas_mc._x = 400 ;
	 * canvas_mc._y = 200 ;
	 * 
	 * var c:Canvas = new Canvas(canvas_mc, data) ;
	 * trace (c + " : " + c.size()) ;
	 * c.draw() ;
	 * 
	 * var bounds = canvas_mc.getBounds(canvas_mc);
	 * 
	 * var count:Number = 0;
	 * onEnterFrame = function()
	 * {
	 *     count ++;
	 *     var b = bounds ;
	 *     var xAmount = Math.sin(count/8)*40 ;
	 *     var yAmount = Math.cos(count/8)*50 ;
	 *     var transform:Function = CanvasTransform.createPinch(b.xMin, b.yMin, b.xMax, b.yMax, xAmount, yAmount) ;
	 *     c.setTransform( transform ) ;
	 *     c.clear();
	 *     c.draw() ;
	 *     
	 *     var speedX = (_xmouse - canvas_mc._x ) * 0.2 ;
	 *     var speedY = (_ymouse - canvas_mc._y ) * 0.2 ;
	 *     canvas_mc._x += speedX ;
	 *     canvas_mc._y += speedY ;
	 *     
	 *     updateAfterEvent() ;
	 * }
	 * 
	 * var cpt:Number = 0 ;
	 * this.onKeyDown = function ()
	 * {
	 *     (cpt++ %2 == 0) ? c.linesToCurves() : c.curvesToLines() ;
	 * }
	 * Key.addListener(this) ;
	 * }
	 * @see CanvasTransform.
	 */
	public function setTransform( transform:Function ):Void 
	{
		if(typeof transform != "function")
		{
			removeTransform() ;
		}
		else 
		{
			this.C = function(cx:Number, cy:Number, ax:Number, ay:Number):Void 
			{
				var cp:Object = transform(cx,cy);
				var ap:Object = transform(ax,ay);
				this.curveTo(cp.x, cp.y, ap.x, ap.y);
			} ;
			this.L = function (x:Number, y:Number):Void 
			{
				var p:Object = transform(x,y);
				this.lineTo(p.x,p.y);
			} ;
			this.M = function(x:Number, y:Number):Void 
			{
				var p:Object = transform(x,y) ;
				this.moveTo(p.x,p.y);
			} ;
		}
	}
	
	/**
	 * Returns the number of elements in the model.
	 * @return the number of elements in the model.
	 */
	public function size():Number 
	{
		return _data.length ;
	}

	private var _data:Array ;
  
}