/**
 * @class       com.wis.math.alg.Vector
 * @author      Richard Wright
 * @version     1.7
 * @description Implements the behaviours of the Vector Class. Provides instance
 *              and static methods for manipulation of a Vector object.
 *              <p>
 *              I've swayed from using '$' as a class-based variable identifier for
 *              this class due to the increased usage of UI-defined class variables
 *              for this group of classes: Point, Vector, Quaternion, Col, and ColMC
 *              classes all reflect this format. Also, there are method duplications
 *              to support calls from other classes which can referenced through
 *              ClassInstanceName.classMethod() or the static Vector.classMethod().
 * @usage       <pre>var inst:Vector = new Vector(vx,vy[,vz]);</pre>
 * @param       vx (Number)  -- x-axis value of vector.
 * @param       vy (Number)  -- y-axis value of vector.
 * @param       vz (Number)  -- z-axis value of vector.
 * -----------------------------------------------
 * Latest update: August 13, 2004
 * -----------------------------------------------
 * Dependency:    com.wis.math.geom.util.Transformation
 * -----------------------------------------------
 * AS2 revision copyright: ? 2003, Richard Wright   [wisolutions2002@shaw.ca]
 * JS  original copyright: ? 2003, John Haggerty    [http://www.slimeland.com/]
 * AS1 original copyright: ? 2002, Brandon Williams [brandon@plotdev.com]
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
 *       Vector(x,y) or (x,y,z)
 *           1.  toString()
 *           2.  resetComponents(vx,vy,vz)
 *           3.  copyComponents(V)
 *           4.  incrementX(incX)
 *           5.  incrementY(incY)
 *           6.  incrementZ(incZ)
 *           7.  incrementComponents(incX,incY,incZ)
 *           8.  adds(V)
 *           9.  returnAddition(V)
 *           10. subtract(V)
 *           11. returnSubtraction(V)
 *           12  scalar(s)
 *           13. returnScalar(s)
 *           14. scalarComponent(V)
 *           15. divide(s)
 *           16. returnDivide(s)
 *           17. dotProduct(V)
 *           18. crossProduct(V)
 *           19. norm()
 *           20. unitVector()
 *           21. normalize()
 *           22. swap(V)
 *           23. angleVector(V)
 *           24. areaPara(V)
 *           25. areaTriangle(A,B)
 *           26. volumePara3d(A,B)
 *           27. perp()
 *           28. fromPointVals(x1,x2,y1,y2,z1,z2)
 *           29. equal(V)
 *           30. sameDirection(V)
 *           31. greater(V)
 *           32. greaterEqual(V)
 *           33. less(V)
 *           34. lessEqual(V)
 *           35. round3(x)
 *           36. inv()
 *           37. get _len()
 *           38. get _lenSq()
 *           39. copy()
 *           40. transform(trans,dontTranslate)
 *           41. transformed(trans,dontTranslate)
 *       - static methods
 *           42. normalizer(vec)
 *           43. neg(v)
 *           44. adder(v1,v2)
 *           45. scaler(v1,s)
 *           46. compare(v1,v2)
 *           47. mult(v1,v2)
 *           48. dot(v1,v2)
 *           49. cross(v1,v2)
 * -----------------------------------------------
 * Updates may be available at:
 *             http://members.shaw.ca/flashprogramming/wisASLibrary/wis/
 * -----------------------------------------------
**/

import com.wis.math.geom.util.Transformation;

// Transformation class variables reference:
// var $vx,$vy,$vz,$c:Vector;
// var $identity:Boolean;
// var $inverse:Transformation;

class com.wis.math.alg.Vector
{
	/**
	 * @property x  (Number)  -- x-axis value of vector.
	 * @property y  (Number)  -- y-axis value of vector.
	 * @property z  (Number)  -- z-axis value of vector.
     * @property $b3  (Boolean)  -- flags three dimensional vector object.
	 * @property XX  (Vector)  -- static -- x-axis identity vector.
	 * @property YY  (Vector)  -- static -- y-axis identity vector.
	 * @property ZZ  (Vector)  -- static -- z-axis identity vector.
	 * @property OO  (Vector)  -- static -- transform identity vector.
	**/
    var x:Number;
    var y:Number;
    var z:Number;
    var $b3:Boolean;
	static var XX:Vector = new Vector(1,0,0);
	static var YY:Vector = new Vector(0,1,0);
	static var ZZ:Vector = new Vector(0,0,1);
    static var OO:Vector = new Vector(0,0,0);

    // constructor
    function Vector(vx:Number,vy:Number,vz:Number)
    {
	    x = vx;
	    y = vy;
	    z = vz;
		if (vz!=undefined) $b3 = true;
		else $b3 = false;
    }

// 1. toString

    /**
     * @method  toString
     * @description  Prepares a string containing class properties.
     * @usage  <pre>inst.toString();</pre>
     * @return  (String)  -- returns a string containing 2d or 3d class properties.
    **/
    function toString():String
    {
	    var s:String;

	    if ($b3) s = ("["+x+","+y+","+z +"]");
	    else s = ("["+x+","+y+"]");

	    return s;
    }

// 2. resetComponents

    /**
     * @method  resetComponents
     * @description  Resets class properties for this instance.
     * @usage  <pre>inst.resetComponents(vx,vy,vz);</pre>
     * @param   vx   (Number)  -- a real number for x-axis.
     * @param   vy   (Number)  -- a real number for y-axis.
     * @param   vz   (Number)  -- a real number for z-axis.
     * @return  (Void)
    **/
    function resetComponents(vx:Number,vy:Number,vz:Number):Void
    {
	    x = vx;
	    y = vy;
	    if ($b3) z = vz;
    }

// 3. copyComponents

    /**
     * @method  copyComponents
     * @description  Creates a new Vector using this instance's properties.
     * @usage  <pre>inst.copyComponents(V);</pre>
     * @param   V   (Vector)  -- a 2d or 3d Vector object.
     * @return  (Void)
    **/
    function copyComponents(V:Vector):Void
    {
	    x = V.x;
	    y = V.y;
	    if ($b3) z = V.z;
    }

// 4. incrementX

    /**
     * @method  incrementX
     * @description  Adds input to instance x-component.
     * @usage  <pre>inst.incrementX(incX);</pre>
     * @param   incX   (Number)  -- a real number.
     * @return  (Void)
    **/
    function incrementX(incX:Number):Void
    {
	    x += incX;
    }

// 5. incrementY

    /**
     * @method  incrementY
     * @description  Adds input to instance y-component.
     * @usage  <pre>inst.incrementY(incY);</pre>
     * @param   incY   (Number)  -- a real number.
     * @return  (Void)
    **/
    function incrementY(incY:Number):Void
    {
	    y += incY;
    }

// 6. incrementZ

    /**
     * @method  incrementZ
     * @description  Adds input to instance z-component.
     * @usage  <pre>inst.incrementZ(incZ);</pre>
     * @param   incZ   (Number)  -- a real number.
     * @return  (Void)
    **/
    function incrementZ(incZ:Number):Void
    {
	    if ($b3) z += incZ;
    }

// 7. incrementComponents

    /**
     * @method  incrementComponents
     * @description  Adds input values to instance properties.
     * @usage  <pre>inst.incrementComponents(incX,incY,incZ);</pre>
     * @param   incX   (Number)  -- a real number.
     * @param   incY   (Number)  -- a real number.
     * @param   incZ   (Number)  -- a real number.
     * @return  (Void)
    **/
    function incrementComponents(incX:Number,incY:Number,incZ:Number):Void
    {
	    x += incX;
	    y += incY;
	    if ($b3) z += incZ;
    }

// 8. adds

    /**
     * @method  adds
     * @description  Adds Vector input to this instance.
     * @usage  <pre>inst.adds(V);</pre>
     * @param   V   (Vector)  -- a Vector object in 2d or 3d.
     * @return  (Vector)  -- returns this instance with incremented properties.
    **/
    function adds(V:Vector):Vector
    {
	    x += V.x;
	    y += V.y;
	    if ($b3) z += V.z;

	    return this;
    }

// 9. returnAddition

    /**
     * @method  returnAddition
     * @description    Adds Vector input to this instance.
     * @usage  <pre>inst.returnAddition(V);</pre>
     * @param   V   (Vector)  -- a Vector object in 2d or 3d.
     * @return  (Vector)  -- returns a new Vector with result of addition.
    **/
    function returnAddition(V:Vector):Vector
    {
        var v:Vector;

	    if ($b3) v = new Vector((x+V.x),(y+V.y),(z+V.z));
	    else v = new Vector((x+V.x),(y+V.y));

	    return v;
    }

// 10. subtract

    /**
     * @method  subtract
     * @description  Subtracts Vector input from this instance.
     * @usage  <pre>inst.subtract(V);</pre>
     * @param   V   (Vector)  -- a Vector object in 2d or 3d.
     * @return  (Vector)  -- returns this instance with decremented properties.
    **/
    function subtract(V:Vector):Vector
    {
	    x -= V.x;
	    y -= V.y;
	    if ($b3) z -= V.z;

	    return this;
    }

// 11. returnSubtraction

    /**
     * @method  returnSubtraction
     * @description  Subtracts Vector input from this instance.
     * @usage  <pre>inst.returnSubtraction(V);</pre>
     * @param   V   (Vector)  -- a Vector object in 2d or 3d.
     * @return  (Vector)  -- returns a new Vector object with result of subtraction.
    **/
    function returnSubtraction(V:Vector):Vector
    {
        var v:Vector;

	    if ($b3) v = new Vector((x-V.x),(y-V.y),(z-V.z));
	    else v = new Vector((x-V.x),(y-V.y));

	    return v;
    }

// 12. scalar

    /**
     * @method  scalar
     * @description  Scales this instance by input value.
     * @usage  <pre>inst.scalar(s);</pre>
     * @param   s   (Number)  -- a real number.
     * @return  (Void)
    **/
    function scalar(s:Number):Void
    {
	    x *= s;
	    y *= s;
	    if ($b3) z *= s;
    }

// 13. returnScalar

    /**
     * @method  returnScalar
     * @description  Scales this instance by input value.
     * @usage  <pre>inst.returnScalar(s);</pre>
     * @param   s   (Number)  -- a real number.
     * @return  (Vector)  -- returns a new Vector with scaled result.
    **/
    function returnScalar(s:Number):Vector
    {
        var v:Vector;

        if ($b3) v = new Vector(x*s,y*s,z*s);
        else v = new Vector(x*s,y*s);

        return v;
    }

// 14. scalarComponent
//- scalar component in the direction of 'V'

    /**
     * @method  scalarComponent
     * @description  Scalar component in the direction of 'V'.
     * @usage  <pre>inst.scalarComponent(V);</pre>
     * @param   V   (Vector)   -- an object which defines direction vector.
     * @return  (Number)  -- returns scalar component in the direction of 'V'.
    **/
    function scalarComponent(V:Vector):Number
    {
	    var a:Vector;

	    if ($b3) a = new Vector(x,y,z);
	    else a = new Vector(x,y);
	    a.unitVector(V);

	    return this.dotProduct(a);
    }

// 15. divide

    /**
     * @method  divide
     * @description  Divides this instance by input value.
     * @usage  <pre>inst.divide(s);</pre>
     * @param   s   (Number)  -- a real number.
     * @return  (Vector)  -- returns this instance divided by input scalar.
    **/
    function divide(s:Number):Vector
    {
        x /= s;
        y /= s;
        if ($b3) z /= s;

        return this;
    }

// 16. returnDivide

    /**
     * @method  returnDivide
     * @description  Divides this instance by input value.
     * @usage  <pre>inst.returnDivide(s);</pre>
     * @param   s   (Number)  -- a real number.
     * @return  (Vector)  -- returns a new Vector object populated with this instance divided by input scalar.
    **/
    function returnDivide(s:Number):Vector
    {
        var v:Vector;

        if ($b3) v = new Vector(x/s,y/s,z/s);
        else v = new Vector(x/s,y/s);

        return v;
    }

// 17. dotProduct

    /**
     * @method  dotProduct
     * @description  Calculates the dot product of this instance and 'V'.
     * @usage  <pre>inst.dotProduct(V);</pre>
     * @param   V   (Vector)  -- an object which defines passed direction vector.
     * @return  (Number)  -- returns the dot product of this instance and 'V'.
    **/
    function dotProduct(V:Vector):Number
    {
        var n:Number;

	    if ($b3) n = (x*V.x)+(y*V.y)+(z*V.z);
	    else n = (x*V.x)+(y*V.y);

	    return n;
    }

// 18. crossProduct

    /**
     * @method  crossProduct
     * @description  Calculates the cross product of this instance and 'V'. 2D ref:
     *               <a href='http://mathquest.com/discuss/sci.math/a/m/415647/415659'>2D Cross Product</a>.
     * @usage  <pre>inst.crossProduct(V);</pre>
     * @param   V   (Vector)  -- an object which defines passed direction vector.
     * @return  (Vector)  -- returns a new Vector object populated with the cross product of this instance and 'V'.
    **/
    function crossProduct(V:Vector):Vector
    {
	    var cross:Vector = new Vector(0.0,0.0,0.0);

	    if ($b3)
	    {
			cross.x = (y*V.z)-(z*V.y);
			cross.y = (z*V.x)-(x*V.z);
	        cross.z = (x*V.y)-(y*V.x);
	    }
	    else
	    {
	        // ref: http://mathquest.com/discuss/sci.math/a/m/415647/415659
			cross.x = 0; //(y*V.z)-(z*V.y) = ((y*0)-(0*V.y) = 0
			cross.y = 0; //(z*V.x)-(x*V.z) = (0*V.x)-(x*0) = 0
	        cross.z = (x*V.y)-(y*V.x);
        }

	    return cross;
    }

// 19. norm

    /**
     * @method  norm
     * @description  Calculates normal of this instance.
     * @usage  <pre>inst.norm();</pre>
     * @return  (Number)  -- returns normal of this instance.
    **/
    function norm():Number
    {
        var n:Number;

	    if ($b3) n = Math.sqrt((x*x)+(y*y)+(z*z));
	    else n = Math.sqrt((x*x)+(y*y));

	    return n;
    }

// 20. unitVector

    /**
     * @method  unitVector
     * @description  Defines the unit vector of this instance.
     * @usage  <pre>inst.unitVector();</pre>
     * @return  (Vector)  -- returns a new Vector object populated with this instance's unit vector.
    **/
    function unitVector():Vector
    {
	    var unit:Vector;
	    var norm = this.norm();

	    if ($b3) unit = new Vector(x,y,z);
	    else unit = new Vector(x,y);
	    unit.x /= norm;
	    unit.y /= norm;
	    if ($b3) unit.z /= norm;

	    return unit;
    }

// 21. normalize

    /**
     * @method  normalize
     * @description  Normalizes this instance.
     * @usage  <pre>inst.normalize();</pre>
     * @return  (Void)
    **/
    function normalize():Void
    {
	    var norm = this.norm();

	    x /= norm;
	    y /= norm;
	    if ($b3) z /= norm;
    }

// 22. swap

    /**
     * @method  swap
     * @description  Swaps this instance's properties with 'V'.
     * @usage  <pre>inst.swap(V);</pre>
     * @param   V   (Vector)  -- a  Vector object input to swap properties.
     * @return  (Void)
    **/
    function swap(V:Vector):Void
    {
	    var tempX:Number,tempY:Number,tempZ:Number;

	    tempX = x;
	    tempY = y;
	    x = V.x;
	    y = V.y;
	    V.x = tempX;
	    V.y = tempY;
	    if ($b3)
	    {
	        tempZ = z;
	        z = V.z;
	        V.z = tempZ;
	    }
    }

// 23. angleVector

    /**
     * @method  angleVector
     * @description  Defines angle between this instance and 'V'.
     * @usage  <pre>inst.angleVector(V);</pre>
     * @param   V   (Vector)  -- a direction Vector object.
     * @return  (Number)  -- returns the angle between this instance and 'V'.
    **/
    function angleVector(V:Vector):Number
    {
	    return this.dotProduct(V)/(this.norm()*V.norm());
    }

// 24. areaPara

    /**
     * @method  areaPara
     * @description  Calculates the area of a parallelogram defined by this
     *               instance and the input vector.
     * @usage  <pre>inst.areaPara(V);</pre>
     * @param   V   (Vector)  -- a direction Vector object.
     * @return  (Number)  -- returns the area of a parallelogram defined by this instance and the input vector.
    **/
    function areaPara(V:Vector):Number
    {
	    var temp:Vector;

	    if ($b3) temp = new Vector(x,y,z);
	    else temp = new Vector(x,y);
	    temp.crossProduct(V);

	    return temp.norm();
    }

// 25. areaTriangle

    /**
     * @method  areaTriangle
     * @description  Calculates the area of a triangle defined by this
     *               instance and two input vectors.
     * @usage  <pre>inst.areaTriangle(A,B);</pre>
     * @param   A   (Vector)  -- a direction Vector object.
     * @param   B   (Vector)  -- a direction Vector object.
     * @return  (Number)  -- returns the area of a triangle defined by this instance and two input vectors.
    **/
    function areaTriangle(A:Vector,B:Vector):Number
    {
	    var v:Vector,w:Vector;

	    if ($b3)
	    {
	        v = new Vector(x,y,z);
	        w = new Vector(x,y,z);
	    }
	    else
	    {
	        v = new Vector(x,y);
	        w = new Vector(x,y);
	    }

	    v = this.subtract(A);
	    w = this.subtract(B);

	    return (.5*v.areaPara(w));
    }

// 26. volumePara3D

    /**
     * @method  volumePara3d
     * @description  Calculates the volume of a parallelepiped in 3-space defined
     *               by this instance and the input vector.
     * @usage  <pre>inst.volumePara3d(A,B);</pre>
     * @param   A   (Vector)  -- a direction Vector object.
     * @param   B   (Vector)  -- a direction Vector object.
     * @return  (Number)  -- returns the volume of a parallelepiped in 3-space defined by this instance and the input vector.
    **/
    function volumePara3d(A:Vector,B:Vector):Number
    {
	    var temp:Vector = new Vector(x,y,z);

	    temp = A.crossProduct(B);

	    return Math.abs(A.dotProduct(temp));
    }

// 27. perp

    /**
     * @method  perp
     * @description  Defines perpendicular direction vector of this instance.
     * @usage  <pre>inst.perp();</pre>
     * @return  (Vector)  -- returns perpendicular direction vector of this instance.
    **/
    function perp():Vector
    {
        var v:Vector;

        if ($b3) v = new Vector(-y,x,z);
        else v = new Vector(-y,x);

        return v;
    }

// 28. fromPointVals

//- originally used Point input, but importing the
    // Point class conflicted with cross import of Vector class within the
    // Point class .. input params are listed in axis pairs rather than in
    // point pairs to support both 2D and 3D

    /**
     * @method  fromPointVals
     * @description  Defines a new Vector object using input x, y, and z values.
     * @usage  <pre>inst.fromPointVals(x1,x2,y1,y2,z1,z2);</pre>
     * @param   x1   (Number)  -- a real number.
     * @param   x2   (Number)  -- a real number.
     * @param   y1   (Number)  -- a real number.
     * @param   y2   (Number)  -- a real number.
     * @param   z1   (Number)  -- a real number.
     * @param   z2   (Number)  -- a real number.
     * @return  (Vector)  -- returns a new Vector object using input x, y, and z values.
    **/
    function fromPointVals(x1:Number,x2:Number,y1:Number,y2:Number,z1:Number,z2:Number):Vector
    {
        var v:Vector;

        if (z1) v = new Vector(x2-x1,y2-y1,z2-z1);
        else v = new Vector(x2-x1,y2-y1);

        return v;
    }

// 29. equal

    /**
     * @method  equal
     * @description  Boolean 'equality' comparison of this instance and 'V'.
     * @usage  <pre>inst.equal(V);</pre>
     * @param   V   (Vector)  -- a direction Vector object.
     * @return  (Boolean)
    **/
    function equal(V:Vector):Boolean
    {
        var b:Boolean;

	    if ($b3) b = (round3(x)==round3(V.x)) && (round3(y)==round3(V.y)) && (round3(z)==round3(V.z));
	    else b = (round3(x)==round3(V.x)) && (round3(y)==round3(V.y));

	    return b;
    }

// 30. sameDirection

    /**
     * @method  sameDirection
     * @description  Boolean 'direction' comparison of this instance and 'V'.
     * @usage  <pre>inst.sameDirection(V);</pre>
     * @param   V   (Vector)  -- a direction Vector object.
     * @return  (Boolean)
    **/
    function sameDirection(V:Vector):Boolean
    {
	    var a:Vector,b:Vector;

	    if ($b3)
	    {
	        a = new Vector(x,y,z);
	        b = new Vector(x,y,z);
	    }
	    else
	    {
	        a = new Vector(x,y);
	        b = new Vector(x,y);
	    }

	    a.unitVector(this);
	    b.unitVector(V);

	    return a.equal(b);
    }

// 31. greater

    /**
     * @method  greater
     * @description  Boolean 'greater than' comparison of this instance and 'V'.
     * @usage  <pre>inst.greater(V);</pre>
     * @param   V   (Vector)  -- a direction Vector object.
     * @return  (Boolean)
    **/
    function greater(V:Vector):Boolean
    {
        var b:Boolean;

	    if ($b3) b = (round3(x)>round3(V.x)) && (round3(y)>round3(V.y)) && (round3(z)>round3(V.z));
	    else b = (round3(x)>round3(V.x)) && (round3(y)>round3(V.y));

	    return b;
    }

// 32. greaterEqual

    /**
     * @method  greaterEqual
     * @description  Boolean 'greater than or equal' comparison of this instance and 'V'.
     * @usage  <pre>inst.greaterEqual(V);</pre>
     * @param   V   (Vector)  -- a direction Vector object.
     * @return  (Boolean)
    **/
    function greaterEqual(V:Vector):Boolean
    {
        var b:Boolean;

	    if ($b3) b = (round3(x)>=round3(V.x)) && (round3(y)>=round3(V.y)) && (round3(z)>=round3(V.z));
	    else b = (round3(x)>=round3(V.x)) && (round3(y)>=round3(V.y));

	    return b;
    }

// 33. less

    /**
     * @method  less
     * @description  Boolean 'less than' comparison of this instance and 'V'.
     * @usage  <pre>inst.less(V);</pre>
     * @param   V   (Vector)  -- a direction Vector object.
     * @return  (Boolean)
    **/
    function less(V:Vector):Boolean
    {
        var b:Boolean;

	    if ($b3) b = (round3(x)<round3(V.x)) && (round3(y)<round3(V.y)) && (round3(z)<round3(V.z));
	    else b = (round3(x)<round3(V.x)) && (round3(y)<round3(V.y));

	    return b;
    }

// 34. lessEqual

    /**
     * @method  lessEqual
     * @description  Boolean 'less than or equal' comparison of this instance and 'V'.
     * @usage  <pre>inst.lessEqual(V);</pre>
     * @param   V   (Vector)  -- a direction Vector object.
     * @return  (Boolean)
    **/
    function lessEqual(V:Vector):Boolean
    {
        var b:Boolean;

	    if ($b3) b = (round3(x)<=round3(V.x)) && (round3(y)<=round3(V.y)) && (round3(z)<=round3(V.z));
	    else b = (round3(x)<=round3(V.x)) && (round3(y)<=round3(V.y));

	    return b;
    }

// 35. round3

    /**
     * @method  round3
     * @description  Rounds input value to 3 decimals.
     * @usage  <pre>inst.round3(n);</pre>
     * @param   n   (Number)  -- a real number.
     * @return  (Number)  -- returns the input value rounded to 3 decimals.
    **/
    function round3(n:Number):Number
    {
	    return Math.round(n*1000)/1000;
    }

// 36. inv

    /**
     * @method  inv
     * @description  Defines the inverse of this instance.
     * @usage  <pre>inst.inv();</pre>
     * @return  (Number)  -- returns a new Vector object, an inverse of this instance.
    **/
    function inv():Vector
    {
        return new Vector(1/x,1/y,1/z);
    }

// 37. get _len

    /**
     * @method  get _len
     * @description  Gets the magnitude of this instance.
     * @usage  <pre>inst._len;</pre>
     * @return  (Number)  -- returns the magnitude of this instance.
    **/
    function get _len():Number
    {
        return Math.sqrt(x*x+y*y+z*z);
    }

// 38. get _lenSq

    /**
     * @method  get _lenSq
     * @description  Gets the square of the magnitude of this instance.
     * @usage  <pre>inst._lenSq;</pre>
     * @return  (Number)  -- returns the square of the magnitude of this instance.
    **/
    function get _lenSq():Number
    {
        return x*x+y*y+z*z;
    }

// 39. copy

    /**
     * @method  copy
     * @description  Creates a copy of this instance.
     * @usage  <pre>inst.copy();</pre>
     * @return  (Vector)  -- returns a new Vector object, a copy of this instance.
    **/
    function copy():Vector
    {
    	return new Vector(x,y,z);
    }

// 40. transform

    /**
     * @method  transform
     * @description  Transforms this instance, with or without translation.
     * @usage  <pre>inst.transform(trans,dontTranslate);</pre>
     * @param   trans   (Transformation)  -- an object containing transformation matrix.
     * @param   dontTranslate   (Boolean)  -- if true, transform without translation.
     * @return  (Void)
    **/
    function transform(trans:Transformation,dontTranslate:Boolean):Void
    {
    	var newx:Number;
    	var newy:Number;
    	var newz:Number;

    	if (dontTranslate)
    	{
    		newx = Vector.dot(trans.$vx,this);
    		newy = Vector.dot(trans.$vy,this);
    		newz = Vector.dot(trans.$vz,this);
    	}
    	else
    	{
    		newx = Vector.dot(trans.$vx,this)+trans.$c.x;
    		newy = Vector.dot(trans.$vy,this)+trans.$c.y;
    		newz = Vector.dot(trans.$vz,this)+trans.$c.z;
    	}
    	x = newx;
    	y = newy;
    	z = newz;
    }

// 41. transformed

    /**
     * @method  transformed
     * @description  Creates a new Vector object with the transformation of
     *               this instance, with or without translation.
     * @usage  <pre>inst.transformed(trans,dontTranslate);</pre>
     * @param   trans   (Transformation)  -- an object containing transformation matrix.
     * @param   dontTranslate   (Boolean)    -- if true, transform without translation.
     * @return  (Vector)  -- a new Vector object with the result of tranform.
    **/
    function transformed(trans:Transformation,dontTranslate:Boolean):Vector
    {
    	if (dontTranslate)
    	{
    		return new Vector
    		(
    			Vector.dot(trans.$vx,this),
    			Vector.dot(trans.$vy,this),
    			Vector.dot(trans.$vz,this)
    		);
    	}
    	else
    	{
    		return new Vector
    		(
    			Vector.dot(trans.$vx,this)+trans.$c.x,
    			Vector.dot(trans.$vy,this)+trans.$c.y,
    			Vector.dot(trans.$vz,this)+trans.$c.z
    		);
    	}
    }

//////////////////////////////////
// Static Methods
//////////////////////////////////

// 42. normalizer

    /**
     * @method  normalizer
     * @description  Static -- creates a new Vector object of the normalized input vector.
     * @usage  <pre>Vector.normalizer(vec);</pre>
     * @param   vec   (Vector)  -- a direction Vector object.
     * @return  (Vector)  -- returns a new Vector object of the normalized input vector.
    **/
    static function normalizer(vec:Vector):Vector
    {
        var l:Number = 1/vec._len;

        return new Vector(vec.x*l,vec.y*l,vec.z*l);
    }

// 43. neg

    /**
     * @method  neg
     * @description  Static -- creates a new Vector object of the negative of input vector.
     * @usage  <pre>Vector.neg(v);</pre>
     * @param   v   (Vector)  -- a direction Vector object.
     * @return  (Vector)  -- returns a new Vector object of the negative of input vector.
    **/
    static function neg(v:Vector):Vector
    {
        return new Vector(-v.x,-v.y,-v.z);
    }

// 44. adder

    /**
     * @method  adder
     * @description  Static -- creates a new Vector object from the addition of two input vectors.
     * @usage  <pre>Vector.adder(v1,v2);</pre>
     * @param   v1   (Vector)  -- a direction Vector object.
     * @param   v2   (Vector)  -- a direction Vector object.
     * @return  (Vector)  -- returns a new Vector object from the addition of two input vectors.
    **/
    static function adder(v1:Vector,v2:Vector):Vector
    {
    	return new Vector(v1.x+v2.x,v1.y+v2.y,v1.z+v2.z);
    }

// 45. scaler

    /**
     * @method  scaler
     * @description  Static -- creates a new Vector object from the scaled result
     *                         of input vector and scalar value.
     * @usage  <pre>Vector.scaler(v1,s);</pre>
     * @param   v1   (Vector)  -- a direction Vector object.
     * @param   s   (Number)  -- a real number.
     * @return  (Vector)  -- returns a new Vector object from the scaled result of input vector and scalar value.
    **/
    static function scaler(v1:Vector,s:Number):Vector
    {
    	return new Vector(v1.x*s,v1.y*s,v1.z*s);
    }

// 46. compare

    /**
     * @method  compare
     * @description Static -- Boolean comparison of two input vectors.
     * @usage  <pre>Vector.compare(v1,v2);</pre>
     * @param   v1   (Vector)  -- a direction Vector object.
     * @param   v2   (Vector)  -- a direction Vector object.
     * @return  (Boolean)
    **/
    static function compare(v1:Vector,v2:Vector):Boolean
    {
    	return (v1.x==v2.x && v1.y==v2.y && v1.z==v2.z);
    }

// 47. mult

    /**
     * @method  mult
     * @description  Static -- creates a new Vector object from the multiplication
     *                         of two input vectors.
     * @usage  <pre>Vector.mult(v1,v2);</pre>
     * @param   v1   (Vector)  -- a direction Vector object.
     * @param   v2   (Vector)  -- a direction Vector object.
     * @return  (Vector)  -- returns a new Vector object from the multiplication of two input vectors.
    **/
    static function mult(v1:Vector,v2:Vector):Vector
    {
    	return new Vector(v1.x*v2.x,v1.y*v2.y,v1.z*v2.z);
    }

// 48. dot

    /**
     * @method  dot
     * @description  Static -- defines the dot product of two input vectors.
     * @usage  <pre>Vector.dot(v1,v2);</pre>
     * @param   v1   (Vector)  -- a direction Vector object.
     * @param   v2   (Vector)  -- a direction Vector object.
     * @return  (Number)  -- returns the dot product of two input vectors.
    **/
    static function dot(v1:Vector,v2:Vector):Number
    {
    	return v1.x*v2.x+v1.y*v2.y+v1.z*v2.z;
    }

// 49. cross

    /**
     * @method  cross
     * @description  Static -- defines the cross product of two input vectors.
     * @usage  <pre>Vector.cross(v1,v2);</pre>
     * @param   v1   (Vector)  -- a direction Vector object.
     * @param   v2   (Vector)  -- a direction Vector object.
     * @return  (Vector)  -- returns the cross product of two input vectors.
    **/
    static function cross(v1:Vector,v2:Vector):Vector
    {
    	return new Vector
    	(
    	    v1.y*v2.z-v1.z*v2.y,
    	    v1.z*v2.x-v1.x*v2.z,
    	    v1.x*v2.y-v1.y*v2.x
    	);
    }

}

