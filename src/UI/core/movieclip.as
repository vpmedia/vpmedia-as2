    class UI.core.movieclip extends MovieClip
    {
        var attachMovie, onResult;
        function movieclip () {
            super();
        }
        function onError(msg) {
            _global.am.onError(msg);
        }
        function onInfo(msg, ico) {
            _global.am.onInfo(msg, ico);
        }
        function get StageWidth() {
            return (_global.stg.__width);
        }
        function get StageHeight() {
            return (_global.stg.__height);
        }
        function addToolTip(text, target) {
            _global.tt.addToolTip(text, target);
        }
        function drawRect(mc, x, y, w, h, fill, alpha, cornerRadius) {
            if ((w < 0) || (h < 0)) {
                return (undefined);
            }
            if (cornerRadius > 0) {
                var _local2;
                var _local3;
                var _local8;
                var _local7;
                var _local10;
                var _local9;
                if (cornerRadius > (Math.min(w, h) / 2)) {
                    cornerRadius = Math.min(w, h) / 2;
                }
                _local2 = (Math.PI/4);
                mc.moveTo(x + cornerRadius, y);
                if (fill != null) {
                    mc.beginFill(fill, alpha);
                }
                mc.lineTo((x + w) - cornerRadius, y);
                _local3 = -1.5707963267949;
                _local8 = ((x + w) - cornerRadius) + ((Math.cos(_local3 + (_local2 / 2)) * cornerRadius) / Math.cos(_local2 / 2));
                _local7 = (y + cornerRadius) + ((Math.sin(_local3 + (_local2 / 2)) * cornerRadius) / Math.cos(_local2 / 2));
                _local10 = ((x + w) - cornerRadius) + (Math.cos(_local3 + _local2) * cornerRadius);
                _local9 = (y + cornerRadius) + (Math.sin(_local3 + _local2) * cornerRadius);
                mc.curveTo(_local8, _local7, _local10, _local9);
                _local3 = _local3 + _local2;
                _local8 = ((x + w) - cornerRadius) + ((Math.cos(_local3 + (_local2 / 2)) * cornerRadius) / Math.cos(_local2 / 2));
                _local7 = (y + cornerRadius) + ((Math.sin(_local3 + (_local2 / 2)) * cornerRadius) / Math.cos(_local2 / 2));
                _local10 = ((x + w) - cornerRadius) + (Math.cos(_local3 + _local2) * cornerRadius);
                _local9 = (y + cornerRadius) + (Math.sin(_local3 + _local2) * cornerRadius);
                mc.curveTo(_local8, _local7, _local10, _local9);
                mc.lineTo(x + w, (y + h) - cornerRadius);
                _local3 = _local3 + _local2;
                _local8 = ((x + w) - cornerRadius) + ((Math.cos(_local3 + (_local2 / 2)) * cornerRadius) / Math.cos(_local2 / 2));
                _local7 = ((y + h) - cornerRadius) + ((Math.sin(_local3 + (_local2 / 2)) * cornerRadius) / Math.cos(_local2 / 2));
                _local10 = ((x + w) - cornerRadius) + (Math.cos(_local3 + _local2) * cornerRadius);
                _local9 = ((y + h) - cornerRadius) + (Math.sin(_local3 + _local2) * cornerRadius);
                mc.curveTo(_local8, _local7, _local10, _local9);
                _local3 = _local3 + _local2;
                _local8 = ((x + w) - cornerRadius) + ((Math.cos(_local3 + (_local2 / 2)) * cornerRadius) / Math.cos(_local2 / 2));
                _local7 = ((y + h) - cornerRadius) + ((Math.sin(_local3 + (_local2 / 2)) * cornerRadius) / Math.cos(_local2 / 2));
                _local10 = ((x + w) - cornerRadius) + (Math.cos(_local3 + _local2) * cornerRadius);
                _local9 = ((y + h) - cornerRadius) + (Math.sin(_local3 + _local2) * cornerRadius);
                mc.curveTo(_local8, _local7, _local10, _local9);
                mc.lineTo(x + cornerRadius, y + h);
                _local3 = _local3 + _local2;
                _local8 = (x + cornerRadius) + ((Math.cos(_local3 + (_local2 / 2)) * cornerRadius) / Math.cos(_local2 / 2));
                _local7 = ((y + h) - cornerRadius) + ((Math.sin(_local3 + (_local2 / 2)) * cornerRadius) / Math.cos(_local2 / 2));
                _local10 = (x + cornerRadius) + (Math.cos(_local3 + _local2) * cornerRadius);
                _local9 = ((y + h) - cornerRadius) + (Math.sin(_local3 + _local2) * cornerRadius);
                mc.curveTo(_local8, _local7, _local10, _local9);
                _local3 = _local3 + _local2;
                _local8 = (x + cornerRadius) + ((Math.cos(_local3 + (_local2 / 2)) * cornerRadius) / Math.cos(_local2 / 2));
                _local7 = ((y + h) - cornerRadius) + ((Math.sin(_local3 + (_local2 / 2)) * cornerRadius) / Math.cos(_local2 / 2));
                _local10 = (x + cornerRadius) + (Math.cos(_local3 + _local2) * cornerRadius);
                _local9 = ((y + h) - cornerRadius) + (Math.sin(_local3 + _local2) * cornerRadius);
                mc.curveTo(_local8, _local7, _local10, _local9);
                mc.lineTo(x, y + cornerRadius);
                _local3 = _local3 + _local2;
                _local8 = (x + cornerRadius) + ((Math.cos(_local3 + (_local2 / 2)) * cornerRadius) / Math.cos(_local2 / 2));
                _local7 = (y + cornerRadius) + ((Math.sin(_local3 + (_local2 / 2)) * cornerRadius) / Math.cos(_local2 / 2));
                _local10 = (x + cornerRadius) + (Math.cos(_local3 + _local2) * cornerRadius);
                _local9 = (y + cornerRadius) + (Math.sin(_local3 + _local2) * cornerRadius);
                mc.curveTo(_local8, _local7, _local10, _local9);
                _local3 = _local3 + _local2;
                _local8 = (x + cornerRadius) + ((Math.cos(_local3 + (_local2 / 2)) * cornerRadius) / Math.cos(_local2 / 2));
                _local7 = (y + cornerRadius) + ((Math.sin(_local3 + (_local2 / 2)) * cornerRadius) / Math.cos(_local2 / 2));
                _local10 = (x + cornerRadius) + (Math.cos(_local3 + _local2) * cornerRadius);
                _local9 = (y + cornerRadius) + (Math.sin(_local3 + _local2) * cornerRadius);
                mc.curveTo(_local8, _local7, _local10, _local9);
                if (fill != null) {
                    mc.endFill();
                }
            } else {
                mc.moveTo(x, y);
                mc.beginFill(fill, alpha);
                mc.lineTo(x + w, y);
                mc.lineTo(x + w, y + h);
                mc.lineTo(x, y + h);
                mc.lineTo(x, y);
                mc.endFill();
             }
        }
        function addControl(type, n, depth, data) {
			
            var _local3 = this.attachMovie(type, n, depth);
			
            if (data.width) {
                _local3.setSize(data.width, data.height);
            }
			
            for (var _local4 in data) {
				trace(_local4);
                if ((_local4 != "width") && (_local4 != "height")) {
                    _local3[_local4] = data[_local4];
                }
            }
			return (_local3);
        }
        function get Cache() {
            return (_global.conn.__cache);
        }
        function ResBind(method, obj) {
            var a = new Array ();
            var _local3 = 2;
            while (_local3 < arguments.length) {
                a.push(arguments[_local3]);
                _local3++;
            }
            onResult = function (data) {
                a.splice(0, 0, data);
                method.apply(obj, a);
            };
        }
        function onAlert(content, width, height, title, owner, white) {
            var _local2 = _global.form_manager.onAlert(content, width, height, title, owner, white);
            return (_local2);
        }
        function get Clusters() {
            return (_global.cm);
        }
        function formatDecimals(num, digits) {
            if (digits <= 0) {
                return (Math.round(num).toString());
            }
            var _local4 = Math.pow(10, digits);
            var _local2 = String (Math.round(num * _local4) / _local4);
            if (_local2.indexOf(".") == -1) {
                _local2 = _local2 + ".0";
            }
            var _local6 = _local2.split(".");
            var _local3 = digits - _local6[1].length;
            var _local1 = 1;
            while (_local1 <= _local3) {
                _local2 = _local2 + "0";
                _local1++;
            }
            return (_local2);
        }
    }
