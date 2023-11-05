class Estudiante{
  String numcontrol;
  String nombre;
  String carrera;
  int semestre;

  Estudiante({
    required this.numcontrol,
    required this.nombre,
    required this.carrera,
    required this.semestre,
  });

  Map<String,dynamic> toJSON(){
    return{
      'numcontrol':numcontrol,
      'nombre':nombre,
      'carrera':carrera,
      'semestre':semestre,
    };

  }

}
