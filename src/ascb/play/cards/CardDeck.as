import ascb.play.cards.Card;
import ascb.util.ArrayUtils;

class ascb.play.cards.CardDeck extends Array {

  function CardDeck() {
    reset();
  }

  function reset():Void {
    for(var i:Number = 0; i < length; i++) {
      shift();
    }

    // Create a local array that contains the names of the four suits.
    var aSuits:Array = ["Hearts", "Diamonds", "Spades", "Clubs"];

    // Specify the names of the cards for stuffing into the cards array later.
    var aCardNames:Array = ["2", "3", "4", "5", "6", "7", "8", "9", "10",
                            "J", "Q", "K", "A"];

    // Create a 52-card array. Each element is an object that contains
    // properties for: the card's integer value (for sorting purposes), card name, 
    // suit name, and display name. The display name combines the card's name
    // and suit in a single string for display to the user.
    for (var i:Number = 0; i < aSuits.length; i++) {
      // For each suit, add thirteen cards
      for (var j:Number = 0; j < 13; j++) {
        push(new Card(j, aCardNames[j], aSuits[i]));
      }
    }
  }

  public function shuffle():Void {
    var aShuffled:Array = ArrayUtils.randomize(this);
    for(var i:Number = 0; i < aShuffled.length; i++) {
      this[i] = aShuffled[i];
    }
  }

}