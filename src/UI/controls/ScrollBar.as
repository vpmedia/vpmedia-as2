    class UI.controls.ScrollBar extends UI.core.events
    {
        var attachMovie, __scroll, dispatchEvent, __size;
        function ScrollBar () {
            super();
            this.attachMovie("BasicScrollBar", "__scroll", 0);
            __scroll.addListener("scroll", onScroll, this);
        }
        function onKeyDown() {
            if (Key.isDown(40)) {
                if (direction != "Horizontal") {
                    __scroll.setPosThumb(scrollPosition + 1);
                }
            }
            if (Key.isDown(38)) {
                if (direction != "Horizontal") {
                    __scroll.setPosThumb(scrollPosition - 1);
                }
            }
            if (Key.isDown(39)) {
                if (direction == "Horizontal") {
                    __scroll.setPosThumb(scrollPosition + 1);
                }
            }
            if (Key.isDown(37)) {
                if (direction == "Horizontal") {
                    __scroll.setPosThumb(scrollPosition - 1);
                }
            }
        }
        function onScroll(data) {
            dispatchEvent("scroll", data);
        }
        function set enabled(e) {
            __scroll.enabled = e;
            //return (enabled);
        }
        function get max() {
            return (__scroll.max);
        }
        function get enabled() {
            return (__scroll.enabled);
        }
        function get width() {
            if (direction == "Horizontal") {
                return (__size);
            } else {
                return (13);
             }
        }
        function get isScrolling() {
            return (__scroll.isScrolling);
        }
        function get height() {
            if (direction == "Horizontal") {
                return (13);
            } else {
                return (__size);
             }
        }
        function set direction(d) {
            if (d == "Horizontal") {
                __scroll._rotation = -90;
            } else {
                __scroll._rotation = 0;
             }
            setSize(__size);
            //return (direction);
        }
        function get direction() {
            if (__scroll._rotation == -90) {
                return ("Horizontal");
            } else {
                return ("Vertical");
             }
        }
        function set scrollPosition(p) {
            __scroll.scrollPosition = p;
            //return (scrollPosition);
        }
        function get scrollPosition() {
            return (__scroll.scrollPosition);
        }
        function setScrollProperties(p1, p2, p3) {
            __scroll.setScrollProperties(p1, p2, p3);
        }
        function setSize(size) {
            __size = size;
            __scroll.setSize(size);
            if (direction == "Horizontal") {
                __scroll._y = __scroll._height;
            } else {
                __scroll._y = 0;
             }
        }
    }
