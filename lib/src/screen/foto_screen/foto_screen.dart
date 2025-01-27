// ignore_for_file: must_be_immutable, unnecessary_string_interpolations, avoid_print, sort_child_properties_last, use_build_context_synchronously

import 'dart:convert';

import 'package:app_ppmob/src/component/circular_progress.dart';
import 'package:app_ppmob/src/data/dao/foto_dao.dart';
import 'package:app_ppmob/src/model/foto.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FotoScreen extends StatefulWidget {
  int? idFiscalizacao;

  FotoScreen({
    super.key,
    this.idFiscalizacao,
  });

  @override
  FotoScreenState createState() => FotoScreenState();
}

class FotoScreenState extends State<FotoScreen> {
  List<Foto>? listaFoto = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initScreen();
  }

  initScreen() async {
    await findAllByIdFiscalizacao();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> findAllByIdFiscalizacao() async {
    try {
      var lista = await FotoDao().findAllByIdFiscalizacao(widget.idFiscalizacao!);
      setState(() {
        listaFoto = lista;
      });
    } catch (e) {
      if (kDebugMode) {
        print('$e: findAllByIdFiscalizacao');
      }
    }
  }

  Future<void> deleteById(int id) async {
    try {
      await FotoDao().deleteById(id);
    } catch (e) {
      if (kDebugMode) {
        print('deleteById: $e');
      }
    }
  }

  void _showDeleteConfirmation(BuildContext context, int idFoto) {
    final size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: const Center(
            child: Text(
              "Deseja Prosseguir?",
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          content: const Text(
            "A foto será excluída permanentemente!",
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                  child: SizedBox(
                    width: size.width * 0.30,
                    height: size.height * 0.06,
                    child: TextButton(
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.grey,
                        elevation: 15,
                        foregroundColor: Theme.of(context).colorScheme.error,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Colors.white54,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                  child: SizedBox(
                    width: size.width * 0.32,
                    height: size.height * 0.06,
                    child: TextButton(
                      child: const Text(
                        "Confirmar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.grey,
                        elevation: 15,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Colors.white54,
                            width: 1.0,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          await deleteById(idFoto);
                          await findAllByIdFiscalizacao();
                          Navigator.of(context).pop();
                          setState(() {
                            isLoading = false;
                          });
                        } catch (e) {
                          if (kDebugMode) {
                            print('confirmar remover transportadora: $e');
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget getTitle() {
    return const Text(
      TitleScreen.foto,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1C7ED6),
        height: 0.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: getTitle(),
        ),
        body: const Center(child: CircularProgressComponent()),
      );
    }
    if (listaFoto == null || listaFoto!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: getTitle(),
        ),
        body: const Center(
          child: Text(
            'Nenhuma foto registrada!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: getTitle(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2, // Número de colunas
          crossAxisSpacing: 8.0, // Espaço horizontal entre imagens
          mainAxisSpacing: 8.0, // Espaço vertical entre imagens
          childAspectRatio: 0.8, // Ajusta a proporção do item (altura/largura)
          children: List.generate(listaFoto!.length, (index) {
            final foto = listaFoto![index];
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.memory(
                          base64Decode(foto.imagem.toString()),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      foto.descricao ?? 'Sem descrição',
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () async {
                      _showDeleteConfirmation(context, foto.id!);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
