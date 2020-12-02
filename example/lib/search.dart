import 'package:flutter/material.dart';
import 'package:gpt_3_dart/gpt_3_dart.dart';

class SearchForm extends StatefulWidget {
  final OpenAI openAI;
  SearchForm(this.openAI);
  @override
  _SearchFormState createState() => _SearchFormState(openAI: openAI);
}

class _SearchFormState extends State<SearchForm> {
  OpenAI openAI;
  _SearchFormState({@required this.openAI});
  TextEditingController _queryController;
  static List<String> documentsList = [null];
  String response = "";

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController();
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(15.0),
                children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _queryController,
                decoration: InputDecoration(hintText: 'Enter your query'),
                validator: (v) {
                  if (v.trim().isEmpty) return 'Please enter something';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Add Documents',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              ..._getDocuments(),
              SizedBox(
                height: 40,
              ),
              MaterialButton(
                  onPressed: () async {
                    List search = await openAI.search(
                        documentsList, _queryController.text);
                    setState(() {
                      response = search.join(',');
                    });
                  },
                  child: Text('Search'),
                  color: Colors.blue,
                  textColor: Colors.white),
              SizedBox(height: 40),
              Text(response),
            ],
          ),
        ])));
  }

  List<Widget> _getDocuments() {
    List<Widget> documentsTextFields = [];
    for (int i = 0; i < documentsList.length; i++) {
      documentsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: DocumentTextFields(i)),
            SizedBox(
              width: 16,
            ),
            _addRemoveButton(i == documentsList.length - 1, i),
          ],
        ),
      ));
    }
    return documentsTextFields;
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all documents textfields
          documentsList.insert(0, null);
        } else
          documentsList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}

class DocumentTextFields extends StatefulWidget {
  final int index;
  DocumentTextFields(this.index);
  @override
  _DocumentTextFieldsState createState() => _DocumentTextFieldsState();
}

class _DocumentTextFieldsState extends State<DocumentTextFields> {
  TextEditingController _queryController;

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController();
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _queryController.text =
          _SearchFormState.documentsList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _queryController,
      onChanged: (v) => _SearchFormState.documentsList[widget.index] = v,
      decoration: InputDecoration(hintText: 'Enter your document'),
      validator: (v) {
        if (v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}
