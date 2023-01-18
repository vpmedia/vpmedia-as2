class com.desuade.partigen.Partigen extends Object
{
    static var __get___idletimeout, __get___emitters, __get__AUTHORS, __get__LICENSE, __get__LONGVERSION, __get__VERSION, __get__VERSIONDATE, __get__WEBSITE, __get___idle, __set___idletimeout;
    function Partigen()
    {
        super();
    } // End of the function
    static function init(my_cl)
    {
        dlmclient = my_cl;
        switch (com.desuade.partigen.Partigen.dlmclient.__get___licensetype())
        {
            case "V":
            {
                PGLICENSE = "Volume License";
                break;
            } 
            case "A":
            {
                PGLICENSE = "Academic License";
                break;
            } 
            case "B":
            {
                PGLICENSE = "Beta License";
                break;
            } 
            case "P":
            {
                PGLICENSE = "Publish License";
                break;
            } 
            case "C":
            {
                PGLICENSE = "Commercial License";
                break;
            } 
        } // End of switch
        if (!com.desuade.partigen.Partigen.dlmclient.__get___activated())
        {
            PGLICENSE = com.desuade.partigen.Partigen.PGLICENSE + " - Not Activated";
        } // end if
        _global.Partigen = com.desuade.partigen.Partigen;
        _global.PGparticle = com.desuade.partigen.PGparticle;
        _global.PGemitter = com.desuade.partigen.PGemitter;
        _global.Errors = com.desuade.partigen.Errors;
        _global.ZigoEngine = com.mosesSupposes.fuse.ZigoEngine;
        com.mosesSupposes.fuse.ZigoEngine.register(com.mosesSupposes.fuse.PennerEasing);
        com.mosesSupposes.fuse.ZigoEngine.setControllerDepth(-35);
        com.desuade.partigen.Partigen.setupBroadcasting();
        _root._totalparticles = 0;
        _root.createEmptyMovieClip("pgidler", -34);
    } // End of the function
    static function ino()
    {
        return (true);
    } // End of the function
    static function checkl()
    {
        if (com.desuade.partigen.Partigen.dlmclient.__get___expired())
        {
            allowc = false;
            com.desuade.partigen.Errors.output(false, 1, 0);
            _root.createTextField("expired_txt", _root.getNextHighestDepth(), 0, 0, 2000, 45);
            _root.expired_txt.background = true;
            _root.expired_txt.backgroundColor = 16777215;
            _root.expired_txt.text = "This was created with a beta version of Desuade Partigen and has now expired. \rThe latest version of partigen is availabe at http://www.desuade.com/";
        }
        else if (com.desuade.partigen.Partigen.dlmclient.__get___trialexpired())
        {
            allowc = false;
            com.desuade.partigen.Errors.output(false, 7, 0);
            _root.createTextField("expired_txt", _root.getNextHighestDepth(), 0, 0, 2000, 65);
            _root.expired_txt.background = true;
            _root.expired_txt.backgroundColor = 16777215;
            _root.expired_txt.text = "This contains a trial version of Desuade Partigen that has expired. \rAll files made without a license will expire after the trial is over. \rYou may purchase a license from http://www.desuade.com \rOnce you have purchased a license, you may republish this file to regain it\'s functionality.";
        }
        else if (com.desuade.partigen.Partigen.dlmclient == undefined || com.desuade.partigen.Partigen.dlmclient == null || com.desuade.partigen.Partigen.dlmclient.__get___trialexpired() == undefined || com.desuade.partigen.Partigen.dlmclient.__get___expired() == undefined)
        {
            allowc = false;
            com.desuade.partigen.Errors.output(false, 411, 0);
            _root.createTextField("expired_txt", _root.getNextHighestDepth(), 0, 0, 2000, 65);
            _root.expired_txt.background = true;
            _root.expired_txt.backgroundColor = 16777215;
            _root.expired_txt.text = "There was an error loading the DLM client. \rPlease make sure you have downloaded a legitimate copy with proper licensing.";
        }
        else
        {
            allowc = true;
        } // end else if
    } // End of the function
    static function get _idle()
    {
        return (com.desuade.partigen.Partigen.idle);
    } // End of the function
    static function get _idletimeout()
    {
        return (com.desuade.partigen.Partigen.idletimeout);
    } // End of the function
    static function set _idletimeout(inum)
    {
        idletimeout = inum;
        if (inum > 0)
        {
            com.desuade.partigen.Partigen.checkidle();
        }
        else
        {
            delete _root.pgidler.onEnterFrame;
        } // end else if
        //return (com.desuade.partigen.Partigen._idletimeout());
        null;
    } // End of the function
    static function checkidle()
    {
        var im = _root.pgidler;
        im.ae = [];
        var _loc3 = new Object();
        _loc3.onKeyDown = function ()
        {
            im.oldpos = Math.random();
        };
        _loc3.onKeyUp = function ()
        {
            im.oldpos = Math.random();
        };
        Key.addListener(_loc3);
        im.onEnterFrame = function ()
        {
            var _loc3 = _root._xmouse + _root._ymouse;
            if (_loc3 == im.oldpos)
            {
                var _loc4 = (getTimer() - im.oldtime) / 1000;
                if (_loc4 > com.desuade.partigen.Partigen.__get___idletimeout())
                {
                    if (com.desuade.partigen.Partigen.idle == false)
                    {
                        if (com.desuade.partigen.Partigen._events.onIdle === true)
                        {
                            com.desuade.partigen.Partigen.broadcastMessage("idleEvent");
                        } // end if
                        im.ae = com.desuade.partigen.Partigen.getAllEmitters("_active", "eq", true);
                        for (var _loc2 in im.ae)
                        {
                            im.ae[_loc2].stop();
                        } // end of for...in
                    } // end if
                    idle = true;
                } // end if
            }
            else
            {
                im.oldtime = getTimer();
                if (com.desuade.partigen.Partigen.idle)
                {
                    for (var _loc2 in im.ae)
                    {
                        im.ae[_loc2].start(false);
                    } // end of for...in
                    im.ae = [];
                    idle = false;
                    if (com.desuade.partigen.Partigen._events.onReturn === true)
                    {
                        com.desuade.partigen.Partigen.broadcastMessage("returnEvent");
                    } // end if
                } // end if
            } // end else if
            im.oldpos = _loc3;
        };
    } // End of the function
    static function broadcastMessage()
    {
    } // End of the function
    static function addListener()
    {
    } // End of the function
    static function setupBroadcasting()
    {
        AsBroadcaster.initialize(com.desuade.partigen.Partigen);
        var _loc1 = new Object();
        _loc1.birthEvent = function (emitter, particle)
        {
            if (emitter._events.onBirth === true)
            {
                emitter.onBirth(particle);
                com.desuade.partigen.Errors.output(true, 5, 3, emitter.__get___namers() + ".onBirth", particle, getTimer() / 1000);
            } // end if
            if (com.desuade.partigen.Partigen._events.onBirth === true)
            {
                com.desuade.partigen.Partigen.onBirth(emitter, particle);
                com.desuade.partigen.Errors.output(true, 5, 3, "Partigen.onBirth", particle, getTimer() / 1000);
            } // end if
        };
        _loc1.deathEvent = function (emitter, particle)
        {
            if (emitter._events.onDeath === true)
            {
                emitter.onDeath(particle);
                com.desuade.partigen.Errors.output(true, 5, 3, emitter.__get___namers() + ".onDeath", particle, getTimer() / 1000);
            } // end if
            if (com.desuade.partigen.Partigen._events.onDeath === true)
            {
                com.desuade.partigen.Partigen.onDeath(emitter, particle);
                com.desuade.partigen.Errors.output(true, 5, 3, "Partigen.onDeath", particle, getTimer() / 1000);
            } // end if
        };
        _loc1.tweenEndEvent = function (emitter, particle)
        {
            if (emitter._events.onTweenEnd === true)
            {
                emitter.onTweenEnd(particle);
                com.desuade.partigen.Errors.output(true, 5, 3, emitter.__get___namers() + ".onTweenEnd", particle, getTimer() / 1000);
            } // end if
            if (com.desuade.partigen.Partigen._events.onTweenEnd === true)
            {
                com.desuade.partigen.Partigen.onTweenEnd(emitter, particle);
                com.desuade.partigen.Errors.output(true, 5, 3, "Partigen.onTweenEnd", particle, getTimer() / 1000);
            } // end if
        };
        var _loc2 = new Object();
        _loc2.idleEvent = function ()
        {
            if (com.desuade.partigen.Partigen._events.onIdle === true)
            {
                com.desuade.partigen.Partigen.onIdle();
                com.desuade.partigen.Errors.output(true, 5, 1, "Partigen.onIdle", "", getTimer() / 1000);
            } // end if
        };
        _loc2.returnEvent = function ()
        {
            if (com.desuade.partigen.Partigen._events.onReturn === true)
            {
                com.desuade.partigen.Partigen.onReturn();
                com.desuade.partigen.Errors.output(true, 5, 1, "Partigen.onReturn", "", getTimer() / 1000);
            } // end if
        };
        com.desuade.partigen.Partigen.addListener(_loc1);
        com.desuade.partigen.Partigen.addListener(_loc2);
    } // End of the function
    static function get VERSIONDATE()
    {
        return (com.desuade.partigen.Partigen.PGVERSIONDATE);
    } // End of the function
    static function get AUTHORS()
    {
        return (com.desuade.partigen.Partigen.PGAUTHORS);
    } // End of the function
    static function get VERSION()
    {
        return (com.desuade.partigen.Partigen.PGVERSION);
    } // End of the function
    static function get LONGVERSION()
    {
        return (com.desuade.partigen.Partigen.PGVERSIONLONG);
    } // End of the function
    static function get WEBSITE()
    {
        return (com.desuade.partigen.Partigen.PGWEBSITE);
    } // End of the function
    static function get LICENSE()
    {
        return (com.desuade.partigen.Partigen.PGLICENSE);
    } // End of the function
    static function get _emitters()
    {
        var _loc1 = com.desuade.partigen.Partigen.emitters;
        var _loc2 = new Array();
        for (var _loc3 in _loc1)
        {
            _loc2.push([_loc1[_loc3], _loc3]);
        } // end of for...in
        return (_loc2);
    } // End of the function
    static function resolveID(id1, id2)
    {
        if (id2 == undefined)
        {
            return (com.desuade.partigen.Partigen.emitters[id1]);
        }
        else
        {
            return (com.desuade.partigen.Partigen.emitters[id1]._allparticles[id2]);
        } // end else if
    } // End of the function
    static function createEmitter(target, name, depth, emissiontarget, propobj)
    {
        if (!com.desuade.partigen.Partigen.taged)
        {
            com.desuade.partigen.Errors.output(false, 0, 1);
            taged = true;
            com.desuade.partigen.Partigen.checkl();
        } // end if
        if (com.desuade.partigen.Partigen.allowc)
        {
            if (target == undefined)
            {
                com.desuade.partigen.Errors.output(true, 112, 1, "Partigen.createEmitter");
                return;
            } // end if
            if (name == undefined)
            {
                com.desuade.partigen.Errors.output(true, 113, 1, "Partigen.createEmitter");
                return;
            } // end if
            emissiontarget = emissiontarget == undefined ? (0) : (emissiontarget);
            depth = depth == undefined ? (target.getNextHighestDepth()) : (depth);
            if (target.getInstanceAtDepth(depth) != undefined)
            {
                com.desuade.partigen.Errors.output(true, 114, 1, "Partigen.createEmitter");
                return;
            } // end if
            var _loc1 = null;
            var _loc6 = com.desuade.partigen.PGemitter;
            var _loc9 = [propobj, emissiontarget, com.desuade.partigen.Partigen.eamt + 1, com.desuade.partigen.Partigen.dlmclient];
            var _loc2 = MovieClip.prototype.createEmptyMovieClip.apply(target, [name, depth]);
            if (_loc2 == undefined)
            {
                com.desuade.partigen.Errors.output(true, 111, 1, "Partigen.createEmitter");
                return;
            }
            else
            {
                eamt = ++com.desuade.partigen.Partigen.eamt;
                com.desuade.partigen.Errors.output(true, 2, 1, "Partigen.createEmitter", _loc2, "#" + com.desuade.partigen.Partigen.eamt + " @" + depth + " ");
            } // end else if
            for (var _loc3 in _loc1)
            {
                _loc2[_loc3] = _loc1[_loc3];
            } // end of for...in
            _loc2.__proto__ = _loc6.prototype;
            _loc6.apply(_loc2, _loc9);
            return (target[name]);
        }
        else
        {
            return;
        } // end else if
    } // End of the function
    static function duplicateEmitter(emitter, target, name, depth, emissiontarget, propobj, fe)
    {
        function createEmitter2(cepgt, cepgn, cepgd, ptarget, propobjh)
        {
            ptarget = ptarget == undefined ? (emitter.__get___emissiontarget()) : (ptarget);
            cepgd = cepgd == undefined ? (target.getNextHighestDepth()) : (cepgd);
            if (cepgt.getInstanceAtDepth(cepgd) != undefined)
            {
                com.desuade.partigen.Errors.output(true, 114, 1, fromy + ".duplicateEmitter");
                return;
            } // end if
            var _loc1 = null;
            var _loc5 = com.desuade.partigen.PGemitter;
            var _loc6 = [propobjh, ptarget, com.desuade.partigen.Partigen.eamt + 1, com.desuade.partigen.Partigen.dlmclient];
            var _loc2 = MovieClip.prototype.createEmptyMovieClip.apply(cepgt, [cepgn, cepgd]);
            if (_loc2 == undefined)
            {
                com.desuade.partigen.Errors.output(true, 111, 1, fromy + ".duplicateEmitter");
                return;
            }
            else
            {
                eamt = ++com.desuade.partigen.Partigen.eamt;
                com.desuade.partigen.Errors.output(true, 2, 1, fromy + ".duplicateEmitter", _loc2, "#" + com.desuade.partigen.Partigen.eamt + " @" + cepgd + " ");
            } // end else if
            for (var _loc3 in _loc1)
            {
                _loc2[_loc3] = _loc1[_loc3];
            } // end of for...in
            _loc2.__proto__ = _loc5.prototype;
            _loc5.apply(_loc2, _loc6);
            return (cepgt[cepgn]);
        } // End of the function
        var fromy = fe ? (emitter.__get___namers()) : ("Partigen");
        name = name == undefined ? (emitter.__get___namers() + (com.desuade.partigen.Partigen.eamt + 1)) : (name);
        var target = target == undefined ? (emitter._parent) : (target);
        com.desuade.partigen.Errors.output(true, 6, 1, fromy + ".duplicateEmitter", emitter + " as " + name + "...");
        var _loc1 = new Object();
        for (var _loc7 in emitter)
        {
            if (_loc7 != "lineseg" && _loc7 != "active" && _loc7 != "timeout" && _loc7 != "intervalPG" && _loc7 != "eramt" && _loc7 != "wrngamt" && _loc7 != "yang" && _loc7 != "xang" && _loc7 != "_allparticles" && _loc7 != "emissionPoint" && _loc7 != "namers" && _loc7 != "_emissiontarget" && _loc7 != "id" && _loc7 != "_useParentCoords" && _loc7 != "_total" && _loc7 != "_totalparticles")
            {
                _loc1[_loc7] = emitter[_loc7];
            } // end if
        } // end of for...in
        for (var _loc5 in propobj)
        {
            if (propobj[_loc5] != undefined)
            {
                _loc1[_loc5] = propobj[_loc5];
                continue;
            } // end if
            delete _loc1[_loc5];
        } // end of for...in
        return (createEmitter2(target, name, depth, emissiontarget, _loc1));
    } // End of the function
    static function removeEmitter(emitter, rp, fe)
    {
        rp = rp == undefined ? (true) : (rp);
        if (fe == true)
        {
            var _loc6 = String(emitter.__get___namers());
        }
        else
        {
            _loc6 = "Partigen";
        } // end else if
        for (var _loc5 in com.desuade.partigen.Partigen.__get___emitters())
        {
            if (com.desuade.partigen.Partigen.__get___emitters()[_loc5][0] == emitter)
            {
                var _loc4 = true;
                var _loc3 = com.desuade.partigen.Partigen.__get___emitters()[_loc5][1];
            } // end if
        } // end of for...in
        if (_loc4 == undefined)
        {
            com.desuade.partigen.Errors.output(true, 4, 1, _loc6 + ".removeEmitter");
            return (false);
        }
        else
        {
            if (rp)
            {
                var _loc1 = emitter.__get___particles().length;
                do
                {
                    --_loc1;
                    removeMovieClip (emitter.__get___particles()[_loc1][0]);
                } while (_loc1)
            } // end if
            delete com.desuade.partigen.Partigen.emitters[_loc3];
            com.desuade.partigen.Errors.output(true, 3, 1, _loc6 + ".removeEmitter", emitter);
            removeMovieClip (emitter);
            return (true);
        } // end else if
    } // End of the function
    static function setAllEmitters(prop, ismethod, value)
    {
        if (ismethod == true || ismethod == undefined)
        {
            for (var _loc4 in com.desuade.partigen.Partigen.__get___emitters())
            {
                var _loc3 = com.desuade.partigen.Partigen.__get___emitters()[_loc4][0];
                if (value.length != undefined)
                {
                    _loc3[prop](value[0], value[1], value[2], value[3], value[4], value[5], value[6], value[7], value[8], value[9]);
                    continue;
                } // end if
                _loc3[prop](value);
            } // end of for...in
        }
        else
        {
            for (var _loc4 in com.desuade.partigen.Partigen.__get___emitters())
            {
                _loc3 = com.desuade.partigen.Partigen.__get___emitters()[_loc4][0];
                _loc3[prop] = value;
            } // end of for...in
        } // end else if
    } // End of the function
    static function getAllEmitters(prop, combine, value)
    {
        var _loc2 = [];
        switch (combine)
        {
            case "number":
            {
                _loc2 = 0;
                break;
            } 
            case "array":
            {
                _loc2 = new Array();
                break;
            } 
            case "object":
            {
                _loc2 = new Object();
                break;
            } 
            default:
            {
                _loc2 = new Array();
                break;
            } 
        } // End of switch
        for (var _loc6 in com.desuade.partigen.Partigen.__get___emitters())
        {
            var _loc1 = com.desuade.partigen.Partigen.__get___emitters()[_loc6][0];
            if (combine !== "number")
            {
                continue;
            } // end if
            _loc2 = _loc2 + Number(_loc1[prop]);
            continue;
            _loc2[_loc6] = _loc1[prop];
            continue;
            _loc2[_loc1] = _loc1[prop];
            continue;
            if (_loc1[prop] < value)
            {
                _loc2.push(_loc1);
            } // end if
            continue;
            if (_loc1[prop] > value)
            {
                _loc2.push(_loc1);
            } // end if
            continue;
            if (_loc1[prop] == value)
            {
                _loc2.push(_loc1);
            } // end if
            continue;
            if (_loc1[prop] != value)
            {
                _loc2.push(_loc1);
            } // end if
            continue;
        } // end of for...in
        return (_loc2);
    } // End of the function
    static function verify(emitter, verbose, prop, fe, fsc, to)
    {
        var emitter = emitter;
        var fullar = ["_source", "_mode", "_events", "_order", "_emissiontarget", "_lowestdepth", "_startaligned", "_orientation", "_eps", "_size", "_life", "_scalestart", "_scaleend", "_burst", "_alphaend", "_alphastart", "_rotationstart", "_rotationend", "_colorstart", "_colorend"];
        var fsc = fsc == undefined ? (false) : (fsc);
        prop = typeof(prop) == "string" ? ([prop]) : (prop);
        var varlist = prop == undefined ? (fullar) : (prop);
        var verb = verbose == undefined ? (false) : (verbose);
        var src = fe ? (emitter.__get___namers() + ".verify") : ("Partigen.verify");
        if (verb)
        {
            if (varlist == fullar)
            {
                com.desuade.partigen.Errors.output(true, 121, 1, src, emitter.__get___namers() + "...");
            } // end if
        } // end if
        var varer;
        var proper;
        var mvarer;
        var mproper;
        emitter.eramt = 0;
        emitter.wrngamt = 0;
        var erobj = {};
        var vrb = function ()
        {
            if (verb)
            {
                var _loc4 = varer;
                var _loc2 = proper;
                if (_loc4 == "_events")
                {
                    var _loc1 = _loc2;
                    _loc2 = "";
                    for (var _loc3 in _loc1)
                    {
                        _loc2 = _loc2 + (_loc3 + ":" + _loc1[_loc3] + ",");
                    } // end of for...in
                    _loc2 = _loc2.slice(0, -1);
                } // end if
                com.desuade.partigen.Errors.output(true, 123, 1, src, undefined, _loc4 + " (" + _loc2 + ")");
            } // end if
        };
        var vrbS = function ()
        {
            if (verb)
            {
                com.desuade.partigen.Errors.output(true, 123, 1, src, undefined, varer + " (\'" + proper + "\')");
            } // end if
        };
        var er = function (nu, r, m)
        {
            var _loc4 = m ? (mvarer) : (varer);
            var _loc2 = m ? (mproper) : (proper);
            if (_loc4 == "_events")
            {
                var _loc1 = _loc2;
                _loc2 = "";
                for (var _loc3 in _loc1)
                {
                    _loc2 = _loc2 + (_loc3 + ":" + _loc1[_loc3] + ",");
                } // end of for...in
                _loc2 = _loc2.slice(0, -1);
            } // end if
            com.desuade.partigen.Errors.output(true, nu, 1, src, undefined, _loc4 + " (" + _loc2 + ")");
            if (r)
            {
                ++emitter.eramt;
                erobj[_loc4] = _loc2;
            }
            else
            {
                ++emitter.wrngamt;
            } // end else if
        };
        var modePropCheck = function (modearr)
        {
            var _loc1 = function ()
            {
                if (verb)
                {
                    com.desuade.partigen.Errors.output(true, 123, 1, src, undefined, mvarer + " (" + mproper + ")");
                } // end if
            };
            var _loc4 = function ()
            {
                if (verb)
                {
                    com.desuade.partigen.Errors.output(true, 123, 1, src, undefined, mvarer + " (\'" + mproper + "\')");
                } // end if
            };
            for (var _loc6 in modearr)
            {
                mvarer = modearr[_loc6];
                mproper = emitter[mvarer];
                if (mproper == undefined)
                {
                    er(122, true, true);
                    continue;
                } // end if
                if (mvarer == "_tween_x" || mvarer == "_tween_y" || mvarer == "_tween_cx" || mvarer == "_tween_cy" || mvarer == "_physics_angle")
                {
                    if (typeof(mproper) == "string" || typeof(mproper) == "number")
                    {
                        if (typeof(mproper) == "string")
                        {
                            if (isNaN(Number(mproper)) && mproper != "disabled" && mproper != "null")
                            {
                                er(132, true, true);
                            }
                            else if (mvarer == "_tween_cx" || mvarer == "_tween_cy")
                            {
                                if (emitter._tween_cx == "disabled" || emitter._tween_cy == "disabled")
                                {
                                    if (mproper != "disabled")
                                    {
                                        er(151, false, true);
                                    }
                                    else
                                    {
                                        _loc4();
                                    } // end else if
                                }
                                else
                                {
                                    _loc4();
                                } // end else if
                            }
                            else
                            {
                                _loc4();
                            } // end else if
                        }
                        else if (mvarer == "_tween_cx" || mvarer == "_tween_cy")
                        {
                            if (emitter._tween_cx == "disabled" || emitter._tween_cy == "disabled")
                            {
                                er(151, false, true);
                            }
                            else
                            {
                                _loc1();
                            } // end else if
                        }
                        else
                        {
                            _loc1();
                        } // end else if
                    }
                    else if (mproper == null)
                    {
                        if (mvarer == "_tween_cx" || mvarer == "_tween_cy")
                        {
                            _loc1();
                        }
                        else
                        {
                            er(129, true, true);
                        } // end else if
                    }
                    else
                    {
                        er(129, true, true);
                    } // end else if
                } // end else if
                if (mvarer == "_physics_vx" || mvarer == "_physics_vy" || mvarer == "_physics_ax" || mvarer == "_physics_ay" || mvarer == "_physics_fx" || mvarer == "_physics_fy" || mvarer == "_tween_duration" || mvarer == "_tween_delay")
                {
                    if (typeof(mproper) == "number")
                    {
                        if (mvarer == "_tween_duration" || mvarer == "_tween_delay" || mvarer == "_physics_fx" || mvarer == "_physics_fy")
                        {
                            if (mproper < 0)
                            {
                                if (mvarer == "_tween_duration" || mvarer == "_tween_delay")
                                {
                                    er(131, false, true);
                                }
                                else
                                {
                                    er(149, false, true);
                                } // end else if
                            }
                            else
                            {
                                _loc1();
                            } // end else if
                        }
                        else
                        {
                            _loc1();
                        } // end else if
                    }
                    else
                    {
                        er(130, true, true);
                    } // end if
                } // end else if
                if (mvarer == "_physics_anglerange")
                {
                    if (typeof(mproper) == "object")
                    {
                        if (mproper[0] != undefined && mproper[1] != undefined && mproper.length == 2)
                        {
                            if ((typeof(mproper[0]) == "string" || typeof(mproper[0]) == "number") && (typeof(mproper[1]) == "string" || typeof(mproper[1]) == "number"))
                            {
                                if (mproper[0] > mproper[1])
                                {
                                    er(137, false, true);
                                }
                                else if (mproper[0] < -360 || mproper[0] > 360 || mproper[1] < -360 || mproper[1] > 360)
                                {
                                    er(138, false, true);
                                }
                                else
                                {
                                    _loc1();
                                } // end else if
                            } // end else if
                        }
                        else
                        {
                            er(136, true, true);
                        } // end else if
                    }
                    else if (typeof(mproper) == "string")
                    {
                        if (mproper == "disabled")
                        {
                            _loc1();
                        }
                        else
                        {
                            er(134, true, true);
                        } // end else if
                    }
                    else
                    {
                        er(135, true, true);
                    } // end else if
                } // end else if
                if (mvarer == "_tween_ease")
                {
                    var _loc2 = ["linear", "easeInQuad", "easeOutQuad", "easeInOutQuad", "easeInExpo", "easeOutExpo", "easeInOutExpo", "easeOutInExpo", "easeInElastic", "easeOutElastic", "easeInOutElastic", "easeOutInElastic", "easeInBack", "easeOutBack", "easeInOutBack", "easeOutInBack", "easeOutBounce", "easeInBounce", "easeInOutBounce", "easeOutInBounce", "easeInCubic", "easeOutCubic", "easeInOutCubic", "easeOutInCubic", "easeInQuart", "easeOutQuart", "easeInOutQuart", "easeOutInQuart", "easeInQuint", "easeOutQuint", "easeInOutQuint", "easeOutInQuint", "easeInSine", "easeOutSine", "easeInOutSine", "easeOutInSine", "easeInCirc", "easeOutCirc", "easeInOutCirc", "easeOutInCirc"];
                    var _loc3 = false;
                    for (var _loc6 in _loc2)
                    {
                        if (_loc2[_loc6] == mproper)
                        {
                            _loc3 = true;
                            break;
                        } // end if
                    } // end of for...in
                    if (_loc3)
                    {
                        _loc1();
                        continue;
                    } // end if
                    er(133, true, true);
                } // end if
            } // end of for...in
        };
        var rgPropCheck = function (arcars)
        {
            for (var _loc13 in arcars)
            {
                varer = arcars[_loc13];
                proper = emitter[varer];
                if (proper == undefined)
                {
                    er(122, true, false);
                    if (varer == "_source")
                    {
                        if (verb)
                        {
                            if (varlist == fullar)
                            {
                                var _loc8 = emitter.eramt == 1 ? (" error and ") : (" errors and ");
                                var _loc9 = emitter.wrngamt == 1 ? (" warning.") : (" warnings.");
                                com.desuade.partigen.Errors.output(true, 124, 1, src, emitter.eramt + _loc8 + emitter.wrngamt + _loc9);
                            } // end if
                        } // end if
                        if (fsc)
                        {
                            com.desuade.partigen.Errors.output(true, 225, 1, emitter.namers + ".start");
                        } // end if
                        if (varlist == fullar)
                        {
                            return (erobj);
                        } // end if
                    } // end if
                    continue;
                } // end if
                switch (varer)
                {
                    case "_source":
                    {
                        if (proper.charCodeAt(0) != 42)
                        {
                            var _loc4 = emitter.createEmptyMovieClip("hold", 596733);
                            _loc4._visible = false;
                            _loc4._alpha = 0;
                            if (_loc4.attachMovie(proper, proper, 0) == undefined)
                            {
                                er(125, true, false);
                            }
                            else
                            {
                                vrb();
                            } // end else if
                            _loc4.removeMovieClip();
                            if (verb)
                            {
                                if (varlist == fullar)
                                {
                                    _loc8 = emitter.eramt == 1 ? (" error and ") : (" errors and ");
                                    _loc9 = emitter.wrngamt == 1 ? (" warning.") : (" warnings.");
                                    com.desuade.partigen.Errors.output(true, 124, 1, src, emitter.eramt + _loc8 + emitter.wrngamt + _loc9);
                                } // end if
                            } // end if
                            if (emitter.eramt == 0)
                            {
                                if (fsc)
                                {
                                    emitter.start(false, false, to);
                                } // end if
                            }
                            else if (fsc)
                            {
                                com.desuade.partigen.Errors.output(true, 225, 1, emitter.namers + ".start");
                            } // end else if
                            if (varlist == fullar)
                            {
                                return (erobj);
                            } // end if
                        }
                        else
                        {
                            var _loc3 = emitter.createEmptyMovieClip("blank", 596733);
                            _loc3._visible = false;
                            _loc3._alpha = 0;
                            _loc3.loadMovie(proper.slice(1));
                            emitter.int_idt = getTimer();
                            clearInterval(emitter.int_id);
                            emitter.int_id = setInterval(com.desuade.partigen.Partigen.checkGoodLoad, 100, _loc3, emitter, verb, src, varer, fsc, varlist, fullar, to);
                            if (varlist == fullar)
                            {
                                return (erobj);
                            } // end if
                        } // end else if
                        break;
                    } 
                    case "_eps":
                    {
                        if (proper <= 0)
                        {
                            er(139, true, false);
                        }
                        else
                        {
                            vrb();
                        } // end else if
                        break;
                    } 
                    case "_mode":
                    {
                        if (proper[0] == "tween" || proper[0] == "physics")
                        {
                            if (proper[1] == "point" || proper[1] == "line" || proper[1] == "box")
                            {
                                vrb();
                                if (varlist == fullar)
                                {
                                    if (proper[0] == "tween")
                                    {
                                        var _loc10 = ["_tween_x", "_tween_y", "_tween_cx", "_tween_cy", "_tween_delay", "_tween_duration", "_tween_ease"];
                                        modePropCheck(_loc10);
                                    }
                                    else
                                    {
                                        var _loc11 = ["_physics_vx", "_physics_vy", "_physics_ax", "_physics_ay", "_physics_angle", "_physics_anglerange", "_physics_fx", "_physics_fy"];
                                        modePropCheck(_loc11);
                                    } // end else if
                                    if (proper[1] == "line")
                                    {
                                        rgPropCheck(["_lineconfig"]);
                                    } // end if
                                    if (proper[1] == "box")
                                    {
                                        rgPropCheck(["_boxconfig"]);
                                    } // end if
                                } // end if
                            }
                            else
                            {
                                er(128, true, false);
                            } // end else if
                        }
                        else
                        {
                            er(128, true, false);
                        } // end else if
                        break;
                    } 
                    case "_lineconfig":
                    {
                        if (proper[0] != undefined && proper[1] != undefined && proper[2] != undefined && proper.length == 3)
                        {
                            if ((typeof(proper[0]) == "number" || typeof(proper[1]) == "number") && typeof(proper[2]) == "number")
                            {
                                vrb();
                            }
                            else if ((typeof(proper[0]) == "string" || typeof(proper[1]) == "string") && typeof(proper[2]) == "number")
                            {
                                if (isNaN(Number(proper[0])) || isNaN(Number(proper[1])))
                                {
                                    er(146, true, false);
                                }
                                else
                                {
                                    vrb();
                                } // end else if
                            }
                            else
                            {
                                er(147, true, false);
                            } // end else if
                        }
                        else
                        {
                            er(152, true, false);
                        } // end else if
                        break;
                    } 
                    case "_boxconfig":
                    {
                        if (proper[0] != undefined && proper[1] != undefined && proper.length == 2)
                        {
                            if (typeof(proper[0]) == "number" || typeof(proper[1]) == "number")
                            {
                                vrb();
                            }
                            else if (typeof(proper[0]) == "string" || typeof(proper[1]) == "string")
                            {
                                if (isNaN(Number(proper[0])) || isNaN(Number(proper[1])))
                                {
                                    er(146, true, false);
                                }
                                else
                                {
                                    vrb();
                                } // end else if
                            }
                            else
                            {
                                er(147, true, false);
                            } // end else if
                        }
                        else
                        {
                            er(136, true, false);
                        } // end else if
                        break;
                    } 
                    case "_startaligned":
                    {
                        vrb();
                        break;
                    } 
                    case "_orientation":
                    {
                        if (proper < -360 || proper > 360)
                        {
                            er(138, false, true);
                        }
                        else
                        {
                            vrb();
                        } // end else if
                        break;
                    } 
                    case "_events":
                    {
                        var _loc6 = false;
                        var _loc7 = false;
                        var _loc5 = 0;
                        for (var _loc13 in proper)
                        {
                            ++_loc5;
                            if (typeof(proper[_loc13]) != "boolean")
                            {
                                _loc6 = true;
                            } // end if
                            if (_loc13 == "onBirth" || _loc13 == "onDeath" || _loc13 == "onTweenEnd")
                            {
                                continue;
                            } // end if
                            _loc7 = true;
                        } // end of for...in
                        if (_loc6 || _loc5 != 3)
                        {
                            er(126, false, false);
                        }
                        else if (_loc7)
                        {
                            er(150, false, false);
                        }
                        else
                        {
                            vrb();
                        } // end else if
                        break;
                    } 
                    case "_order":
                    {
                        if (proper == "front" || proper == "back" || proper == "random")
                        {
                            vrb();
                        }
                        else
                        {
                            er(140, true, false);
                        } // end else if
                        break;
                    } 
                    case "_emissiontarget":
                    {
                        if (typeof(proper) == "movieclip")
                        {
                            vrb();
                        }
                        else
                        {
                            er(141, true, false);
                        } // end else if
                        break;
                    } 
                    case "_lowestdepth":
                    {
                        if (proper <= 0 || proper >= 1048574)
                        {
                            er(142, true, false);
                        }
                        else
                        {
                            var _loc2 = false;
                            if (emitter._order == "front")
                            {
                                if (emitter.__get___emissiontarget() == emitter._parent && emitter.getDepth() >= proper)
                                {
                                    er(144, true, false);
                                    _loc2 = true;
                                    break;
                                }
                                else
                                {
                                    for (var _loc13 in com.desuade.partigen.Partigen.__get___emitters())
                                    {
                                        var _loc1 = com.desuade.partigen.Partigen.__get___emitters()[_loc13];
                                        if (emitter.__get___emissiontarget() == _loc1._parent)
                                        {
                                            if (_loc1.getDepth() >= proper)
                                            {
                                                er(144, true, false);
                                                _loc2 = true;
                                                break;
                                            } // end if
                                        } // end if
                                    } // end of for...in
                                } // end if
                            } // end else if
                            if (!_loc2)
                            {
                                if (emitter.__get___emissiontarget().getInstanceAtDepth(proper) != undefined)
                                {
                                    er(143, false, false);
                                }
                                else
                                {
                                    vrb();
                                } // end if
                            } // end else if
                        } // end else if
                        break;
                    } 
                    case "_size":
                    {
                        if (typeof(proper) == "string" && proper == "disabled")
                        {
                            vrb();
                        }
                        else if (proper[0] != undefined && proper[1] != undefined && proper.length == 2)
                        {
                            if (typeof(proper[0]) == "number" || typeof(proper[1]) == "number")
                            {
                                if (proper[0] < 0 || proper[1] < 0)
                                {
                                    er(139, true, false);
                                }
                                else
                                {
                                    vrb();
                                } // end else if
                            }
                            else if (typeof(proper[0]) == "string" || typeof(proper[1]) == "string")
                            {
                                if (isNaN(Number(proper[0])) || isNaN(Number(proper[1])))
                                {
                                    er(146, true, false);
                                }
                                else
                                {
                                    vrb();
                                } // end else if
                            }
                            else
                            {
                                er(147, true, false);
                            } // end else if
                        }
                        else
                        {
                            er(136, true, false);
                        } // end else if
                        break;
                    } 
                    case "_scaleend":
                    {
                        if (typeof(proper) == "string" && proper == "disabled")
                        {
                            vrb();
                        }
                        else if (proper[0] != undefined && proper[1] != undefined && proper.length == 2)
                        {
                            if (typeof(proper[0]) == "number" || typeof(proper[1]) == "number")
                            {
                                if (proper[0] < 0 || proper[1] < 0)
                                {
                                    er(139, true, false);
                                }
                                else if (proper[0] > proper[1])
                                {
                                    er(137, false, false);
                                }
                                else
                                {
                                    vrb();
                                } // end else if
                            }
                            else if (typeof(proper[0]) == "string" || typeof(proper[1]) == "string")
                            {
                                if (isNaN(Number(proper[0])) || isNaN(Number(proper[1])))
                                {
                                    er(146, true, false);
                                }
                                else
                                {
                                    vrb();
                                } // end else if
                            }
                            else
                            {
                                er(147, true, false);
                            } // end else if
                        }
                        else
                        {
                            er(136, true, false);
                        } // end else if
                        break;
                    } 
                    case "_burst":
                    {
                        if (proper <= 0)
                        {
                            er(139, true, false);
                        }
                        else
                        {
                            vrb();
                        } // end else if
                        break;
                    } 
                    case "_rotationstart":
                    {
                        if (proper <= -360 || proper >= 360)
                        {
                            er(138, false, false);
                        }
                        else
                        {
                            vrb();
                        } // end else if
                        break;
                    } 
                    case "_alphastart":
                    {
                        if (proper < 0)
                        {
                            er(148, true, false);
                        }
                        else
                        {
                            vrb();
                        } // end else if
                        break;
                    } 
                    case "_life":
                    {
                        if (proper[0] != undefined && proper[0] != undefined && proper.length == 2)
                        {
                            if (typeof(proper[0]) == "number" || typeof(proper[1]) == "number")
                            {
                                if (proper[0] > proper[1])
                                {
                                    er(137, false, false);
                                }
                                else
                                {
                                    vrb();
                                } // end else if
                            }
                            else if (typeof(proper[0]) == "string" || typeof(proper[1]) == "string")
                            {
                                er(130, true, false);
                            }
                            else
                            {
                                er(145, true, false);
                            } // end else if
                        }
                        else
                        {
                            er(136, true, false);
                        } // end else if
                        break;
                    } 
                    case "_scalestart":
                    {
                        if (proper[0] != undefined && proper[1] != undefined && proper.length == 2)
                        {
                            if (typeof(proper[0]) == "number" || typeof(proper[1]) == "number")
                            {
                                if (proper[0] < 0 || proper[1] < 0)
                                {
                                    er(139, true, false);
                                }
                                else if (proper[0] > proper[1])
                                {
                                    er(137, false, false);
                                }
                                else
                                {
                                    vrb();
                                } // end else if
                            }
                            else if (typeof(proper[0]) == "string" || typeof(proper[1]) == "string")
                            {
                                er(130, true, false);
                            }
                            else
                            {
                                er(145, true, false);
                            } // end else if
                        }
                        else
                        {
                            er(136, true, false);
                        } // end else if
                        break;
                    } 
                } // End of switch
                if (varer == "_tween_x" || varer == "_tween_y" || varer == "_tween_cx" || varer == "_tween_cy" || varer == "_tween_delay" || varer == "_tween_duration" || varer == "_tween_ease" || varer == "_physics_vx" || varer == "_physics_vy" || varer == "_physics_ax" || varer == "_physics_ay" || varer == "_physics_angle" || varer == "_physics_anglerange" || varer == "_physics_fx" || varer == "_physics_fy")
                {
                    modePropCheck([varer]);
                } // end if
                if (varer == "_colorstart" || varer == "_colorend")
                {
                    if (typeof(proper) == "string" && proper == "disabled")
                    {
                        vrb();
                    }
                    else if (proper[0] != undefined && proper[1] != undefined && proper.length == 2)
                    {
                        if (typeof(proper[1]) == "number")
                        {
                            vrb();
                        }
                        else if (typeof(proper[1]) == "string")
                        {
                            if (isNaN(Number(proper[1])))
                            {
                                er(146, true, false);
                            }
                            else
                            {
                                vrb();
                            } // end else if
                        }
                        else
                        {
                            er(147, true, false);
                        } // end else if
                    }
                    else
                    {
                        er(136, true, false);
                    } // end else if
                } // end else if
                if (varer == "_rotationend" || varer == "_alphaend")
                {
                    if (typeof(proper) == "string" || typeof(proper) == "number")
                    {
                        if (typeof(proper) == "string")
                        {
                            if (isNaN(Number(proper)) && proper != "disabled")
                            {
                                er(132, true, false);
                            }
                            else if (proper != "disabled")
                            {
                                vrbS();
                            }
                            else
                            {
                                vrb();
                            } // end else if
                        }
                        else
                        {
                            vrb();
                        } // end else if
                        continue;
                    } // end if
                    er(129, true, false);
                } // end if
            } // end of for...in
        };
        rgPropCheck(varlist);
        if (varlist != fullar)
        {
            return (erobj);
        } // end if
    } // End of the function
    static function checkGoodLoad(mc, emitter, verb, src, varer, fsc, varlist, fullar, to)
    {
        if (getTimer() < emitter.int_idt + 3000)
        {
            var _loc4 = mc.getBytesTotal();
            if (_loc4 <= 0)
            {
            }
            else
            {
                clearInterval(emitter.int_id);
                mc.removeMovieClip();
                if (verb)
                {
                    var _loc5 = emitter.eramt == 1 ? (" error and ") : (" errors and ");
                    var _loc6 = emitter.wrngamt == 1 ? (" warning.") : (" warnings.");
                    com.desuade.partigen.Errors.output(true, 123, 1, src, undefined, varer + " (URL)");
                    if (varlist == fullar)
                    {
                        com.desuade.partigen.Errors.output(true, 124, 1, src, emitter.eramt + _loc5 + emitter.wrngamt + _loc6);
                    } // end if
                } // end if
                if (fsc)
                {
                    if (emitter.eramt == 0)
                    {
                        emitter.start(false, false, to);
                    }
                    else
                    {
                        com.desuade.partigen.Errors.output(true, 225, 1, emitter.namers + ".start");
                    } // end if
                } // end else if
                return (true);
            } // end else if
        }
        else
        {
            ++emitter.eramt;
            clearInterval(emitter.int_id);
            mc.removeMovieClip();
            com.desuade.partigen.Errors.output(true, 127, 1, src, undefined, varer);
            if (verb)
            {
                if (varlist == fullar)
                {
                    _loc5 = emitter.eramt == 1 ? (" error and ") : (" errors and ");
                    _loc6 = emitter.wrngamt == 1 ? (" warning.") : (" warnings.");
                    com.desuade.partigen.Errors.output(true, 124, 1, src, emitter.eramt + _loc5 + emitter.wrngamt + _loc6);
                } // end if
            } // end if
            if (fsc)
            {
                com.desuade.partigen.Errors.output(true, 225, 1, emitter.namers + ".start");
            } // end if
            return (false);
        } // end else if
    } // End of the function
    static function randomRange(min, max, round)
    {
        var _loc4 = Math.random;
        var _loc6 = Math.round;
        round = round != undefined ? (round) : (0);
        var _loc2 = 1;
        for (var _loc1 = 0; _loc1 < round; ++_loc1)
        {
            _loc2 = _loc2 * 10;
        } // end of for
        var _loc5 = _loc6((min + _loc4() * (max - min)) * _loc2) / _loc2;
        return (_loc5);
    } // End of the function
    static function convertValue(real, prop, val, mc, parentmc, inval)
    {
        var parentmc = parentmc == undefined ? (_root) : (parentmc);
        var curpar = mc;
        var valarr = real ? ([]) : ([val]);
        var endvalue = 0;
        var checkt = 0;
        var nonparent = function ()
        {
            curpar = mc;
            valarr = real ? ([]) : ([val]);
            while (curpar != _root)
            {
                curpar = curpar._parent;
                valarr.push(curpar[prop]);
            } // end while
            valarr.pop();
            for (var _loc2 in valarr)
            {
                endvalue = endvalue + valarr[_loc2];
            } // end of for...in
            var _loc4 = real ? (val - endvalue) : (endvalue);
            var _loc3 = _loc4 - com.desuade.partigen.Partigen.convertValue(false, prop, parentmc[prop], parentmc, _root, true);
            return (_loc3);
        };
        var _loc4 = function ()
        {
            while (curpar != parentmc)
            {
                if (checkt > 25)
                {
                    return (nonparent());
                    break;
                } // end if
                curpar = curpar._parent;
                valarr.push(curpar[prop]);
                ++checkt;
            } // end while
            if (inval != true)
            {
                valarr.pop();
            } // end if
            for (var _loc1 in valarr)
            {
                endvalue = endvalue + valarr[_loc1];
            } // end of for...in
            var _loc2 = real ? (val - endvalue) : (endvalue);
            return (false ? (Math.round(_loc2)) : (_loc2));
        };
        return (_loc4());
    } // End of the function
    static function onBirth(emitter, particle)
    {
    } // End of the function
    static function onDeath(emitter, particle)
    {
    } // End of the function
    static function onTweenEnd(emitter, particle)
    {
    } // End of the function
    static function onIdle()
    {
    } // End of the function
    static function onReturn()
    {
    } // End of the function
    static var PGVERSION = 1;
    static var PGVERSIONLONG = "1.0";
    static var PGVERSIONDATE = "March 26th, 2007";
    static var PGAUTHORS = "Andrew Fitzgerald";
    static var PGWEBSITE = "http://www.desuade.com/";
    static var PGLICENSE = "Trial Mode";
    static var dlmclient = null;
    static var allowc = null;
    static var taged = false;
    static var _output = 1;
    static var _useinterval = true;
    static var _events = {onDeath: false, onBirth: false, onTweenEnd: false, onIdle: false, onReturn: false};
    static var _defaultsource = "particle_ps";
    static var _defaultease = "linear";
    static var _defaultmode = ["tween", "point"];
    static var emitters = {};
    static var idle = false;
    static var idletimeout = 0;
    static var eamt = 0;
} // End of Class
