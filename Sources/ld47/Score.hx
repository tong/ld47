package ld47;

class Score {
	public var spawnedElectrons(default, default):Int = 0;
	public var shotsFired(default, default):Int = 0;
	public var shotsHitAtom(default, default):Int = 0;
	public var shotsDestroyedByEnemyElectron(default, default):Int = 0;
	public var ownershipsTaken(default, default):Int = 0;
    public var ownershipsLost(default, default):Int = 0;
    
	public function new(spawned:Int, fired:Int, hitAtom:Int, destroyed:Int, ownershipsTaken:Int, ownershipsLost:Int) {
		spawnedElectrons = spawned;
		shotsFired = fired;
		shotsHitAtom = hitAtom;
		shotsDestroyedByEnemyElectron = destroyed;
		this.ownershipsTaken = ownershipsTaken;
		this.ownershipsLost = ownershipsLost;
	}

	public function combine(s:Score):Score {
        return new Score(this.spawnedElectrons	+ s.spawnedElectrons, 
                        this.shotsFired	+ s.shotsFired, 
                        this.shotsHitAtom + s.shotsHitAtom,
                        this.shotsDestroyedByEnemyElectron	+ s.shotsDestroyedByEnemyElectron, 
                        this.ownershipsTaken + s.ownershipsTaken,
                        this.ownershipsLost	+ s.ownershipsLost);
    }
    
	public static var spawned = new Score(1, 0, 0, 0, 0, 0);
	public static var fired = new Score(0, 1, 0, 0, 0, 0);	
    public static var destroyed = new Score(0, 0, 0, 1, 0, 0);
    
	public static var taken = new Score(0, 0, 0, 0, 1, 0);
    public static var lost = new Score(0, 0, 0, 0, 0, 1);
    public static var hit = new Score(0, 0, 1, 0, 0, 0);

    public static var empty = new Score(0,0,0,0,0,0);
}
