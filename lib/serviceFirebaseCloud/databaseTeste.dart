import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addEmployeeDetails(
      Map<String, dynamic> employeeInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('Employee')
        .doc(id)
        .set(employeeInfoMap);
  }

  //Função para ler os dados do Firebase
  Future<Stream<QuerySnapshot>> getEmmployeeDetails()async{
    return await FirebaseFirestore.instance.collection('Employee').snapshots();
  }

  //Função para editar dados do funcionario
  Future updateEmployeeDetail(String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance.collection('Employee').doc(id).update(updateInfo);
  }

  //Função para deletar funcionario
  Future deleteEmployeeDetail(String id) async {
    return await FirebaseFirestore.instance.collection('Employee').doc(id).delete();
  }
}
