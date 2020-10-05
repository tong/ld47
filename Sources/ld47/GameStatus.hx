package ld47;

class GameStatus {
    public var isFinished(default,null):Bool=false;
    public var winner(default,null):Player;
    public var hasWinner(default,null):Bool;
    public var others(default,null):Array<Player> = new Array<Player>();    

    public function new (finished:Bool, winner:Player, others:Array<Player> ){
        this.isFinished = finished;
        this.winner = winner;
        hasWinner = winner != null;
        this.others = others;
    }

    public static function running(players: Array<Player>){
        return new GameStatus(false,null, players);
    }

    public static function finished(winner:Player, others:Array<Player>){
        return new GameStatus(true,winner,others);
    }

    public static function draw(players: Array<Player>){
        return new GameStatus(true,null, players);
    }
}