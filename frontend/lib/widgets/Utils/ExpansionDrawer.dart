import 'package:flutter/material.dart';

class ExpansionDrawer extends StatefulWidget {
  final onTap;
  final onExpansion;
  final label;
  final Icon pIcon;
  final Icon cIcon;
  final bool isExpanded;
  const ExpansionDrawer({
    super.key,
    required this.label,
    required this.pIcon,
    required this.cIcon,
    required this.onTap,
    required this.isExpanded,
    this.onExpansion,
  });

  @override
  State<ExpansionDrawer> createState() => _ExpansionDrawerState();
}

class _ExpansionDrawerState extends State<ExpansionDrawer> {
  final names = ['CO', 'CH4', 'LPG', 'Smoke'];

  var expand = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: UniqueKey(),
      initiallyExpanded: widget.isExpanded,
      trailing: widget.isExpanded
          ? const Icon(
              Icons.arrow_drop_up,
              color: Colors.black,
            )
          : const Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ),
      tilePadding: const EdgeInsets.only(right: 8),
      onExpansionChanged: (value) => widget.onExpansion(value),
      title: Text(widget.label,
          style: const TextStyle(
              fontSize: 19, color: Colors.black, fontWeight: FontWeight.bold)),
      leading: Padding(
        padding: const EdgeInsets.only(left: 7.0),
        child: widget.pIcon,
      ),
      children: List.generate(names.length, (index) {
        return ListTile(
            title: Text(names[index]),
            iconColor: Colors.black,
            titleTextStyle: const TextStyle(fontSize: 20, color: Colors.black),
            leading: widget.cIcon,
            onTap: () => widget.onTap(index));
      }),
    );
  }
}
