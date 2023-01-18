// create short ref.
var mp = MovieClip.prototype;

// _x -> x
mp.addProperty ("x",function (){return this._x;},function (value){this.x = this._y = value;});
ASSetPropFlags (mp,"x",1,0);

// _y -> y
mp.addProperty ("y",function (){return this._y;},function (value){this.y = this._y = value;});
ASSetPropFlags (mp,"y",1,0);

// _xscale -> xscale - as2 uses 0 to 100, as3 uses 0 to 1
mp.addProperty ("xscale",function (){return this._xscale;},function (value){this.xscale = this._yscale = value;});
ASSetPropFlags (mp,"xscale",1,0);

// _yscale -> yscale - as2 uses 0 to 100, as3 uses 0 to 1
mp.addProperty ("yscale",function (){return this._yscale;},function (value){this.yscale = this._yscale = value;});
ASSetPropFlags (mp,"yscale",1,0);

// _alpha -> alpha - as2 uses 0 to 100, as3 uses 0 to 1
mp.addProperty ("alpha",function (){return this._alpha;},function (value){this.alpha = this._alpha = value;});
ASSetPropFlags (mp,"alpha",1,0);

// _rotation -> rotation
mp.addProperty ("rotation",function (){return this._rotation;},function (value){this.rotation = this._rotation = value;});
ASSetPropFlags (mp,"rotation",1,0);

// gc
delete mp;