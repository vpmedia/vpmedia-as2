class com.desuade.partigen.PGemitter extends MovieClip
{
    var id, _parent, _useParentCoords, _mode, _name, namers, emissionPoint, _allparticles, __set___emissiontarget, _burst, _lowestdepth, __set___life, _source, _total, _alphaend, timeout, _rotationstart, _events, _order, __set___eps, _alphastart, __set___scalestart, _rotationend, _tween_cy, _tween_cx, _physics_anglerange, __set___size, __set___colorend, __set___colorstart, __set___scaleend, _tween_x, _tween_y, _tween_duration, _startaligned, _orientation, _tween_delay, _tween_ease, _physics_vx, _physics_vy, _physics_ax, _physics_ay, _physics_fx, _physics_fy, __set___physics_angle, _lineconfig, _boxconfig, lineseg, _loc4, emissiontarget, __get___emissiontarget, __get___active, __get___timeout, __get___physics_anglerange_min, __get___physics_anglerange_max, __get___colorstart, __get___colorstart_color, __get___colorstart_percent, __get___colorend, __get___colorend_color, __get___colorend_percent, __get___scaleend, __get___scaleend_min, __get___scaleend_max, __get___scalestart, __get___scalestart_min, __get___scalestart_max, __get___life, __get___life_min, __get___life_max, __get___size, __get___size_width, __get___size_height, __get___mode_mode, __get___mode_emission, __get___lineconfig_x, __get___lineconfig_y, __get___lineconfig_points, __get___boxconfig_x, __get___boxconfig_y, eps, intervalPG, __get___eps, active, colorStart, colorEnd, psize, plife, pscalestart, pscaleend, phys_angle, __get___physics_angle, xang, yang, _y, _x, onEnterFrame, __get___particles, __set___boxconfig_x, __set___boxconfig_y, __set___colorend_color, __set___colorend_percent, __set___colorstart_color, __set___colorstart_percent, __get___emissionpoint, __get___id, __set___life_max, __set___life_min, __set___lineconfig_points, __set___lineconfig_x, __set___lineconfig_y, __get___lineseg, __set___mode_emission, __set___mode_mode, __get___namers, __set___physics_anglerange_max, __set___physics_anglerange_min, __set___scaleend_max, __set___scaleend_min, __set___scalestart_max, __set___scalestart_min, __set___size_height, __set___size_width, __set___timeout;
    function PGemitter(propobj, ptarget, eid, dmcl)
    {
        super();
        com.desuade.partigen.Partigen.emitters[eid] = this;
        id = eid;
        _useParentCoords = _parent.useParentCoords != undefined ? (_parent.useParentCoords) : (false);
        if (dmcl._licensetype == "P" && _parent.ide != true)
        {
            com.desuade.partigen.Errors.output(true, 412, 0);
        }
        else
        {
            _parent.logo._visible = false;
            _mode = com.desuade.partigen.Partigen._defaultmode;
            namers = _parent.ide ? (_parent._name) : (_name);
            emissionPoint = new Array();
            _allparticles = new Object();
            this.__set___emissiontarget(ptarget);
            this.__set___life(_lowestdepth = _burst = 1);
            _source = com.desuade.partigen.Partigen._defaultsource;
            _rotationstart = timeout = _alphaend = _total = 0;
            _events = {onDeath: false, onBirth: false, onTweenEnd: false};
            _order = "front";
            this.__set___eps(10);
            this.__set___scalestart(_alphastart = 100);
            this.__set___scaleend(this.__set___colorstart(this.__set___colorend(this.__set___size(_physics_anglerange = _tween_cx = _tween_cy = _rotationend = "disabled"))));
            _tween_x = "0";
            _tween_y = "-200";
            _tween_duration = 2;
            _startaligned = false;
            _orientation = 90;
            _tween_delay = 0;
            _tween_ease = com.desuade.partigen.Partigen._defaultease;
            _physics_vx = 2;
            _physics_vy = 4;
            _physics_ax = 0;
            _physics_ay = -1.000000E-001;
            _physics_fx = 0;
            _physics_fy = 0;
            this.__set___physics_angle(90);
            _lineconfig = ["100", "0", 4];
            _boxconfig = ["100", "100"];
            lineseg = -1;
            for (var _loc4 in propobj)
            {
                this[_loc4] = propobj[_loc4];
            } // end of for...in
        } // end else if
    } // End of the function
    function get _emissiontarget()
    {
        return (emissiontarget);
    } // End of the function
    function set _emissiontarget(et)
    {
        switch (et)
        {
            case 0:
            {
                this.emissiontarget = this;
                break;
            } 
            case 1:
            {
                this.emissiontarget = this._useParentCoords ? (this._parent._parent) : (this._parent);
                break;
            } 
            default:
            {
                this.emissiontarget = eval(et);
                break;
            } 
        } // End of switch
        if (this.emissiontarget._totalparticles == undefined)
        {
            this.emissiontarget._totalparticles = 0;
        } // end if
        //return (this._emissiontarget());
        null;
    } // End of the function
    function get _id()
    {
        return (id);
    } // End of the function
    function get _timeout()
    {
        return (timeout);
    } // End of the function
    function set _timeout(to)
    {
        var _loc3 = timeout;
        timeout = to > 0 ? (to) : (0);
        if (_loc3 == 0 && to == 0)
        {
        }
        else if (to > 0)
        {
            if (this.__get___active())
            {
                com.desuade.partigen.Errors.output(true, 245, 1, namers, timeout + " seconds.");
                com.mosesSupposes.fuse.ZigoEngine.doTween(this, "timeout", 0, timeout, "linear", 0, {skipLevel: 0, scope: this, func: function ()
                {
                }});
            }
            else
            {
                com.desuade.partigen.Errors.output(true, 247, 1, namers, timeout + " seconds.");
            } // end else if
        }
        else
        {
            com.desuade.partigen.Errors.output(true, 246, 1, namers);
            com.mosesSupposes.fuse.ZigoEngine.removeTween(this, "timeout");
        } // end else if
        //return (this._timeout());
        null;
    } // End of the function
    function get _physics_anglerange_min()
    {
        return (_physics_anglerange == "disabled" ? ("disabled") : (_physics_anglerange[0]));
    } // End of the function
    function set _physics_anglerange_min(min)
    {
        _physics_anglerange = typeof(_physics_anglerange) != "object" ? ([]) : (_physics_anglerange);
        _physics_anglerange[0] = min;
        //return (this._physics_anglerange_min());
        null;
    } // End of the function
    function get _physics_anglerange_max()
    {
        return (_physics_anglerange == "disabled" ? ("disabled") : (_physics_anglerange[1]));
    } // End of the function
    function set _physics_anglerange_max(max)
    {
        _physics_anglerange = typeof(_physics_anglerange) != "object" ? ([]) : (_physics_anglerange);
        _physics_anglerange[1] = max;
        //return (this._physics_anglerange_max());
        null;
    } // End of the function
    function get _colorstart_color()
    {
        //return (this._colorstart() == "disabled" ? ("disabled") : (this.__get___colorstart()[0]));
    } // End of the function
    function set _colorstart_color(color)
    {
        this.__set___colorstart(typeof(this.__get___colorstart()) != "object" ? ([]) : (this.__get___colorstart()));
        this.__get___colorstart()[0] = color;
        //return (this._colorstart_color());
        null;
    } // End of the function
    function get _colorstart_percent()
    {
        //return (this._colorstart() == "disabled" ? ("disabled") : (this.__get___colorstart()[1]));
    } // End of the function
    function set _colorstart_percent(percent)
    {
        this.__set___colorstart(typeof(this.__get___colorstart()) != "object" ? ([]) : (this.__get___colorstart()));
        this.__get___colorstart()[1] = percent;
        //return (this._colorstart_percent());
        null;
    } // End of the function
    function get _colorend_color()
    {
        //return (this._colorend() == "disabled" ? ("disabled") : (this.__get___colorend()[0]));
    } // End of the function
    function set _colorend_color(color)
    {
        this.__set___colorend(typeof(this.__get___colorend()) != "object" ? ([]) : (this.__get___colorend()));
        this.__get___colorend()[0] = color;
        //return (this._colorend_color());
        null;
    } // End of the function
    function get _colorend_percent()
    {
        //return (this._colorend() == "disabled" ? ("disabled") : (this.__get___colorend()[1]));
    } // End of the function
    function set _colorend_percent(percent)
    {
        this.__set___colorend(typeof(this.__get___colorend()) != "object" ? ([]) : (this.__get___colorend()));
        this.__get___colorend()[1] = percent;
        //return (this._colorend_percent());
        null;
    } // End of the function
    function get _scaleend_min()
    {
        //return (this._scaleend() == "disabled" ? ("disabled") : (this.__get___scaleend()[0]));
    } // End of the function
    function set _scaleend_min(min)
    {
        this.__set___scaleend(typeof(this.__get___scaleend()) != "object" ? ([]) : (this.__get___scaleend()));
        this.__get___scaleend()[0] = min;
        //return (this._scaleend_min());
        null;
    } // End of the function
    function get _scaleend_max()
    {
        //return (this._scaleend() == "disabled" ? ("disabled") : (this.__get___scaleend()[1]));
    } // End of the function
    function set _scaleend_max(max)
    {
        this.__set___scaleend(typeof(this.__get___scaleend()) != "object" ? ([]) : (this.__get___scaleend()));
        this.__get___scaleend()[1] = max;
        //return (this._scaleend_max());
        null;
    } // End of the function
    function get _scalestart_min()
    {
        //return (this._scalestart()[0]);
    } // End of the function
    function set _scalestart_min(min)
    {
        this.__get___scalestart()[0] = min;
        //return (this._scalestart_min());
        null;
    } // End of the function
    function get _scalestart_max()
    {
        //return (this._scalestart()[1]);
    } // End of the function
    function set _scalestart_max(max)
    {
        this.__get___scalestart()[1] = max;
        //return (this._scalestart_max());
        null;
    } // End of the function
    function get _life_min()
    {
        //return (this._life()[0]);
    } // End of the function
    function set _life_min(min)
    {
        this.__get___life()[0] = min;
        //return (this._life_min());
        null;
    } // End of the function
    function get _life_max()
    {
        //return (this._life()[1]);
    } // End of the function
    function set _life_max(max)
    {
        this.__get___life()[1] = max;
        //return (this._life_max());
        null;
    } // End of the function
    function get _size_width()
    {
        //return (this._size() == "disabled" ? ("disabled") : (this.__get___size()[0]));
    } // End of the function
    function set _size_width(w)
    {
        this.__set___size(typeof(this.__get___size()) != "object" ? ([]) : (this.__get___size()));
        this.__get___size()[0] = w;
        //return (this._size_width());
        null;
    } // End of the function
    function get _size_height()
    {
        //return (this._size() == "disabled" ? ("disabled") : (this.__get___size()[1]));
    } // End of the function
    function set _size_height(h)
    {
        this.__set___size(typeof(this.__get___size()) != "object" ? ([]) : (this.__get___size()));
        this.__get___size()[1] = h;
        //return (this._size_height());
        null;
    } // End of the function
    function get _mode_mode()
    {
        return (_mode[0]);
    } // End of the function
    function set _mode_mode(m)
    {
        _mode[0] = m;
        //return (this._mode_mode());
        null;
    } // End of the function
    function get _mode_emission()
    {
        return (_mode[1]);
    } // End of the function
    function set _mode_emission(t)
    {
        _mode[1] = t;
        //return (this._mode_emission());
        null;
    } // End of the function
    function get _lineconfig_x()
    {
        return (_lineconfig[0]);
    } // End of the function
    function set _lineconfig_x(m)
    {
        _lineconfig[0] = m;
        //return (this._lineconfig_x());
        null;
    } // End of the function
    function get _lineconfig_y()
    {
        return (_lineconfig[1]);
    } // End of the function
    function set _lineconfig_y(m)
    {
        _lineconfig[1] = m;
        //return (this._lineconfig_y());
        null;
    } // End of the function
    function get _lineconfig_points()
    {
        return (_lineconfig[2]);
    } // End of the function
    function set _lineconfig_points(t)
    {
        _lineconfig[2] = t;
        //return (this._lineconfig_points());
        null;
    } // End of the function
    function get _boxconfig_x()
    {
        return (_boxconfig[0]);
    } // End of the function
    function set _boxconfig_x(m)
    {
        _boxconfig[0] = m;
        //return (this._boxconfig_x());
        null;
    } // End of the function
    function get _boxconfig_y()
    {
        return (_boxconfig[1]);
    } // End of the function
    function set _boxconfig_y(m)
    {
        _boxconfig[1] = m;
        //return (this._boxconfig_y());
        null;
    } // End of the function
    function get _namers()
    {
        return (namers);
    } // End of the function
    function get _eps()
    {
        return (eps);
    } // End of the function
    function set _eps(po)
    {
        if (intervalPG != undefined)
        {
            eps = po;
            clearInterval(intervalPG);
            intervalPG = setInterval(updateTimer, 1000 / this.__get___eps(), this);
        }
        else
        {
            eps = po;
        } // end else if
        //return (this._eps());
        null;
    } // End of the function
    function get _active()
    {
        return (active);
    } // End of the function
    function get _colorstart()
    {
        return (colorStart);
    } // End of the function
    function set _colorstart(colorStartarray)
    {
        if (typeof(colorStartarray) == "string")
        {
            if (colorStartarray == "disabled")
            {
                colorStart = "disabled";
            }
            else
            {
                colorStart = [colorStartarray, 100];
            } // end else if
        }
        else if (typeof(colorStartarray) == "number")
        {
            colorStart = [colorStartarray, 100];
        }
        else
        {
            var _loc4 = colorStartarray[0];
            var _loc3 = colorStartarray[1] != undefined ? (colorStartarray[1]) : (100);
            colorStart = [_loc4, _loc3];
        } // end else if
        //return (this._colorstart());
        null;
    } // End of the function
    function get _colorend()
    {
        return (colorEnd);
    } // End of the function
    function set _colorend(colorEndarray)
    {
        if (typeof(colorEndarray) == "string")
        {
            if (colorEndarray == "disabled")
            {
                colorEnd = "disabled";
            }
            else
            {
                colorEnd = [colorEndarray, 100];
            } // end else if
        }
        else if (typeof(colorEndarray) == "number")
        {
            colorEnd = [colorEndarray, 100];
        }
        else
        {
            var _loc4 = colorEndarray[0];
            var _loc3 = colorEndarray[1] != undefined ? (colorEndarray[1]) : (100);
            colorEnd = [_loc4, _loc3];
        } // end else if
        //return (this._colorend());
        null;
    } // End of the function
    function get _size()
    {
        return (psize);
    } // End of the function
    function set _size(sizearray)
    {
        if (typeof(sizearray) == "number")
        {
            psize = [sizearray, sizearray];
        }
        else if (typeof(sizearray) == "string")
        {
            if (sizearray == "disabled")
            {
                psize = "disabled";
            }
            else
            {
                psize = [sizearray, sizearray];
            } // end else if
        }
        else
        {
            var _loc3 = sizearray[0];
            var _loc4 = sizearray[1] != undefined ? (sizearray[1]) : (_loc3);
            psize = [_loc3, _loc4];
            if (sizearray == undefined || sizearray[0] == undefined)
            {
                psize = undefined;
            } // end else if
        } // end else if
        //return (this._size());
        null;
    } // End of the function
    function get _life()
    {
        return (plife);
    } // End of the function
    function set _life(lifearray)
    {
        if (typeof(lifearray) == "number")
        {
            plife = [lifearray, lifearray];
        }
        else
        {
            var _loc3 = lifearray[0];
            var _loc4 = lifearray[1] != undefined ? (lifearray[1]) : (_loc3);
            plife = [_loc3, _loc4];
        } // end else if
        //return (this._life());
        null;
    } // End of the function
    function get _scalestart()
    {
        return (pscalestart);
    } // End of the function
    function set _scalestart(scalearray)
    {
        if (typeof(scalearray) == "number" || typeof(scalearray) == "string")
        {
            pscalestart = [scalearray, scalearray];
        }
        else
        {
            var _loc3 = scalearray[0];
            var _loc4 = scalearray[1] != undefined ? (scalearray[1]) : (_loc3);
            pscalestart = [_loc3, _loc4];
        } // end else if
        //return (this._scalestart());
        null;
    } // End of the function
    function get _scaleend()
    {
        return (pscaleend);
    } // End of the function
    function set _scaleend(scalearray)
    {
        if (typeof(scalearray) == "number" || typeof(scalearray) == "string")
        {
            if (scalearray == "disabled")
            {
                pscaleend = "disabled";
            }
            else
            {
                pscaleend = [scalearray, scalearray];
            } // end else if
        }
        else
        {
            var _loc3 = scalearray[0];
            var _loc4 = scalearray[1] != undefined ? (scalearray[1]) : (_loc3);
            pscaleend = [_loc3, _loc4];
        } // end else if
        //return (this._scaleend());
        null;
    } // End of the function
    function get _particles()
    {
        var _loc2 = _allparticles;
        var _loc3 = new Array();
        for (var _loc4 in _loc2)
        {
            _loc3.push([_loc2[_loc4], _loc4]);
        } // end of for...in
        return (_loc3);
    } // End of the function
    function get _physics_angle()
    {
        return (phys_angle);
    } // End of the function
    function set _physics_angle(ang)
    {
        phys_angle = typeof(ang) == "string" ? (this.__get___physics_angle() + Number(ang)) : (ang);
        xang = this.__get___physics_angle() != undefined ? (Math.round(Math.cos(this.__get___physics_angle() * 3.141593E+000 / 180) * 1000) / 1000) : (1);
        yang = this.__get___physics_angle() != undefined ? (Math.round(Math.sin(this.__get___physics_angle() * 3.141593E+000 / 180) * 1000) / 1000) : (1);
        //return (this._physics_angle());
        null;
    } // End of the function
    function get _emissionpoint()
    {
        return (emissionPoint);
    } // End of the function
    function get _lineseg()
    {
        return (lineseg);
    } // End of the function
    function emissionType()
    {
        switch (_mode[1])
        {
            case "point":
            {
                if (_useParentCoords)
                {
                    emissionPoint = [com.desuade.partigen.Partigen.convertValue(false, "_x", _parent._x, _parent, this.__get___emissiontarget()), com.desuade.partigen.Partigen.convertValue(false, "_y", _parent._y, _parent, this.__get___emissiontarget())];
                }
                else if (this.__get___emissiontarget() == this)
                {
                    emissionPoint = [0, 0];
                }
                else
                {
                    emissionPoint = [com.desuade.partigen.Partigen.convertValue(false, "_x", _x, this, this.__get___emissiontarget()), com.desuade.partigen.Partigen.convertValue(false, "_y", _y, this, this.__get___emissiontarget())];
                } // end else if
                break;
            } 
            case "box":
            {
                if (_useParentCoords)
                {
                    var _loc3 = com.desuade.partigen.Partigen.convertValue(false, "_x", _parent._x, _parent, this.__get___emissiontarget());
                    var _loc2 = com.desuade.partigen.Partigen.convertValue(false, "_y", _parent._y, _parent, this.__get___emissiontarget());
                }
                else if (this.__get___emissiontarget() == this)
                {
                    _loc3 = 0;
                    _loc2 = 0;
                }
                else
                {
                    _loc3 = com.desuade.partigen.Partigen.convertValue(false, "_x", _x, this, this.__get___emissiontarget());
                    _loc2 = com.desuade.partigen.Partigen.convertValue(false, "_y", _y, this, this.__get___emissiontarget());
                } // end else if
                var _loc9 = typeof(_boxconfig[0]) == "string" ? (_loc3 + Number(_boxconfig[0])) : (_boxconfig[0]);
                var _loc8 = typeof(_boxconfig[1]) == "string" ? (_loc2 + Number(_boxconfig[1])) : (_boxconfig[1]);
                emissionPoint = [com.desuade.partigen.Partigen.randomRange(_loc3, _loc9), com.desuade.partigen.Partigen.randomRange(_loc2, _loc8)];
                break;
            } 
            case "line":
            {
                ++lineseg;
                lineseg = lineseg == _lineconfig[2] ? (0) : (lineseg);
                var _loc4 = lineseg;
                if (_useParentCoords)
                {
                    _loc3 = com.desuade.partigen.Partigen.convertValue(false, "_x", _parent._x, _parent, this.__get___emissiontarget());
                    _loc2 = com.desuade.partigen.Partigen.convertValue(false, "_y", _parent._y, _parent, this.__get___emissiontarget());
                }
                else if (this.__get___emissiontarget() == this)
                {
                    _loc3 = 0;
                    _loc2 = 0;
                }
                else
                {
                    _loc3 = com.desuade.partigen.Partigen.convertValue(false, "_x", _x, this, this.__get___emissiontarget());
                    _loc2 = com.desuade.partigen.Partigen.convertValue(false, "_y", _y, this, this.__get___emissiontarget());
                } // end else if
                var _loc7 = typeof(_lineconfig[0]) == "string" ? (_loc3 + Number(_lineconfig[0])) : (_lineconfig[0]);
                var _loc6 = typeof(_lineconfig[1]) == "string" ? (_loc2 + Number(_lineconfig[1])) : (_lineconfig[1]);
                var _loc5 = _lineconfig[2] - 1;
                emissionPoint = [int(_loc3 + (_loc7 - _loc3) / _loc5 * _loc4), int(_loc2 + (_loc6 - _loc2) / _loc5 * _loc4)];
                break;
            } 
        } // End of switch
    } // End of the function
    function updateTimer(tt)
    {
        var _loc12 = tt._burst;
        var _loc3 = tt.__get___emissiontarget();
        var _loc9 = com.desuade.partigen.Partigen.randomRange;
        var _loc10 = [];
        var _loc2;
        var _loc11 = 0;
        while (_loc11++ < _loc12)
        {
            if (tt._mode[0] == "physics")
            {
                tt.__set___physics_angle(tt._physics_anglerange != "disabled" ? (_loc9(tt._physics_anglerange[0], tt._physics_anglerange[1], 2)) : (tt.__get___physics_angle()));
            } // end if
            tt.emissionType();
            var _loc5 = "p_" + (_loc3._totalparticles + 1);
            var _loc6 = tt._total + 1;
            switch (tt._order)
            {
                case "front":
                {
                    _loc2 = _loc3._totalparticles + tt._lowestdepth;
                    if (_loc2 >= tt.dceil)
                    {
                        for (var _loc4 = 0; _loc2 > (_loc4 + 1) * tt.dceil; ++_loc4)
                        {
                        } // end of for
                        _loc2 = _loc2 - _loc4 * tt.dceil + tt._lowestdepth;
                    } // end if
                    break;
                } 
                case "back":
                {
                    _loc2 = tt.dceil - _loc3._totalparticles;
                    if (_loc2 <= tt._lowestdepth)
                    {
                        for (var _loc4 = 0; _loc2 + _loc4 * tt.dceil < tt._lowestdepth; ++_loc4)
                        {
                        } // end of for
                        _loc2 = _loc2 + _loc4 * tt.dceil;
                        trace (_loc4 + " | " + _loc2);
                    } // end if
                    break;
                } 
                case "random":
                {
                    var _loc8 = _loc9(tt._lowestdepth, tt.dceil);
                    _loc2 = _loc3.getInstanceAtDepth(_loc8) == undefined ? (_loc8) : (_loc9(tt._lowestdepth, tt.dceil));
                    break;
                } 
            } // End of switch
            if (tt._source.charCodeAt(0) == 42)
            {
                var _loc7 = MovieClip.prototype.createEmptyMovieClip.apply(_loc3, [_loc5, _loc2]);
                _loc3[_loc5].createEmptyMovieClip("loadedskin", 0);
                _loc3[_loc5].loadedskin.loadMovie(tt._source.slice(1));
                if (_loc3[_loc5].loadedskin != undefined)
                {
                    _loc7.__proto__ = tt._emitclass.prototype;
                    tt._emitclass.apply(_loc7, [tt, _loc6, tt.__get___physics_angle()]);
                    ++_loc3._totalparticles;
                    ++tt._total;
                    _loc10.push(_loc6);
                }
                else
                {
                    com.desuade.partigen.Errors.output(true, 211, 2, "PGemitter");
                } // end else if
                continue;
            } // end if
            _loc7 = MovieClip.prototype.attachMovie.apply(_loc3, [tt._source, _loc5, _loc2]);
            if (_loc7 != undefined)
            {
                _loc7.__proto__ = tt._emitclass.prototype;
                tt._emitclass.apply(_loc7, [tt, _loc6, tt.__get___physics_angle()]);
                ++_loc3._totalparticles;
                ++tt._total;
                _loc10.push(_loc6);
                continue;
            } // end if
            com.desuade.partigen.Errors.output(true, 212, 2, "PGemitter");
        } // end while
        return (_loc10);
    } // End of the function
    function start(doverify, verbose, timeout)
    {
        function starty()
        {
            if (com.desuade.partigen.Partigen._useinterval)
            {
                if (tt.intervalPG == undefined)
                {
                    tt.intervalPG = setInterval(tt.updateTimer, 1000 / tt._eps, tt);
                    tt.active = true;
                    com.desuade.partigen.Errors.output(true, 221, 1, tt.namers + ".start", tt);
                    tt._timeout = timeout;
                    return (true);
                }
                else
                {
                    com.desuade.partigen.Errors.output(true, 222, 1, tt.namers + ".start");
                    return (false);
                } // end else if
            }
            else
            {
                tt.onEnterFrame = function ()
                {
                    tt.updateTimer(tt);
                };
                tt.active = true;
                com.desuade.partigen.Errors.output(true, 221, 1, tt.namers + ".start", tt);
                tt._timeout = timeout;
                return (true);
            } // end else if
        } // End of the function
        var _loc2 = doverify == undefined ? (true) : (doverify);
        var tt = this;
        var timeout = timeout == undefined ? (tt._timeout) : (timeout);
        if (_loc2)
        {
            this.verify(verbose, undefined, true, timeout);
        }
        else
        {
            return (starty());
        } // end else if
    } // End of the function
    function stop()
    {
        if (active == true)
        {
            if (com.desuade.partigen.Partigen._useinterval)
            {
                clearInterval(intervalPG);
                delete this.intervalPG;
            }
            else
            {
                delete this.onEnterFrame;
            } // end else if
            active = false;
            timeout = 0;
            com.mosesSupposes.fuse.ZigoEngine.removeTween(this, "timeout");
            com.desuade.partigen.Errors.output(true, 223, 1, namers + ".stop", this);
            return (true);
        }
        else
        {
            com.desuade.partigen.Errors.output(true, 224, 1, namers + ".stop");
            return (false);
        } // end else if
    } // End of the function
    function toggleFreeze()
    {
        var _loc3 = this.__get___particles();
        var _loc4 = {frozen: [], thawed: []};
        var _loc2 = _loc3.length;
        if (_loc2 != 0 && _loc2 != undefined)
        {
            com.desuade.partigen.Errors.output(true, 231, 1, namers + ".toggleFreeze");
            do
            {
                --_loc2;
                var tt = _loc3[_loc2][0];
                if (!tt._antifreeze)
                {
                    if (tt._frozen)
                    {
                        tt.roef();
                        com.mosesSupposes.fuse.ZigoEngine.unpauseTween(tt);
                        tt.isfrozen = false;
                        _loc4.thawed.push(_loc3[_loc2][1]);
                        com.desuade.partigen.Errors.output(true, 232, 2, namers + ".toggleFreeze", tt);
                    }
                    else if (!tt._frozen)
                    {
                        tt.onEnterFrame = function ()
                        {
                            tt.oef(tt);
                        };
                        com.mosesSupposes.fuse.ZigoEngine.pauseTween(tt);
                        tt.isfrozen = true;
                        _loc4.frozen.push(_loc3[_loc2][1]);
                        com.desuade.partigen.Errors.output(true, 233, 2, namers + ".toggleFreeze", tt + "(" + tt._x + "," + tt._y + ")");
                    } // end else if
                    continue;
                } // end if
                com.desuade.partigen.Errors.output(true, 236, 2, namers + ".toggleFreeze", "", tt);
            } while (_loc2)
        }
        else
        {
            com.desuade.partigen.Errors.output(true, 239, 1, namers + ".toggleFreeze");
        } // end else if
        return (_loc4);
    } // End of the function
    function freeze(a1, a2)
    {
        if (a1 == undefined)
        {
            var _loc4 = this.__get___particles();
            a1 = 0;
            a2 = 0;
        }
        else if (a2 == undefined)
        {
            _loc4 = [this.__get___particles()[a1]];
        }
        else
        {
            _loc4 = this.__get___particles().slice(a1, a2);
        } // end else if
        var _loc6 = [];
        if (this.__get___particles().length != 0 && this.__get___particles().length != undefined)
        {
            if (typeof(a1) == "number")
            {
                com.desuade.partigen.Errors.output(true, 234, 1, namers + ".freeze");
                var _loc2 = _loc4.length;
                do
                {
                    --_loc2;
                    var tt = _loc4[_loc2][0];
                    if (!tt._antifreeze)
                    {
                        if (a2 != undefined)
                        {
                            tt.onEnterFrame = function ()
                            {
                                tt.oef(tt);
                            };
                            com.mosesSupposes.fuse.ZigoEngine.pauseTween(tt);
                            tt.isfrozen = true;
                            com.desuade.partigen.Errors.output(true, 233, 2, namers + ".freeze", tt + "(" + tt._x + "," + tt._y + ")");
                        }
                        else
                        {
                            tt.onEnterFrame = function ()
                            {
                                tt.oef(tt);
                            };
                            com.mosesSupposes.fuse.ZigoEngine.pauseTween(tt);
                            tt.isfrozen = true;
                            com.desuade.partigen.Errors.output(true, 233, 2, namers + ".freeze", tt + "(" + tt._x + "," + tt._y + ")");
                        } // end else if
                        _loc6.push(_loc4[_loc2][1]);
                        continue;
                    } // end if
                    com.desuade.partigen.Errors.output(true, 236, 2, namers + ".freeze", "", tt);
                } while (_loc2)
                return (_loc6);
            }
            else if (a1 != undefined)
            {
                if (_allparticles[a1._id] == a1)
                {
                    if (!a1._antifreeze)
                    {
                        tt.onEnterFrame = function ()
                        {
                            tt.oef(tt);
                        };
                        com.mosesSupposes.fuse.ZigoEngine.pauseTween(a1);
                        a1.isfrozen = true;
                        com.desuade.partigen.Errors.output(true, 233, 1, namers + ".freeze", a1 + "(" + a1._x + "," + a1._y + ")");
                        return ([a1._id]);
                    }
                    else
                    {
                        com.desuade.partigen.Errors.output(true, 236, 1, namers + ".freeze", "", a1);
                        return ([]);
                    } // end else if
                }
                else
                {
                    com.desuade.partigen.Errors.output(true, 237, 1, namers + ".freeze");
                    return ([]);
                } // end else if
            }
            else
            {
                com.desuade.partigen.Errors.output(true, 242, 1, namers + ".freeze", "", a1);
                return ([]);
            } // end else if
        }
        else
        {
            com.desuade.partigen.Errors.output(true, 239, 1, namers + ".freeze");
        } // end else if
    } // End of the function
    function thaw(a1, a2)
    {
        if (a1 == undefined)
        {
            var _loc4 = this.__get___particles();
            a1 = 0;
            a2 = 0;
        }
        else if (a2 == undefined)
        {
            _loc4 = [this.__get___particles()[a1]];
        }
        else
        {
            _loc4 = this.__get___particles().slice(a1, a2);
        } // end else if
        var _loc6 = [];
        if (this.__get___particles().length != 0 && this.__get___particles().length != undefined)
        {
            if (typeof(a1) == "number")
            {
                com.desuade.partigen.Errors.output(true, 235, 1, namers + ".thaw");
                var _loc3 = _loc4.length;
                do
                {
                    --_loc3;
                    var _loc2 = _loc4[_loc3][0];
                    if (_loc2._frozen)
                    {
                        _loc2.roef();
                        com.mosesSupposes.fuse.ZigoEngine.unpauseTween(_loc2);
                        _loc2.isfrozen = false;
                        com.desuade.partigen.Errors.output(true, 232, 2, namers + ".thaw", _loc2 + "(" + _loc2._x + "," + _loc2._y + ")");
                        _loc6.push(_loc4[_loc3][1]);
                        continue;
                    } // end if
                    com.desuade.partigen.Errors.output(true, 238, 2, namers + ".thaw", "", _loc2);
                } while (_loc3)
                return (_loc6);
            }
            else if (a1 != undefined)
            {
                if (_allparticles[a1._id] == a1)
                {
                    a1.roef();
                    com.mosesSupposes.fuse.ZigoEngine.unpauseTween(a1);
                    com.desuade.partigen.Errors.output(true, 232, 1, namers + ".thaw", a1 + "(" + a1._x + "," + a1._y + ")");
                    return ([a1._id]);
                }
                else
                {
                    com.desuade.partigen.Errors.output(true, 237, 1, namers + ".thaw");
                    return ([]);
                } // end else if
            }
            else
            {
                com.desuade.partigen.Errors.output(true, 242, 1, namers + ".thaw", "", a1);
                return ([]);
            } // end else if
        }
        else
        {
            com.desuade.partigen.Errors.output(true, 239, 1, namers + ".thaw");
        } // end else if
    } // End of the function
    function loadConfig(file, usestring)
    {
        function doconf()
        {
            var _loc3 = {};
            var _loc1;
            for (var _loc1 in em_lv)
            {
                if (em_lv[_loc1] != undefined && em_lv[_loc1] != em_lv.onLoad && em_lv[_loc1] != em_lv.decode)
                {
                    var _loc2 = jar[_loc1];
                    if (em_lv[_loc1].charCodeAt(0) == 42)
                    {
                        if (em_lv[_loc1].charCodeAt(1) >= 48 && em_lv[_loc1].charCodeAt(1) <= 57 || em_lv[_loc1].charCodeAt(1) == 45)
                        {
                            jar[_loc1] = em_lv[_loc1].slice(1);
                        }
                        else
                        {
                            jar[_loc1] = em_lv[_loc1];
                        } // end else if
                    }
                    else if (em_lv[_loc1].charCodeAt(0) >= 48 && em_lv[_loc1].charCodeAt(0) <= 57 || em_lv[_loc1].charCodeAt(0) == 45)
                    {
                        jar[_loc1] = Number(em_lv[_loc1]);
                    }
                    else if (em_lv[_loc1] == "true")
                    {
                        jar[_loc1] = true;
                    }
                    else if (em_lv[_loc1] == "false")
                    {
                        jar[_loc1] = false;
                    }
                    else
                    {
                        jar[_loc1] = em_lv[_loc1];
                    } // end else if
                    _loc3[_loc1] = [_loc2, jar[_loc1]];
                    com.desuade.partigen.Errors.output(true, 244, 1, nrm + ".loadConfig", jar[_loc1], _loc1 + " = " + _loc2);
                } // end if
            } // end of for...in
            com.desuade.partigen.Errors.output(true, 241, 1, nrm + ".loadConfig");
            return (_loc3);
        } // End of the function
        var _loc5 = usestring == undefined ? (false) : (usestring);
        var nrm = namers;
        if (_loc5)
        {
            com.desuade.partigen.Errors.output(true, 248, 1, nrm + ".loadConfig");
        }
        else
        {
            com.desuade.partigen.Errors.output(true, 249, 1, nrm + ".loadConfig", file);
        } // end else if
        var jar = this;
        var em_lv = new LoadVars();
        em_lv.onLoad = function (success)
        {
            if (success)
            {
                return (doconf());
            }
            else
            {
                com.desuade.partigen.Errors.output(true, 242, 1, nrm + ".loadConfig", file);
                return;
            } // end else if
        };
        if (_loc5)
        {
            em_lv.decode(file);
            return (doconf());
        }
        else
        {
            return (em_lv.load(file));
        } // end else if
    } // End of the function
    function setTween(x, y, cx, cy, duration, ease, delay)
    {
        _tween_x = x != undefined ? (x) : (_tween_x);
        _tween_y = y != undefined ? (y) : (_tween_y);
        _tween_cx = cx != undefined ? (cx) : (_tween_cx);
        _tween_cy = cy != undefined ? (cy) : (_tween_cy);
        _tween_duration = duration != undefined ? (duration) : (_tween_duration);
        _tween_ease = ease != undefined ? (ease) : (_tween_ease);
        _tween_delay = delay != undefined ? (delay) : (_tween_delay);
    } // End of the function
    function setPhysics(vx, vy, ax, ay, fx, fy, ang)
    {
        _physics_vx = vx != undefined ? (vx) : (_physics_vx);
        _physics_vy = vy != undefined ? (vy) : (_physics_vy);
        _physics_ax = ax != undefined ? (ax) : (_physics_ax);
        _physics_ay = ay != undefined ? (ay) : (_physics_ay);
        _physics_fx = fx != undefined ? (fx) : (_physics_fx);
        _physics_fy = fy != undefined ? (fy) : (_physics_fy);
        if (typeof(ang) == "number")
        {
            this.__set___physics_angle(ang);
        }
        else if (typeof(ang) == "object")
        {
            _physics_anglerange = ang;
        }
        else if (typeof(ang) == "string")
        {
            if (ang == "disabled")
            {
                _physics_anglerange = ang;
            }
            else
            {
                this.__set___physics_angle(ang);
            } // end else if
        } // end else if
    } // End of the function
    function verify(verbose, prop, fsc, to)
    {
        return (com.desuade.partigen.Partigen.verify(this, verbose, prop, true, fsc, to));
    } // End of the function
    function forceEmit(burst)
    {
        var _loc3 = _burst;
        _burst = burst == undefined ? (1) : (burst);
        var _loc2 = this.updateTimer(this);
        _burst = _loc3;
        return (_loc2);
    } // End of the function
    function getAllParticles(prop, combine, value)
    {
        var _loc3 = [];
        switch (combine)
        {
            case "number":
            {
                _loc3 = 0;
                break;
            } 
            case "array":
            {
                _loc3 = new Array();
                break;
            } 
            case "object":
            {
                _loc3 = new Object();
                break;
            } 
            default:
            {
                _loc3 = new Array();
                break;
            } 
        } // End of switch
        for (var _loc7 in this.__get___particles())
        {
            var _loc2 = this.__get___particles()[_loc7][0];
            if (combine !== "number")
            {
                continue;
            } // end if
            _loc3 = _loc3 + Number(_loc2[prop]);
            continue;
            _loc3[_loc7] = _loc2[prop];
            continue;
            _loc3[_loc2] = _loc2[prop];
            continue;
            if (_loc2[prop] < value)
            {
                _loc3.push(_loc2);
            } // end if
            continue;
            if (_loc2[prop] > value)
            {
                _loc3.push(_loc2);
            } // end if
            continue;
            if (_loc2[prop] == value)
            {
                _loc3.push(_loc2);
            } // end if
            continue;
            if (_loc2[prop] != value)
            {
                _loc3.push(_loc2);
            } // end if
            continue;
        } // end of for...in
        return (_loc3);
    } // End of the function
    function duplicateEmitter(target, name, depth, emissiontarget, propobj)
    {
        return (com.desuade.partigen.Partigen.duplicateEmitter(this, target, name, depth, emissiontarget, propobj, true));
    } // End of the function
    function removeEmitter(rp)
    {
        return (com.desuade.partigen.Partigen.removeEmitter(this, rp, true));
    } // End of the function
    function kill(particle, de)
    {
        if (_allparticles[particle] != undefined)
        {
            _allparticles[particle].kill(de, true);
            return (true);
        }
        else
        {
            com.desuade.partigen.Errors.output(true, 243, 1, namers + ".kill", undefined, "A particle with an ID of " + particle);
            return (false);
        } // end else if
    } // End of the function
    function oef(particle)
    {
    } // End of the function
    function onBirth(particle)
    {
    } // End of the function
    function onDeath(particle)
    {
    } // End of the function
    function onTweenEnd(particle)
    {
    } // End of the function
    var _useParentCoordsT = false;
    var eramt = 0;
    var wrngamt = 0;
    var exw = 0;
    var exh = 0;
    var dceil = 1048570;
    var _emitclass = com.desuade.partigen.PGparticle;
} // End of Class
