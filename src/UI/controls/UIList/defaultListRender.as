    class UI.controls.UIList.defaultListRender extends UI.core.movieclip
    {
        var createEmptyMovieClip, createTextField, label_txt, List, __data, __width, __height, hitSpace, drawRect;
        function defaultListRender () {
            super();
            this.createEmptyMovieClip("hitSpace", 2);
            this.createTextField("label_txt", 0, 0, 1, 100, 20);
            label_txt.selectable = false;
            var _local3 = new TextFormat ();
            _local3.font = "Verdana";
            _local3.size = 10;
            label_txt.setNewTextFormat(_local3);
        }
        function set label(t) {
            label_txt.text = t;
            List.onChangeWidth(this, getWidth());
            //return (label);
        }
        function get label() {
            return (label_txt.text);
        }
        function getWidth() {
            return (label_txt.textWidth + 8);
        }
        function getBestHeight() {
            return (20);
        }
        function set data(d) {
            __data = d;
            //return (data);
        }
        function get data() {
            return (__data);
        }
        function setSize(width, height) {
            __width = width;
            __height = height;
            label_txt._width = width;
            label_txt._height = height;
            label_txt._y = 2;
            hitSpace.clear();
            drawRect(hitSpace, 0, 0, width, height, 16777215, 0);
        }
    }
