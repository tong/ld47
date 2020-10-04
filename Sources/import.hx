
import haxe.Json;
import haxe.io.Bytes;

#if macro
import sys.FileSystem;
import sys.io.File;
#else

#if kha_html5
import js.lib.Promise;
#end

import armory.system.Event;
// import armory.trait.internal.CanvasScript;
// import armory.trait.physics.PhysicsWorld;
// import armory.trait.physics.RigidBody;

import iron.Scene;
import iron.Trait;
import iron.data.Data;
import iron.data.MaterialData;
import iron.math.Mat4;
import iron.math.Quat;
import iron.math.Vec2;
import iron.math.Vec3;
import iron.math.Vec4;
import iron.object.BoneAnimation;
import iron.object.CameraObject;
import iron.object.LightObject;
import iron.object.MeshObject;
import iron.object.Object;
import iron.object.SpeakerObject;
import iron.object.Transform;
import iron.object.Uniforms;
import iron.system.Audio;
import iron.system.Input;
import iron.system.Time;
import iron.system.Tween;

import kha.Assets;
import kha.Color;
import kha.Blob;
import kha.FastFloat;
import kha.Font;
import kha.System;
import kha.audio1.AudioChannel;
import kha.input.KeyCode;
import kha.math.FastMatrix3;

//import tron.Input;
import tron.Log;
import tron.DataTools;
import tron.MathTools;
import tron.MathTools.PI;
import tron.MathTools.PI2;
import tron.MathTools.HALF_PI;
import tron.Music;
import tron.PhysicsTools;
import tron.SpawnTools;
import tron.sys.Path;

using StringTools;
using tron.PhysicsTools;

#end // !macro
