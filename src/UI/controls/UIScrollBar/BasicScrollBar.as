    class UI.controls.UIScrollBar.BasicScrollBar extends UI.core.events
    {
        var __enabled, __prefix, attachMovie, createEmptyMovieClip, __track, notab, thumb, _ymouse, trackInt, dispatchEvent, isScrolling, __direction, __VSpace, hitArea, onMouseMove, scrolling, lastY;
        function BasicScrollBar () {
            super();
            __enabled = true;
            __prefix = "V";
            this.attachMovie("ScrollBar_Track", "__track", 0);
            this.createEmptyMovieClip("__HSpace", 1);
            this.createEmptyMovieClip("__VSpace", 2);
            this.attachMovie("ScrollBarThumb", "thumb", 3);
            draw("V");
            var o = this;
            __track.onPress = function () {
                o.onTrackDown();
            };
            __track.onRelease = (__track.onReleaseOutside = function () {
                o.onTrackUp();
            });
            notab(__track);
            __track.useHandCursor = false;
            setState(2);
            thumb.setState(2);
        }
        function onTrackDown() {
            var _local3 = _ymouse - trackDecriment;
            var _local2 = (((_local3 * (maxPos - minPos)) / ((__size - trackDecriment) - thumb._height)) - minPos) + trackDecriment;
            if (_local2 < scrollPosition) {
                onTrakInt(this, true, _local2);
                trackInt = setInterval(onTrakInt, 200, this, true, _local2);
            } else {
                onTrakInt(this, false, _local2);
                trackInt = setInterval(onTrakInt, 200, this, false, _local2);
             }
        }
        function onTrakInt(p, mv, ov) {
            var _local4 = p._ymouse - trackDecriment;
            var _local5 = Math.round(((_local4 * (p.maxPos - p.minPos)) / ((p.__size - p.trackDecriment) - p.thumb._height)) - p.minPos);
            var _local3 = p.thumb._height;
            if (mv == true) {
                p.scrollPosition = Math.max(p.scrollPosition - _local3, p.minPos);
            } else {
                p.scrollPosition = Math.min(p.scrollPosition + _local3, p.maxPos);
             }
        }
        function onTrackUp() {
            clearInterval(trackInt);
        }
        function onSetFocus() {
        }
        function set scrollPosition(pos) {
            pos = Fix(pos);
            _scrollPosition = pos;
            dispatchEvent("scroll", {target:this, scrollPosition:pos});
            if (isScrolling != true) {
                var _local3 = getY(pos) + 6;
                thumb._y = _local3;
            }
            //return (scrollPosition);
        }
        function setPosThumb(pos) {
            if (pos < minPos) {
                pos = minPos;
            }
            if (pos > maxPos) {
                pos = maxPos;
            }
            _scrollPosition = pos;
            if (isScrolling != true) {
                pos = Math.min(pos, maxPos);
                pos = Math.max(pos, minPos);
                var _local3 = getY(pos);
                thumb._y = _local3;
            }
            dispatchEvent("scroll", {target:this, scrollPosition:pos});
        }
        function set enabled(e) {
            if ((e == true) && (__enabled == false)) {
                setState(2);
                thumb.setState(2);
            }
            if (e == false) {
                setState(1);
                thumb.setState(1);
            }
            __enabled = e;
            //return (enabled);
        }
        function get enabled() {
            return (__enabled);
        }
        function get scrollPosition() {
            return (_scrollPosition);
        }
        function setScrollProperties(size, min, max) {
            pageSize = size;
            minPos = Math.max(min, 0);
            maxPos = Math.max(max, 0);
            resizeThumb();
            var _local2 = Fix(scrollPosition);
            scrollPosition = (_local2);
        }
        function Fix(n) {
            if (n < minPos) {
                n = minPos;
            }
            if (n > maxPos) {
                n = maxPos;
            }
            return (n);
        }
        function resizeThumb() {
            var _local3 = __size - trackDecriment;
            var _local2 = (pageSize / ((maxPos - minPos) + pageSize)) * (__size - trackDecriment);
            thumb.clear();
            thumb.setSize(_local2);
        }
        function getY(value) {
            var _local2 = (((value - minPos) * ((__size - trackDecriment) - thumb._height)) / (maxPos - minPos)) + 7;
            return (_local2);
        }
        function getValue(y) {
            return (((y - 13) * (maxPos - minPos)) / ((__size - trackDecriment) - thumb._height));
        }
        function setSize(size) {
            __size = size;
            if (size <= 39) {
                thumb._visible = false;
            } else {
                thumb._visible = true;
             }
            if (__direction == "Horizontal") {
                __track.gotoAndStop(2);
                __track._width = size;
                __track._height = 13;
            } else {
                __track.gotoAndStop(1);
                __track._height = size;
                __track._width = 13;
                var _local3 = __VSpace;
                _local3.down._y = size - _local3.down._height;
             }
            resizeThumb();
            hitArea = __track;
        }
        function setState(i, t) {
            var _local2 = "down";
            if (t == 1) {
                _local2 = "up";
            }
            var _local3 = this[("__" + __prefix) + "Space"][_local2];
            _local3.gotoAndStop(i);
        }
        function draw(prefix) {
            var _local2 = this[("__" + prefix) + "Space"];
            _local2.attachMovie(("ScrollBar_" + prefix) + "Down", "down", 0);
            _local2.attachMovie(("ScrollBar_" + prefix) + "Up", "up", 1);
            var owner = this;
            notab(_local2.down);
            notab(_local2.up);
            _local2.down.onPress = function () {
                owner.scrollDown(this);
            };
            _local2.up.onPress = function () {
                owner.scrollUp(this);
            };
            _local2.down.onRollOver = function () {
                owner.setState(3, 0);
            };
            _local2.up.onRollOver = function () {
                owner.setState(3, 1);
            };
            _local2.down.onRollOut = function () {
                owner.setState(2, 0);
            };
            _local2.up.onRollOut = function () {
                owner.setState(2, 1);
            };
            _local2.down.onReleaseOutside = function () {
                owner.releaseScroll(this, 0);
            };
            _local2.up.onReleaseOutside = function () {
                owner.releaseScroll(this, 1);
            };
            _local2.down.onRelease = function () {
                owner.releaseScrollOver(this, 0);
            };
            _local2.up.onRelease = function () {
                owner.releaseScrollOver(this, 1);
            };
            notab(thumb);
            thumb.onPress = function () {
                owner.scrollThumb();
            };
            thumb.onRelease = function () {
                owner.releaseThumbOver();
            };
            thumb.onReleaseOutside = function () {
                owner.releaseThumb();
            };
            thumb.onRollOver = function () {
                if ((owner.__enabled == true) && (this.activeState != 4)) {
                    this.setState(3);
                }
            };
            thumb.onRollOut = function () {
                if ((owner.__enabled == true) && (this.activeState != 4)) {
                    this.setState(2);
                }
            };
            thumb.useHandCursor = (_local2.up.useHandCursor = (_local2.down.useHandCursor = false));
        }
        function releaseThumbOver() {
            if (__enabled == true) {
                isScrolling = false;
                thumb.setState(3);
                onMouseMove = null;
            }
        }
        function releaseThumb() {
            if (__enabled == true) {
                isScrolling = false;
                thumb.setState(2);
                onMouseMove = null;
            }
        }
        function releaseScrollOver(mc) {
            if (__enabled == true) {
                mc.gotoAndStop(3);
                releaseScroll();
            }
        }
        function releaseScroll(mc) {
            if (__enabled == true) {
                mc.gotoAndStop(2);
                clearInterval(scrolling);
            }
        }
        function scrollUp(mc) {
            if (__enabled == true) {
                mc.gotoAndStop(4);
                scrollIt("one", -1);
                scrolling = setInterval(scrollInterval, 200, "one", -1, this);
            }
        }
        function scrollDown(mc) {
            if (__enabled == true) {
                mc.gotoAndStop(4);
                scrollIt("one", 1);
                scrolling = setInterval(scrollInterval, 200, "one", 1, this);
            }
        }
        function scrollInterval(inc, mode, ref) {
            clearInterval(ref.scrolling);
            if (inc == "page") {
            } else {
                ref.scrollIt(inc, mode);
             }
            ref.scrolling = setInterval(ref.scrollInterval, 7, inc, mode, ref);
        }
        function scrollIt(inc, mode) {
            var _local3 = 1;
            var _local2 = scrollPosition + (mode * _local3);
            _local2 = Fix(_local2);
            scrollPosition = (_local2);
        }
        function trackScroller() {
            if ((thumb._y + thumb._height) < _ymouse) {
                scrollIt("page", 1);
            } else if (thumb._y > _ymouse) {
                scrollIt("page", -1);
            }
        }
        function get max() {
            return (maxPos);
        }
        function scrollThumb() {
            if (__enabled == true) {
                lastY = thumb._ymouse;
                onMouseMove = dragThumb;
            }
        }
        function dragThumb() {
            var _local2 = _ymouse - lastY;
            if (_local2 < 13) {
                _local2 = 13;
            }
            var _local3 = (__size - 13) - thumb._height;
            if (_local2 > _local3) {
                _local2 = _local3;
            }
            thumb._y = _local2;
            var _local5 = __size - trackDecriment;
            var _local4 = getValue(thumb._y) + 1;
            setPosThumb(_local4);
            isScrolling = true;
        }
        var __size = 0;
        var minPos = 0;
        var maxPos = 0;
        var pageSize = 0;
        var trackDecriment = 26;
        var _scrollPosition = 0;
    }
