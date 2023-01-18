import com.architekture.controls.layout.Rect;
/**
 * 
 * Portions Copyright (C) 2005 by Allen Ellison
 * http://www.cs.umd.edu/hcil/treemaps
 * Free for commercial and non-commercial use

The contents of this class is subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in
compliance with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/.

Software distributed under the License is distributed on an "AS IS"
basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
the License for the specific language governing rights and limitations
under the License.

The Original Code is the Treemap Algorithms v1.0

The Initial Developers of the Original Code is Ben Bederson
and Martin Wattinberg.  
Copyright (C) 2001 University of Maryland, College Park, MD 20742.
All Rights Reserved.

Contributor(s): Ben Bederson; Martin Wattenberg

INTELLECTUAL PROPERTY NOTES

The Treemap Algorithms are copyrighted by the University of Maryland,
and are available for all users, in accordance with the Open Source
model. It is available as free software for license according to the
Mozilla Public License.

The University of Maryland is not responsible for applications which use
Treemap Algorithms that infringe on third party's intellectual
property protection such as patents.

 */
class com.architekture.controls.layout.SquarifiedLayout {
	public static var BEST:Number = 2, ALTERNATE:Number = 3;
	private static var orientation:Number;
	public static var VERTICAL:Number = 0;
	public static var HORIZONTAL:Number = 1;
	public static var ASCENDING:Number = 0;
	public static var DESCENDING:Number = 1;
	//	public var layout:Function;
	public function SquarifiedLayout (model:Object, width:Number, height:Number) {
		if (model) {
			layout (model.sort (sortDescend), 0, model.length - 1, new Rect (0, 0, width, height));
		}
	}
	public static function squareLayout (model:Object, bounds) {
		if (model) {
			layout (model.sort (sortDescend), 0, model.length - 1, bounds);
		}
	}
	public static function layout (items:Array, start:Number, end:Number, bounds:Object) {
		if (start > end) {
			return;
		}
		if (end - start < 2) {
			layoutBest (items, start, end, bounds);
			return;
		}
		var x:Number = bounds.x;
		var y:Number = bounds.y;
		var w:Number = bounds.w;
		var h:Number = bounds.h;
		var total:Number = totalSize (items, start, end);
		var mid:Number = start;
		var a:Number = items[start].size / total;
		//  what is getSize() precisely?
		var b:Number = a;
		if (w < h) {
			// height/width
			while (mid <= end) {
				var aspect:Number = normAspect (h, w, a, b);
				var q:Number = items[mid].size / total;
				if (normAspect (h, w, a, b + q) > aspect) {
					break;
				}
				mid++;
				b += q;
			}
			layoutBest (items, start, mid, new Rect (x, y, w, h * b));
			layout (items, mid + 1, end, new Rect (x, y + h * b, w, h * (1 - b)));
		}
		else {
			// width/height
			while (mid <= end) {
				var aspect:Number = normAspect (w, h, a, b);
				var q:Number = items[mid].size / total;
				if (normAspect (w, h, a, b + q) > aspect) {
					break;
				}
				mid++;
				b += q;
			}
			layoutBest (items, start, mid, new Rect (x, y, w * b, h));
			layout (items, mid + 1, end, new Rect (x + w * b, y, w * (1 - b), h));
		}
	}
	public static function layoutBest (items:Array, start:Number, end:Number, bounds:Object, order:Number) {
		if (order == undefined) {
			sliceLayout (items, start, end, bounds, bounds.w > bounds.h ? HORIZONTAL : VERTICAL, ASCENDING);
		}
		else {
			sliceLayout (items, start, end, bounds, bounds.w > bounds.h ? HORIZONTAL : VERTICAL, order);
		}
	}
	private static function aspect (big:Number, small:Number, a:Number, b:Number):Number {
		return (big * b) / (small * a / b);
	}
	private static function normAspect (big:Number, small:Number, a:Number, b:Number):Number {
		var x:Number = aspect (big, small, a, b);
		if (x < 1) {
			return 1 / x;
		}
		return x;
	}
	public static function totalSize (items:Array, start:Number, end:Number) {
		var sum:Number = 0;
		if (start == undefined) {
			return totalSize (items, 0, items.length - 1);
		}
		for (var i:Number = start; i <= end; i++) {
			sum += items[i].size;
		}
		return sum;
	}
	public static function sliceLayout (items:Array, start:Number, end:Number, bounds:Object, orientation:Number, order:Number) {
		var total = totalSize (items, start, end);
		var a:Number = 0;
		var vertical:Boolean = (orientation == VERTICAL);
		if (order == undefined) {
			order = ASCENDING;
		}
		for (var i = start; i <= end; i++) {
			var r:Object = new Object ();
			// rectangle
			var b:Number = items[i].size / total;
			if (vertical) {
				r.x = bounds.x;
				r.w = bounds.w;
				if (order == ASCENDING) {
					r.y = bounds.y + bounds.h * a;
				}
				else {
					r.y = bounds.y + bounds.h * (1 - a - b);
				}
				r.h = bounds.h * b;
			}
			else {
				if (order == ASCENDING) {
					r.x = bounds.x + bounds.w * a;
				}
				else {
					r.x = bounds.x + bounds.w * (1 - a - b);
				}
				r.w = bounds.w * b;
				r.y = bounds.y;
				r.h = bounds.h;
			}
			//            setBounds(items[i],r);
			items[i].bounds = r;
			a += b;
			/*			_root.beginFill(_global.fillColor,40);
			_root.lineStyle(_global.strokeWidth,0,100);
			_root.moveTo(r.x,r.y);
			_root.lineTo(r.x+r.w,r.y);
			_root.lineTo(r.x+r.w,r.y+r.h);
			_root.lineTo(r.x,r.y+r.h);
			_root.lineTo(r.x,r.y);
			_root.endFill();
			*/
		}
	}
	private static function sortDescend (a:Object, b:Object):Number {
		if (a.size < b.size) {
			return 1;
		}
		else if (a.size > b.size) {
			return -1;
		}
		else {
			return 0;
		}
	}
}
