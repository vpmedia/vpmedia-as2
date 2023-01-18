import ascb.util.NumberUtils;
import ascb.play.cards.*;

class ascb.play.Cards {


  private var _cdkDeck:CardDeck;

  // The Cards constructor creates a deck of cards.
  function Cards() {
    _cdkDeck = new CardDeck();
  }

  // The deal() method needs to know the number of players in the game 
  // and the number of cards to deal per player. If the cardsPerPlayer 
  // parameter is undefined, then it deals all the cards.
  public function deal(nPlayers:Number, nPerPlayer:Number):Array {

    _cdkDeck.reset();
    _cdkDeck.shuffle();

    // Create an array, players, that holds the cards dealt to each player.
    var aHands:Array = new Array();

    // If a cardsPerPlayer value was passed in, deal that number of cards.
    // Otherwise, divide the number of cards (52) by the number of players.
    var nCardsEach:Number = (nPerPlayer == undefined) ? Math.floor(_cdkDeck.length / nPlayers) : nPerPlayer;

    // Deal out the specified number of cards to each player.
    for (var i = 0; i < nPlayers; i++) {

      aHands.push(new CardHand(_cdkDeck));

      // Deal a random card to each player. Remove that card from the 
      // tempCards array so that it cannot be dealt again.
      for (var j:Number = 0; j < nCardsEach; j++) {
        aHands[i].push(_cdkDeck.shift());
      }

      // Use Cards.orderHand() to sort a player's hand, and use setHand() 
      // to assign it to the card player object.
      aHands[i].orderHand();
    }

    // Return the players array.
    return aHands;
  }


}