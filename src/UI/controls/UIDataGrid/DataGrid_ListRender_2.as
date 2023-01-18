    class UI.controls.UIDataGrid.DataGrid_ListRender_2 extends UI.core.movieclip
    {
        var createEmptyMovieClip, children, childCount, datOn, hidden, drawRect, hitSpace, List, attachMovie, addProperty, __width, lineSpace;
        function DataGrid_ListRender_2 () {
            super();
            this.createEmptyMovieClip("hitSpace", 3);
            this.createEmptyMovieClip("lineSpace", 4);
            children = new Object ();
            childCount = 0;
            datOn = new Object ();
            hidden = new Object ();
            drawRect(hitSpace, 0, 0, 1, 1, 0, 0);
        }
        function onData(d) {
            for (var _local3 in d) {
                if (!children[_local3]) {
                    datOn[_local3] = d[_local3];
                    createChild(_local3);
                }
                children[_local3].setData(d[_local3]);
            }
        }
        function onSelect() {
            for (var _local2 in children) {
                children[_local2].onSelect();
            }
        }
        function onDeselect() {
            for (var _local2 in children) {
                children[_local2].onDeselect();
            }
        }
        function setRender(id) {
            var _local3 = children[id].getData();
            children[id].removeMovieClip();
            createChild(id);
            children[id].setData(_local3);
        }
        function redraw() {
            for (var _local5 in children) {
                refreshItem(_local5);
            }
            var _local3 = new Array ();
            for (var _local5 in hidden) {
                var _local4 = List._parent.getCellData(_local5);
                if (_local4.visible != false) {
                    createChild(_local5);
                    children[_local5].setData(datOn[_local5]);
                    _local3.push(_local5);
                }
            }
            var _local2 = 0;
            while (_local2 < _local3.length) {
                delete hidden[_local3[_local2]];
                _local2++;
            }
        }
        function getBestHeight() {
            var _local3 = 0;
            for (var _local4 in children) {
                var _local2 = children[_local4].getBestHeight();
                if (_local2 > _local3) {
                    _local3 = _local2;
                }
            }
            return (_local3);
        }
        function getWidth() {
            return (0);
        }
        function createChild(id) {
            var _local2 = List._parent.getCellData(id);
            if (!_local2) {
                return (undefined);
            }
            if (_local2.visible == false) {
                var mc = this;
                hidden[id] = true;
            } else {
                var mc = this.attachMovie(List._parent.getCellRender(id), "c" + childCount, 5 + childCount);
                childCount++;
                mc.owner = this;
                children[id] = mc;
                refreshItem(id);
             }
            var o = this;
            var _local4 = function () {
                if (mc == o) {
                    return (o.datOn[id]);
                } else {
                    return (mc.getData());
                 }
            };
            var _local3 = function (v) {
                o.datOn[id] = v;
                mc.setData(v);
            };
            this.addProperty(id, _local4, _local3);
        }
        function onChangeHeight() {
            List.onChangeHeight(this, getBestHeight());
        }
        function refreshItem(id) {
            var _local2 = children[id];
            var _local3 = List._parent.getCellData(id);
            if (_local3.visible != false) {
                if (_local3.width != _local2.__lastWidth) {
                    _local2.setWidth(_local3.width + 6);
                    _local2.__lastWidth = _local3.width;
                }
                _local2._x = _local3.x - 9;
                _local2._visible = true;
            } else {
                _local2._visible = false;
                _local2._x = 0;
             }
        }
        function getChild(id) {
            return (children[id]);
        }
        function setSize(w, h) {
            __width = w;
            hitSpace._width = w;
            hitSpace._height = h;
            lineSpace.clear();
            if (List.hLines == true) {
                drawRect(lineSpace, -1, h - 1, w + 2, 1, 14671839, 100);
            }
        }
    }
