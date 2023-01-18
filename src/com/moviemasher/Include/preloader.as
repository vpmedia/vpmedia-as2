
System.security.allowDomain(_global.root._url);
var tween;
function setProgress(n)
{
	if (tween) tween.fforward();
	tween = new mx.transitions.Tween(mask_mc, "_width", mx.transitions.easing.None.easeNone, mask_mc._width, Math.round((logo_mc._width * n) / 100), 1, true);

}

setProgress(10);