/*
===============================================================================
Real hidden methods/functions
-------------------------------------------------------------------------------
These functions are the real core of MC Tween. They control all tweenings, and
are kept separated from the methods themselves for organization's sake.
-------------------------------------------------------------------------------
*/

_global.$createTweenController = function() {
	// INTERNAL USE: Creates the tween controller that will do all tween updates remotely
	var tweenHolder = _root.createEmptyMovieClip ("__tweenController__", 123432); // Any level
	tweenHolder.$_tweenPropList = new Array();  // Will hold the list of properties beeing tweened. an array of objects.
	tweenHolder.$_tTime = getTimer();
	tweenHolder.onEnterFrame = _global.$updateTweens;
};
ASSetPropFlags(_global, "$createTweenController", 1, 0);

_global.$removeTweenController = function() {
	// INTERNAL USE: Destroys the tween controller in a centralized, clean, functional and paranoid way
	delete _root.__tweenController__.$_tweenPropList;
	delete _root.__tweenController__.$_tTime;
	delete _root.__tweenController__.onEnterFrame;
	_root.__tweenController__.removeMovieClip();
};
ASSetPropFlags(_global, "$removeTweenController", 1, 0);

_global.$addTween = function(mtarget, prop, propDest, timeSeconds, animType, delay, callback, extra1, extra2, extras) {
	// INTERNAL USE: Adds a new tween for an object

	// Sets default values if undefined/invalid
	if (timeSeconds == undefined) timeSeconds = 0; // default time length
	if (animType == undefined || animType == "") animType = "easeOutExpo"; // default equation!
	if (delay == undefined) delay = 0; // default delay

	// Starts tweening.. prepares to create handling mcs
	// Faster this way
	if (typeof(prop) == "string") {
		// Single property
		var properties = [prop]; // Properties, as in "_x"
		var oldProperties = [mtarget[prop]]; // Old value, as in 0
		var newProperties = [propDest]; // New (target) value, as in 100
	} else {
		// Array of properties
		// ****Hm.. this looks strange... test concat() for speed?
		var properties = []; // Properties, as in "_x"
		var oldProperties = []; // Old value, as in 0
		var newProperties = []; // New (target) value, as in 100
		for (var i in prop) oldProperties.push (mtarget[prop[i]]);
		for (var i in prop) properties.push (prop[i]);
		for (var i in propDest) newProperties.push (propDest[i]);
	}

	var $_callback_assigned = false; // 1.7.4: Knows if callback has already been assigned to an object

	// Checks if the master movieClip (which controls all tweens) exists, if not creates it
	if (_root.__tweenController__ == undefined) _global.$createTweenController();

	var tweenPropList = _root.__tweenController__.$_tweenPropList;

	// Now set its data (adds to the list of properties being tweened)
	var tTime = _root.__tweenController__.$_tTime; // 2.16.12: laco's suggestion, for a REAL uniform time
	for (var i in oldProperties) {
		// Set one new object for each property that should be tweened
		if (newProperties[i] != undefined && !mtarget.$_isTweenLocked) {
			// Only creates tweenings for properties that are not undefined. That way,
			// certain properties can be optional on the shortcut functions even though
			// they are passed to the tweening function - they're just ignored

			// Checks if it's at the tween list already
			if (mtarget.$_tweenCount > 0) {
				for (var pti=0; pti<tweenPropList.length; pti++) {
					if (tweenPropList[pti]._targ == mtarget && tweenPropList[pti]._prop == properties[i]) {
						// Exists for the same property... checks if the time is the same (if the NEW's start time would be before the OLD's ending time)
						if (tTime + (delay*1000) < tweenPropList[pti]._timeDest) {
							// It's a property that is already being tweened, BUT has already started, so it's ok to overwrite.
							// So it deletes the old one(s) and THEN creates the new one.
							tweenPropList.splice(pti, 1);
							pti--;
							mtarget.$_tweenCount--;
						}
					}
				}
			}

			// Finally, adds the new tween data to the list
			tweenPropList.push ({
				_prop       : properties[i],
				_targ       : mtarget,
				_propStart  : undefined,		// was "oldProperties[i]" (2.14.9). Doesn't set: it must be read at the first update time, to allow animating with correct [new] values when using the delay parameter
				_propDest   : newProperties[i],
				_timeStart  : tTime,
				_timeDest   : tTime+(timeSeconds*1000),
				_animType   : animType,
				_extra1     : extra1,
				_extra2     : extra2,
				_extras     : extras,			// 2.25.27: 'extras' for more tween-related data
				_delay      : delay,
				_isPaused   : false,			// whether it's paused or not
				_timePaused : 0,				// the time it has been paused
				_callback   : $_callback_assigned ? undefined : callback
			});
			// $tweenCount is used for a faster start
			mtarget.$_tweenCount = mtarget.$_tweenCount > 0 ? mtarget.$_tweenCount+1 : 1; // to avoid setting ++ to undefined
			$_callback_assigned = true; // 1.7.4
		}
	}

	// Hides stuff from public view on the movieclip being tweened
	ASSetPropFlags(mtarget, "$_tweenCount", 1, 0); // List of stuff being tweened
};
ASSetPropFlags(_global, "$addTween", 1, 0);

_global.$updateTweens = function() {
	// INTERNAL USE: This is ran every frame to update *all* existing tweens

	// On each pass, it should check and update the properties
	var tTime = this.$_tTime = getTimer();
	for (var i=0; i<this.$_tweenPropList.length; i++) {
		var objProp = this.$_tweenPropList[i]; // Temporary shortcut to this property controller object
		if (objProp._targ.toString() == undefined) {
			// Object doesn't exist anymore; so just remove it from the list (2.18.20)
			// There's no point in trying to do a clean removal through _global.$stopTween(), so just gets deleted
			this.$_tweenPropList.splice(i,1);
			i--;
		} else {
			if (objProp._timeStart + (objProp._delay*1000) <= tTime && !objProp._isPaused) {
				// Starts tweening already
				// Some of the lines below seem weird because of the nested if/elseif blocks.
				// That's because this is meant to be *fast*, not to be readable, so I've chosen to avoid unnecesssary if() checks when possible

				// "first-time" update to allow dinamically changed values for delays (2.14.9)
				if (objProp._propStart == undefined) {
					if (objProp._prop.substr(0, 10) == "__special_") {
							objProp._propStart = objProp._targ[objProp._prop];
					} else {
						// Normal cases
						objProp._propStart = objProp._targ[objProp._prop];
					}
				}
				var endTime = objProp._timeDest + (objProp._delay*1000);
				if (endTime <= tTime) {
					// Finished, just use the end value for the last update
					var newValue = objProp._propDest;
				} else {
					// Continue, in-tween
					var newValue = _global.findTweenValue (objProp._propStart, objProp._propDest, objProp._timeStart, tTime-(objProp._delay*1000), objProp._timeDest, objProp._animType, objProp._extra1, objProp._extra2);
				}

				// sets the property value... this is done to have a 'correct' value in the target object

				objProp._targ[objProp._prop] = objProp._extras.mustRound ? Math.round(newValue) : newValue; // 2.26.27: option for rounded
				
				// special hard-coded case for filters
				if (objProp._prop == "__special_blur_x__") 			_global.$setFilterProperty (objProp._targ, "blur_blurX", newValue, objProp._extras);
				if (objProp._prop == "__special_blur_y__") 			_global.$setFilterProperty (objProp._targ, "blur_blurY", newValue, objProp._extras);

				// 2.23.26: calls the update event, if any
				if (objProp._targ.onTweenUpdate != undefined) {
					objProp._targ.onTweenUpdate(objProp._prop);
				}

				if (endTime <= tTime) {
					// Past the destiny time: ended.

					// 2.23.26: calls the completion event, if any
					if (objProp._targ.onTweenComplete != undefined) {
						objProp._targ.onTweenComplete(objProp._prop);
					}

					_global.$stopTween (objProp._targ, [objProp._prop], false);

					// Removes from the tweening properties list array. So simpler than the previous versions :)
					// (objProp still exists so it works further on)
					//  this.$_tweenPropList.splice(i,1); // 2.18.17 -- not needed anymore, controlled on _global.stopTween()
					i--;

					if (objProp._callback != undefined) {
						// Calls the _callback function
						if (_global.backwardCallbackTweening) {
							// Old style, for compatibility.
							// IF YOU'RE USING AN OLD VERSION AND WANT BACKWARD COMPATIBILITY, use this line:
							// _global.backwardCallbackTweening = true;
							// ON YOUR MOVIES AFTER (or before) THE #INCLUDE STATEMENT.
							var childMC = objProp._targ.createEmptyMovieClip("__child__", 122344);
							objProp._callback.apply(childMC, null);
							childMC.removeMovieClip();
						} else {
							// New method for 2.12.9: use the mc scope
							// So simpler. I should have done this from the start...
							// ...instead of trying the impossible (using the scope from which the tween was called)
							objProp._callback.apply(objProp._targ, null);
						}
					}
				}
			}
		}
	}
	// Deletes the tween controller movieclip if no tweens are left
	if (this.$_tweenPropList.length == 0) _global.$removeTweenController();
};
ASSetPropFlags(_global, "$updateTween", 1, 0);

_global.$stopTween = function(mtarget, props, wipeFuture) {
	// INTERNAL USE: Removes tweening immediately, deleting it

	// wipeFuture = removes future, non-executed tweenings too
	var tweenPropList = _root.__tweenController__.$_tweenPropList;
	var _prop;
	// Deletes it
	for (var pti in tweenPropList) {
		_prop = tweenPropList[pti]._prop;
		for (var i=0; i<props.length || (i<1 && props == undefined); i++) {
			if (tweenPropList[pti]._targ == mtarget && (_prop == props[i] || props == undefined) && (wipeFuture || tweenPropList[pti]._timeDest+(tweenPropList[pti]._delay*1000) <= getTimer())) {
				// Removes auxiliary vars
				switch (_prop) {
				case "__special_mc_frame__":
				case "__special_mc_ra__":
                case "__special_mc_rb__":
                case "__special_mc_ga__":
                case "__special_mc_gb__":
                case "__special_mc_ba__":
                case "__special_mc_bb__":
                case "__special_mc_aa__":
                case "__special_mc_ab__":
                case "__special_sound_volume__":
				case "__special_bst_t__":
					delete mtarget[_prop];
					break;
				case "__special_text_b__":
					delete mtarget.__special_text_r__;
					delete mtarget.__special_text_g__;
					delete mtarget.__special_text_b__;
					break;
				}
				// Removes from the list
				tweenPropList.splice(pti, 1);
			}
		}
	}
	// Updates the tween count "cache"
	if (props == undefined) {
		delete (mtarget.$_tweenCount);
	} else {
		mtarget.$_tweenCount = 0;
		for (var pti in tweenPropList) {
			if (tweenPropList[pti]._targ == mtarget) mtarget.$_tweenCount++;
		}
		if (mtarget.$_tweenCount == 0) delete mtarget.$_tweenCount;
	}
	// Check if the tween movieclip controller should still exist
	if (tweenPropList.length == 0) {
		// No tweenings remain, remove it
		_global.$removeTweenController();
	}
};
ASSetPropFlags(_global, "$stopTween", 1, 0);

_global.$setFilterProperty = function(mtarget, propName, propValue, extras) {
	// Sets a property for a Flash 8-based filter.
	// This is needed because you can't modify the .filter property directly; you have to re-apply it,
	// and to do so in a non-destructible way (without erasing the previous filters) the array must
	// be cloned...
	var i;
	var applied = false;

	// Creates a copy of .filters 
	var newFilters = [];
	for (var i=0; i<mtarget.filters.length; i++) {
		newFilters.push(mtarget.filters[i]);
	}

	// Finally replaces it. This looks a bit weird, I know...
	// I'll have to rewrite this later. I'm think which would be the best approach; this is too hardcoded.
	if (propName.substr(0, 5) == "blur_") {
		// Blur...
		for (i=0; i<mtarget.filters.length; i++) {
			if (newFilters[i] instanceof flash.filters.BlurFilter) {
				newFilters[i][propName.substr(5)] = propValue;
				if (extras.__special_blur_quality__ != undefined) newFilters[i].quality = extras.__special_blur_quality__; // Applies quality
				applied = true;
				break;
			}

		}
		if (!applied) {
			// Creates a new filter and applies it
			var myFilter;
			var quality = extras.__special_blur_quality__ == undefined ? 2 : extras.__special_blur_quality__; // Quality
			if (propName == "blur_blurX") myFilter = new flash.filters.BlurFilter(propValue, 0, quality);
			if (propName == "blur_blurY") myFilter = new flash.filters.BlurFilter(0, propValue, quality);
			newFilters.push(myFilter);
		}
	
	} else {
		// Can't do anything
//		trace ("MC TWEEN ### Error on $setFilterProperty: propName \""+propName+"\" is not valid.");
		return;
	}
	// And reapplies the filter
	mtarget.filters = newFilters;
};

/*
===============================================================================
Main methods/functions
-------------------------------------------------------------------------------
The most basic tweening functions - for starting, stopping, pausing, etc.
-------------------------------------------------------------------------------
*/

MovieClip.prototype.tween = TextField.prototype.tween  = function (prop, propDest, timeSeconds, animType, delay, callback, extra1, extra2) {
	// Starts a variable/property/attribute tween for an specific object.
	_global.$addTween(this, prop, propDest, timeSeconds, animType, delay, callback, extra1, extra2);
};
ASSetPropFlags(MovieClip.prototype, "tween", 1, 0);
ASSetPropFlags(TextField.prototype, "tween", 1, 0);
ASSetPropFlags(Sound.prototype, "tween", 1, 0);
/*
MovieClip.prototype.roundedTween = TextField.prototype.roundedTween =  function (prop, propDest, timeSeconds, animType, delay, callback, extra1, extra2) {
	// Starts a variable/property/attribute tween for an specific object, and uses only rounded values when updating
	_global.$addTween(this, prop, propDest, timeSeconds, animType, delay, callback, extra1, extra2, {mustRound:true});
};
ASSetPropFlags(MovieClip.prototype, "roundedTween", 1, 0);
ASSetPropFlags(TextField.prototype, "roundedTween", 1, 0);
ASSetPropFlags(Sound.prototype, "roundedTween", 1, 0);
*/
MovieClip.prototype.stopTween = TextField.prototype.stopTween  = function(props) {
	// Removes tweenings immediately, leaving objects as-is. Examples:
	//  <movieclip>.stopTween ("_x");          // Stops _x tweening
	//  <movieclip>.stopTween (["_x", "_y"]);  // Stops _x and _y tweening
	//  <movieclip>.stopTween ("_x", "_y");  // Stops _x and _y tweening
	//  <movieclip>.stopTween ();              // Stops all tweening processes
	if (typeof (props) == "string") props = [props]; // in case of one property, turn into array
	if (props != undefined) {
		// 2.22.26: counts all arguments as parameters too
		for (var i=1; i<Arguments.length; i++) props.push(Arguments[i]);
	}
	_global.$stopTween(this, props, true);
};
ASSetPropFlags(MovieClip.prototype, "stopTween", 1, 0);
ASSetPropFlags(TextField.prototype, "stopTween", 1, 0);
ASSetPropFlags(Sound.prototype, "stopTween", 1, 0);

MovieClip.prototype.pauseTween = TextField.prototype.pauseTween =  function(props) {
	if (props != undefined) {
		if (typeof (props) == "string") props = [props]; // in case of one property, turn into array
		for (var i=1; i<Arguments.length; i++) props.push(Arguments[i]);
	}
	var tweenPropList = _root.__tweenController__.$_tweenPropList;
	var mustPause;
	for (var pti in tweenPropList) {
		if (tweenPropList[pti]._targ == this && !tweenPropList[pti]._isPaused) {
			if (props != undefined) {
				// Tests if it can be stopped
				mustPause = false;
				for (var i in props) {
					if (props[i] == tweenPropList[pti]._prop) {
						mustPause = true;
						break;
					}
				}
			}
			if (props == undefined || mustPause) {
				tweenPropList[pti]._isPaused = true;
				tweenPropList[pti]._timePaused = _root.__tweenController__.$_tTime;
			}
		}
	}
};
ASSetPropFlags(MovieClip.prototype, "pauseTween", 1, 0);
ASSetPropFlags(TextField.prototype, "pauseTween", 1, 0);


MovieClip.prototype.getTweens = TextField.prototype.getTweens = function() {
	// Returns the number of tweenings actually being executed
	// Tweenings are NOT overwritten, so it's possible to have a series of tweenings at the same time
	return (this.$_tweenCount);
};
ASSetPropFlags(MovieClip.prototype, "getTweens", 1, 0);
ASSetPropFlags(TextField.prototype, "getTweens", 1, 0);


MovieClip.prototype.isTweening = TextField.prototype.isTweening  = function() {
	// Returns true if there's at least one tweening being executed, otherwise false
	return (this.$_tweenCount > 0 ? true : false);
};
ASSetPropFlags(MovieClip.prototype, "isTweening", 1, 0);
ASSetPropFlags(TextField.prototype, "isTweening", 1, 0);



/*
===============================================================================
Shortcut methods/functions
-------------------------------------------------------------------------------
Start tweenings with different commands. These methods are used mostly for code
readability and special handling of some non-property attributes (like movieclip
color, sound volume, etc) but also to make the coding easier for non-expert
programmers or designers.
-------------------------------------------------------------------------------
*/

MovieClip.prototype.alphaTo = TextField.prototype.alphaTo = function (propDest_a, timeSeconds, animType, delay, callback, extra1, extra2) {
	// Does an alpha tween. Example: <movieclip>.alphaTo(100)
	_global.$addTween(this, "_alpha", propDest_a, timeSeconds, animType, delay, callback, extra1, extra2);
};
ASSetPropFlags(MovieClip.prototype, "alphaTo", 1, 0);
ASSetPropFlags(TextField.prototype, "alphaTo", 1, 0);

MovieClip.prototype.rotateTo = TextField.prototype.rotateTo = function (propDest_rotation, timeSeconds, animType, delay, callback, extra1, extra2) {
	// Rotates an object given a degree.
	_global.$addTween(this, "_rotation", propDest_rotation, timeSeconds, animType, delay, callback, extra1, extra2);
};
ASSetPropFlags(MovieClip.prototype, "rotateTo", 1, 0);
ASSetPropFlags(TextField.prototype, "rotateTo", 1, 0);

MovieClip.prototype.scaleTo = TextField.prototype.scaleTo = function (propDest_scale, timeSeconds, animType, delay, callback, extra1, extra2) {
	// Scales an object uniformly.
	_global.$addTween(this, ["_xscale", "_yscale"], [propDest_scale, propDest_scale], timeSeconds, animType, delay, callback, extra1, extra2);
};
ASSetPropFlags(MovieClip.prototype, "scaleTo", 1, 0);
ASSetPropFlags(TextField.prototype, "scaleTo", 1, 0);

MovieClip.prototype.slideTo = TextField.prototype.slideTo = function (propDest_x, propDest_y, timeSeconds, animType, delay, callback, extra1, extra2) {
	// Does a xy sliding tween. Example: <movieclip>.slideTo(100, 100)
	_global.$addTween(this, ["_x", "_y"], [propDest_x, propDest_y], timeSeconds, animType, delay, callback, extra1, extra2);
};
ASSetPropFlags(MovieClip.prototype, "slideTo", 1, 0);
ASSetPropFlags(TextField.prototype, "slideTo", 1, 0);



MovieClip.prototype.blurTo = TextField.prototype.blurTo = function () {
	// Creates a blur on the object.
	// 1 -> (propDest_blur, quality, timeSeconds, animType, delay, callback, extra1, extra2)
	// 2 -> (BlurFilter, timeSeconds, animType, delay, callback, extra1, extra2)
	// propDest_blur = blur, as on flash.filters.BlurFilter .blurX and .blurY parameters
	// quality = blur quality, as on flash.filters.BlurFilter .quality
	if (typeof(arguments[0]) == "object" && arguments[0] != undefined) {
		// It's an object
		_global.$addTween(this, ["__special_blur_x__","__special_blur_y__"], [arguments[0].blurX, arguments[0].blurY], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], {__special_blur_quality__:arguments[0].quality});
	} else {
		// Normal parameters
		_global.$addTween(this, ["__special_blur_x__","__special_blur_y__"], [arguments[0], arguments[0]], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], {__special_blur_quality__:arguments[1]});
	}
};
ASSetPropFlags(MovieClip.prototype, "blurTo", 1, 0);
ASSetPropFlags(TextField.prototype, "blurTo", 1, 0);

_global.findTweenValue = function (_propStart, _propDest, _timeStart, _timeNow, _timeDest, _animType, _extra1, _extra2) {
	// Returns the current value of a property mid-value given the time.
	// Used by the tween methods to see where the movieclip should be on the current
	// tweening process. All equations on this function are Robert Penner's work.
	var t = _timeNow - _timeStart;  // current time (frames, seconds)
	var b = _propStart;             // beginning value
	var c = _propDest - _propStart; // change in value
	var d = _timeDest - _timeStart; // duration (frames, seconds)
	var a = _extra1;                // amplitude (optional - used only on *elastic easing)
	var p = _extra2;                // period (optional - used only on *elastic easing)
	var s = _extra1;                // overshoot ammount (optional - used only on *back easing)

	switch (_animType.toLowerCase()) {
	case "linear":
		// simple linear tweening - no easing
		return c*t/d + b;

		case "easeinexpo":
		// exponential (2^t) easing in - accelerating from zero velocity
		return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b;
	case "easeoutexpo":
		// exponential (2^t) easing out - decelerating to zero velocity
		return (t==d) ? b+c : c * (-Math.pow(2, -10 * t/d) + 1) + b;
		
	case "easeinelastic":
		// elastic (exponentially decaying sine wave) easing in
		if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
		if (!a || a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
	case "easeoutelastic":
		// elastic (exponentially decaying sine wave) easing out
		if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
		if (!a || a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		return (a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b);
	
	// Robert Penner's explanation for the s parameter (overshoot ammount):
	//  s controls the amount of overshoot: higher s means greater overshoot
	//  s has a default value of 1.70158, which produces an overshoot of 10 percent
	//  s==0 produces cubic easing with no overshoot
	case "easeinback":
		// back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing in - backtracking slightly, then reversing direction and moving to target
		if (s == undefined) s = 1.70158;
		return c*(t/=d)*t*((s+1)*t - s) + b;
	case "easeoutback":
		// back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing out - moving towards target, overshooting it slightly, then reversing and coming back to target
		if (s == undefined) s = 1.70158;
		return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
	
	// This were changed a bit by me (since I'm not using Penner's own Math.* functions)
	// So I changed it to call findTweenValue() instead (with some different arguments)
	case "easeinbounce":
		// bounce (exponentially decaying parabolic bounce) easing in
		return c - findTweenValue (0, c, 0, d-t, d, "easeOutBounce") + b;
	case "easeoutbounce":
		// bounce (exponentially decaying parabolic bounce) easing out
		if ((t/=d) < (1/2.75)) {
			return c*(7.5625*t*t) + b;
		} else if (t < (2/2.75)) {
			return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
		} else if (t < (2.5/2.75)) {
			return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
		} else {
			return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
		}
	
	default:
		trace ("MC TWEEN ### Error on transition: there's no \""+_animType+"\" animation type.");
		return 0;
	}
};
ASSetPropFlags(_global, "findTweenValue", 1, 0);