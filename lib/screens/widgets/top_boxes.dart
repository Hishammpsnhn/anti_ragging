import 'package:flutter/material.dart';

class TopBoxes extends StatelessWidget {
  final int totalCases;
  final int pendingCases;
  final int solvedCases;

  TopBoxes({
    required this.totalCases,
    required this.pendingCases,
    required this.solvedCases,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _buildTopBox("Total Case", totalCases),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTopBox("Pending Case", pendingCases),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTopBox("Solved Case", solvedCases),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBox(String text, int number) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
