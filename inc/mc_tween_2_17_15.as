/*
===============================================================================
= MOVIECLIP/TEXTFIELD TWEENING PROTOTYPE
=------------------------------------------------------------------------------
=
= MC_TWEEN
= Created to be a helpful tweening extension for general users
= By Zeh Fernando
= z [AT] zeh.com.br
= Sao Paulo, Brazil
= http://www.zeh.com.br
= 
=------------------------------------------------------------------------------
= Version: 2.17.15
= Latest changes:
=        (2003) apr 05 (1.0.0) - first version
=               apr 06 (1.1.0) - added callback property to mc.tween()
=                      (1.1.1) - code fixing/cleaning
=                      (1.2.1) - added mc.isTweening(), mc.getTweens()
=               apr 07 (1.3.1) - added initial delay property to mc.tween()
=               apr 08 (1.3.2) - using onEnterFrame instead of setInterval
=               apr 11 (1.3.3) - added some comments, deleted some old code
=                      (1.4.3) - added some shortcut methods (easier to use)
=               apr 29 (1.5.3) - updated with robert penner's equations v1.4
=               may 02 (1.6.3) - updated with robert penner's equations v1.5
=                      (1.7.3) - added mc.colorTo(), a shortcut/helper method
=               may 06 (1.7.4) - fixed a callback bug on the slideTo method -
=                                props to Gregg Wygonik for pointing that out
=               may 11 (1.8.4) - added mc.stopTween() to stop tweenings
=               may 12 (1.8.5) - fixed a really stupid colorTo() error
=               may 12 (1.9.5) - added mc.colorTransformTo(), a shortcut/helper
=                                method which enables color.setTransform tweens
=               may 13 (1.9.6) - ditched mc.colorTo()'s original code. now it's
=                                based on a mc.colorTransformTo() call
=              jul 23 (1.10.6) - added another shortcut, scaleTo()
=              jul 25 (1.11.6) - added another shortcut, rotateTo() (duh)
=              jul 27 (1.11.7) - made colorTransformTo() better handle
=                                undefined properties and not create unneeded
=                                tween movieclips (faster)
=              aug 26 (1.12.7) - completely revamped the frame control, to use
=                                one submovieClip for each movieclip instead
=                                of a submovieClip for each property (cleaner)
=              oct 01 (1.12.8) - minor fix (mispell) on stopTween(), thanks kim
=              dec 02 (1.12.9) - fixed minor alphaTo+colorTo+colorTransformTo
=                                issue that broke simultaneous calls
=       (2004) jan 23 (2.12.9) - completely revamped the frame control system
=                                (again): it now uses one single mc at _root
=                                (faster, cleaner)
=                              - callback functionality scope changed. NOT
=                                BACKWARDS COMPATIBLE BY DEFAULT! search for
=                                "backwardCallbackTweening" for help on how
=                                to make it compatible
=              feb 10 (2.13.9) - better time control for synch start
=              feb 10 (2.14.9) - made it possible to tween the same property
=                                several times (not direct overwritting) - ie,
=                                complex animations are now possible with
=                                sequence tweenings
=             feb 11 (2.14.10) - optimizations for speed
=             feb 17 (2.15.10) - added lockTween() and unlockTween()
=             feb 18 (2.15.11) - stoptween() fixed, not updating $_tweenCount
=             mar 01 (2.16.11) - added textfield methods: tween(), alphaTo(),
=                                colorTo(), rotateTo(), slideTo(), scaleTo(),
=                                as well as stopTween(), lockTween(),
=                                unlockTween(), getTweens(), isTweening(),
=                                AND a new one, scrollTo()
=             may 23 (2.16.12) - added *real* synchronization for tweenings
=                                issued on the same frame (thanks to laco)
=             jun 22 (2.16.13) - rewrote colorTransformTo() in a more cleaner,
=                                intelligent and faster way - and fixed the
=                                inability to issue multiple colorTransformTo()
=                                calls (thanks to Martin Klasson for finding
=                                this error)
=                    (2.16.14) - rewrote part of the property set algorithm,
=                                making it clearer and more logic, as well as
=                                the textfield.colorTo() method (fixed a
=                                potential bug for sequential calls)
=             jul 17 (2.16.15) - fixed elastic equations problems that'd
=                                appear on flash mx 2004 when exporting a
=                                version 7 swf - updated to Robert Penner's own
=                                solution, in fact (thanks BrianWaters for
=                                pointing that out)
=             aug 17 (2.17.15) - added sound methods: tween(), stopTween(),
=                                getTweens(), isTweening(), lockTween(),
=                                unlockTween() AND two new ones, volumeTo() and
=                                panTo(), for volume and panning tweens that
=                                can be applied to sound objects
=
=------------------------------------------------------------------------------
= This tweens given movieclip properties from their current values to new values,
= during an specified time. It's inspired by Jonas Galvez's simpleTween method
= and created to be *easy* to non-experienced coders (designers).
=
= ALL easing/tweening equations present here were based on Robert Penner's work
= with easing equations. I merely coded Flash MX-friendly prototypes. You can
= find more information and his original source code here:
= http://www.robertpenner.com/easing/
=
= KEY FEATURES of this prototype are:
= * IT'S BASED ON TIME, NOT ON FRAMES. That means that, if you use it and tell
=   your mc to move to an specified position on 5 seconds, it'll take 5 seconds
=   to get there no matter which kind of computer is running it. Better
=   computers will have better framerate, of course, but still, it'll move at
=   the same speed time-wise.
= * IT'S NOT BASED ON THE MC'S OWN ONENTERFRAME(). This means that you won't
=   overwrite your dynamically-set onEnterFrame() functions (if any). Instead,
=   it creates a single MovieClips to handle onEnterFrame() events for each
=   separate property. In this case onEnterFrame() provide a more tight,
=   framerate-based update rate than setInterval() functions.
= * IT'S REUSABLE AND CAN BE EXECUTED MULTIPLE TIMES. That is, if you do a
=   tween on a given object, you can still issue another tween WHILE the
=   current tween is being executed - none of them will get destroyed and both
=   will execute until the end. You can start an _alpha tween on a movieclip
=   in the middle of a _y tween, for example - it'll work without a problem. You
=   can also start a tween on a variable that's already beeing tweened - the
=   new one will take over from where the other one stopped if you want it to,
=   or it'll delay and only start tweening after a certain ammount of time if
=   that's what you want.
= * YOU CAN TWEEN SINGLE PROPERTIES AS WELL AS AN ARRAY OF PROPERTIES. This way,
=   you can move your movieclip at the same time you're scaling it or setting
=   its alpha, for example, instead of having to rely on different tween
=   commands which might produce discrepancies.
= * IT HAS SEVERAL SHORTCUT METHODS TO AVOID UNNECESSARY RECODING. You don't
=   need separate fade, slide, transform, and color protoypes - this one does
=   all that with similar syntax. You could only use the tween() method
=   directly for all kinds of tweenings possible, but in case you're doing some
=   common tween, you can use slideTo(), alphaTo() or colorTo() which also
=   makes a more readable code.
= * YOU CAN USE IT ON TEXTFIELDS. So you can tween a textfield alpha, position,
=   scale, color, rotation, scroll and whichever property it might have, just
=   like you'd do with movieclips
= * YOU CAN USE IT ON SOUND OBJECTS. So you can do a sound fade or panning
= * IT SAVES THE WORLD (TM).
=
===============================================================================
*/

/*
===============================================================================
= <movieclip>.tween()
= or
= <textfield>.tween()
=
= METHOD. Makes a given movieclip/textfield property(ies) tween from its
= current value(s) to other one(s).
=
= How to use:
=      <movieclip>.tween(property, pEnd, seconds, animType, delay, callback, extra1, extra2)
=      <textfield>.tween(property, pEnd, seconds, animType, delay, callback, extra1, extra2)
=
= Parameters:
=      property = property(ies) to be tweened (string) (*)
=      pEnd     = end property value(s) (number) (*)
=      seconds  = seconds to reach the end value (number) (**) defaults to 2
=      animType = animation equation type (string) (**) defaults to "easeOutExpo"
=      delay    = delay (sec) to start animation (number) (**) defaults to 0
=      callback = function to be called when finished (object) (**)
=      extra1   = optional animation parameter. (**)
=                 means AMPLITUDE (a) when animType = *elastic
=                 means OVERSHOOT AMMOUNT (s) when animType = *back
=      extra2   = optional animation parameter. (**)
=                 means PERIOD (p) when animType = *elastic
=
=           (*) = property can be an array
=          (**) = property is optional
=
= Examples:
=      ball.tween ("_alpha", 0);
=      box.tween (["_x", "_y"], [100, 100], 4, "linear");
=      menuItem.tween ("_yscale", 200, 3, undefined, undefined, doPlay);
=      name_txt.tween ("_alpha", 100, 1);
=
= Additional functions/methods:
=      <movieclip>.lockTween() = "locks" the movieclip so it can't be tweened
=      <textfield>.lockTween() = (the same)
=          <sound>.lockTween() = (the same)
=      <movieclip>.unlockTween() = "unlocks" the movieclip so it can be tweened again
=      <textfield>.unlockTween() = (the same)
=          <sound>.unlockTween() = (the same)
=      <movieclip>.getTweens() = returns the number of tweenings being done
=      <textfield>.getTweens() = (the same)
=          <sound>.getTweens() = (the same)
=      <movieclip>.isTweening() = returns TRUE if tweening, FALSE if otherwise
=      <textfield>.isTweening() = (the same)
=          <sound>.isTweening() = (the same)
=      <movieclip>.stopTween("property") = removes tweenings being done. You
=             can stop tweenings individually (ie, ("_x")), as an array (ie,
=             (["_x", "_y"])) or all tweenings (no parameters).
=      <textfield>.stopTween("property") = (the same)
=          <sound>.stopTween("property") = (the same)
=
= Shortcut methods:
=      These methods do the same as tween(), but in a shorter way. They're
=      pretty much self-explanatory. ALL ARGUMENTS are optional (in a xy
=      function, for example, you only need to pass the x or y argument).
=
=      <movieclip>.alphaTo(alpha, seconds, animtype, delay, callback, extra1, extra2)
=      <textfield>.alphaTo(alpha, seconds, animtype, delay, callback, extra1, extra2)
=             alpha value from 0 to 100
=
=      <movieclip>.colorTo(color, seconds, animtype, delay, callback, extra1, extra2)
=      <textfield>.colorTo(color, seconds, animtype, delay, callback, extra1, extra2)
=             use like Flash MX's color.setRGB (use a number like 0xff01d3)
=
=      <movieclip>.colorTransformTo(ra, rb, ga, gb, ba, bb, aa, ab, seconds, animtype, delay, callback, extra1, extra2)
=             use like Flash MX's color.setTransform. all values are optional.
=
=      <movieclip>.rotateTo(rotation, seconds, animtype, delay, callback, extra1, extra2)
=      <textfield>.rotateTo(rotation, seconds, animtype, delay, callback, extra1, extra2)
=             rotation is the same as _rotation values, that is, angle in degrees
=
=      <movieclip>.slideTo(x, y, seconds, animtype, delay, callback, extra1, extra2)
=      <textfield>.slideTo(x, y, seconds, animtype, delay, callback, extra1, extra2)
=             x or y are optional (use "undefined" without quotes).
=
=      <movieclip>.scaleTo(size, seconds, animtype, delay, callback, extra1, extra2)
=      <textfield>.scaleTo(size, seconds, animtype, delay, callback, extra1, extra2)
=             size is the same as _yscale/_xscale values, that is, percentage.
=
=      <textfield>.scrollTo(line, seconds, animtype, delay, callback, extra1, extra2)
=             line is the same variable used on .scroll, (1 -> .maxscroll)
=
=      <sound>.volumeTo (volume, seconds, animtype, delay, callback, extra1, extra2);
=             volume is a value between 0 and 100, inclusive; like setVolume()
=
=      <sound>.panTo (pan, seconds, animtype, delay, callback, extra1, extra2);
=             pan is a value between -100 and 100, inclusive; like setPan()
===============================================================================
*/
MovieClip.prototype.tween = TextField.prototype.tween = Sound.prototype.tween = function (prop, propDest, timeSeconds, animType, delay, callback, extra1, extra2) {
  // Sets default values if undefined/invalid
  if (timeSeconds < 0.001) timeSeconds = 2; // default time length
  if (animType == undefined || animType == "") animType = "easeOutExpo"; // default equation!
  if (delay == undefined) delay = 0; // default delay

  // Starts tweening.. prepares to create handling mcs
  if (typeof(prop) == "string") {
    // Single property
    var properties = [prop]; // Properties, as in "_x"
    var oldProperties = [this[prop]]; // Old value, as in 0
    var newProperties = [propDest]; // New (target) value, as in 100
  } else {
    // Array of properties
    var properties = []; // Properties, as in "_x"
    var oldProperties = []; // Old value, as in 0
    var newProperties = []; // New (target) value, as in 100
    for (var i in prop) oldProperties.push (this[prop[i]]);
    for (var i in prop) properties.push (prop[i]);
    for (var i in propDest) newProperties.push (propDest[i]);
  }

  var $_callback_assigned = false; // 1.7.4: Knows if callback has already been assigned to a movieclip

  // Checks if the master movieClip (which controls all tweens) exists
  if (_root.__tweenController__ == undefined) {
    // Doesn't exist: create, and set its methods/data
    var tweenHolder = _root.createEmptyMovieClip ("__tweenController__", 123432); // Any level
    tweenHolder.$_tweenPropList = new Array();  // Will hold the list of properties beeing tweened. an array of objects.
    tweenHolder.$_tTime = getTimer();
    tweenHolder.onEnterFrame = function() {
      // On each pass, it should check and update the properties
      var tTime = this.$_tTime = getTimer();
      for (var i=0; i<this.$_tweenPropList.length; i++) {
        var objProp = this.$_tweenPropList[i]; // Temporary shortcut to this property controller object
        if (objProp._timeStart + (objProp._delay*1000) <= tTime) {
          // Starts tweening already

          // "first-time" update to allow dinamically changed values for delays (2.14.9)
          if (objProp._propStart == undefined) {
            if (objProp._prop.substr(0, 10) == "__special_") {
              if (objProp._prop == "__special_mc_ra__") {
                objProp._propStart = new Color (objProp._targ).getTransform().ra;
              } else if (objProp._prop == "__special_mc_rb__") {
                objProp._propStart = new Color (objProp._targ).getTransform().rb;
              } else if (objProp._prop == "__special_mc_ga__") {
                objProp._propStart = new Color (objProp._targ).getTransform().ga;
              } else if (objProp._prop == "__special_mc_gb__") {
                objProp._propStart = new Color (objProp._targ).getTransform().gb;
              } else if (objProp._prop == "__special_mc_ba__") {
                objProp._propStart = new Color (objProp._targ).getTransform().ba;
              } else if (objProp._prop == "__special_mc_bb__") {
                objProp._propStart = new Color (objProp._targ).getTransform().bb;
              } else if (objProp._prop == "__special_mc_aa__") {
                objProp._propStart = new Color (objProp._targ).getTransform().aa;
              } else if (objProp._prop == "__special_mc_ab__") {
                objProp._propStart = new Color (objProp._targ).getTransform().ab;
              } else if (objProp._prop == "__special_text_r__") {
                objProp._propStart = objProp._targ.textColor >> 16;
              } else if (objProp._prop == "__special_text_g__") {
                objProp._propStart = (objProp._targ.textColor & 0x00FF00) >> 8;
              } else if (objProp._prop == "__special_text_b__") {
                objProp._propStart = objProp._targ.textColor & 0x0000FF;
              } else if (objProp._prop == "__special_sound_volume__") {
                objProp._propStart = objProp._targ.getVolume();
              } else if (objProp._prop == "__special_sound_pan__") {
                objProp._propStart = objProp._targ.getPan();
              } else {
                objProp._propStart = objProp._targ[objProp._prop];
              }
            } else {
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
          objProp._targ[objProp._prop] = newValue;

          // special hard-coded case for movieclip color transformation...
          if (objProp._prop == "__special_mc_ra__") new Color(objProp._targ).setTransform({ra:newValue});
          if (objProp._prop == "__special_mc_rb__") new Color(objProp._targ).setTransform({rb:newValue});
          if (objProp._prop == "__special_mc_ga__") new Color(objProp._targ).setTransform({ga:newValue});
          if (objProp._prop == "__special_mc_gb__") new Color(objProp._targ).setTransform({gb:newValue});
          if (objProp._prop == "__special_mc_ba__") new Color(objProp._targ).setTransform({ba:newValue});
          if (objProp._prop == "__special_mc_bb__") new Color(objProp._targ).setTransform({bb:newValue});
          if (objProp._prop == "__special_mc_aa__") new Color(objProp._targ).setTransform({aa:newValue});
          if (objProp._prop == "__special_mc_ab__") new Color(objProp._targ).setTransform({ab:newValue});

          // special hard-coded case for textfield color...
          if (typeof(objProp._targ) != "movieclip" && (objProp._prop == "__special_text_b__")) {
            // Special case: textfield, B value for textColor value. B being the last one to update, so also set the textfield's textColor
            objProp._targ.textColor = (objProp._targ.__special_text_r__ << 16) + (objProp._targ.__special_text_g__ << 8) + objProp._targ.__special_text_b__;
          }

          // special hard-coded case for sound volume...
          if (objProp._prop == "__special_sound_volume__") objProp._targ.setVolume(newValue);
          if (objProp._prop == "__special_sound_pan__") objProp._targ.setPan(newValue);

          if (endTime <= tTime) {
            // Past the destiny time: ended.

            // Deletes if it's a special, hard-coded value

            if (objProp._prop == "__special_mc_ra__") delete objProp._targ[objProp._prop];
            if (objProp._prop == "__special_mc_rb__") delete objProp._targ[objProp._prop];
            if (objProp._prop == "__special_mc_ga__") delete objProp._targ[objProp._prop];
            if (objProp._prop == "__special_mc_gb__") delete objProp._targ[objProp._prop];
            if (objProp._prop == "__special_mc_ba__") delete objProp._targ[objProp._prop];
            if (objProp._prop == "__special_mc_bb__") delete objProp._targ[objProp._prop];
            if (objProp._prop == "__special_mc_aa__") delete objProp._targ[objProp._prop];
            if (objProp._prop == "__special_mc_ab__") delete objProp._targ[objProp._prop];
            if (objProp._prop == "__special_text_b__") {
                delete objProp._targ.__special_text_r__;
                delete objProp._targ.__special_text_g__;
                delete objProp._targ.__special_text_b__;
            }
            if (objProp._prop == "__special_sound_volume__") delete objProp._targ[objProp._prop];

            // Removes from the tweening properties list array. So simpler than the previous versions :)
            // (objProp still exists so it works further on)
            this.$_tweenPropList.splice(i,1);
            i--;

            objProp._targ.$_tweenCount--;
            if (objProp._targ.$_tweenCount == 0) delete objProp._targ.$_tweenCount;
            
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

            // Deletes the tweener movieclip if no tweens are left
            if (this.$_tweenPropList.length == 0) this.removeMovieClip();
          }

        }
      }
    };
  }

  var tweenPropList = _root.__tweenController__.$_tweenPropList;

  // Now set its data (adds to the list of properties being tweened)
  var tTime = _root.__tweenController__.$_tTime; // 2.16.12: laco's suggestion, for a REAL uniform time
  for (var i in oldProperties) {
    // Set one new object for each property that should be tweened
    if (newProperties[i] != undefined && !this.$_isTweenLocked) {
      // Only creates tweenings for properties that are not undefined. That way,
      // certain properties can be optional on the shortcut functions even though
      // they are passed to the tweening function

      // Checks if it's at the tween list already
      if (this.$_tweenCount > 0) {
        for (var pti=0; pti<tweenPropList.length; pti++) {
          if (tweenPropList[pti]._targ == this && tweenPropList[pti]._prop == properties[i]) {
            // Exists for the same property... checks if the time is the same (if the NEW's start time would be before the OLD's ending time)
            if (tTime + (delay*1000) < tweenPropList[pti]._timeDest) {
              // It's a property that is already being tweened, BUT has already started, so it's ok to overwrite.
              // So it deletes the old one(s) and THEN creates the new one.
              tweenPropList.splice(pti, 1);
              pti--;
              this.$_tweenCount--;
            }
          }
        }
      }

      // Finally, adds the new tween data to the list
      tweenPropList.push ({
        _prop : properties[i],
        _targ : this,
        _propStart : undefined, // was "oldProperties[i]" (2.14.9). Doesn't set: it must be read at the first update time, to allow animating with correct [new] values when using the delay parameter
        _propDest : newProperties[i],
        _timeStart : tTime,
        _timeDest : tTime+(timeSeconds*1000),
        _animType : animType,
        _extra1 : extra1,
        _extra2 : extra2,
        _delay : delay,
        _callback : $_callback_assigned ? undefined : callback
      });
      // $tweenCount is used for a faster start
      this.$_tweenCount = this.$_tweenCount > 0 ? this.$_tweenCount+1 : 1; // to avoid setting ++ to undefined
      $_callback_assigned = true; // 1.7.4
    }
  }
  
  // Hides stuff from public view on the movieclip being tweened
  ASSetPropFlags(this, "$_tweenCount", 1, 0); // List of stuff being tweened
};
ASSetPropFlags(MovieClip.prototype, "tween", 1, 0);
ASSetPropFlags(TextField.prototype, "tween", 1, 0);
ASSetPropFlags(Sound.prototype, "tween", 1, 0);

MovieClip.prototype.lockTween = TextField.prototype.lockTween = Sounf.prototype.lockTween = function() {
    this.$_isTweenLocked = true;
    ASSetPropFlags(this, "this.$_isTweenLocked", 1, 0);
};
ASSetPropFlags(MovieClip.prototype, "lockTween", 1, 0);
ASSetPropFlags(TextField.prototype, "lockTween", 1, 0);
ASSetPropFlags(Sound.prototype, "lockTween", 1, 0);

MovieClip.prototype.unlockTween = TextField.prototype.unlockTween = Sound.prototype.unlockTween = function() {
    delete (this.$_isTweenLocked);
};
ASSetPropFlags(MovieClip.prototype, "unlockTween", 1, 0);
ASSetPropFlags(TextField.prototype, "unlockTween", 1, 0);
ASSetPropFlags(Sound.prototype, "unlockTween", 1, 0);

MovieClip.prototype.getTweens = TextField.prototype.getTweens = Sound.prototype.getTweens = function() {
  // Returns the number of tweenings actually being executed
  // Tweenings are NOT overwritten, so it's possible to have a series of tweenings at the same time
  return (this.$_tweenCount);
};
ASSetPropFlags(MovieClip.prototype, "getTweens", 1, 0);
ASSetPropFlags(TextField.prototype, "getTweens", 1, 0);
ASSetPropFlags(Sound.prototype, "getTweens", 1, 0);

MovieClip.prototype.isTweening = TextField.prototype.isTweening = Sound.prototype.isTweening = function() {
  // Returns true if there's at least one tweening being executed, otherwise false
  return (this.$_tweenCount > 0 ? true : false);
};
ASSetPropFlags(MovieClip.prototype, "isTweening", 1, 0);
ASSetPropFlags(TextField.prototype, "isTweening", 1, 0);
ASSetPropFlags(Sound.prototype, "isTweening", 1, 0);

MovieClip.prototype.stopTween = TextField.prototype.stopTween = Sound.prototype.stopTween = function(props) {
  // Removes tweenings immediately, leaving objects as-is. Examples:
  //  <movieclip>.stopTween ("_x");          // Stops _x tweening
  //  <movieclip>.stopTween (["_x", "_y"]);  // Stops _x and _y tweening
  //  <movieclip>.stopTween ();              // Stops all tweening processes
  var tweenPropList = _root.__tweenController__.$_tweenPropList;
  switch (typeof (props)) {
  case "string": // one property. example: "_alpha"
    props = [props];
  case "object": // several properties. example: ["_alpha", "_rotation"]
    for (var i in props) {
      for (var pti in tweenPropList) {
        if (tweenPropList[pti]._targ == this && tweenPropList[pti]._prop == props[i]) {
          tweenPropList.splice(pti, 1);
        }
      }
    }
    // Updates the tween count "cache"
    this.$_tweenCount = 0;
    for (var pti in tweenPropList) {
      if (tweenPropList[pti]._targ == this) this.$_tweenCount++;
    }
    if (this.$_tweenCount == 0) delete (this.$_tweenCount);
    break;
  default: // empty. deletes/stops everything *for this movieclip*
    for (var pti in tweenPropList) {
      if (tweenPropList[pti]._targ == this) tweenPropList.splice(pti, 1);
    }
    delete (this.$_tweenCount);
  }
  if (tweenPropList.length == 0) {
    // No tweenings remain, remove it
    _root.__tweenController__.removeMovieClip();
    this.__tweenController_ADVhelper__.removeMovieClip();
  }
};
ASSetPropFlags(MovieClip.prototype, "stopTween", 1, 0);
ASSetPropFlags(TextField.prototype, "stopTween", 1, 0);
ASSetPropFlags(Sound.prototype, "stopTween", 1, 0);


// Shortcut functions
// They do the same as tween(), but in an easier and shorter way. Intended to produce a more readable code for non-expert programmers

MovieClip.prototype.alphaTo = TextField.prototype.alphaTo = function (propDest_a, timeSeconds, animType, delay, callback, extra1, extra2) {
  // Does an alpha tween. Example: <movieclip>.alphaTo(100)
  this.tween ("_alpha", propDest_a, timeSeconds, animType, delay, callback, extra1, extra2);
};
ASSetPropFlags(MovieClip.prototype, "alphaTo", 1, 0);
ASSetPropFlags(TextField.prototype, "alphaTo", 1, 0);

MovieClip.prototype.rotateTo = TextField.prototype.rotateTo = function (propDest_rotation, timeSeconds, animType, delay, callback, extra1, extra2) {
  // Rotates an object given a degree.
  this.tween ("_rotation", propDest_rotation, timeSeconds, animType, delay, callback, extra1, extra2);
};
ASSetPropFlags(MovieClip.prototype, "rotateTo", 1, 0);
ASSetPropFlags(TextField.prototype, "rotateTo", 1, 0);

MovieClip.prototype.scaleTo = TextField.prototype.scaleTo = function (propDest_scale, timeSeconds, animType, delay, callback, extra1, extra2) {
  // Scales an object uniformly.
  this.tween (["_xscale", "_yscale"], [propDest_scale, propDest_scale], timeSeconds, animType, delay, callback, extra1, extra2);
};
ASSetPropFlags(MovieClip.prototype, "scaleTo", 1, 0);
ASSetPropFlags(TextField.prototype, "scaleTo", 1, 0);

TextField.prototype.scrollTo = function (propDest_scroll, timeSeconds, animType, delay, callback, extra1, extra2) {
  // Tweens the scroll property of a textfield.. so you can do an easing scroll to a line
  this.tween ("scroll", propDest_scroll, timeSeconds, animType, delay, callback, extra1, extra2);
};
ASSetPropFlags(TextField.prototype, "scrollTo", 1, 0);

MovieClip.prototype.slideTo = TextField.prototype.slideTo = function (propDest_x, propDest_y, timeSeconds, animType, delay, callback, extra1, extra2) {
  // Does a xy sliding tween. Example: <movieclip>.slideTo(100, 100)
  this.tween (["_x", "_y"], [propDest_x, propDest_y], timeSeconds, animType, delay, callback, extra1, extra2);
};
ASSetPropFlags(MovieClip.prototype, "slideTo", 1, 0);
ASSetPropFlags(TextField.prototype, "slideTo", 1, 0);

Sound.prototype.volumeTo = function (propDest_volume, timeSeconds, animType, delay, callback, extra1, extra2) {
  // Does a sound volume tween, 'fading' from one volume set to another (0->100)
  this.tween ("__special_sound_volume__", propDest_volume, timeSeconds, animType, delay, callback, extra1, extra2);
};
ASSetPropFlags(Sound.prototype, "volumeTo", 1, 0);

Sound.prototype.panTo = function (propDest_volume, timeSeconds, animType, delay, callback, extra1, extra2) {
  // Does a panning tween, 'fading' from one pan set to another (-100->100)
  this.tween ("__special_sound_pan__", propDest_volume, timeSeconds, animType, delay, callback, extra1, extra2);
};
ASSetPropFlags(Sound.prototype, "panTo", 1, 0);

MovieClip.prototype.colorTo = TextField.prototype.colorTo = function (propDest_color, timeSeconds, animType, delay, callback, extra1, extra2) {
  // Does a simple color transformation (tint) tweening.
  // Works like Flash MX's color.setRGB method.
  //  Example: <movieclip>.colorTo(0xFF6CD9)
  var new_r = propDest_color >> 16;
  var new_g = (propDest_color & 0x00FF00) >> 8;
  var new_b = propDest_color & 0x0000FF;
  if ((typeof(this)) == "movieclip") {
    // Normal movieclip, so create a colorTransformTo tween
    this.colorTransformTo (0, new_r, 0, new_g, 0, new_b, undefined, undefined, timeSeconds, animType, delay, callback, extra1, extra2);
  } else {
    // Textfield, so do a textColor transform
    // __special_text_?__ is understood by the tweening function as being a map to its textcolor's RGB value
    this.tween (["__special_text_r__", "__special_text_g__", "__special_text_b__"], [new_r, new_g, new_b], timeSeconds, animType, delay, callback, extra1, extra2);
  }
};
ASSetPropFlags(MovieClip.prototype, "colorTo", 1, 0);
ASSetPropFlags(TextField.prototype, "colorTo", 1, 0);

MovieClip.prototype.colorTransformTo = function (propDest_ra, propDest_rb, propDest_ga, propDest_gb, propDest_ba, propDest_bb, propDest_aa, propDest_ab, timeSeconds, animType, delay, callback, extra1, extra2) {
  // Does a color transformation tweening, based on Flash's "advanced" color transformation settings.
  // Works like Flash MX's color.setTransform method, although it uses properties directly as parameters and not a color object
  //  Example: <movieclip>.colorTo(200, 0, 200, 0, 200, 0, undefined, undefined, 2) --> 'dodged' colors
  //           <movieclip>.colorTo(100, 0, 100, 0, 100, 0, 100, 0, 2)  --> 'normal' state of a movieclip
  // ra = red alpha, % of the original object's color to remain on the new object
  // rb = red offset, how much to add to the red color
  // ga, gb = same for green
  // ba, bb = same for blue
  // aa, ab = same for alpha

  // 2.16.13, complete new method: __special_mc_XX__ is understood by the tweening function as a hardcoded link to the movieclip's color object's XX property
  this.tween(["__special_mc_ra__", "__special_mc_rb__", "__special_mc_ga__", "__special_mc_gb__", "__special_mc_ba__", "__special_mc_bb__", "__special_mc_aa__", "__special_mc_ab__"], [propDest_ra, propDest_rb, propDest_ga, propDest_gb, propDest_ba, propDest_bb, propDest_aa, propDest_ab], timeSeconds, animType, delay, callback, extra1, extra2);
};
ASSetPropFlags(MovieClip.prototype, "colorTransformTo", 1, 0);

/*
===============================================================================
= _global.findTweenValue()
=
= FUNCTION (internal). Returns the current value of a property mid-value given the time.
= Used by the tween methods to see where the movieclip should be on the current
= tweening process. All equations on this function are Robert Penner's work.

=
= How to use:
=      <var> = findTweenValue(pStart, pEnd, tStart, tNow, tEnd, animType, extra1, extra2)
=
= Parameters:
=      pStart   = initial property value (number)
=      pEnd     = end property value (number)
=      tStart   = starting time (seconds, miliseconds, or frames)
=      tNow     = time now (seconds, miliseconds, or frames)
=      tEnd     = ending time (seconds, miliseconds, or frames)
=      animType = animation type (string)
=      extra1   = optional animation parameter.
=                 means AMPLITUDE (a) when animType = *elastic
=                 means OVERSHOOT AMMOUNT (s) when animType = *back
=      extra2   = optional animation parameter.
=                 means PERIOD (p) when animType = *elastic
=
= Examples:
=      x = findTweenValue (0, 100, 0, 555, 1000, "linear");
=      stuff = findTweenValue (0, 100, ti, getTimer(), ti+1000, "easeinout");
=
===============================================================================
*/
_global.findTweenValue = function (_propStart, _propDest, _timeStart, _timeNow, _timeDest, _animType, _extra1, _extra2) {
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

  case "easeinquad":
    // quadratic (t^2) easing in - accelerating from zero velocity
    return c*(t/=d)*t + b;
  case "easeoutquad":
    // quadratic (t^2) easing out - decelerating to zero velocity
    return -c *(t/=d)*(t-2) + b;
  case "easeinoutquad":
    // quadratic (t^2) easing in/out - acceleration until halfway, then deceleration
    if ((t/=d/2) < 1) return c/2*t*t + b;
    return -c/2 * ((--t)*(t-2) - 1) + b;

  case "easeincubic":
    // cubic (t^3) easing in - accelerating from zero velocity
    return c*(t/=d)*t*t + b;
  case "easeoutcubic":
    // cubic (t^3) easing out - decelerating to zero velocity
    return c*((t=t/d-1)*t*t + 1) + b;
  case "easeinoutcubic":
    // cubic (t^3) easing in/out - acceleration until halfway, then deceleration
    if ((t/=d/2) < 1) return c/2*t*t*t + b;
    return c/2*((t-=2)*t*t + 2) + b;

  case "easeinquart":
    // quartic (t^4) easing in - accelerating from zero velocity
    return c*(t/=d)*t*t*t + b;
  case "easeoutquart":

    // quartic (t^4) easing out - decelerating to zero velocity
    return -c * ((t=t/d-1)*t*t*t - 1) + b;
  case "easeinoutquart":
    // quartic (t^4) easing in/out - acceleration until halfway, then deceleration
    if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
    return -c/2 * ((t-=2)*t*t*t - 2) + b;

  case "easeinquint":
    // quintic (t^5) easing in - accelerating from zero velocity
    return c*(t/=d)*t*t*t*t + b;
  case "easeoutquint":
    // quintic (t^5) easing out - decelerating to zero velocity
    return c*((t=t/d-1)*t*t*t*t + 1) + b;
  case "easeinoutquint":
    // quintic (t^5) easing in/out - acceleration until halfway, then deceleration
    if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
    return c/2*((t-=2)*t*t*t*t + 2) + b;

  case "easeinsine":
    // sinusoidal (sin(t)) easing in - accelerating from zero velocity
    return -c * Math.cos(t/d * (Math.PI/2)) + c + b;
  case "easeoutsine":
    // sinusoidal (sin(t)) easing out - decelerating to zero velocity
    return c * Math.sin(t/d * (Math.PI/2)) + b;
  case "easeinoutsine":
    // sinusoidal (sin(t)) easing in/out - acceleration until halfway, then deceleration
    return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;

  case "easeinexpo":
    // exponential (2^t) easing in - accelerating from zero velocity
    return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b;
  case "easeoutexpo":
    // exponential (2^t) easing out - decelerating to zero velocity
    return (t==d) ? b+c : c * (-Math.pow(2, -10 * t/d) + 1) + b;
  case "easeinoutexpo":
    // exponential (2^t) easing in/out - acceleration until halfway, then deceleration
    if (t==0) return b;
    if (t==d) return b+c;
    if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b;
    return c/2 * (-Math.pow(2, -10 * --t) + 2) + b;

  case "easeincirc":
    // circular (sqrt(1-t^2)) easing in - accelerating from zero velocity
    return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b;
  case "easeoutcirc":
    // circular (sqrt(1-t^2)) easing out - decelerating to zero velocity
    return c * Math.sqrt(1 - (t=t/d-1)*t) + b;
  case "easeinoutcirc":
    // circular (sqrt(1-t^2)) easing in/out - acceleration until halfway, then deceleration
    if ((t/=d/2) < 1) return -c/2 * (Math.sqrt(1 - t*t) - 1) + b;
    return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b;

  case "easeinelastic":
    // elastic (exponentially decaying sine wave)
    if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
    if (!a || a < Math.abs(c)) { a=c; var s=p/4; }
    else var s = p/(2*Math.PI) * Math.asin (c/a);
    return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
  case "easeoutelastic":
    // elastic (exponentially decaying sine wave)
    if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
    if (!a || a < Math.abs(c)) { a=c; var s=p/4; }
    else var s = p/(2*Math.PI) * Math.asin (c/a);
    return (a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b);
  case "easeinoutelastic":
    // elastic (exponentially decaying sine wave)
    if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
    if (!a || a < Math.abs(c)) { a=c; var s=p/4; }
    else var s = p/(2*Math.PI) * Math.asin (c/a);
    if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
    return (a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )*.5 + c + b);

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
  case "easeinoutback":
    // back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing in/out - backtracking slightly, then reversing direction and moving to target, then overshooting target, reversing, and finally coming back to target
    if (s == undefined) s = 1.70158; 
    if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
    return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;

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
  case "easeinoutbounce":
    // bounce (exponentially decaying parabolic bounce) easing in/out
    if (t < d/2) return findTweenValue (0, c, 0, t*2, d, "easeInBounce") * .5 + b;
    return findTweenValue(0, c, 0, t*2-d, d, "easeOutBounce") * .5 + c*.5 + b;
  }
};
ASSetPropFlags(_global, "findTweenValue", 1, 0);