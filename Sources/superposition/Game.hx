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
	//?theme : String,
	atoms : Array<AtomData>,
}

typedef AtomData = {
	//?name: String, //TODO explicit atom name
	//?type: String, //TODO atom type
	slots : Int,
	?loc : { ?x : Null<Float> , ?y : Null<Float> , ?z : Null<Float> },
	//?rot: Float,
	?player : Null<Int>,
	?electrons : Array<Core>,
	//?atoms : Array<Atom> // sub atoms
}

class Game extends Trait {

	public static var active(default,null) : Game;

	public var data(default,null) : GameData;
	public var time(default,null) : Float;
	public var paused(default,null) = false;
	public var finished(default,null) = false;
	public var dim = new Vec3( 19.2, 10.8, 10 );

	public var players(default, null):Array<Player>;
	public var atoms(default, null):Array<Atom>;
	public var flyingElectrons(default,null):Array<Electron>;

	var timeStart:Null<Float>;
	var timePauseStart:Null<Float>;
	var minAtomDistance = 3;
	var atomContainer:Object;
	//var soundAmbient : AudioChannel;

	public function new() {
		super();
		Log.info('Game');
		Game.active = this;
		notifyOnInit( () -> {
			atomContainer = Scene.active.getEmpty('AtomContainer');
			notifyOnRemove( () -> {
				//if( soundAmbient != null ) soundAmbient.stop();
				for( p in players ) p.dispose();
				for( a in atoms ) a.dispose();
			});
			notifyOnUpdate( update );
			//notifyOnRender2D( render2D );
		});
	}

	public function create( ?data : GameData, ?onReady : Void->Void ) {
		trace( 'Game create' );
		if( data == null && this.data == null ) {
			trace('Cannot start game, no data');
			return;
		}
		if( data != null ) this.data = data;
		players = [];
		atoms = [];
		flyingElectrons = [];
		var ts = Time.realTime ();

		//trace("Loading materials");
		//for( i in 1...5 ) DataTools.loadMaterial('Game','Player$i');
		//ElectronCoreNone

		trace( 'Spawning ${ this.data.players.length} players' );
		spawnPlayers( this.data.players, () -> {
			trace( 'Spawning map: ${ this.data.map.name}' );
			spawnMap( this.data.map, () -> {
				//trace('Loading ambient sound');
				//SoundEffect.play( 'atom_ambient_'+(1+Std.int(Math.random()*8)), true, true, 0.9, a -> {
				/* SoundEffect.loadSet( 'atom_ambient_', 8, sounds -> {
					trace(sounds);
					trace(Time.realTime ()-ts);
				}); */
				//SoundEffect.play( 'game_ambient_'+(1+Std.int(Math.random()*3)), true, true, 1.0, a -> {
				/* SoundEffect.play( 'game_ambient_1', true, true, 1.0, a -> {
					trace(Time.realTime ()-ts);
					soundAmbient = a;
					soundAmbient.pause();
					if( onReady != null ) onReady() else start();
				}); */
				if( onReady != null ) onReady() else start();
			});
		});
		/*
		trace('Preloading electron core meshes');
		//for( m in Data.cachedMeshes.keys() ) trace(m);
		var numMeshesLoaded = 0;
		var meshesToLoad = EnumTools.getConstructors(Electron.Core);
		for( name in meshesToLoad ) {
			var meshName = 'ElectronCore'+name;
			Data.getMesh( 'mesh_'+meshName, meshName, m -> {
				if( ++numMeshesLoaded == meshesToLoad.length ) {
					trace( 'Spawning ${ this.data.players.length} players' );
					spawnPlayers( this.data.players, () -> {
						trace( 'Spawning map: ${ this.data.map.name}' );
						spawnMap( this.data.map, () -> {
							//trace('Loading ambient sound');
							//SoundEffect.play( 'atom_ambient_'+(1+Std.int(Math.random()*8)), true, true, 0.9, a -> {
							/* SoundEffect.loadSet( 'atom_ambient_', 8, sounds -> {
								trace(sounds);
								trace(Time.realTime ()-ts);
							}); */
							//SoundEffect.play( 'game_ambient_'+(1+Std.int(Math.random()*3)), true, true, 1.0, a -> {
							/* SoundEffect.play( 'game_ambient_1', true, true, 1.0, a -> {
								trace(Time.realTime ()-ts);
								soundAmbient = a;
								soundAmbient.pause();
								if( onReady != null ) onReady() else start();
							}); * /
							if( onReady != null ) onReady() else start();
						});
					});
				}
			});
		}
		*/
	}

	public function start() {

		trace('Starting game' );
		
		paused = finished = false;
		timeStart = Time.time();
		time = 0;

		//var cam = Scene.active.camera;
		////cam.transform.loc.z = CAM_Z;
		////cam.transform.buildMatrix();

		//soundAmbient.fadeIn( 1.0, 1.0 ).play();
		
		var values = { chromatic : Postprocess.chromatic_aberration_uniforms[0] = 12.0 };
		Tween.to({
			target: values,
			//delay: 0.2,
			duration: 0.7,
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
			spawnAtom( dat.loc, dat.slots, a -> {
				if( dat.player != null ) {
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

	function spawnAtom( ?loc : { ?x : Null<Float> , ?y : Null<Float> , ?z : Null<Float> }, numSlots : Int, cb : Atom->Void ) {
		Scene.active.spawnObject('Atom', atomContainer, obj -> {
			obj.name = 'Atom'+atoms.length;
			obj.visible = true;
			var atom = new Atom( atoms.length, numSlots );
			atom.notifyOnInit( ()->{
				cb(atom);
			});
			obj.addTrait( atom );
			var v = new Vec3();
			if( loc != null ) {
				if( loc.x != null ) v.x = loc.x*dim.x/2;
				if( loc.y != null ) v.y = loc.y*dim.y/2;
				if( loc.z != null ) v.z = loc.z*dim.z/2;
			}
			atom.setPostion(v);
			atoms.push(atom);			
		});
	}

	function update() {

		if( time == null || paused || finished ) return;
		time = Time.time() - timeStart;

		for( p in players ) p.update();
		for( a in atoms ) a.update();

		for( electron in flyingElectrons ) {
			if( dim.x/2 < Math.abs( electron.object.transform.worldx() ) || dim.y/2 < Math.abs( electron.object.transform.worldy() ) ) {
				trace("electron has left the world");
				electron.object.remove();
				flyingElectrons.remove( electron );
				return;
			}
		}

		/* var ownedAtoms = atoms.filter( a -> return a.electrons.length > 0 );
		if( ownedAtoms.length == 0 ) {
			if( flyingElectrons.length == 0 ) {
				finish();
				return;
			}
		}
		*/

		//var ownedAtoms = atoms.filter( a -> return a.player != null );
		var ownedAtoms = atoms.filter( a -> return a.electrons.length > 0 );
		if( ownedAtoms.length == 0 && flyingElectrons.length == 0 ) {
			trace('no electrons left -> everybody loses');
			finish(); // game draw
			return;
		} else {
			var winners = players.slice(0);
			var losers = new Array<Player>();
			for( i in 0...players.length ) {
				var player = players[i];
				var playerAtomsOwned = atoms.filter( a -> return a.player == player );
				var playerElectronsFlying = flyingElectrons.filter( e -> return e.player == player );
				//trace( player.index+': PlayerAtoms: '+playerAtomsOwned.length+', flying: '+playerElectronsFlying.length );
				if( playerAtomsOwned.length == 0 && playerElectronsFlying.length == 0 ) {
					//trace("player "+ player.index +" has no electrons left -> he loses	");
					winners.splice( i, 1 );
					losers.push(player);
					//finish();
					//return;
				}
			}
			if( winners.length == 1 ) {
				finish( winners[0] );
				return;
			}
		}
		
		/*
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
			if (dim.x/2 < Math.abs(locElectron.x) || 
				dim.y/2 < Math.abs(locElectron.y)){
					//the electron leaves the game area
					electronOK=false;
					electron.dispose();	
					//SoundEffect.play( 'electron_death', 0.1 );
			}
			if (electronOK) {
				newFlyingElectrons.push(electron);
			}
		}
		flyingElectrons = newFlyingElectrons;
		*/
	}

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
