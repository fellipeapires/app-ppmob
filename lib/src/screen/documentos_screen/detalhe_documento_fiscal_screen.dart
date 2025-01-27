// ignore_for_file: deprecated_member_use, must_be_immutable, unnecessary_to_list_in_spreads

import 'package:app_ppmob/src/model/item_documento_fiscal.dart';
import 'package:app_ppmob/src/screen/documentos_screen/documento_fiscal_screen.dart';
import 'package:app_ppmob/src/shared/constants/constants.dart';
import 'package:flutter/material.dart';

class DetalheDocumentoFiscalScreen extends StatefulWidget {
  String? numeroFiscal;
  String? dataSaida;
  String? valor;
  String? nomeExpedidor;
  String? cnpjExpedidor;
  String? enderecoExpedidor;
  String? municipioExpedidor;
  String? cnpjTransportadora;
  String? nomeTransportadora;
  String? municipioTransportadora;

  List<ItemDocumentoFiscal>? itens;

  DetalheDocumentoFiscalScreen({
    super.key,
    required this.numeroFiscal,
    required this.dataSaida,
    required this.valor,
    required this.nomeExpedidor,
    required this.cnpjExpedidor,
    required this.enderecoExpedidor,
    required this.municipioExpedidor,
    required this.cnpjTransportadora,
    required this.nomeTransportadora,
    required this.municipioTransportadora,
    required this.itens,
  });

  @override
  State<DetalheDocumentoFiscalScreen> createState() => _DetalheDocumentoFiscalScreenState();
}

class _DetalheDocumentoFiscalScreenState extends State<DetalheDocumentoFiscalScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget _documentoFiscal() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Documento Fiscal',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('Nº Fiscal: ${widget.numeroFiscal}'),
              Text('Data de Daída: ${widget.dataSaida}'),
              // Text('Valor Total: R\$ ${widget.valor}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _expedidor() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Expedidor:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Nome: ${widget.nomeExpedidor}'),
              Text('CNPJ: ${widget.cnpjExpedidor}'),
              Text('Endereço: ${widget.enderecoExpedidor}'),
              Text('Município: ${widget.municipioExpedidor}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _transportador() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 8.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Transportador:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Nome: ${widget.nomeTransportadora}'),
              Text('CNPJ: ${widget.cnpjTransportadora}'),
              Text('Município: ${widget.municipioTransportadora}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _listViewItens() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
            child: Text(
              'Produtos:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: widget.itens!.length,
              itemBuilder: (context, index) {
                final item = widget.itens![index];
                return ListTile(
                  title: Text(item.descricao ?? 'DESCRICAO NAO INFORMADA'), 
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Nº Onu: ${item.numeroOnu ?? ''}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Nº Risco: ${item.codRisco ?? ''}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Classe: ${item.classe ?? ''}'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Qtd: ${item.quantidade ?? ''}'),
                          Text('Valor Total: ${item.valorTotal ?? ''}'),
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _resumo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Valor Total Documento: R\$ ${widget.valor}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const DocumentoFiscalScreen()),
          (Route<dynamic> route) => true,
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: const Text(
            TitleScreen.detalheDocumentoFiscal,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C7ED6),
              height: 0.5,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _documentoFiscal(),
            const Divider(),
            _expedidor(),
            const Divider(),
            _transportador(),
            const Divider(),
            _listViewItens(),
            const Divider(),
          ],
        ),
        bottomNavigationBar: _resumo(),
      ),
    );
  }
}
