class com.desuade.dlm.Client
{
    var __get___activated, __get___expired, __get___licensed, __get___licensetype, __get___trialexpired, __get___version, __get___versiondate, __get___watermarked;
    function Client(ewm, ser, tl, ida, id, cwm, expdate, activ)
    {
        Stage.align = "lt";
        serialn = ser;
        currentdate = new Date();
        triallength = tl;
        installdate = ida;
        customwm = cwm;
        enablewatermark = ewm;
        isactivated = activ;
        islicensed = this.validatelicense(ser, id);
        validatelicense = new Function();
        delete this.validatelicense;
        var _loc6 = 2245879;
        if (lcactivation)
        {
            islicensed = isactivated ? (true) : (false);
        } // end if
        if (islicensed)
        {
            if (lcwatermark)
            {
                iswatermarked = true;
                this.checkwm("devwm" + id, id);
                var _loc7 = setInterval(checkwm, 5000, "devwm" + id, id);
            } // end if
            var _loc4 = currentdate >= expdate ? (true) : (false);
            if (lcexpires && _loc4)
            {
                hasexpiredop = true;
            }
            else
            {
                hasexpiredop = false;
            } // end else if
        }
        else
        {
            trialhasexpiredop = this.checktrialexpired(installdate, currentdate, triallength);
            if (enablewatermark)
            {
                iswatermarked = true;
                this.checkwm("devwm" + id, id);
                _loc7 = setInterval(checkwm, 2000, "devwm" + id, id);
            } // end if
        } // end else if
        _global.ASSetPropFlags(com.desuade.dlm.Client, null, 1, false);
        _global.ASSetPropFlags(this, null, 1, false);
    } // End of the function
    function get _version()
    {
        return (VERSION);
    } // End of the function
    function get _versiondate()
    {
        return (VERSIONDATE);
    } // End of the function
    function get _expired()
    {
        return (hasexpiredop);
    } // End of the function
    function get _trialexpired()
    {
        return (trialhasexpiredop);
    } // End of the function
    function get _licensed()
    {
        return (islicensed);
    } // End of the function
    function get _activated()
    {
        return (isactivated);
    } // End of the function
    function get _watermarked()
    {
        return (iswatermarked);
    } // End of the function
    function get _licensetype()
    {
        return (licensetp);
    } // End of the function
    static function ino()
    {
        return (true);
    } // End of the function
    function checkwm(nam, dpt)
    {
        var _loc4 = _root.dlmwm;
        if (_loc4.wm != true)
        {
            _loc4 = _root.attachMovie("dwm", "dlmwm", 2245879);
            _loc4.attachMovie(customwm, nam, dpt);
            _loc4.wm = true;
            _global.ASSetPropFlags(_loc4, null, 1, false);
        }
        else if (_loc4[nam] == undefined)
        {
            _loc4.attachMovie(customwm, nam, dpt);
            _global.ASSetPropFlags(_loc4, null, 1, false);
        } // end else if
        if (_root.getNextHighestDepth() - 1 != dpt)
        {
            _loc4.swapDepths(_root.getNextHighestDepth());
        } // end if
        _loc4._x = _loc4._y = 0;
        _loc4._alpha = 100;
        _loc4._visible = true;
    } // End of the function
    function validatelicense(sn, dlid)
    {
        var snar = sn.split("-");
        var _loc3 = Number(snar[0].slice(3, 5).split("").join("."));
        if (isNaN(_loc3))
        {
            return (false);
        } // end if
        if (_loc3 > VERSION)
        {
            return (false);
        } // end if
        var _loc11 = function (obj, tt)
        {
            if (obj.slice(0, 3) != "DLM")
            {
                return (false);
            } // end if
            return (true);
        };
        var _loc10 = function (obj, tt)
        {
            if (obj.slice(0, 2) != "DV")
            {
                return (false);
            } // end if
            return (true);
        };
        var _loc9 = function (obj, tt)
        {
            return (true);
        };
        var _loc8 = function (obj, tt)
        {
            return (true);
        };
        var _loc7 = function (obj, tt)
        {
            var _loc1 = Number(snar[4].slice(1, 2));
            tt.lcwatermark = licarr[_loc1][0];
            tt.lcactivation = licarr[_loc1][1];
            tt.lcexpires = licarr[_loc1][2];
            tt.licensetp = obj.slice(0, 1);
            return (licarr[_loc1] == undefined ? (false) : (true));
        };
        var licarr = [[true, true, true], [true, true, false], [true, false, true], [true, false, false], [false, true, true], [false, true, false], [false, false, true], [false, false, false]];
        var _loc4 = {};
        _loc4[1] = [[_loc11, _loc10, _loc9, _loc8, _loc7], [[true, 5], [false, 3], [true, 4], [true, 5], [false, 4]]];
        if (_loc4[_loc3][0].length != snar.length)
        {
            return (false);
        }
        else
        {
            for (var _loc6 in snar)
            {
                if (_loc4[_loc3][1][_loc6][0])
                {
                    if (snar[_loc6].length != _loc4[_loc3][1][_loc6][1])
                    {
                        return (false);
                    } // end if
                    continue;
                } // end if
                if (snar[_loc6].length < _loc4[_loc3][1][_loc6][1])
                {
                    return (false);
                } // end if
            } // end of for...in
        } // end else if
        for (var _loc2 = 0; _loc2 < snar.length; ++_loc2)
        {
            if (_loc4[_loc3][0][_loc2](snar[_loc2], this) == false)
            {
                return (false);
            } // end if
        } // end of for
        return (true);
    } // End of the function
    function checktrialexpired(old, cur, tl)
    {
        var _loc1 = Math.floor((cur.getTime() - old.getTime()) / 86400000);
        return (_loc1 >= 0 && _loc1 < tl ? (false) : (true));
    } // End of the function
    var VERSION = 1;
    var VERSIONDATE = "March, 9th 2007";
    var serialn = null;
    var licensetp = null;
    var lcwatermark = null;
    var lcactivation = null;
    var lcexpires = null;
    var installdate = null;
    var currentdate = null;
    var triallength = null;
    var enabletrial = null;
    var enablewatermark = null;
    var customwm = null;
    var iswatermarked = false;
    var islicensed = false;
    var isactivated = false;
    var hasexpiredop = false;
    var trialhasexpiredop = false;
} // End of Class
