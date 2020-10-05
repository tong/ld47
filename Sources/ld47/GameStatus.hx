package ld47;

class GameStatus {

    public final isFinished : Bool;
    public final winner : Player;
    public final hasWinner : Bool;
    public final others : Array<Player> = new Array<Player>();    

    function new (finished:Bool, winner:Player, others:Array<Player> ){
        this.isFinished = finished;
        this.winner = winner;
        hasWinner = winner != null;
        this.others = others;
    }

    public static inline function running(players: Array<Player>){
        return new GameStatus(false,null, players);
    }

    public static inline function finished(winner:Player, others:Array<Player>){
        return new GameStatus(true,winner,others);
    }

    public static inline function draw(players: Array<Player>){
        return new GameStatus(true,null, players);
    }
}