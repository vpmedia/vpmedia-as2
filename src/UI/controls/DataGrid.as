
    class UI.controls.DataGrid extends UI.core.events
    {
        var vLines, attachMovie, linesHolder, list, createEmptyMovieClip, renders, dispatchEvent, head, __get__multipleSelection, __get__setterEvent, __get__rowColors, __get__hLines, cellData, drawRect, __height, sizeHolder, __width;
        function DataGrid () {
            super();
            vLines = true;
            this.attachMovie("List", "list", 0);
            this.attachMovie("DataGrid_Header", "head", 2);
            linesHolder = list.lineSpace;
            this.createEmptyMovieClip("sizeHolder", 3);
            if (!_root.datagrid_dragger) {
                _root.attachMovie("DataGrid_Dragger", "datagrid_dragger", -50);
                _root.datagrid_dragger._visible = false;
            }
            renders = new Object ();
            list._y = 15;
            list.render = "DataGrid_ListRender";
            list.blockFocus();
            list.forwardEvent = this;
        }
        function onKeyDown() {
            list.onKeyDown();
            dispatchEvent("onKeyDown", {target:this});
        }
        function setScrollSelection(state) {
            list.setScrollSelection(state);
        }
        function setTooltip(id, tip) {
            head.setTooltip(id, tip);
        }
        function setColumnWidth(id, w) {
            head.getLabelData(id).width = w;
            head.redraw();
        }
        function set multipleSelection(b) {
            list.multipleSelection = b;
            //return (__get__multipleSelection());
        }
        function get selectedIndex() {
            return (list.selectedIndex);
        }
        function get lastSelectedIndex() {
            return (list.lastSelectedIndex);
        }
        function set selectedIndex(i) {
            list.selectedIndex = i;
            //return (selectedIndex);
        }
        function addColumn(id, label, width, tip, oh) {
            var _local2 = head.createChild(id, label, width, oh);
            renders[id] = defaultRender;
            if (tip != undefined) {
                setTooltip(id, tip);
            }
            return (_local2);
        }
        function addItem(data, rd) {
            return (list.addItem(data, rd));
        }
        function get selectedItems() {
            return (list.selectedItems);
        }
        function set setterEvent(b) {
            list.setterEvent = b;
            //return (__get__setterEvent());
        }
        function addItemAt(i, data, rd) {
            return (list.addItemAt(i, data, rd));
        }
        function getItemAt(i) {
            return (list.getItemAt(i));
        }
        function get length() {
            return (list.length);
        }
        function set rowColors(c) {
            list.rowColors = c;
            //return (__get__rowColors());
        }
        function removeItemAt(i) {
            list.removeItemAt(i);
        }
        function removeAll() {
            list.removeAll();
        }
        function get selectedItem() {
            return (list.selectedItem);
        }
        function setRender(id, r) {
            renders[id] = r;
            var _local2 = 0;
            while (_local2 < list.length) {
                list.getItemAt(_local2).setRender(id);
                _local2++;
            }
        }
        function set hLines(b) {
            list.hLines = b;
            //return (__get__hLines());
        }
        function onSetFocus() {
            list.onSetFocus();
        }
        function onKillFocus() {
            list.onKillFocus();
        }
        function sizeCells(data) {
            cellData = data;
            linesHolder.clear();
            if (vLines == true) {
                for (var _local5 in data) {
                    if (data[_local5].visible != false) {
                        var _local4 = (data[_local5].x + data[_local5].width) - 1;
                        drawRect(linesHolder, _local4, 0, 1, __height - 16, 15000804, 100);
                    }
                }
            }
            var _local2 = 0;
            while (_local2 < list.length) {
                list.getItemAt(_local2).redraw();
                _local2++;
            }
        }
        function getCellRender(id) {
            return (renders[id]);
        }
        function getCellData(id) {
            return (cellData[id]);
        }
        function doSort(id, mode) {
            var _local5 = list.__data;
            var _local10 = new Array ();
            var _local4 = new Array ();
            var _local2 = 0;
            while (_local2 < _local5.length) {
                var _local6 = _local5[_local2].mc;
                _local4.push({val:_local6[id], id:_local2});
                _local2++;
            }
            if (icase) {
                var _local14 = function (a, b) {
                    var _local2 = a.val;
                    var _local1 = b.val;
                    _local2 = ((typeof (_local2) == "string") ? (_local2.toLowerCase()) : (_local2));
                    _local1 = ((typeof (_local1) == "string") ? (_local1.toLowerCase()) : (_local1));
                    return (_local1 < _local2);
                };
                var _local11 = function (a, b) {
                    var _local2 = a.val;
                    var _local1 = b.val;
                    _local2 = ((typeof (_local2) == "string") ? (_local2.toLowerCase()) : (_local2));
                    _local1 = ((typeof (_local1) == "string") ? (_local1.toLowerCase()) : (_local1));
                    return (_local2 < _local1);
                };
                _local4.sort(((mode == 0) ? (_local14) : (_local11)));
            } else {
                _local4.sortOn("val", ((mode == 0) ? (Array.ASCENDING) : (Array.DESCENDING)));
             }
            var _local3 = 0;
            while (_local3 < _local4.length) {
                var _local7 = _local4[_local3].id;
                _local10.push(_local5[_local7]);
                _local3++;
            }
            list.__data = _local10;
            list.redraw(0);
        }
        function get vPosition() {
            return (list.vPosition);
        }
        function get hPosition() {
            return (list.hPosition);
        }
        function set vPosition(p) {
            list.vPosition = p;
            //return (vPosition);
        }
        function set hPosition(p) {
            list.hPosition = p;
            //return (hPosition);
        }
        function get maxVPosition() {
            return (list.maxVPosition);
        }
        function get maxHPosition() {
            return (list.maxHPosition);
        }
        function redrawHead() {
            head.redraw();
        }
        function drawBlackLine(x) {
            sizeHolder.clear();
            drawRect(sizeHolder, x - 1, 1, 1, __height - 2, 0, 100);
        }
        function get width() {
            return (__width);
        }
        function get height() {
            return (__height);
        }
        function redraw(i) {
            list.redraw(i);
        }
        function setSize(w, h) {
            __height = h;
            __width = w;
            head.setSize(w);
            list.setSize(w, h - 15);
            sizeCells(cellData);
        }
        var defaultRender = "DataGrid_DefaultRender";
        var focusRect = true;
        var icase = true;
    }
