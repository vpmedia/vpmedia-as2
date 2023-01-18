import ascb.play.Cards;
import ascb.play.cards.*;
import ascb.util.NumberUtils;

class ascb.play.cards.CardHand extends Array {

  private var _cdkDeck:CardDeck;

  // When a new card player is created by way of its constructor, pass it
  // a reference to the card deck, and give it a unique player ID.
  function CardHand(cdkDeck:CardDeck) {
    _cdkDeck = cdkDeck;
  }

  public function discard():Array {
    var aCards:Array = new Array();
    for(var i:Number = 0; i < arguments.length; i++) {
      aCards.push(this[arguments[i]]);
      _cdkDeck.push(this[arguments[i]]);
    }
    for(var i:Number = 0; i < arguments.length; i++) {
      splice(arguments[i], 1);
    }
    return aCards;
  }

  public function draw(nDraw:Number):Void {
    
    nDraw = (nDraw == undefined) ? 1 : nDraw;

    // Add the specified number of cards to the hand.
    for (var i = 0; i < nDraw; i++) {
      push(_cdkDeck.shift());
    }

    orderHand();
  }

  public function orderHand():Void {
    sort(sorter);
  }

  // Used by sort() in the orderHand() method to sort the cards by suit and rank.
  private function sorter(crdA:Card, crdB:Card):Number {
    if (crdA.suit > crdB.suit) {
      return 1;
    } else if (crdA.suit < crdB.suit) {
      return -1;
    } else {
      return (Number(crdA.value) > Number(crdB.value)) ? 1 : 0;
    }
  }

}