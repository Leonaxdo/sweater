import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _height = 170;
  int _weight = 70;
  int _muscle = 30;
  int _bodyFat = 20;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _height = prefs.getInt('height') ?? 170;
      _weight = prefs.getInt('weight') ?? 70;
      _muscle = prefs.getInt('muscle') ?? 30;
      _bodyFat = prefs.getInt('bodyFat') ?? 20;
    });
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('height', _height);
    await prefs.setInt('weight', _weight);
    await prefs.setInt('muscle', _muscle);
    await prefs.setInt('bodyFat', _bodyFat);
  }

  List<Widget> _buildPickerItems(int min, int max) {
    List<Widget> items = [];
    for (int i = min; i <= max; i++) {
      items.add(Text(i.toString()));
    }
    return items;
  }

  void _showPicker(BuildContext context, String title, int currentValue, ValueChanged<int> onSelectedItemChanged, List<int> items) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(title, style: TextStyle(fontSize: 20)),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(initialItem: currentValue - items.first),
                    itemExtent: 32.0,
                    onSelectedItemChanged: (index) {
                      onSelectedItemChanged(items[index]);
                    },
                    children: items.map((item) => Text(item.toString())).toList(),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('프로필'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListTile(
                title: Text('키 (cm)'),
                trailing: Text(_height.toString()),
                onTap: () => _showPicker(context, '키 (cm)', _height, (int value) {
                  setState(() {
                    _height = value;
                  });
                }, List<int>.generate(151, (index) => 100 + index)),
              ),
              ListTile(
                title: Text('몸무게 (kg)'),
                trailing: Text(_weight.toString()),
                onTap: () => _showPicker(context, '몸무게 (kg)', _weight, (int value) {
                  setState(() {
                    _weight = value;
                  });
                }, List<int>.generate(171, (index) => 30 + index)),
              ),
              ListTile(
                title: Text('근육량 (kg)'),
                trailing: Text(_muscle.toString()),
                onTap: () => _showPicker(context, '근육량 (kg)', _muscle, (int value) {
                  setState(() {
                    _muscle = value;
                  });
                }, List<int>.generate(91, (index) => 10 + index)),
              ),
              ListTile(
                title: Text('체지방량 (%)'),
                trailing: Text(_bodyFat.toString()),
                onTap: () => _showPicker(context, '체지방량 (%)', _bodyFat, (int value) {
                  setState(() {
                    _bodyFat = value;
                  });
                }, List<int>.generate(46, (index) => 5 + index)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _saveData();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('프로필 저장됨')));
                },
                child: Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
