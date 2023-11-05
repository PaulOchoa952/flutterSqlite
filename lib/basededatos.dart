import 'package:dam_u3_estuditante_sqlite/estudiante.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB{
  static Future<Database> _abrirDB() async{
    return openDatabase(
        join(await getDatabasesPath(),'ejemplo1_13.db'),

        onCreate: (db,version){
          return db.execute("CREATE TABLE "
              "ESTUDIANTE(NUMCONTROL TEXT PRIMARY KEY,"
              "NOMBRE TEXT,CARRERA TEXT,"
              "SEMESTRE INTEGER)");
      },
      version: 1

    );

  }//fin crear tabla

  static Future<int> insertar(Estudiante e) async{
    Database db = await _abrirDB();
    return db.insert("ESTUDIANTE", e.toJSON(),
    conflictAlgorithm: ConflictAlgorithm.replace
    );

  }//fin insertar

  static Future<List<Estudiante>> mostrarTodos() async {
    Database db=await _abrirDB();
    List<Map<String,dynamic>> resultado=await db.query("ESTUDIANTE");
    return List.generate(resultado.length, (index){
      return Estudiante(numcontrol: resultado[index]['NUMCONTROL'],
          nombre: resultado[index]['NOMBRE'],
          carrera: resultado[index]['CARRERA'],
          semestre: resultado[index]['SEMESTRE']
      );
    });
  }

  static Future<int> actualizar(Estudiante e) async{
    Database db =await _abrirDB();
    return db.update("ESTUDIANTE", e.toJSON(),where: "NUMCONTROL=?",whereArgs: [e.numcontrol]);
    
  }
  static Future<int> eliminar(String numcontrol) async{
    Database db=await _abrirDB();
    return db.delete("ESTUDIANTE",where: "NUMCONTROL=?",whereArgs: [numcontrol]);
  }
  

}