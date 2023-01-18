//Created by Action Script Viewer - http://www.buraks.com/asv
    class UI.core.tabManager extends UI.core.movieclip
    {
        var ownerRefs, tabStore, tID, ctHolder, fm, ctOrder, nextRef, tcInt;
        function tabManager (owner) {
            super();
            ownerRefs = new Object ();
            tabStore = new Array ();
            tID = 0;
            _global.tabs = this;
            ctHolder = new Object ();
            fm = owner;
            Selection.addListener(this);
        }
        function findMatch(o1, o2) {
            var _local3 = o1.split(",");
            o2 = "," + o2;
            var _local5 = "";
            var _local1 = _local3.length;
            while (_local1 > 0) {
                var _local2 = _local3[_local1 - 1];
                if (o2.indexOf(("," + _local2) + ",") != -1) {
                    _local5 = _local2;
                }
                _local1--;
            }
        }
        function setOrder(o) {
            var lastSel = eval (Selection.getFocus());
            var oldCT = ctOrder;
            ctOrder = o + ",";
            var i = 0;
            while (i < tabStore.length) {
                tabStore[i].tabEnabled = false;
                i++;
            }
            var orders = ctOrder.split(",");
            orders.pop();
            var holdMC;
            var f = findMatch(oldCT, ctOrder);
            if (f == "") {
                f = orders[0];
            }
            nextRef = new Array ();
            var j = 0;
            while (j < orders.length) {
                var id = orders[j];
                var ct = ctHolder[id];
                var tempOrder = new Array ();
                for (var h in ct) {
                    if (h != "length") {
                        var mc = ct[h].tabOwner();
                        mc.tabEnabled = true;
                        if ((id == f) && (holdMC == undefined)) {
                            holdMC = mc;
                        }
                        tempOrder.push({index:mc.tabIndex, mc:mc});
                    }
                }
                tempOrder.sortOn("index");
                nextRef = nextRef.concat(tempOrder);
                j++;
            }
            var d = 0;
            while (d < nextRef.length) {
                nextRef[d].mc.___tnid = d;
                d++;
            }
            if (ownerRefs[f]) {
                holdMC = ownerRefs[f];
            }
            Selection.setFocus(holdMC);
            _root.fcm_focusrect.clear();
        }
        function onSetFocus(old, newf) {
            if (newf.__tct) {
                ownerRefs[newf.__tct] = newf;
            }
        }
        function registerContext(n) {
            ctHolder[n] = new Object ();
            ctHolder[n].length = 1;
            ctHolder[n].i = ctCount;
            ctCount++;
        }
        function registerTab(p_ct, mc, i) {
            var _local2 = ctHolder[p_ct];
            _local2[i] = mc;
            _local2.length++;
            mc.__tct = p_ct;
            mc.__id = i;
            tID++;
            var _local3 = mc.tabOwner();
            _local3.tabIndex = (_local2.i * 150) + i;
            _local3.__tct = p_ct;
            tabStore.push(_local3);
        }
        function nextID(ct) {
            return (ctHolder[ct].length);
        }
        function onFocusMC(mc) {
            if (mc.tabOwner().__tct) {
                ownerRefs[mc.tabOwner().__tct] = mc.tabOwner();
            }
        }
        function focusCheat(mc) {
            tcInt = setInterval(100, workTabCheat, this, mc);
        }
        function workTabCheat(o, mc) {
            clearInterval(o.tcInt);
            Selection.setFocus(mc);
        }
        var ctIndex = -1;
        var ctCount = 0;
    }
