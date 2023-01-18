/**
* @author Patrick Matte
* last revision January 30th 2006
*/
 
 class com.blitzagency.worldspace.cameras.FPSCamera extends com.blitzagency.worldspace.SpaceCamera{
	
	private var xmouseMemory:Number;
	private var ymouseMemory:Number;
	private var txMemory:Number;
	private var tyMemory:Number;
	private var tzMemory:Number;
	private var txTarget:Number;
	private var tyTarget:Number;
	private var tzTarget:Number;
	private var xTarget:Number;
	private var zTarget:Number;
	private var onMouseMove:Function;
	public var movementFactor:Number = 100;
	public var rotationFactor:Number = 2;
	public var inertia:Number = 5;
	
	public function FPSCamera(x:Number,y:Number,z:Number,tx:Number,ty:Number,tz:Number,fl:Number){
		super(x,y,z,tx,ty,tz,fl);
		txTarget = tx;
		tyTarget = ty;
		tzTarget = tz;
		xTarget = x;
		zTarget = z;
		Mouse.addListener(this);
	}
	
	private function onMouseDown():Void{
		xmouseMemory = _root._xmouse;
		ymouseMemory = _root._ymouse;
		txMemory = tx;
		tyMemory = ty;
		onMouseMove = rotate;
	}
	
	private function onMouseUp():Void{
		onMouseMove = undefined;
	}
	
	public function rotate():Void{
		var xMouse:Number = _root._xmouse;
		var yMouse:Number = _root._ymouse;
		txTarget = (ymouseMemory - yMouse)/rotationFactor + txMemory;
		tyTarget = (xmouseMemory - xMouse)/rotationFactor + tyMemory;
	}
	
	public function forward():Void{
		var radians:Number = (270-ty) * Math.PI/180;
		var xDelta = Math.cos(radians)*movementFactor;
		var zDelta = Math.sin(radians)*movementFactor*-1;			
		xTarget += xDelta ;
		zTarget += zDelta ;
	}

	public function backward():Void{
		var radians:Number = (270-ty) * Math.PI/180;
		var xDelta = Math.cos(radians)*-movementFactor;
		var zDelta = Math.sin(radians)*-movementFactor*-1;			
		xTarget += xDelta ;
		zTarget += zDelta ;
	}

	public function left():Void{
		var radians:Number = (270-ty-90) * Math.PI/180;
		var xDelta = Math.cos(radians)*movementFactor;
		var zDelta = Math.sin(radians)*movementFactor*-1;			
		xTarget += xDelta ;
		zTarget += zDelta ;
	}

	public function right():Void{
		var radians:Number = (270-ty+90) * Math.PI/180;
		var xDelta = Math.cos(radians)*movementFactor;
		var zDelta = Math.sin(radians)*movementFactor*-1;			
		xTarget += xDelta ;
		zTarget += zDelta ;
	}

	public function update(){
		if(Key.isDown(38) || Key.isDown(87)){
			forward();
		}
		if(Key.isDown(40) || Key.isDown(83)){
			backward();
		}
		if(Key.isDown(37) || Key.isDown(65)){
			left();
		}
		if(Key.isDown(39) || Key.isDown(68)){
			right();
		}
		// rotate camera
		tx = Math.round((tx+(txTarget-tx)/inertia)*10)/10;
		ty = Math.round((ty+(tyTarget-ty)/inertia)*10)/10;
		
		// move camera
		x = Math.round((x + (xTarget-x)/inertia)*10)/10;
		z = Math.round((z + (zTarget-z)/inertia)*10)/10;
	}

}