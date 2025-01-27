// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:convert';

import 'package:app_ppmob/src/data/dao/foto_dao.dart';
import 'package:app_ppmob/src/model/foto.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:app_ppmob/src/shared/util/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:image/image.dart' as img;


class CameraWidget extends StatefulWidget {
  int? idFiscalizacao;
  String? descricao;

  CameraWidget({
    super.key,
    this.idFiscalizacao,
    this.descricao,
  });

  @override
  State<CameraWidget> createState() => CameraWidgetState();
}

class CameraWidgetState extends State<CameraWidget> {
  String? _base64Image;
  final int maxImageSize = 1;

  @override
  void initState() {
    super.initState();
  }

  Widget btnIconCamera(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: GestureDetector(
        onTap: () async {
          _showPicker(context, ImageSource.camera);
        },
        child: CircleAvatar(
          radius: 13,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: const Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget btnFloatCamera(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: FloatingActionButton(
        heroTag: 'btnCamera',
        tooltip: 'Abrir Câmera',
        mini: false,
        splashColor: Theme.of(context).colorScheme.secondary,
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: () async {
          _showPicker(context, ImageSource.camera);
        },
        child: const FaIcon(
          FontAwesomeIcons.camera,
          // size: 50,
          color: Color(0xFF002358),
        ),
      ),
    );
  }

  Widget btnIconButton(BuildContext context) {
    return IconButton(
      tooltip: 'Abrir Câmera',
      splashColor: Theme.of(context).colorScheme.secondary,
      color: Theme.of(context).colorScheme.primary,
      iconSize: 30.0,
      icon: const FaIcon(
        FontAwesomeIcons.camera,
        color: Color(0xFF002358),
      ),
      onPressed: () async {
        _showPicker(context, ImageSource.camera);
      },
    );
  }

Future<void> _showPicker(BuildContext context, ImageSource source) async {
  final ImagePicker picker = ImagePicker();
  final XFile? imagemSelecionada = await picker.pickImage(source: source);

  if (imagemSelecionada != null) {
    Uint8List originalBytes = await imagemSelecionada.readAsBytes();
    img.Image? image = img.decodeImage(originalBytes);
    if (image != null) {
      img.Image resizedImage = img.copyResize(image, width: 800); 
      List<int> compressedList = img.encodeJpg(resizedImage, quality: 30); 
      Uint8List compressedBytes = Uint8List.fromList(compressedList);
      int fileSizeInBytes = compressedBytes.length;
      int fileSizeInMegaBytes = fileSizeInBytes ~/ (1024 * 1024);
      if (fileSizeInMegaBytes <= maxImageSize) {
        String base64Imagem = base64Encode(compressedBytes);
        setState(() {
          _base64Image = base64Imagem;
        });
        try {
          Foto foto = Foto(
            idFiscalizacao: widget.idFiscalizacao,
            nome: Utility.getNamePhoto(int.parse(widget.idFiscalizacao.toString())),
            descricao: widget.descricao,
            dataFoto: Utility.getDateTime().toString(),
            sincronizado: EstadoEntidade.naoSincronizado,
            imagem: _base64Image,
          );
          FotoDao().insert(foto);
        } catch (e) {
          if (kDebugMode) {
            print('_showPicker: $e');
          }
        }
      } else {
        Utility.snackbar(context, 'A imagem excede o tamanho permitido. Selecione uma com resolução máxima de: $maxImageSize MB.');
      }
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return btnIconButton(context);
  }
}
