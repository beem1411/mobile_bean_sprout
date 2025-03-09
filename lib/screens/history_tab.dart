import 'package:flutter/material.dart';
import 'package:mobile/constant/app_state.dart';
import 'package:provider/provider.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final history = Provider.of<AppState>(context).history;

    return Scaffold(
      body: ListView.builder(
          itemCount: history.length,
          itemBuilder: (context, index) {
            final record = history[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: Icon(
                  record['status'] == 'เริ่มปลูก'
                      ? Icons.schedule
                      : Icons.check_circle,
                  color: record['status'] == 'เริ่มปลูก'
                      ? Colors.orange
                      : Colors.green,
                ),
                title: Text('รอบที่ปลูก: ${record['round']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    record['status'] == 'เริ่มปลูก'
                    ?Text('วันที่ปลูก: ${record['date']}')
                    :Text('วันที่เก็บ: ${record['date']}'),
                    Text('สถานะ: ${record['status']}'),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

