/* START GLOBAL DEFINITIONS*/
XML.prototype.ignoreWhite = true;
var mp = MovieClip.prototype;
/**
 * <p>Description: add properties</p>
 *
 * @author András Csizmadia
 * @version 1.0
 */
mp.addProperty ("_r", function ()
{
	return Math.round (this._r);
}, function (value)
{
	this._r = Math.round (value);
});
//
mp.addProperty ("_left", function ()
{
	return this.getBounds (this._parent).xmin;
}, function (x)
{
	this._x = x - this.getBounds ().xmin;
});
mp.addProperty ("_right", function ()
{
	return this.getBounds (this._parent).xmax;
}, function (x)
{
	this._x = x - this.getBounds ().xmax;
});
mp.addProperty ("_top", function ()
{
	return this.getBounds (this._parent).ymin;
}, function (y)
{
	this._y = y - this.getBounds ().ymin;
});
mp.addProperty ("_bottom", function ()
{
	return this.getBounds (this._parent).ymax;
}, function (y)
{
	this._y = y - this.getBounds ().ymax;
});
mp.addProperty ("_xcenter", function ()
{
	var b = this.getBounds (this._parent);
	return (b.xmax + b.xmin) / 2;
}, function (x)
{
	var b = this.getBounds (this);
	this._x = x - (b.xmax + b.xmin) / 2;
});
mp.addProperty ("_ycenter", function ()
{
	var b = this.getBounds (this._parent);
	return (b.ymax + b.ymin) / 2;
}, function (y)
{
	var b = this.getBounds (this);
	this._y = y - (b.ymax + b.ymin) / 2;
});
//
mp.addProperty ('_path', function ()
{
	if (this._path == undefined)
	{
		var a = this._url.split ('/');
		a.pop ();
		this._path = a.join ('/') + '/';
	}
	return this._path;
}, null);
//
function showProto ()
{
	trace ("**Additional Prototypes**");
	trace ("MovieClip: _ycenter, _xcenter, _bottom, _top, _right, _left, _r, _path");
}
showProto ();
delete showProto;
ASSetPropFlags (mp, "_ycenter", 1, 0);
ASSetPropFlags (mp, "_xcenter", 1, 0);
ASSetPropFlags (mp, "_bottom", 1, 0);
ASSetPropFlags (mp, "_top", 1, 0);
ASSetPropFlags (mp, "_right", 1, 0);
ASSetPropFlags (mp, "_left", 1, 0);
ASSetPropFlags (mp, "_r", 1, 0);
ASSetPropFlags (mp, "_path", 1, 0);
delete mp;
