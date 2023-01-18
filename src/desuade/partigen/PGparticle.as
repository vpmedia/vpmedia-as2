class com.desuade.partigen.PGparticle extends MovieClip
{
    var _x, _y, getDepth, plife, isfrozen, id, _alpha, _antifreeze, mode, emitter, _yscale, _xscale, _width, _height, __get___mode, _parent, _physics_ax, _physics_ay, xang, yang, _physics_vx, _physics_vy, __set___physics_fx, __set___physics_fy, _rotation, physics_fx, __get___physics_fx, physics_fy, __get___physics_fy, _name, __get___emitter, __get___id, removeMovieClip, __get___frozen, __get___life;
    function PGparticle(grent, pid, pang)
    {
        super();
        grent._allparticles[pid] = this;
        _x = grent.__get___emissionpoint()[0];
        _y = grent.__get___emissionpoint()[1];
        com.desuade.partigen.Errors.output(true, 311, 2, grent.__get___namers() + ".particle", undefined, getTimer() / 1000 + "s #" + pid + " @" + this.getDepth() + ": " + this + " (" + _x + "," + _y);
        if (grent.__get___colorstart() != undefined && grent.__get___colorstart() != "disabled")
        {
            com.mosesSupposes.fuse.ZigoEngine.setColorByKey(this, "tint", grent.__get___colorstart()[1], grent.__get___colorstart()[0]);
        } // end if
        oef = grent.oef;
        var _loc9 = com.desuade.partigen.Partigen.randomRange;
        var _loc4 = _loc9(grent.__get___life()[0], grent.__get___life()[1], 2);
        plife = _loc4;
        isfrozen = false;
        id = pid;
        _alpha = grent._alphastart;
        _antifreeze = false;
        mode = grent._mode[0];
        emitter = grent;
        var _loc7 = _loc9(grent.__get___scalestart()[0], grent.__get___scalestart()[1]);
        if (grent.__get___size() == "disabled")
        {
            _xscale = _yscale = _loc7;
        }
        else
        {
            _width = typeof(grent.__get___size()[0]) == "string" ? (Number(grent.__get___size()[0]) + _width) : (grent.__get___size()[0]);
            _height = typeof(grent.__get___size()[1]) == "string" ? (Number(grent.__get___size()[1]) + _height) : (grent.__get___size()[1]);
        } // end else if
        switch (this.__get___mode())
        {
            case "tween":
            {
                if (_parent == grent)
                {
                    if (typeof(grent._tween_x) == "number")
                    {
                        var _loc5 = grent._useParentCoordsT ? (grent._tween_x - grent._parent._x) : (grent._tween_x - grent._x);
                    }
                    else
                    {
                        _loc5 = grent._tween_x;
                    } // end else if
                    if (typeof(grent._tween_y) == "number")
                    {
                        tempy = grent._useParentCoordsT ? (grent._tween_y - grent._parent._y) : (grent._tween_y - grent._y);
                    }
                    else
                    {
                        tempy = grent._tween_y;
                    } // end else if
                    if (typeof(grent._tween_cx) == "number")
                    {
                        var _loc13 = grent._useParentCoordsT ? (grent._tween_cx - grent._parent._x) : (grent._tween_cx - grent._x);
                    }
                    else
                    {
                        _loc13 = grent._tween_cx;
                    } // end else if
                    if (typeof(grent._tween_cy) == "number")
                    {
                        var _loc12 = grent._useParentCoordsT ? (grent._tween_cy - grent._parent._y) : (grent._tween_cy - grent._y);
                    }
                    else
                    {
                        _loc12 = grent._tween_cy;
                    } // end else if
                }
                else
                {
                    _loc5 = grent._tween_x;
                    var tempy = grent._tween_y;
                    _loc13 = grent._tween_cx;
                    _loc12 = grent._tween_cy;
                } // end else if
                if (grent._tween_cx == "disabled" || grent._tween_cy == "disabled")
                {
                    com.mosesSupposes.fuse.ZigoEngine.doTween(this, "_x,_y", [_loc5, tempy], grent._tween_duration, grent._tween_ease, grent._tween_delay, {skipLevel: 2, scope: this, func: function ()
                    {
                        if (_emitter._events.onTweenEnd === true || com.desuade.partigen.Partigen._events.onTweenEnd === true)
                        {
                            com.desuade.partigen.Partigen.broadcastMessage("tweenEndEvent", _emitter, this);
                        } // end if
                    }});
                }
                else
                {
                    com.mosesSupposes.fuse.ZigoEngine.doTween(this, "_bezier_", {x: _loc5, y: tempy, controlX: _loc13, controlY: _loc12}, grent._tween_duration, grent._tween_ease, grent._tween_delay, {skipLevel: 2, scope: this, func: function ()
                    {
                        if (_emitter._events.onTweenEnd === true || com.desuade.partigen.Partigen._events.onTweenEnd === true)
                        {
                            com.desuade.partigen.Partigen.broadcastMessage("tweenEndEvent", _emitter, this);
                        } // end if
                    }});
                } // end else if
                break;
            } 
            case "physics":
            {
                _physics_ax = grent._physics_ax;
                _physics_ay = grent._physics_ay;
                xang = grent.xang;
                yang = grent.yang;
                _physics_vx = grent._physics_vx * xang;
                _physics_vy = grent._physics_vy * yang;
                this.__set___physics_fx(grent._physics_fx);
                this.__set___physics_fy(grent._physics_fy);
                break;
            } 
        } // End of switch
        if (grent._startaligned)
        {
            switch (mode)
            {
                case "physics":
                {
                    var _loc6 = Math.round(Math.abs(pang - grent._orientation));
                    if (pang >= 0 && pang <= grent._orientation)
                    {
                        _rotation = pang >= 0 ? (_loc6) : (-_loc6);
                    }
                    else
                    {
                        _rotation = pang >= 0 ? (-_loc6) : (_loc6);
                    } // end else if
                    break;
                } 
                case "tween":
                {
                    var _loc11 = typeof(_loc5) == "number" ? (_loc5 - _x) : (_loc5 + _x - _x);
                    var _loc10 = typeof(tempy) == "number" ? (tempy - _y) : (tempy + _y - _y);
                    var _loc18 = Math.round(Math.atan2(_loc10 * -1, _loc11) / 1.745329E-002) - grent._orientation;
                    _rotation = _loc18 * -1;
                    break;
                } 
            } // End of switch
        }
        else
        {
            _rotation = grent._rotationstart;
        } // end else if
        this.roef();
        if (grent._events.onBirth === true || com.desuade.partigen.Partigen._events.onBirth === true)
        {
            com.desuade.partigen.Partigen.broadcastMessage("birthEvent", grent, this);
        } // end if
        if (_loc4 < 0)
        {
            com.desuade.partigen.Errors.output(true, 313, 2, grent.__get___namers() + ".particle", undefined, getTimer() / 1000 + ": " + this);
        }
        else
        {
            if (grent._rotationend != "disabled")
            {
                com.mosesSupposes.fuse.ZigoEngine.doTween(this, "_rotation", grent._rotationend, _loc4, "linear", 0);
            } // end if
            if (grent.__get___colorend() != "disabled")
            {
                com.mosesSupposes.fuse.ZigoEngine.doTween(this, "_tint", {tint: grent.__get___colorend()[0], percent: grent.__get___colorend()[1]}, _loc4, "linear", 0);
            } // end if
            if (grent.__get___scaleend() != "disabled" && grent.__get___size() == "disabled")
            {
                var _loc16 = typeof(grent.__get___scaleend()[0]) == "string" ? (_loc7 + Number(grent.__get___scaleend()[0])) : (grent.__get___scaleend()[0]);
                var _loc14 = typeof(grent.__get___scaleend()[1]) == "string" ? (_loc7 + Number(grent.__get___scaleend()[1])) : (grent.__get___scaleend()[1]);
                var _loc17 = _loc9(_loc16, _loc14);
                com.mosesSupposes.fuse.ZigoEngine.doTween(this, "_scale", _loc17, _loc4, "linear", 0);
            } // end if
            if (grent._alphaend != "disabled")
            {
                com.mosesSupposes.fuse.ZigoEngine.doTween(this, "_alpha", grent._alphaend, _loc4, "linear", 0);
            } // end if
            com.mosesSupposes.fuse.ZigoEngine.doTween(this, "plife", 0, _loc4, "linear", 0, {skipLevel: 0, scope: this, func: function ()
            {
                this.kill(true, false, true);
            }});
        } // end else if
    } // End of the function
    function get _physics_fx()
    {
        return (physics_fx);
    } // End of the function
    function set _physics_fx(val)
    {
        phys_fx = 1 - val / 100;
        physics_fx = val;
        //return (this._physics_fx());
        null;
    } // End of the function
    function get _physics_fy()
    {
        return (physics_fy);
    } // End of the function
    function set _physics_fy(val)
    {
        phys_fy = 1 - val / 100;
        physics_fy = val;
        //return (this._physics_fy());
        null;
    } // End of the function
    function get _life()
    {
        return (plife);
    } // End of the function
    function get _mode()
    {
        return (mode);
    } // End of the function
    function get _emitter()
    {
        return (emitter);
    } // End of the function
    function get _id()
    {
        return (id);
    } // End of the function
    function get _frozen()
    {
        return (isfrozen);
    } // End of the function
    function kill(de, em, dnk)
    {
        de = de == undefined ? (true) : (de);
        var _loc3 = em ? (this.__get___emitter()._name) : (_name);
        var _loc6 = dnk ? (312) : (314);
        var _loc7 = dnk ? (2) : (1);
        var _loc4 = dnk ? (this.__get___emitter().__get___namers() + ".particle") : (_loc3 + ".kill");
        com.desuade.partigen.Errors.output(true, _loc6, _loc7, _loc4, undefined, getTimer() / 1000 + "s: #" + this.__get___id() + " (" + _x + "," + _y);
        if (de)
        {
            if (this.__get___emitter()._events.onDeath === true || com.desuade.partigen.Partigen._events.onDeath === true)
            {
                com.desuade.partigen.Partigen.broadcastMessage("deathEvent", this.__get___emitter(), this);
            } // end if
        } // end if
        delete this.__get___emitter()._allparticles[this.__get___id()];
        this.removeMovieClip();
    } // End of the function
    function freeze(force)
    {
        _antifreeze = force == undefined ? (_antifreeze) : (!force);
        this.__get___emitter().freeze(this);
    } // End of the function
    function thaw()
    {
        this.__get___emitter().thaw(this);
    } // End of the function
    function oef(particle)
    {
    } // End of the function
    function roef()
    {
        switch (this.__get___mode())
        {
            case "tween":
            {
                function onEnterFrame()
                {
                    this.oef(this);
                } // End of the function
                break;
            } 
            case "physics":
            {
                function onEnterFrame()
                {
                    _physics_vx = _physics_vx + _physics_ax;
                    _physics_vy = _physics_vy + _physics_ay;
                    _physics_vx = _physics_vx * phys_fx;
                    _physics_vy = _physics_vy * phys_fy;
                    _x = _x + (_physics_vx = Math.round(_physics_vx * 100) / 100);
                    _y = _y - (_physics_vy = Math.round(_physics_vy * 100) / 100);
                    this.oef(this);
                } // End of the function
                break;
            } 
        } // End of switch
    } // End of the function
} // End of Class
