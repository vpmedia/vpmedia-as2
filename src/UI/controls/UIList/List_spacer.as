    class UI.controls.UIList.List_spacer extends UI.core.events
    {
        var createEmptyMovieClip, UISpace, drawRect, hitSpace, __width, __height;
        function List_spacer () {
            super();
            this.createEmptyMovieClip("UISpace", 1);
        }
        function getBestHeight() {
            return (3);
        }
        function getWidth() {
            return (0);
        }
        function get type() {
            return ("spacer");
        }
        function setSize(width, height) {
            UISpace.clear();
            drawRect(UISpace, 0, 1, width, 1, 12961221, 100);
            hitSpace.clear();
            drawRect(hitSpace, 0, 0, width, height, 16777215, 0);
            hitSpace.onPress = function () {
            };
            hitSpace.useHandCursor = false;
            hitSpace._focusrect = false;
            hitSpace.tabChildren = false;
            hitSpace.tabEnabled = false;
            __width = width;
            __height = height;
        }
    }
