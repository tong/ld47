package superposition;

import superposition.Electron.Core;
import superposition.Player.Score;

typedef GameData = {
	players : Array<PlayerData>,
	map : MapData,
}

typedef PlayerData = {
	name : String,
	enabled : Bool,
	color : Color,
}

typedef MapData = {
	name: String,
	atoms : Array<AtomData>,
}

typedef AtomData = {
	slots : Int,
	loc : { x : Float, y : Float },
	?player : Null<Int>,
	?electrons : Array<Core>,
}

class Game extends Trait {

	//static inline var CAM_Z = 265;
	static inline var CAM_Z = 24.5;

	public static var active(default,null) : Game;

	public var data(default,null) : GameData;
	public var time(default,null) : Float;
	public var paused(default,null) = false;
	public var finished(default,null) = false;

	public var size(default,null) = new Vec2( 19.2, 10.8 );
	public var players(default, null):Array<Player>;
	public var atoms(default, null):Array<Atom>;
	public var flyingElectrons(default,null):Array<Electron>;

	var timeStart:Null<Float>;
	var timePauseStart:Null<Float>;
	var minAtomDistance = 3;
	var atomContainer:Object;
	var soundAmbient : AudioChannel;

	public function new() {
		super();
		Log.info('Game');
		Game.active = this;
		notifyOnInit( () -> {
			atomContainer = Scene.active.getEmpty('AtomContainer');
			notifyOnRemove( () -> {
				if( soundAmbient != null ) soundAmbient.stop();
				for( p in players ) p.dispose();
				for( a in atoms ) a.dispose();
			});
			notifyOnUpdate( update );
			//notifyOnRender2D( render2D );
		});
	}

	public function create( ?data : GameData, ?onReady : Void->Void ) {
		if( data == null && this.data == null ) {
			trace('Cannot start game, no data');
			return;
		}
		if( data != null ) this.data = data;
		players = [];
		atoms = [];
		flyingElectrons = [];
		trace( 'Spawning ${ this.data.players.length} players' );
		spawnPlayers( this.data.players, () -> {
			trace( 'Spawning map: ${ this.data.map.name}' );
			spawnMap( this.data.map, () -> {
				if( onReady != null ) onReady() else start();
			});
		});
	}

	public function start() {

		trace('Starting game' );
		
		paused = finished = false;
		timeStart = Time.time();
		time = 0;

		//var cam = Scene.active.camera;
		////cam.transform.loc.z = CAM_Z;
		////cam.transform.buildMatrix();

		//SoundEffect.play( 'game_start', false, true, 0.07 );
		
		Postprocess.chromatic_aberration_uniforms[0] = 16.0;
		var values = { chromatic : Postprocess.chromatic_aberration_uniforms[0] };
		Tween.to({
			target: values,
			delay: 0.2,
			duration: 1.0,
			props: { chromatic: 0.03 },
			ease: QuartOut,
			tick: () -> {
				Postprocess.chromatic_aberration_uniforms[0] = values.chromatic;
			},
			done: () -> {
				Postprocess.chromatic_aberration_uniforms[0] = 0.03;
			}
		});
	}

	public function restart() {
		for( p in players ) p.dispose();
	}

	public function pause() {
		if( !paused  && !finished ) {
			trace('Pause game');
			paused = true;
			timePauseStart = Time.time();
		}
	}
	
	public function resume() {
		if( paused && !finished ) {
			trace('Resume game');
			paused = false;
			timeStart += Time.time() - timePauseStart;
			timePauseStart = null;
		}
	}

	public function finish( ?winner : Player ) {
		if( finished ) return;
		trace('Finish game');
		finished = true;
		var menu = new ResultMenu( winner );
		object.addTrait( menu );
		//Scene.active.root.addTrait( menu );
		//atomContainer.addTrait( menu );
		
		//Scene.setActive( 'Mainmenu' );

		/*
		if( status == null ) {
			var winner = status.winner;
			var others = status.others;
			if(status.hasWinner){
				trace('the game is finished, winner is player ${winner.index} with a score of ${winner.score}' );						
			} else {
				trace('the game ended in a draw');
			}
			var menu = new ResultMenu( status );
			Scene.active.root.addTrait( menu );
		}
		*/

		/*
		//trace('status others:' + status.others.length );
		SoundEffect.play( 'game_finish', false, true, 0.1, s -> {
			//Tween.to( { target: s, props: { volume: 0.5 }, delay: 0.1, duration: 0.8 } );
		});
		finished = true;
		var winner = status.winner;
		var others = status.others;
		if (status.hasWinner){
			var score = winner.score;
			trace('the game is finished, winner is player ${winner.index} with a score of $score' );						
		} else {
			trace('the game ended in a draw');
		}
		//if( soundAmbient != null ) soundAmbient.stop();
		//for( a in atoms ) a.destroy();
//		Event.send( GameEvent.End );
		//Scene.setActive( 'Result' );
		//var menu = new ResultMenu( status );
		//Scene.active.root.addTrait( menu );
		*/
	}

	function spawnPlayers( playerData : Array<PlayerData>, cb : Void->Void ) {
		function spawnNext() {
			Scene.active.spawnObject( 'Player', null, obj -> {
				var p = new Player( players.length );
				players.push( p );
				obj.addTrait( p );
				if( players.length == playerData.length ) cb() else spawnNext();
			});
		}
		spawnNext();
	}

	function spawnMap( mapData : MapData, onReady : Void->Void ) {
		function spawnNext() {
			var dat = mapData.atoms[atoms.length];
			spawnAtom( new Vec2( dat.loc.x, dat.loc.y ), dat.slots, a -> {
				if( dat.player != null ) {
					//if( dat.electrons == null || dat.electrons.length == 0 ) {
					a.setPlayer(players[dat.player]);
					var electrons = dat.electrons;
					if( dat.electrons == null || dat.electrons.length == 0 ) electrons = [None];
					a.spawnElectrons( electrons , spawned -> {						
						if (atoms.length == mapData.atoms.length ) onReady() else spawnNext();
					});
				} else {
					if (atoms.length == mapData.atoms.length ) onReady() else spawnNext();
				}
			});
		}
		spawnNext();
	}

	function spawnAtom( pos : Vec2, numSlots : Int, cb : Atom->Void ) {
		Scene.active.spawnObject('Atom', atomContainer, obj -> {
			obj.visible = true;
			var atom = new Atom( atoms.length, numSlots );
			atom.notifyOnInit( ()->{
				cb(atom);
			});
			obj.addTrait(atom);
			atom.setPostion( new Vec2( pos.x*size.x/2, pos.y*size.y/2 ) );
			atoms.push(atom);			
		});
	}

	function update() {

		if( time == null || paused || finished ) return;
		time = Time.time() - timeStart;

		for( p in players ) p.update();
		for( a in atoms ) a.update();

		/* var status = getGameStatus();
		if( status.isFinished ) {
			finish( status );
			return;
		} */

		//trace("----------------------------------------------------");

		var ownedAtoms = atoms.filter( a -> return a.player != null );
		if( ownedAtoms.length == 0 && flyingElectrons.length == 0 ) {
			trace('no electrons left -> everybody looses');
			// game draw
			finish();
			return;
		} else {
			var winners = players.slice(0);
			var losers = new Array<Player>();
			for( i in 0...players.length ) {
				var player = players[i];
				//if( !player.enabled ) continue;
				var playerAtomsOwned = atoms.filter( a -> return a.player == player );
				var playerElectronsFlying = flyingElectrons.filter( e -> return e.player == player );
				//trace( player.index+': PlayerAtoms: '+playerAtomsOwned.length+', flying: '+playerElectronsFlying.length );
				if( playerAtomsOwned.length == 0 && playerElectronsFlying.length == 0 ) {
					//trace("player "+ player.index +" has no electrons left -> he looses	");
					winners.splice( i, 1 );
					losers.push(player);
					//finish();
					//return;
				}
			}
			/*
			if( losers.length > 0 ) {
				finish();
			}
			*/
			if( winners.length == 1 ) {
				finish( winners[0] );
			}
		}

		var newFlyingElectrons = new Array<Electron>();
		for (electron in flyingElectrons){	
			//trace('check flying electron from player ' + electron.player.index);
			var locElectron = new Vec4(electron.object.transform.worldx(), electron.object.transform.worldy());
			var radiusElectron = electron.mesh.transform.dim.x/2;							
			var electronOK = true;
			
			electron.update();

			for (atom in atoms){
				var distance = atom.object.transform.loc.distanceTo(locElectron);
				var radiusAtom = atom.mesh.transform.dim.x/2;
				//trace('test atom in a distance of '+ distance + ' with radius of ' + radiusAtom + ' and in e-radius of ' + radiusElectron );
				if (distance < radiusAtom+radiusElectron) {		
					//the electron hits an atom				
					trace('electron from player ${electron.player.index} hit an atom');
					electronOK = false;						
					object.removeChild(electron.object);
					electron.object.remove();
					electron.player.score.add( Score.hit );
					atom.hit(electron);	
				} else if (distance < radiusAtom*4 && 
							atom.player != electron.player &&
							atom.electrons.length>0){
					trace('electron from player ${electron.player.index} is in outer area of an atom, lets check electrons');

					for (targetElectron in atom.electrons){
						var locTarget = new Vec4(targetElectron.object.transform.worldx(), targetElectron.object.transform.worldy());
						var distElectron = locTarget.distanceTo(locElectron);
						if (distElectron < radiusElectron*2){
							//the electron hits an enemy electron attached to an atom
							trace('electron from player ${electron.player.index} hit an enemy electron orbiting an atom' );
							electron.player.score.add( Score.destroyed );
							electronOK = false;								
							object.removeChild(electron.object);
							electron.object.remove();
							break;
						}								
					}						
				}
				if(!electronOK) break;
			}
			if (size.x/2 < Math.abs(locElectron.x) || 
				size.y/2 < Math.abs(locElectron.y)){
					//the electron leaves the game area
					electronOK=false;
					//object.removeChild(electron.object);
					//electron.object.remove();
					electron.dispose();	
					//SoundEffect.play( 'electron_death', 0.1 );
			}
			if (electronOK) {
				newFlyingElectrons.push(electron);
			}
		}
		flyingElectrons = newFlyingElectrons;
	}

	/* function render2D(g:kha.graphics2.Graphics) {
		if( finished ) {

		}
	} */

	/*
	function getGameStatus():GameStatus{
		//trace('getGameStatus of ' + players.length + ' players');
		if (atoms.filter(atom -> atom.electrons.length > 0).length == 0 && 
			flyingElectrons.length == 0){
			//no electrons left -> everybody looses
			return GameStatus.draw(players);
		}
		else{
			var winners = players.slice(0);
			var loosers = new Array<Player>();
			for (player in players){
				if (atoms.filter(atom -> atom.player != null && 
										 atom.player == player &&
										 atom.electrons.length > 0).length == 0 &&
					flyingElectrons.filter(electron -> electron.player == player).length ==0){
					//player has no electrons left -> he looses					
					winners.splice(winners.indexOf(player),1);
					loosers.push(player);
				}					
			}
			//trace('sorted into ' + winners.length + ' and ' + loosers.length);
			if(winners.length == 1){
				return GameStatus.finished(winners[0],loosers);
			} else {
				return GameStatus.running(winners);
			}
		}
	}
	*/
}
