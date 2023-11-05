import 'package:flutter/material.dart';
import 'estudiante.dart';
import 'basededatos.dart';
class App32 extends StatefulWidget {
  const App32({super.key});
  @override
  State<App32> createState() => _App32State();
}
class _App32State extends State<App32> {
  int _index = 0;
  String titulo = "App Estudiante";
  final numcontrol = TextEditingController();
  final nombre = TextEditingController();
  final carrera = TextEditingController();
  final semestre = TextEditingController();
  Estudiante estGlobal=Estudiante(numcontrol: "",
      nombre: "",
      carrera: "",
      semestre: 0);
  List<Estudiante> data = [];

  void actualizarLista() async{
    List<Estudiante> temp= await DB.mostrarTodos();
    setState(() {
      data=temp;
    });
  }

  void initState(){
    actualizarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("${titulo}"),
      ),
      body: dinamico(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Lista" ),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Agregar" ),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Editar" ),
        ],
        currentIndex: _index,
        onTap: (indice){
          setState(() {
            _index = indice;
          });
        },
      ),
    );
  }
  Widget dinamico(){
    switch(_index){
      case 1: return capturar();
      case 2: return editar();
    }
    return mostrarLista();
  }
  Widget mostrarLista(){
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, indice){
          return ListTile(
            title: Text("${data[indice].nombre}"),
            subtitle: Text("${data[indice].carrera}"),
            leading: CircleAvatar(child: Text("${data[indice].semestre}"), radius: 15,),
            trailing: IconButton(
              onPressed: (){
                DB.eliminar(data[indice].numcontrol).then((value){
                  setState(() {
                    titulo="Se elimino!";
                  });
                  actualizarLista();
                });
              },
              icon: Icon(Icons.delete),
            ),
            onTap: (){
              estGlobal=data[indice];
              setState(() {
                _index = 2;
              });
            },
          );
        });
  }
  Widget capturar(){
    return ListView(
      padding: EdgeInsets.all(40),
      children: [
        TextField(
          controller: numcontrol,
          decoration: InputDecoration(
              labelText: "Num Control:"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: nombre,
          decoration: InputDecoration(
              labelText: "Nombre:"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: carrera,
          decoration: InputDecoration(
              labelText: "Carrera:"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: semestre,
          decoration: InputDecoration(
              labelText: "Semestre:"
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: (){
                  var temporal=Estudiante(
                      numcontrol: numcontrol.text,
                      nombre: nombre.text,
                      carrera: carrera.text,
                      semestre: int.parse(semestre.text));

                      DB.insertar(temporal).then((value) {
                        setState(() {
                          titulo="SE INSERTO CON EXITO";
                        });
                      });
                      numcontrol.text="";
                      nombre.text="";
                      carrera.text="";
                      semestre.text="";
                      actualizarLista();
                },
                child: Text("Insertar")
            ),
            ElevatedButton(
                onPressed: (){
                  setState(() {
                    _index=0;
                  });
                },
                child: Text("Cancelar")
            ),
          ],
        )
      ],
    );
  }
  Widget editar(){
    nombre.text=estGlobal.nombre;
    carrera.text=estGlobal.carrera;
    semestre.text=estGlobal.semestre.toString();
    return ListView(
      padding: EdgeInsets.all(40),
      children: [
        Text("NUM CONTROL:${estGlobal.numcontrol} ", style: TextStyle(fontSize: 20),),
        SizedBox(height: 10,),
        TextField(
          controller: nombre,
          decoration: InputDecoration(
              labelText: "Nombre:"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: carrera,
          decoration: InputDecoration(
              labelText: "Carrera:"
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: semestre,
          decoration: InputDecoration(
              labelText: "Semestre:"
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: (){
                  estGlobal.nombre=nombre.text;
                  estGlobal.carrera=carrera.text;
                  estGlobal.semestre=int.parse(semestre.text);
                  DB.actualizar(estGlobal).then((value){
                    if(value>0){
                      setState(() {
                        titulo="SE ACTUALIZO";
                      });
                      nombre.text="";
                      carrera.text="";
                      semestre.text="";
                      estGlobal=Estudiante(numcontrol: "",
                          nombre: "",
                          carrera: "",
                          semestre: 0);
                    }
                  });
                },
                child: Text("Actualizar")
            ),
            ElevatedButton(
                onPressed: (){
                  setState(() {
                    //titulo="";
                    _index=0;
                  });
                  nombre.text="";
                  carrera.text="";
                  semestre.text="";
                  estGlobal=Estudiante(numcontrol: "",
                      nombre: "",
                      carrera: "",
                      semestre: 0);
                },
                child: Text("Cancelar")
            ),
          ],
        )
      ],
    );
  }
}
