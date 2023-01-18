    class UI.controls.StatusBars extends UI.core.events
    {
        var createEmptyMovieClip, attachMovie, rowHolder, rowMask, vScroll, currentTitleLabel, peakTitleLabel, __data, __index, label_txt, List, drawRect, __height, __width;
        function StatusBars () {
            super();
            this.createEmptyMovieClip("rowHolder", 0);
            this.attachMovie("Label", "currentTitleLabel", 1);
            this.attachMovie("Label", "peakTitleLabel", 2);
            this.attachMovie("ScrollBar", "vScroll", 3);
            this.createEmptyMovieClip("rowMask", 4);
            rowHolder.setMask(rowMask);
            vScroll.addListener("scroll", doVScroll, this);
            vScroll._visible = false;
            vScroll._y = 15;
            vScroll.blockFocus();
            currentTitleLabel.text = "Current Clients";
            currentTitleLabel.setFormat("bold", true);
            currentTitleLabel.autoSize = "left";
            currentTitleLabel._x = 120;
            currentTitleLabel._y = 0;
            peakTitleLabel.autoSize = "left";
            peakTitleLabel.text = "Peak Clients";
            peakTitleLabel.setFormat("color", 6710886);
            peakTitleLabel._x = 325;
            peakTitleLabel._y = 0;
            __data = new Object ();
            __index = 1;
        }
        function set label(l) {
            label_txt.text = l;
            //return (label);
        }
        function get label() {
            return (label_txt.text);
        }
        function getBestHeight() {
            return (List.__rowHeight);
        }
        function getWidth() {
            return (label_txt._x + label_txt._width);
        }
        function clear() {
            __data = new Object ();
            __index = 1;
            this.createEmptyMovieClip("rowHolder", 0);
        }
        function updateServer(sID, label, connected, peak) {
            if (__data[sID] == undefined) {
                __data[sID] = addRow(label, 0);
                updateRow(sID, connected, peak);
            } else {
                updateRow(sID, connected, peak);
             }
        }
        function updateVhost(vhostName, connected, peak) {
            if (__data[vhostName] == undefined) {
                __data[vhostName] = addRow(vhostName, __index);
                updateRow(vhostName, connected, peak);
                _checkScroll();
                __index++;
            } else {
                updateRow(vhostName, connected, peak);
             }
        }
        function updateRow(id, connected, peak) {
            if ((__data[id].connected != connected) || (__data[id].peak != peak)) {
                __data[id].currentClientsTxt.text = connected;
                __data[id].peakClientsTxt.text = peak;
                __data[id].currentClientsTxt._x = ((peak == 0) ? (142 - __data[id].currentClientsTxt.width) : ((142 + ((connected * 176) / peak)) - __data[id].currentClientsTxt.width));
                __data[id].clear();
                drawRect(__data[id], 120, 16, 200, 14, 15726847, 100, 6);
                var _local5 = ((peak == 0) ? 20 : (20 + ((connected * 176) / peak)));
                if (__data[id].index == 0) {
                    drawRect(__data[id], 122, 18, _local5, 10, 36086, 100, 4);
                } else {
                    drawRect(__data[id], 122, 18, _local5, 10, 8585061, 100, 4);
                 }
                __data[id].connected = connected;
                __data[id].peak = peak;
            }
        }
        function addRow(label, i) {
            rowHolder.createEmptyMovieClip("row" + i, i);
            rowHolder["row" + i].index = i;
            rowHolder["row" + i]._y = i * 16;
            rowHolder["row" + i].attachMovie("Label", "label_txt", 2);
            rowHolder["row" + i].attachMovie("Label", "currentClientsTxt", 3);
            rowHolder["row" + i].attachMovie("Label", "peakClientsTxt", 4);
            rowHolder["row" + i].currentClientsTxt.autoSize = "right";
            rowHolder["row" + i].currentClientsTxt.text = "0";
            rowHolder["row" + i].currentClientsTxt._y = 15;
            if (i == 0) {
                rowHolder["row" + i].currentClientsTxt.setFormat("color", 16777215);
            } else {
                rowHolder["row" + i].currentClientsTxt.setFormat("color", 6710886);
             }
            rowHolder["row" + i].peakClientsTxt.autoSize = "left";
            rowHolder["row" + i].peakClientsTxt._x = 325;
            rowHolder["row" + i].peakClientsTxt._y = 15;
            rowHolder["row" + i].peakClientsTxt.setFormat("color", 6710886);
            rowHolder["row" + i].label_txt.setSize(115, 12);
            rowHolder["row" + i].label_txt.text = ((label.length > 19) ? (label.slice(0, 16) + "...") : (label));
            rowHolder["row" + i].label_txt._x = 0;
            rowHolder["row" + i].label_txt._y = 15;
            rowHolder["row" + i].label_txt.autoSize = "right";
            if (i == 0) {
                rowHolder["row" + i].label_txt.setFormat("bold", true);
            }
            rowHolder.setMask(rowMask);
            return (rowHolder["row" + i]);
        }
        function doVScroll() {
            rowHolder._y = -vScroll.scrollPosition;
        }
        function _checkScroll() {
            var _local3 = __index * 16;
            if (_local3 > (__height - 18)) {
                vScroll._visible = true;
                var _local2 = _local3 + 2;
                vScroll.setSize(__height - 4);
                vScroll.setScrollProperties(_local2, 0, _local2 - (__height - 18));
                vScroll._x = __width - (vScroll.width + 2);
            } else {
                vScroll._visible = false;
                rowHolder._y = 0;
             }
        }
        function setSize(width, height) {
            __width = width;
            __height = height;
            rowMask.clear();
            drawRect(rowMask, 0, 15, __width - (vScroll.width + 4), height - 4, 16777215, 0);
        }
    }
