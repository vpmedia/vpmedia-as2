/**
* @class ParticleBehavior
* @author senocular
* @version 0.1.1
* @description 	Creates functions to be used for independantly moving particle movie clips.
*		Functions (or "behaviors" created with the ParticleBehavior class are self-
*		contained and are typically assigned to a particle movie clip's onEnterFrame
*		event handler. Particle movie clips you would create on your own
* @usage 	See: create, multiple.

*/

class ParticleBehavior {
	
	/**
	* @method [ Behavior Generation ]
	* @description The following methods generate behavior functions for your particles
	* @usage Static
	* @returns behavior functions
	*/
	
	/**
	* @method create
	* @description 	Returns an instance of the behavior function specified. Each time create
	*		is called, a new instance of the behavior specified is created with the
	*		properties specified in the optionsObject. For those options not specified
	*		in the optionsObject, defaults are provided
	* @usage 	<pre>myParticle.onEnterFrame = ParticleBehavior.create("behaviorname" [, optionsObject]);</pre>
	* @param 	behaviorname (String)	The name of the behavior to be created
	* @param 	optionsObject (String)	Optional; default: behavior defaults. An object of options related to the behavior
	* @returns 	behavior function
	*/
	public static function create(method, argumentsObject){
		if (!ParticleBehavior[method]) return false;
		return ParticleBehavior[method].apply(null, ParticleBehavior.generateArguments(method, argumentsObject));
	}
	
	/**
	* @method multiple
	* @description 	Returns an instance of a function that combines each behavior passed
	* @usage 	<pre>myParticle.onEnterFrame = ParticleBehavior.multiple(behavior [, behavior...]);</pre>
	* @param 	behavior (Function)	any number of comma separated particle behavior functions created with ParticleBehavior.create
	* @returns 	a single behavior function representing the actions of each passed
	*/
	public static function multiple(){
		var i, a = arguments, n = a.length;
		return function(){
			for(i=0;i<n;i++) a[i].call(this);
		}
	}
	
	
	private static function generateArguments(method, argumentsObject){
		var args = ParticleBehavior[method].defaults;
		var len = args.length;
		var argsList = new Array(len);
		for (var i=0; i<len; i++){
			argsList[i] = (argumentsObject[args[i].param] != undefined) ? argumentsObject[args[i].param] : args[i].value;
		}
		return argsList;
	}
	
	
	/**
	* @method [ Motion Behaviors ]
	* @description The following behaviors generate motion for particles
	* @usage Created through create or multiple
	* @returns behavior functions
	*/
	
	/**
	* @method fall
	* @description 	Falling motion behavior.  Moves a movie clip down (or up) along the y axis
	*		every frame with a speed yvelocity. Each frame yvelocity increases by gravity
	* @usage 	<pre>ParticleBehavior.create("fall", {gravity:2, yvelocity:5});</pre>
	* @param gravity (Number)	Optional; default: 1. Gravity property representing the amount added to the velocity each time the behavior is called
	* @param yvelocity (Number)	Optional; default: 0. Vertical velocity or the amount added to the behavior owner's _y property each time the behavior is called
	* @returns 	behavior function
	*/
	private static function fall(g, vy){
		return function(){
			this._y += (vy += g);
		}
	}
	
	/**
	* @method slide
	* @description 	Sliding motion behavior.  Moves a movie clip in any direction with a speed based
	*		on xvelocity and yvelocity. Each frame the velocities increase by x and y
	*		increases (yvelocity is also increased by gravity) through an additive
	*		process and are further affected by friction through a multiplication. 
	* @usage 	<pre>ParticleBehavior.create("slide", {xvelocity:1, xincrease:1, xfriction:.9});</pre>
	* @param xvelocity (Number)	Optional; default: 0. Horizontal velocity or the amount added to the behavior owner's _x property each time the behavior is called
	* @param yvelocity (Number)	Optional; default: 0. Vertical velocity or the amount added to the behavior owner's _y property each time the behavior is called
	* @param xincrease (Number)	Optional; default: 0. The amount added to the xvelocity each time the behavior is called
	* @param yincrease (Number)	Optional; default: 0. The amount added to the yvelocity each time the behavior is called
	* @param xfriction (Number)	Optional; default: 1. The amount multiplied to the xvelocity each time the behavior is called
	* @param yfriction (Number)	Optional; default: 1. The amount multiplied to the yvelocity each time the behavior is called
	* @param gravity (Number)	Optional; default: 0. Gravity property representing the amount added to the yvelocity each time the behavior is called
	* @returns 	behavior function.
	*/
	private static function slide(vx, vy, cx, cy, fx, fy, g){
		if (g) cy += g;
		return function(){
			this._x += vx = (vx + cx) * fx;
			this._y += vy = (vy + cy) * fy;
		}
	}
	
	/**
	* @method bounce
	* @description 	Bouncing motion behavior (2D).  Moves a movie clip in any direction with a speed
	*		based on xvelocity and yvelocity. Each frame the velocities increase by x and y
	*		increases (yvelocity is also increased by gravity) through an additive
	*		process and are further affected by friction through a multiplication. When the
	*		movie clip reaches the bounds, velocity is reversed creating a bounce.
	* @usage 	<pre>ParticleBehavior.create("bounce", {xvelocity:20, yvelocity:2, xfriction:.8, bounds:myClip.getBounds()});</pre>
	* @param xvelocity (Number)	Optional; default: 0. Horizontal velocity or the amount added to the behavior owner's _x property each time the behavior is called
	* @param yvelocity (Number)	Optional; default: 0. Vertical velocity or the amount added to the behavior owner's _y property each time the behavior is called
	* @param xincrease (Number)	Optional; default: 0. The amount added to the xvelocity each time the behavior is called
	* @param yincrease (Number)	Optional; default: 0. The amount added to the yvelocity each time the behavior is called
	* @param xfriction (Number)	Optional; default: 1. The amount multiplied to the xvelocity each time the behavior is called
	* @param yfriction (Number)	Optional; default: 1. The amount multiplied to the yvelocity each time the behavior is called
	* @param gravity (Number)	Optional; default: 0. Gravity property representing the amount added to the yvelocity each time the behavior is called
	* @param bounds (Object)	Optional; default: bounds of Stage. A bounds object (as given by getBounds) representing the area in which the movie clip will bounce
	* @returns 	behavior function.
	*/
	private static function bounce(vx, vy, cx, cy, fx, fy, g, b){
		var l = b.xMin;
		var t = b.yMin;
		var r = b.xMax;
		b = b.yMax;
		if (g) cy += g;
		return function(){
			this._x += vx = (vx + cx) * fx;
			this._y += vy = (vy + cy) * fy;
			if (this._x <= l){
				this._x = l;
				vx = Math.abs(vx);
			}else if (this._x >= r){
				this._x = r;
				vx = -Math.abs(vx);
			}
			if (this._y <= t){
				this._y = t;
				vy = Math.abs(vy);
			}else if (this._y >= b){
				this._y = b;
				vy = -Math.abs(vy);
			}
		}
	}
	
	/**
	* @method bounce3D
	* @description 	Bouncing motion behavior (3D).  Moves a movie clip in any direction with a speed
	*		based on xvelocity, yvelocity and zvelocity within 3D space. Each frame the velocities
	*		increase by x, y, and z increases (yvelocity is also increased by gravity) through an additive
	*		process and are further affected by friction through a multiplication. When the
	*		movie clip reaches the bounds, velocity is reversed creating a bounce.
	* @usage 	<pre>ParticleBehavior.create("bounce3D", {xvelocity:1, yvelocity:10, swap:true});</pre>
	* @param xvelocity (Number)	Optional; default: 0. Horizontal velocity or the amount added to the behavior owner's x position in 3D space each time the behavior is called
	* @param yvelocity (Number)	Optional; default: 0. Vertical velocity or the amount added to the behavior owner's y position in 3D space each time the behavior is called
	* @param zvelocity (Number)	Optional; default: 0. Forward velocity or the amount added to the behavior owner's z position in 3D space each time the behavior is called
	* @param xincrease (Number)	Optional; default: 0. The amount added to the xvelocity each time the behavior is called
	* @param yincrease (Number)	Optional; default: 0. The amount added to the yvelocity each time the behavior is called
	* @param zincrease (Number)	Optional; default: 0. The amount added to the zvelocity each time the behavior is called
	* @param xfriction (Number)	Optional; default: 1. The amount multiplied to the xvelocity each time the behavior is called
	* @param yfriction (Number)	Optional; default: 1. The amount multiplied to the yvelocity each time the behavior is called
	* @param zfriction (Number)	Optional; default: 1. The amount multiplied to the zvelocity each time the behavior is called
	* @param gravity (Number)	Optional; default: 0. Gravity property representing the amount added to the yvelocity each time the behavior is called
	* @param bounds (Object)	Optional; default: infinity except 0 for minimum y. A bounds object (as given by getBounds) with additional zMin and zMax properties representing the area in which the movie clip will bounce in 3D space
	* @param focallength (Number)	Optional; default: 300. The focal length to be applied to the 3D view of particles
	* @param swap (Boolean)	Optional; default: false. Determines whether or not swapDepths is used to control the arrangement of movie clips using this behavior in the 3D space
	* @returns 	behavior function.
	*/
	private static function bounce3D(x, y, z, vx, vy, vz, cx, cy, cz, fx, fy, fz, g, b, fl, w){
		var l = b.xMin;
		var r = b.xMax;
		var f = b.zMax;
		var k = b.zMin;
		var t = b.yMax;
		b = b.yMin;
		if (g) cy -= g;
		var s;
		return function(){
			x += vx = (vx + cx) * vx;
			y += vy = (vy + cy) * vy;
			z += vz = (vz + cz) * vz;
			if (x <= l){
				x = l;
				vx = Math.abs(vx);
			}else if (x >= r){
				x = r;
				vx = -Math.abs(vx);
			}
			if (y <= b){
				y = b;
				vy = Math.abs(vy);
			}else if (y >= t){
				y = t;
				vy = -Math.abs(vy);
			}
			if (z <= k){
				z = k;
				vz = Math.abs(vz);
			}else if (z >= f){
				z = f;
				vz = -Math.abs(vz);
			}
			s = fl/(fl + z);
			this._xscale = this._yscale = 100*s;
			this._x = x*s;
			this._y = -y*s;
			if (w) this.swapDepths(Math.round(s*1000));
		}
	}
	
	/**
	* @method size
	* @description 	Sizing behavior.  Scales a movie clip.
	* @usage 	<pre>ParticleBehavior.create("size", {xincrease:2, yincrease:2, use:"value"});</pre>
	* @param xincrease (Number)	Optional; default: 0. Amount of increase for sizing the movie clip along its local x axis
	* @param yincrease (Number)	Optional; default: 0. Amount of increase for sizing the movie clip along its local y axis
	* @param use (String)	Optional; values: "percent", "value"; default: "percent". Determines whether the movie clip is scaled through percent ("percent") or through added numeric values ("value"). If not "percent", "value" is implied
	* @returns 	behavior function
	*/
	private static function size(xs, ys, c){
		c = (c != "percent");
		var r;
		return function(){
			if (c){
				if (r = this._rotation) this._rotation = 0;
				this._width += xs;
				this._height += ys;
				if (r) this._rotation = r;
			}else{
				this._xscale += xs;
				this._yscale += ys;
			}
		}
	}
	
	/**
	* @method transparency
	* @description 	Transparency behavior.  Fades a movie clip.
	* @usage 	<pre>ParticleBehavior.create("transparency", {increase:-5});</pre>
	* @param increase (Number)	Optional; default: 1. Gravity property representing the amount added to the velocity each time the behavior is called
	* @param use (String)	Optional; values: "percent", "value"; default: "percent". Determines whether the movie clip is scaled through percent ("percent") or through added numeric values ("value"). If not "percent", "value" is implied
	* @returns 	behavior function
	*/
	private static function transparency(t){
		var a;
		return function(){
			if (a == undefined) a = this._alpha;
			this._alpha = a += t;
		}
	}
	
	/**
	* @method repel
	* @description 	Repelling motion behavior.  Creates a behavior that causes a movie clip to repel
	*		from a central location when a "repeller" (either the mouse or a movie clip) approches
	* @usage 	<pre>ParticleBehavior.create("repel", {x:100, y:100, repeller:my_mc});</pre>
	* @param x (Number)	Optional; default: current _x location. The origin x from which the movie clip is based and is repelled from
	* @param y (Number)	Optional; default: current _y location. The origin y from which the movie clip is based and is repelled from
	* @param repeller (MovieClip, Mouse)	Optional; default: Mouse. Object from which the clip is repelled.  If not a MovieClip, then Mouse can be specified to be repelled from the mouse
	* @param range (Number)	Optional; default: 100.  The range a which the repeller starts to repel the movie clip from it's origin
	* @param acceleration (Number)	Optional; default: .03. Acceleration factor for repelling movement
	* @param friction (Number)	Optional; default: .9. Friction factor for repelling movement
	* @returns 	behavior function
	*/
	private static function repel (x, y, o, r, a, f) {
		var d,dx,dy,vx,vy,v;
		return function(){
			if (x == undefined) x = this._x;
			if (y == undefined) y = this._y;
			if (o == Mouse){
				dx = this._parent._xmouse - this._x;
				dy = this._parent._ymouse - this._y;
			}else{
				dx = o._x - this._x;
				dy = o._y - this._y;
			}
			d = Math.sqrt(dx*dx + dy*dy);
			if (d < r) {
				var v = d*r*a;
				if (v != 0){
					vx -= dx/v;
					vy -= dy/v;
				}
			}
			this._x += (vx = (vx + (x - this._x)*a)*f);
			this._y += (vy = (vy + (y - this._y)*a)*f);
		}
	}
	
	/**
	* @method avoid
	* @description 	Avoiding motion behavior.  Creates a behavior that causes a movie clip to avoid
	*		a movie clip or the mouse.
	* @usage 	<pre>ParticleBehavior.create("avoid", {velocity:2, range:50, avoid:my_mc});</pre>
	* @param avoid (MovieClip, Mouse)	Optional; default: Mouse. Object the clip is to avoid.  If not a MovieClip, then Mouse can be specified to be avoided
	* @param range (Number)	Optional; default: 100.  The range a which the movie clip starts to avoid the avoid object 
	* @param velocity (Number)	Optional; default: 1. Speed at which the movie clip avoids the avoid object. When acceleration is involved, this is a max speed.
	* @param acceleration (Number)	Optional; default: 0. Acceleration factor for avoiding movement
	* @param friction (Number)	Optional; default: 0. Friction factor for avoiding movement
	* @returns 	behavior function
	*/
	private static function avoid(o, r, v, a, f){
		var d,dx,dy,vx=0,vy=0,t,tv=0;
		return function(){
			if (o == Mouse){
				dx = this._parent._xmouse - this._x;
				dy = this._parent._ymouse - this._y;
			}else{
				dx = o._x - this._x;
				dy = o._y - this._y;
			}
			d = Math.sqrt(dx*dx + dy*dy);
			if (d < r) {
				if (a && d) tv = Math.min(v, a*r/d);
				else tv = v;
				if (f) tv *= f;
				t = Math.atan2(dy, dx);
				vx = Math.cos(t);
				vy = Math.sin(t);
			}else if (f) tv *= f;
			else tv = 0;
			if (tv){
				this._x -= vx*tv;
				this._y -= vy*tv;
			}
		}
	}
	
	/**
	* @method constrain
	* @description 	Constraining behavior.  Constrains a movieclip within a boundary.
	* @usage 	<pre>ParticleBehavior.create("constrain", {bounds:my_mc.getBounds(), use:"bounds"});</pre>
	* @param bounds (Object)	Optional; default: bounds of Stage. A bounds object (as given by getBounds) representing the area in which the movie clip will be constrained
	* @param check (String)	Optional; values: "bounds", "center"; default: "bounds". Determines what part of the movie clip is to be checked when constraining, the movie clip's bounds ("bounds") or its center point ("center"). If not "bounds", "center" is implied
	* @returns 	behavior function
	*/
	private static function constrain(b, c){
		var l = b.xMin;
		var t = b.yMin;
		var r = b.xMax;
		b = b.yMax;
		c = (c != "bounds");
		var pb;
		return function(){
			if (c){
				if (this._x < l) this._x = l;
				else if (this._x > r) this._x = r;
				if (this._y < t) this._y = t;
				else if (this._y > b) this._y = b;
			}else{
				pb = this.getBounds(this._parent);
				if (pb.xMin < l) this._x = l - (pb.xMin - this._x);
				else if (pb.xMax > r) this._x = r - (pb.xMax - this._x);
				if (pb.yMin < t) this._y = t - (pb.yMin - this._y);
				else if (pb.yMax > b) this._y = b - (pb.yMax - this._y);
			}
		}
	}
	
	
	
	/**
	* @method [ Removal Behaviors ]
	* @description The following behaviors are used to remove particles
	* @usage Created through create or multiple
	* @returns behavior functions
	*/
	
	
	/**
	* @method boundsRemove
	* @description 	Removal behavior.  Removes a movie clip if it is no longer within the specified bounds.
	* @usage 	<pre>ParticleBehavior.create("boundsRemove", {bounds:my_mc.getBounds(), use:"bounds"});</pre>
	* @param bounds (Object)	Optional; default: bounds of Stage. A bounds object (as given by getBounds) representing the area in which the movie clip will be constrained
	* @param check (String)	Optional; values: "bounds", "center"; default: "bounds". Determines what part of the movie clip is to be checked when constraining, the movie clip's bounds ("bounds") or its center point ("center"). If not "bounds", "center" is implied
	* @returns 	behavior function
	*/
	private static function boundsRemove(b, c){
		var l = b.xMin;
		var t = b.yMin;
		var r = b.xMax;
		b = b.yMax;
		c = (c != "bounds");
		var pb;
		return function(){
			if (c){
				if (this._x < l || this._x > r || this._y < t || this._y > b) this.removeMovieClip();
			}else{
				pb = this.getBounds(this._parent);
				if (pb.xMax < l || pb.xMin > r || pb.yMax < t || pb.yMin > b) this.removeMovieClip();
			}
		}
	}
	
	/**
	* @method timedRemove
	* @description 	Removal behavior.  Removes a movie clip after a specified time (ms).
	* @usage 	<pre>ParticleBehavior.create("timedRemove", {time:3000});</pre>
	* @param time (Number)	Optional; default: 1000. Time in milliseconds to wait before removing the clip.  Removal will only occur when the behavior is called
	* @returns 	behavior function
	*/
	private static function timedRemove(t){
		var s = getTimer();
		return function(){
			if ((getTimer()-s) >= t) this.removeMovieClip();
		}
	}
	
	/**
	* @method framesRemove
	* @description 	Removal behavior.  Removes a movie clip after a specified frames.
	* @usage 	<pre>ParticleBehavior.create("framesRemove", {frames:60});</pre>
	* @param frames (Number)	Optional; default: 100. Number of frames to wait before removing the clip.  Removal will only occur when the behavior is called
	* @returns 	behavior function
	*/
	private static function framesRemove(f){
		var e = 0;
		return function(){
			if ((++e) >= f) this.removeMovieClip();
		}
	}
	
	/**
	* @method changeInPositionRemove
	* @description 	Removal behavior.  Removes a movie clip after a specified frames.
	* @usage 	<pre>ParticleBehavior.create("changeInPositionRemove", {distance:100, check:"less"});</pre>
	* @param distance (Number)	Optional; default: 10. Distance to check between the current location and the last recorded location
	* @param check (String)	Optional; values: "greater", "less"; default: "greater". Determines whether distance is checked to be greater than or less than the specified distance for removal. If not "greater", "less" is implied
	* @returns 	behavior function
	*/
	private static function changeInPositionRemove(d, c){
		var d = d*d;
		var x,y,dx,dy;
		c = (c != "greater");
		return function(){
			if (x != undefined){
				dx = x - this._x;
				dy = y - this._y;
				if (c){
					if (d >= (dx*dx + dy*dy)) this.removeMovieClip();
				}else{
					if (d <= (dx*dx + dy*dy)) this.removeMovieClip();
				}
			}
			x = this._x;
			y = this._y;
		}
	}
	
	/**
	* @method distanceRemove
	* @description 	Removal behavior.  Removes a movie clip after its a certain distance from a point.
	* @usage 	<pre>ParticleBehavior.create("distanceRemove", {x:50, y75, distance:50});</pre>
	* @param x (Number)	Optional; default: current _x location.  The origin x from which distance is to be checked
	* @param y (Number)	Optional; default: current _y location.  The origin y from which distance is to be checked
	* @param distance (Number)	Optional; default: 100. Distance to check between the current location and the last recorded location
	* @returns 	behavior function
	*/
	private static function distanceRemove(x, y, d){
		var d = d*d;
		var dx,dy;
		return function(){
			if (x == undefined) x = this._x;
			if (y == undefined) y = this._y;
			dx = x - this._x;
			dy = y - this._y;
			if (d >= (dx*dx + dy*dy)) this.removeMovieClip();
		}
	}
	
	/**
	* @method distanceTraveledRemove
	* @description 	Removal behavior.  Removes a movie clip after it has traveled a certain distance.
	* @usage 	<pre>ParticleBehavior.create("distanceTraveledRemove", {distance:600});</pre>
	* @param distance (Number)	Optional; default: 100. Distance traveled before removal
	* @returns 	behavior function
	*/
	private static function distanceTraveledRemove(d){
		var d = d*d;
		var x,y,dx,dy,dt=0;
		return function(){
			if (x != undefined){
				dx = x - this._x;
				dy = y - this._y;
				dt += (dx*dx + dy*dy);
				if (d >= dt) this.removeMovieClip();
			}
			x = this._x;
			y = this._y;
		}
	}
	
	/**
	* @method sizeRemove
	* @description 	Removal behavior.  Removes a movie clip after it reaches a certain size. Size is based on local coordinate space
	* @usage 	<pre>ParticleBehavior.create("sizeRemove", {distance:600});</pre>
	* @param minwidth (Number)	Optional; default: 1. The minimum width the movie clip can reach before removal
	* @param minheight (Number)	Optional; default: 1. The minimum height the movie clip can reach before removal
	* @param maxwidth (Number)	Optional; default: 100. The maximum width the movie clip can reach before removal
	* @param maxheight (Number)	Optional; default: 100. The maximum height the movie clip can reach before removal
	* @param check (String)	Optional; values: "both", "single"; default: "both". Determines whether or not both height and width are checked for removal. If not "both", "single" is implied
	* @returns 	behavior function
	*/
	private static function sizeRemove(nw, nh, xw, xh, c){
		c = (c != "both");
		var r;
		return function(){
			if (r = this._rotation) this._rotation = 0;
			if (c){
				if (nw && nw > this._width) this.removeMovieClip();
				if (nh && nh > this._height) this.removeMovieClip();
				if (xw && xw < this._width) this.removeMovieClip();
				if (xh && xh < this._height) this.removeMovieClip();
			}else{
				if (nw && nh && nw > this._width && nh > this._height) this.removeMovieClip();
				if (xw && xh && xw < this._width && xh < this._height) this.removeMovieClip();
			}
			if (r) this._rotation = r;
		}
	}
	
	
	/* DFAULTS */
	
	private static function generateDefaults(){
		fall.defaults = [
			{param:"gravity", value:1},
			{param:"yvelocity", value:0}
		];
		slide.defaults = [
			{param:"xvelocity", value:0},
			{param:"yvelocity", value:0},
			{param:"xincrease", value:0},
			{param:"yincrease", value:0},
			{param:"xfriction", value:1},
			{param:"yfriction", value:1},
			{param:"gravity", value:0}
		];
		bounce.defaults = [
			{param:"xvelocity", value:0},
			{param:"yvelocity", value:0},
			{param:"xincrease", value:0},
			{param:"yincrease", value:0},
			{param:"xfriction", value:1},
			{param:"yfriction", value:1},
			{param:"gravity", value:0},
			{param:"bounds", value:{xMin: 0, yMin: 0, xMax: Stage.width, yMax: Stage.height}}
		];
		bounce3D.defaults = [
			{param:"x", value:0},
			{param:"y", value:0},
			{param:"z", value:0},
			{param:"xvelocity", value:0},
			{param:"yvelocity", value:0},
			{param:"zvelocity", value:0},
			{param:"xincrease", value:0},
			{param:"yincrease", value:0},
			{param:"zincrease", value:0},
			{param:"xfriction", value:0},
			{param:"yfriction", value:0},
			{param:"zfriction", value:0},
			{param:"gravity", value:0},
			{param:"bounds", value:{
					xMin:Number.NEGATIVE_INFINITY,	yMin:0,						zMin:Number.NEGATIVE_INFINITY,
					xMax:Number.POSITIVE_INFINITY,	yMax:Number.POSITIVE_INFINITY,	zMax:Number.POSITIVE_INFINITY
				}
			},
			{param:"focallength", value:300},
			{param:"swap", value:false}
		];
		size.defaults = [
			{param:"xincrease", value:0},
			{param:"yincrease", value:0},
			{param:"use", value:"percent"} /* "percent" or "value", "value" implied if not "percent" */
		];
		transparency.defaults = [
			{param:"increase", value:0}
		];
		repel.defaults = [
			{param:"x", value:undefined},
			{param:"y", value:undefined},
			{param:"repeller", value:Mouse},
			{param:"range", value:100},
			{param:"acceleration", value:.03},
			{param:"friction", value:.9}
		];
		avoid.defaults = [
			{param:"avoid", value:Mouse},
			{param:"range", value:100},
			{param:"velocity", value:1},
			{param:"acceleration", value:0},
			{param:"friction", value:0}
		];
		constrain.defaults = [
			{param:"bounds", value:{xMin: 0, yMin: 0, xMax: Stage.width, yMax: Stage.height}},
			{param:"check", value:"bounds"} /* "bounds" or "center", "center" implied if not "bounds" */
		];
		
		boundsRemove.defaults = [
			{param:"bounds", value:{xMin: 0, yMin: 0, xMax: Stage.width, yMax: Stage.height}},
			{param:"check", value:"bounds"} /* "bounds" or "center", "center" implied if not "bounds" */
		];
		timedRemove.defaults = [
			{param:"time", value:1000}  
		];
		framesRemove.defaults = [
			{param:"frames", value:100}  
		];
		changeInPositionRemove.defaults = [
			{param:"distance", value:10},
			{param:"check", value:"greater"} /* "greater" or "less", "less" implied if not "greater" */
		];
		distanceRemove.defaults = [
			{param:"x", value:undefined},
			{param:"y", value:undefined},
			{param:"distance", value:100}
		];
		distanceTraveledRemove.defaults = [
			{param:"distance", value:100}  
		];
		sizeRemove.defaults = [
			{param:"minwidth", value:1},
			{param:"minheight", value:1},
			{param:"maxwidth", value:100},
			{param:"maxheight", value:100},
			{param:"check", value:"both"} /* "both" or "single", "single" implied if not "both" */
		];
		return true;
	}
	
	private static var $defaults = generateDefaults();
}