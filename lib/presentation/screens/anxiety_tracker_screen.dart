import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../viewmodels/anxiety_viewmodel.dart';
import '../widgets/section_title.dart';

class AnxietyTrackerScreen extends StatefulWidget {
  const AnxietyTrackerScreen({super.key});

  @override
  State<AnxietyTrackerScreen> createState() => _AnxietyTrackerScreenState();
}

class _AnxietyTrackerScreenState extends State<AnxietyTrackerScreen> {
  double _currentScore = 5.0;
  final List<String> _availableSymptoms = [
    "Restlessness",
    "Fast heartbeat",
    "Sleep issues",
    "Overthinking",
    "Panic feelings"
  ];
  final List<String> _selectedSymptoms = [];
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AnxietyViewModel>().loadHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mental Health Tracker")),
      body: Consumer<AnxietyViewModel>(
        builder: (context, vm, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryHeader(vm),
                const SizedBox(height: 16),
                _buildLogSection(vm),
                const SizedBox(height: 32),
                const SectionTitle(title: "Anxiety Trends"),
                const SizedBox(height: 16),
                _buildChart(vm),
                const SizedBox(height: 24),
                const SectionTitle(title: "Recent Entries"),
                _buildHistoryList(vm),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryHeader(AnxietyViewModel vm) {
    if (vm.history.isEmpty) return const SizedBox.shrink();

    double avg = vm.history.map((e) => e.score).reduce((a, b) => a + b) / vm.history.length;
    Color statusColor = avg > 7 ? Colors.red : (avg > 4 ? Colors.orange : Colors.green);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Average Anxiety Level", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              Text(avg.toStringAsFixed(1), style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: statusColor)),
            ],
          ),
          Icon(statusColor == Colors.red ? Icons.warning_amber_rounded : Icons.check_circle_outline, color: statusColor, size: 32),
        ],
      ),
    );
  }

  Widget _buildLogSection(AnxietyViewModel vm) {
    return Card(
      elevation: 0,
      color: Colors.blue.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("How are you feeling today?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text("Score: ${_currentScore.toInt()}/10", style: const TextStyle(color: Color(0xFF003D80), fontWeight: FontWeight.bold)),
            Slider(
              value: _currentScore,
              min: 1,
              max: 10,
              divisions: 9,
              activeColor: const Color(0xFF003D80),
              onChanged: (val) => setState(() => _currentScore = val),
            ),
            const Divider(),
            const Text("Select symptoms:", style: TextStyle(fontWeight: FontWeight.w600)),
            Wrap(
              spacing: 8,
              children: _availableSymptoms.map((s) => FilterChip(
                label: Text(s, style: const TextStyle(fontSize: 12)),
                selected: _selectedSymptoms.contains(s),
                onSelected: (selected) {
                  setState(() {
                    selected ? _selectedSymptoms.add(s) : _selectedSymptoms.remove(s);
                  });
                },
              )).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(hintText: "Optional notes...", border: OutlineInputBorder()),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003D80), foregroundColor: Colors.white),
                onPressed: () async {
                  await vm.addEntry(_currentScore, _selectedSymptoms, _notesController.text);
                  _notesController.clear();
                  setState(() => _selectedSymptoms.clear());
                  if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Entry logged successfully")));
                },
                child: const Text("Log Entry"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChart(AnxietyViewModel vm) {
    if (vm.history.isEmpty) return const Center(child: Text("No entries yet."));
    
    final reverseHistory = vm.history.reversed.toList();
    final spots = reverseHistory.map((e) {
       return FlSpot(reverseHistory.indexOf(e).toDouble(), e.score);
    }).toList();

    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 10,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (val) => FlLine(color: Colors.grey.withValues(alpha: 0.1), strokeWidth: 1),
          ),
          titlesData: const FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Dates hidden to keep clean or add custom
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: const Color(0xFF003D80),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, p2, p3, p4) => FlDotCirclePainter(
                  radius: 4,
                  color: spot.y > 7 ? Colors.red : const Color(0xFF003D80),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                ),
              ),
              belowBarData: BarAreaData(
                show: true, 
                gradient: LinearGradient(
                  colors: [const Color(0xFF003D80).withValues(alpha: 0.2), const Color(0xFF003D80).withValues(alpha: 0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(AnxietyViewModel vm) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vm.history.length,
      itemBuilder: (context, index) {
        final entry = vm.history[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: entry.score > 7 ? Colors.red.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
            child: Text(entry.score.toInt().toString(), style: TextStyle(color: entry.score > 7 ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
          ),
          title: Text(DateFormat('MMM dd, yyyy - hh:mm a').format(entry.timestamp)),
          subtitle: Text(entry.symptoms.join(", ")),
        );
      },
    );
  }
}
