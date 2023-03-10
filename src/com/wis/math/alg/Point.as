/**
 * @class       com.wis.math.alg.Point
 * @author      Richard Wright
 * @version     1.6
 * @description Implements the behaviours of the Point Class -- provides methods
 *              for 2D and 3D point instantiation.
 *              <p>
 *		        I've swayed from using '$' as a class-based variable identifier for
 *              this class due to the increased usage of UI-defined class variables
 *              for this group of classes: Point, Vector, Quaternion, Col, and ColMC
 *              classes all reflect this format.
 *		        <p>
 * @usage       <pre>var inst:Point = new Point(px,py[,pz,pcx,pcy,MC,pSize,D])</pre>
 * @param       px (Number)  -- x-axis value of point.
 * @param       py (Number)  -- y-axis value of point.
 * @param       pz (Number)  -- z-axis value of point.
 * @param       pcx (Number)  -- x-axis center position on 2d screen.
 * @param       pcy (Number)  -- y-axis center position on 2d screen.
 * @param       MC (MovieClip)  -- target clip that represents point.
 * @param       pSize (Number)  -- size of point with perspective.
 * @param       D (Number)  -- distance from user to screen.
 * -----------------------------------------------
 * Latest update: July 27, 2004
 * -----------------------------------------------
 * Dependency:    com.wis.math.alg.Vector
 * -----------------------------------------------
 * AS2 revision copyright: ? 2003, Richard Wright [wisolutions2002@shaw.ca]
 * JS  original copyright: ? 2000-2002, Kevin Lindsey [http://www.kevlindev.com/]
 * -----------------------------------------------
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     - Redistributions of source code must retain the above copyright notice,
 *       this list of conditions and the following disclaimer.
 *
 *     - Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *
 *     - Neither the name of this software nor the names of its contributors
 *       may be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * -----------------------------------------------
 *   Functions:
 *       Point(px,py,pz,pcx,pcy,MC,pSize,D)
 *             1.  adds(that)
 *             2.  addEquals(that)
 *             3.  scalarAdd(s)
 *             4.  scalarAddEquals(s)
 *             5.  subtract(that)
 *             6.  subtractEquals(that)
 *             7.  scalarSubtract(s)
 *             8.  scalarSubtractEquals(s)
 *             9.  multiply(s)
 *             10. multiplyEquals(s)
 *             11. divide(s)
 *             12. divideEquals(s)
 *          - comparison methods
 *             13. equals(that)
 *             14. lessThan(that)
 *             15. lessThanEq(that)
 *             16. greaterThan(that)
 *             17. greaterThanEq(that)
 *          - utility methods
 *             18. lerp(that,t)
 *             19. distanceFrom(that)
 *             20. min(that)
 *             21. max(that)
 *             22. toString()
 *         - get/set methods
 *             23. setXYZ(x,y,z)
 *             24. setFromPoint(that)
 *             25. swap(that)
 *         - 3d-centric methods
 *             26. recenter(pcx,pcy)
 *             27. resize(pSize)
 *             28. translate(tx,ty,tz)
 *             29. scale(sx,sy,sz)
 *             30. rotateXMatrix(a)
 *             31. rotateYMatrix(a)
 *             32. rotateZMatrix(a)
 *             33. axisMatrix(axis,a)
 *             34. rotate(mat)
 *             35. perspective()
 *             36. render()
 *             37. setDepth()
 *             38. lineD1(p,v,s)
 *             39. angle(a,b,c)
 * -----------------------------------------------
 * Updates may be available at:
 *             http://members.shaw.ca/flashprogramming/wisASLibrary/wis/
 * -----------------------------------------------
**/

import com.wis.math.alg.Vector;

class com.wis.math.alg.Point
{
	/**
	 * @property x  (Number)  -- x-axis value of Point object.
	 * @property y  (Number)  -- y-axis value of Point object.
	 * @property z  (Number)  -- z-axis value of Point object.
	 * @property xCtr  (Number)  -- x-axis center position on 2d screen.
	 * @property yCtr  (Number)  -- y-axis center position on 2d screen.
	 * @property size  (Number)  -- size of point at origin.
	 * @property perSize  (Number)  -- size of point with perspective.
	 * @property D  (Number)  -- used for perspective -- distance from your eye to the screen.
	 * @property xp  (Number)  -- x-axis value of Point object scaled with perspective.
	 * @property yp  (Number)  -- y-axis value of Point object scaled with perspective.
	 * @property clip  (MovieClip)  -- scope for Point object.
	 * @property M  (Array)  -- array holder for rotation matrix.
	 * @property $b3  (Boolean)  -- if true, Point object is in 3-space.
	**/
    var x:Number;
    var y:Number;
    var z:Number;
    var xCtr:Number;
    var yCtr:Number;
    var size:Number;
    var perSize:Number;
    var D:Number;
    var xp:Number;
    var yp:Number;
    var clip:MovieClip;
    var M:Array;
    var $b3:Boolean;

    // constructor
    function Point(px:Number,py:Number,pz:Number,pcx:Number,pcy:Number,MC:MovieClip,pSize:Number,pD:Number)
    {
        //trace ("Point Class loaded");
        x = px;
        y = py;
        z = pz;
        xCtr = pcx;
    	yCtr = pcy;
    	clip = MC;
    	size = pSize;
    	perSize = pSize;
    	D = pD;
        if (pz!=undefined) $b3 = true;
		else $b3 = false, z = 0;
    }

// 1. adds ---------------------------------------

    /**
     * @method  adds
     * @description  Adds this instance to passed Point object.
     * @usage  <pre>inst.adds(that);</pre>
     * @param   that   (Point)  -- a Point object in 2-space or 3-space.
     * @return  (Point)  -- returns a new Point object with addition result.
    **/
    function adds(that:Point):Point
    {
        var p:Point;

        if ($b3) p = new Point(x+that.x,y+that.y,z+that.z);
        else p = new Point(x+that.x,y+that.y);

        return p;
    }

// 2. addEquals ----------------------------------

    /**
     * @method  addEquals
     * @description  Adds this instance to passed Point object.
     * @usage  <pre>inst.addEquals(that);</pre>
     * @param   that   (Point))  -- a Point object in 2-space or 3-space.
     * @return  (Point)  -- returns this instance altered by addition result.
    **/
    function addEquals(that:Point):Point
    {
        x += that.x;
        y += that.y;
        if ($b3) z += that.z;

        return this;
    }

// 3. scalarAdd ----------------------------------

    /**
     * @method  scalarAdd
     * @description  Adds a scalar to each axis property of this instance.
     * @usage  <pre>inst.scalarAdd(s);</pre>
     * @param   s   (Number)  -- a real number.
     * @return  (Point)  -- returns a new Point object with scalar addition result.
    **/
    function scalarAdd(s:Number):Point
    {
        var p:Point;

        if ($b3) p = new Point(x+s,y+s,z+s);
        else p = new Point(x+s,y+s);

        return p;
    }

// 4. scalarAddEquals ----------------------------

    /**
     * @method  scalarAddEquals
     * @description  Adds a scalar to each axis property of this instance.
     * @usage  <pre>inst.scalarAddEquals(s);</pre>
     * @param   s   (Number)  -- a real number.
     * @return  (Point)  -- returns this instance altered by scalar addition result.
    **/
    function scalarAddEquals(s:Number):Point
    {
        x += s;
        y += s;
        if ($b3) z += s;

        return this;
    }

// 5. subtract -----------------------------------

    /**
     * @method  subtract
     * @description  Subtracts passed Point object from this instance.
     * @usage  <pre>inst.subtract(that);</pre>
     * @param   that   (Point))  -- a Point object in 2-space or 3-space.
     * @return  (Point)  -- returns a new Point object with subtraction result.
    **/
    function subtract(that:Point):Point
    {
        var p:Point;

        if ($b3) p = new Point(x-that.x,y-that.y,z-that.z);
        else p = new Point(x-that.x,y-that.y);

        return p;
    }

// 6. subtractEquals -----------------------------

    /**
     * @method  subtractEquals
     * @description  Subtracts passed Point object from this instance.
     * @usage  <pre>subtractEquals(that);</pre>
     * @param   that   (Point))  -- a Point object in 2-space or 3-space.
     * @return  (Point)  -- returns this instance altered by subtraction result.
    **/
    function subtractEquals(that:Point):Point
    {
        x -= that.x;
        y -= that.y;
        if ($b3) z -= that.z;

        return this;
    }

// 7. scalarSubtract -----------------------------

    /**
     * @method  scalarSubtract
     * @description  Subtracts a scalar from each axis property of this instance.
     * @usage  <pre>inst.scalarSubtract(s);</pre>
     * @param   s   (Number)  -- a real nmuber.
     * @return  (Point)  -- returns a new Point object with scalar subtraction result.
    **/
    function scalarSubtract(s:Number):Point
    {
        var p:Point;

        if ($b3) p = new Point(x-s,y-s,z-s);
        else p = new Point(x-s,y-s);

        return p;
    }

// 8. scalarSubtractEquals -----------------------

    /**
     * @method  scalarSubtractEquals
     * @description  Subtracts a scalar from each axis property of this instance.
     * @usage  <pre>inst.scalarSubtractEquals(s);</pre>
     * @param   s   (Number)  -- a real number.
     * @return  (Point)  -- returns this instance altered by scalar subtraction result.
    **/
    function scalarSubtractEquals(s:Number):Point
    {
        x -= s;
        y -= s;
        if ($b3) z -= s;

        return this;
    }

// 9. multiply -----------------------------------

    /**
     * @method  multiply
     * @description  Multiplies this instance by a passed scalar.
     * @usage  <pre>inst.multiply(s);</pre>
     * @param   s   (Number)  -- a real number.
     * @return  (Point)  -- returns a new Point object with the scalar multiplication result.
    **/
    function multiply(s:Number):Point
    {
        var p:Point;

        if ($b3) p = new Point(this.x*s,this.y*s,this.z*s);
        else p = new Point(this.x*s,this.y*s);

        return p;
    }

// 10. multiplyEquals -----------------------------

    /**
     * @method  multiplyEquals
     * @description  Multiplies this instance by a passed scalar.
     * @usage  <pre>inst.multiplyEquals(s);</pre>
     * @param   s   (Number)  -- a real number.
     * @return  (Point)  -- returns this instance altered by the scalar multiplication result.
    **/
    function multiplyEquals(s:Number):Point
    {
        x *= s;
        y *= s;
        if ($b3) z *= s;

        return this;
    }

// 11. divide -------------------------------------

    /**
     * @method  divide
     * @description  Divides this instance by a passed scalar.
     * @usage  <pre>inst.divide(s);</pre>
     * @param   s   (Number)  -- a real number.
     * @return  (Point)  -- returns a new Point object with the scalar division result.
    **/
    function divide(s:Number):Point
    {
        var p:Point;

        if ($b3)  p = new Point(x/s,y/s,z/s);
        else p = new Point(x/s,y/s);

        return p;
    }

// 12. divideEquals -------------------------------

    /**
     * @method  divideEquals
     * @description  Divides this instance by a passed scalar.
     * @usage  <pre>inst.divideEquals(s);</pre>
     * @param   s   (Number)  -- a real number.
     * @return  (Point)  -- returns this instance altered by the scalar division result.
    **/
    function divideEquals(s:Number):Point
    {
        x /= s;
        y /= s;
        if ($b3) z /= s;

        return this;
    }

//////////////////////////////////
// Comparison Methods
//////////////////////////////////

// 13. equals -------------------------------------

    /**
     * @method  equals
     * @description  Boolean 'equality' test between this instance and passed Point object.
     * @usage  <pre>inst.equals(that);</pre>
     * @param   that   (Point)  -- a Point object in 2-space or 3-space.
     * @return  (Boolean)
    **/
    function equals(that:Point):Boolean
    {
        var b:Boolean;

        if ($b3) b = (x==that.x && y==that.y && z==that.z);
        else b = (x==that.x && y==that.y);

        return b;
    }

// 14. lessThan -----------------------------------

    /**
     * @method  lessThan
     * @description  Boolean 'less than' test between this instance and passed Point object.
     * @usage  <pre>inst.lessThan(that);</pre>
     * @param   that   (Point)  -- a Point object in 2-space or 3-space.
     * @return  (Boolean)
    **/
    function lessThan(that:Point):Boolean
    {
        var b:Boolean;

        if ($b3) b = (x<that.x && y<that.y && z<that.z);
        else b = (x<that.x && y<that.y);

        return b;
    }

// 15. lessThanEq ---------------------------------

    /**
     * @method  lessThanEq
     * @description  Boolean 'less than or equal' test between this instance and passed Point object.
     * @usage  <pre>inst.lessThanEq(that);</pre>
     * @param   that   (Point)  -- a Point object in 2-space or 3-space.
     * @return  (Boolean)
    **/
    function lessThanEq(that:Point):Boolean
    {
        var b:Boolean;

        if ($b3) b = (x<=that.x && y<=that.y && z<=that.z);
        else b = (x<=that.x && y<=that.y);

        return b;
    }

// 16. greaterThan --------------------------------

    /**
     * @method  greaterThan
     * @description  Boolean 'greater than' test between this instance and passed Point object.
     * @usage  <pre>inst.greaterThan(that);</pre>
     * @param   that   (Point)  -- a Point object in 2-space or 3-space.
     * @return  (Boolean)
    **/
    function greaterThan(that:Point):Boolean
    {
        var b:Boolean;

        if ($b3) b = (x>that.x && y>that.y && z>that.z);
        else b = (x>that.x && y>that.y);

        return b;
    }

// 17. greaterThanEq ------------------------------

    /**
     * @method  greaterThanEq
     * @description  Boolean 'greater than or equal' test between this instance and passed Point object.
     * @usage  <pre>inst.greaterThanEq(that);</pre>
     * @param   that   (Point)  -- a Point object in 2-space or 3-space.
     * @return  (Boolean)
    **/
    function greaterThanEq(that:Point):Boolean
    {
        var b:Boolean;

        if ($b3) b = (x>=that.x && y >=that.y && z>=that.z);
        else b = (x>=that.x && y >=that.y);

        return b;
    }

//////////////////////////////////
// Utilility Methods
//////////////////////////////////

// 18. lerp ---------------------------------------

    /**
     * @method  lerp
     * @description  Linear interpolation of this instance by the passed Point
     *               object and scalar.
     * @usage  <pre>inst.lerp(that,t);</pre>
     * @param   that   (Point)  -- a Point object in 2-space or 3-space.
     * @param   t   (Number)  -- a real number.
     * @return  (Point)  -- returns a new Point object with the lerped results.
    **/
    function lerp(that:Point,t:Number):Point
    {
        var p:Point;

        if ($b3) p = new Point(x+(that.x-x)*t,y+(that.y-y)*t,z+(that.z-z)*t);
        else p = new Point(x+(that.x-x)*t,y+(that.y-y)*t);

        return p;
    }

// 19. distanceFrom -------------------------------

    /**
     * @method  distanceFrom
     * @description  Calculates distance from this instance to passed Point object.
     * @usage  <pre>inst.distanceFrom(that);</pre>
     * @param   that   (Point)  -- a Point object in 2-space or 3-space.
     * @return  (Number)  -- returns the distance between the two points.
    **/
    function distanceFrom(that:Point):Number
    {
        var dx:Number = x-that.x;
        var dy:Number = y-that.y;

        if ($b3) {
            var dz = z-that.z;
            return Math.sqrt(dx*dx+dy*dy+dz*dz);
        } else {
            return Math.sqrt(dx*dx+dy*dy);
        }
    }

// 20. min ----------------------------------------

    /**
     * @method  min
     * @description  Defines minimum axis properties for this instance and
     *               passed Point object.
     * @usage  <pre>inst.min(that);</pre>
     * @param   that   (Point)  -- a Point object in 2-space or 3-space.
     * @return  (Point)  -- returns a new Point object with the minimum values.
    **/
    function min(that:Point):Point
    {
        var p:Point;

        if ($b3) p = new Point(Math.min(x,that.x),Math.min(y,that.y),Math.min(z,that.z));
        else p = new Point(Math.min(x,that.x),Math.min(y,that.y));

        return p;
    }

// 21. max ----------------------------------------

    /**
     * @method  max
     * @description  Defines maximum axis properties for this instance and
     *               passed Point object.
     * @usage  <pre>inst.max(that);</pre>
     * @param   that   (Point)  -- a Point object in 2-space or 3-space.
     * @return  (Point)  -- returns a new Point object with the maximum values.
    **/
    function max(that:Point):Point
    {
        var p:Point;

        if ($b3) p = new Point(Math.max(x,that.x),Math.max(y,that.y),Math.max(z,that.z));
        else p = new Point(Math.max(x,that.x),Math.max(y,that.y));

        return p;
    }

// 22. toString -----------------------------------

    /**
     * @method  toString
     * @description  Creates a string representation of this instance's axis properties.
     * @usage  <pre>inst.toString();</pre>
     * @return  (String)  -- returns a string representation of this instance's axis properties.
    **/
    function toString():String
    {
        var s:String;

        if ($b3) s = x+","+y+","+z;
        else s = x+","+y;

        return s;
    }

///////////////////////////////////////////////////////
// Get/Set Methods
///////////////////////////////////////////////////////

// 23. setXYZ -------------------------------------

    /**
     * @method  setXYZ
     * @description  Sets new axis properties for this instance with axis values.
     * @usage  <pre>inst.setXYZ(px,py,pz);</pre>
     * @param   px   (Number)  -- a real number.
     * @param   py   (Number)  -- a real number.
     * @param   pz   (Number)  -- a real number.
     * @return  (Void)
    **/
    function setXYZ(px:Number,py:Number,pz:Number):Void
    {
        x = px;
        y = py;
        if ($b3) z = pz;
    }

// 24. setFromPoint -------------------------------

    /**
     * @method  setFromPoint
     * @description  Sets new axis properties for this instance with a passed
     *               Point object.
     * @usage  <pre>inst.setFromPoint(that);</pre>
     * @param   that   (Point)  -- a Point object in 2-space or 3-space.
     * @return  (Void)
    **/
    function setFromPoint(that:Point):Void
    {
        x = that.x;
        y = that.y;
        if ($b3) z = that.z;
    }

// 25. swap ---------------------------------------

    /**
     * @method  swap
     * @description  Swaps axis properties for this instance and a passed Point object.
     * @usage  <pre>inst.swap(that);</pre>
     * @param   that   (Point)  -- a Point object in 2-space or 3-space.
     * @return  (Void)
    **/
    function swap(that:Point):Void
    {
        var tx:Number = x;
        var ty:Number = y;
        var tz:Number = z;

        x = that.x;
        y = that.y;
        if ($b3) z = that.z;
        that.x = tx;
        that.y = ty;
        if ($b3) that.z = tz;
    }

// 26. recenter -----------------------------------

    /**
     * @method  recenter
     * @description  Resets this instance's 2D screen center values.
     * @usage  <pre>inst.recenter(pcx,pcy);</pre>
     * @param   pcx   (Number)  -- a real number.
     * @param   pcy   (Number)  -- a real number.
     * @return  (Void)
    **/
    function recenter(pcx:Number,pcy:Number):Void
    {
    	xCtr = pcx;
    	yCtr = pcy;
    }

// 27. resize -------------------------------------

    /**
     * @method  resize
     * @description  Resets this instance's original size at origin.
     * @usage  <pre>inst.resize(pSize);</pre>
     * @param   pSize   (Number)  -- a real number.
     * @return  (Void)
    **/
    function resize(pSize:Number):Void
    {
    	size = pSize;
    }

// 28. translate ----------------------------------

    /**
     * @method  translate
     * @description  Defines translation of this instance with passed
     *               translation values.
     * @usage  <pre>inst.translate(tx,ty,tz);</pre>
     * @param   tx   (Number)  -- a real number.
     * @param   ty   (Number)  -- a real number.
     * @param   tz   (Number)  -- a real number.
     * @return  (Void)
    **/
    function translate(tx:Number,ty:Number,tz:Number):Void
    {
    	x += tx;
    	y += ty;
    	if ($b3) z += tz;
    }

// 29. scale --------------------------------------

    /**
     * @method  scale
     * @description  Scales this instance's axis properties with passed scalar values.
     * @usage  <pre>inst.scale(sx,sy,sz);</pre>
     * @param   sx   (Number)  -- a real number.
     * @param   sy   (Number)  -- a real number.
     * @param   sz   (Number)  -- a real number.
     * @return  (Void)
    **/
    function scale(sx:Number,sy:Number,sz:Number):Void
    {
    	x *= sx;
    	y *= sy;
    	if ($b3) z *= sz;
    }

// 30. rotateXMatrix ------------------------------

    /**
     * @method  rotateXMatrix
     * @description  Rotates this instance's matrix around the x-axis.
     * @usage  <pre>inst.rotateXMatrix(a);</pre>
     * @param   a   (Number)  -- a real number.
     * @return  (Void)
    **/
    function rotateXMatrix(a:Number):Void
    {
    	M = new Array(3);
    	M[0] = new Array(1,0,0);
    	M[1] = new Array(0,Math.cos(a),-Math.sin(a));
    	M[2] = new Array(0,Math.sin(a),Math.cos(a));
    }

// 31. rotateYMatrix ------------------------------

    /**
     * @method  rotateYMatrix
     * @description  Rotates this instance's matrix around the y-axis.
     * @usage  <pre>inst.rotateYMatrix(a);</pre>
     * @param   a   (Number)  -- a real number.
     * @return  (Void)
    **/
    function rotateYMatrix(a:Number):Void
    {
    	M = new Array(3);
    	M[0] = new Array(Math.cos(a),0,-Math.sin(a));
    	M[1] = new Array(0,1,0);
    	M[2] = new Array(Math.sin(a),0,Math.cos(a));
    }

// 32. rotateZMatrix ------------------------------

    /**
     * @method  rotateZMatrix
     * @description  Rotates this instance's matrix around the z-axis.
     * @usage  <pre>inst.rotateZMatrix(a);</pre>
     * @param   a   (Number)  -- a real number.
     * @return  (Void)
    **/
    function rotateZMatrix(a:Number):Void
    {
    	M = new Array(3);
    	M[0] = new Array(Math.cos(a),-Math.sin(a),0);
    	M[1] = new Array(Math.sin(a),Math.cos(a),0);
    	M[2] = new Array(0,0,1);
    }

// 33. axisMatrix ---------------------------------

    /**
     * @method  axisMatrix
     * @description  Calculates this instance's new rotation matrix values around
     *               passed axis Vector object by angle value.
     * @usage  <pre>inst.axisMatrix(axis,a);</pre>
     * @param   axis   (Vector)  -- a direction Vector object.
     * @param   a   (Number)  -- a real number for the rotation angle.
     * @return  (Void)
    **/
    function axisMatrix(axis:Vector,a:Number):Void
    {
    	var s:Number;
    	var c:Number;
    	var t:Number;
    	var a:Number;
    	var ax:Vector = new Vector(axis.x,axis.y,axis.z);

    	ax.unitVector();

    	a *= -1;  // negate angle

    	s = Math.sin(a);
    	c = Math.cos(a);
    	t = 1-c;

    	M = new Array(3);
    	M[0] = new Array(3);
    	M[1] = new Array(3);
    	M[2] = new Array(3);

    	M[0][0] = t*ax.x*ax.x+c;
    	M[0][1] = t*ax.x*ax.y+s*ax.z;
    	M[0][2] = t*ax.x*ax.z-ax.x*ax.y;

    	M[1][0] = t*ax.x*ax.y-s*ax.z;
    	M[1][1] = t*ax.y*ax.y+c;
    	M[1][2] = t*ax.y*ax.z+s*ax.z;

    	M[2][0] = t*ax.x*ax.z+s*ax.y;
    	M[2][1] = t*ax.y*ax.z-s*ax.x;
    	M[2][2] = t*ax.z*ax.z+c;
    }

// 34. rotate -------------------------------------

    /**
     * @method  rotate
     * @description  Calculates this instance's new rotation matrix values
     *               through summation of the multiplication results for this
     *               instance and passed Vector object axis values.
     * @usage  <pre>inst.rotate(mat)</pre>
     * @param   mat   (Array)  --  a nested array holding matrix data.
     * @return  (Void)
    **/
    function rotate(mat:Array):Void
    {
    	var rx:Number;
    	var ry:Number;
    	var rz:Number;

    	rx = x*mat[0][0]+y*mat[0][1]+z*mat[0][2];
    	ry = x*mat[1][0]+y*mat[1][1]+z*mat[1][2];
    	rz = x*mat[2][0]+y*mat[2][1]+z*mat[2][2];

    	x = rx;
    	y = ry;
    	z = rz;
    }

// 35. perspective --------------------------------

    /**
     * @method  perspective
     * @description  Calculates this instance's perspective properties.
     * @usage  <pre>inst.perspective()</pre>
     * @return  (Void)
    **/
    function perspective():Void
    {
    	var per:Number;

    	per = D/(z+D);
    	xp = x*per;
    	yp = y*per;
    	perSize = size*per;
    }

// 36. render -------------------------------------

    /**
     * @method  render
     * @description  Renders scope clip based on this instance's
     *               perspective properties.
     * @usage  <pre>inst.render()</pre>
     * @return  (Void)
    **/
    function render():Void
    {
        perspective();
    	clip._x = xCtr+xp;
    	clip._y = yCtr-yp;
    	clip._xscale = clip._yscale = perSize;
    	this.setDepth();
    }

// 37. setDepth ------------------------------------

    /**
     * @method  setDepth
     * @description  Sets scope clip's depth based on the negative value of
     *               this instance's z-axis property.
     * @usage  <pre>inst.setDepth()</pre>
     * @return  (Void)
    **/
    function setDepth():Void
    {
    	clip.swapDepths(-1*z);
    }

// 38. lineD1 -------------------------------------

    /**
     * @method  lineD1
     * @description  Calculates this instance's 'line of sight' vector based on
     *               passed Point objects and Vector object.
     * @usage  <pre>inst.lineD1(p1,p2,V)</pre>
     * @param   p1   (Point)  -- a Point object in 2-space or 3-space.
     * @param   p2   (Point)  -- a Point object in 2-space or 3-space.
     * @param   V   (Vector)  -- a direction Vector object.
     * @return  (Number)  -- returns a perspective ratio value.
    **/
    function lineD1(p1:Point,p2:Point,V:Vector):Number
    {
    	var temp:Vector;
    	var vec:Vector;

    	if ($b3)
    	{
    	    temp = new Vector(x,y,z);
    	    vec = new Vector(p1.x-p2.x,p1.y-p2.y,p1.z-p2.z);
    	}
    	else
    	{
    	    temp = new Vector(x,y);
    	    vec = new Vector(p1.x-p2.x,p1.y-p2.y);
    	}
    	temp = V.crossProduct(vec);

    	return (temp.norm()/V.norm());
    }

// 39. angle --------------------------------------

    /**
     * @method  angle
     * @description  Defines angle vector created from three passed Point
     *               objects wrt this instance.
     * @usage  <pre>inst.angle(p1,p2,p3)</pre>
     * @param   p1   (Point)  -- a Point object in 2-space or 3-space.
     * @param   p2   (Point)  -- a Point object in 2-space or 3-space.
     * @param   p3   (Point)  -- a Point object in 2-space or 3-space.
     * @return  (Number)  -- returns an angle vector value.
    **/
    function angle(p1:Point,p2:Point,p3:Point):Number
    {
        var v:Vector;
        var w:Vector;

    	if ($b3)
    	{
    	    v = new Vector(p1.x-p2.x,p1.y-p2.y,p1.z-p2.z);
    	    w = new Vector(p3.x-p2.x,p3.y-p2.y,p3.z-p2.z);
    	}
    	else
    	{
    	    v = new Vector(p1.x-p2.x,p1.y-p2.y);
    	    w = new Vector(p3.x-p2.x,p3.y-p2.y);
    	}

    	return (v.angleVector(w));
    }

}

